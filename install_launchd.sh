#!/bin/zsh
set -euo pipefail

AUTOMATION_DIR="$HOME/.adal-automation"
mkdir -p "$AUTOMATION_DIR"/{logs,output}

# Copy kit files into runtime location
cp -f "$(dirname "$0")/discovery_prompt.txt" "$AUTOMATION_DIR/discovery_prompt.txt"
cp -f "$(dirname "$0")/my_comment_style.txt" "$AUTOMATION_DIR/my_comment_style.txt"
cp -f "$(dirname "$0")/run_discovery.sh" "$AUTOMATION_DIR/run_discovery.sh"
chmod +x "$AUTOMATION_DIR/run_discovery.sh"

PLIST_PATH="$HOME/Library/LaunchAgents/com.adal.discovery.plist"
mkdir -p "$HOME/Library/LaunchAgents"

cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.adal.discovery</string>

    <key>ProgramArguments</key>
    <array>
      <string>/bin/zsh</string>
      <string>-lc</string>
      <string>$AUTOMATION_DIR/run_discovery.sh</string>
    </array>

    <key>StartCalendarInterval</key>
    <array>
      <dict><key>Hour</key><integer>9</integer><key>Minute</key><integer>30</integer></dict>
      <dict><key>Hour</key><integer>14</integer><key>Minute</key><integer>30</integer></dict>
      <dict><key>Hour</key><integer>19</integer><key>Minute</key><integer>30</integer></dict>
    </array>

    <key>StandardOutPath</key>
    <string>$AUTOMATION_DIR/logs/launchd.out.log</string>
    <key>StandardErrorPath</key>
    <string>$AUTOMATION_DIR/logs/launchd.err.log</string>
  </dict>
</plist>
EOF

launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo "Installed. Scheduled at 09:30, 14:30, 19:30 local time."
echo "Run once now with: launchctl start com.adal.discovery"
