# AdaL Discovery Automation Kit

This kit runs scheduled **discovery + draft generation** (not auto-posting), then notifies you when drafts are ready.

## What this includes

- `discovery_prompt.txt` — discovery instructions for AdaL
- `my_comment_style.txt` — style profile appended to every run
- `run_discovery.sh` — headless runner script
- `install_launchd.sh` — installs a 3x/day launchd schedule on macOS

## Schedule

By default, it runs **3 times/day**:

- Morning: `09:30`
- Afternoon: `14:30`
- Evening: `19:30`

## Prerequisites (each person/device)

1. macOS
2. AdaL CLI installed and authenticated once interactively
3. Required environment variables in shell profile (if needed by your setup)
4. Browser/MCP tools configured in AdaL (for discovery workflow)
5. Notifications enabled in macOS settings

## Setup

From this folder:

```bash
chmod +x install_launchd.sh
./install_launchd.sh
```

Then test one run:

```bash
launchctl start com.adal.discovery
```

Check outputs:

```bash
ls -lt ~/.adal-automation/output
```

## Where outputs/logs go

- Draft outputs: `~/.adal-automation/output/`
- Runner logs: `~/.adal-automation/logs/adal.err.log`
- launchd logs:
  - `~/.adal-automation/logs/launchd.out.log`
  - `~/.adal-automation/logs/launchd.err.log`

## How to run this?

Install AdaL, logs in once, set required env vars, and runs `install_launchd.sh` on Mac account.  
The schedule and runtime paths are per-user (`$HOME`), so it works independently on each machine/user profile.
