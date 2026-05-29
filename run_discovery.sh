#!/bin/zsh
set -euo pipefail

# Ensure environment is loaded for launchd background execution
if [ -f "$HOME/.zprofile" ]; then source "$HOME/.zprofile"; fi
if [ -f "$HOME/.zshrc" ]; then source "$HOME/.zshrc"; fi

export PATH="/opt/homebrew/bin:$HOME/.adal/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

PROMPT_FILE="$HOME/.adal-automation/discovery_prompt.txt"
STYLE_FILE="$HOME/.adal-automation/my_comment_style.txt"
OUT_DIR="$HOME/.adal-automation/output"
LOG_DIR="$HOME/.adal-automation/logs"
mkdir -p "$OUT_DIR" "$LOG_DIR"

if [ -x "$HOME/.adal/bin/adal" ]; then
  ADAL="$HOME/.adal/bin/adal"
elif command -v adal >/dev/null 2>&1; then
  ADAL="$(command -v adal)"
else
  echo "adal not found in PATH" >> "$LOG_DIR/error.log"
  exit 1
fi

TS="$(date +%Y-%m-%d_%H-%M-%S)"
OUT_JSON="$OUT_DIR/discovery_$TS.json"
OUT_TXT="$OUT_DIR/discovery_$TS.txt"

# Combine prompt and style profile dynamically
PROMPT_CONTENT="$(cat "$PROMPT_FILE")"
STYLE_CONTENT="$(cat "$STYLE_FILE")"
FULL_PROMPT="${PROMPT_CONTENT}

=== CURRENT STYLE PROFILE ===
${STYLE_CONTENT}"

"$ADAL" -q "$FULL_PROMPT" --yolo -o json > "$OUT_JSON" 2>> "$LOG_DIR/adal.err.log"

# optional plain-text extract (keeps things easy to read)
python3 - <<PY > "$OUT_TXT" 2>/dev/null || true
import json
p = "$OUT_JSON"
try:
    d = json.load(open(p))
    print(d.get("answer",""))
except Exception as e:
    print(f"failed to parse {p}: {e}")
PY

# send macOS notification when drafts are ready
SUCCESS="$(python3 - <<PY
import json
p = "$OUT_JSON"
try:
    d = json.load(open(p))
    print("true" if d.get("success") is True else "false")
except Exception:
    print("false")
PY
)"

if command -v osascript >/dev/null 2>&1; then
  if [ "$SUCCESS" = "true" ]; then
    osascript -e "display notification \"3 new draft comments are ready for review\" with title \"adal discovery\" subtitle \"$(basename "$OUT_TXT")\""
  else
    osascript -e "display notification \"discovery run finished with an error\" with title \"adal discovery\" subtitle \"check adal.err.log\""
  fi
fi
