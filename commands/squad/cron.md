---
description: Manage Neural Squad automated heartbeats via macOS launchd
allowed-tools: Bash
---

# /squad-cron

Install, uninstall, or check status of automated heartbeat schedules.

## Usage

```bash
# Check current status
/squad-cron

# Install heartbeats (runs every 15 min)
/squad-cron install

# Remove heartbeats
/squad-cron uninstall
```

## Execution

```bash
bash .claude/scripts/squad/cron-setup.sh status
bash .claude/scripts/squad/cron-setup.sh install
bash .claude/scripts/squad/cron-setup.sh uninstall
```

## Schedule

Agents wake every 15 minutes, staggered by 2 minutes:

| Agent | Minutes |
|-------|---------|
| Architect | :00, :15, :30, :45 |
| Dev | :02, :17, :32, :47 |
| Critic | :04, :19, :34, :49 |

## How It Works

1. Creates launchd plist files in `~/Library/LaunchAgents/`
2. Each plist triggers `heartbeat.sh <agent>` at scheduled times
3. Heartbeat checks for tasks, processes if found, logs activity
4. Output goes to `.claude/logs/squad-*.log`

## Output Format

```
=== Neural Squad Cron Setup ===

Heartbeat Status:

  ✅ architect: installed and loaded
  ✅ dev: installed and loaded
  ✅ critic: installed and loaded

Commands:
  Install:   bash .claude/scripts/squad/cron-setup.sh install
  Uninstall: bash .claude/scripts/squad/cron-setup.sh uninstall
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| "not loaded" | Plist exists but not running | Run install again |
| "permission denied" | Can't write to LaunchAgents | Check ~/Library/LaunchAgents permissions |
| Heartbeat fails | Claude not in PATH | Check PATH in plist includes claude location |

**Fallback**: Run heartbeats manually with `bash .claude/scripts/squad/heartbeat.sh <agent>`
