#!/bin/bash
# Neural Squad - Cron Setup for macOS
# Creates launchd plist files for staggered heartbeats
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"

echo "=== Neural Squad Cron Setup ==="
echo ""

# Create LaunchAgents directory if needed
mkdir -p "$LAUNCH_AGENTS_DIR"

# Heartbeat schedule (every 15 min, staggered by 2 min)
# Architect: :00, :15, :30, :45
# Dev:       :02, :17, :32, :47
# Critic:    :04, :19, :34, :49

create_plist() {
    local agent="$1"
    local minute_offset="$2"
    local plist_name="com.neuralsquad.$agent.plist"
    local plist_path="$LAUNCH_AGENTS_DIR/$plist_name"

    cat > "$plist_path" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.neuralsquad.$agent</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$SCRIPT_DIR/heartbeat.sh</string>
        <string>$agent</string>
    </array>
    <key>StartCalendarInterval</key>
    <array>
        <dict>
            <key>Minute</key>
            <integer>$minute_offset</integer>
        </dict>
        <dict>
            <key>Minute</key>
            <integer>$((minute_offset + 15))</integer>
        </dict>
        <dict>
            <key>Minute</key>
            <integer>$((minute_offset + 30))</integer>
        </dict>
        <dict>
            <key>Minute</key>
            <integer>$((minute_offset + 45))</integer>
        </dict>
    </array>
    <key>WorkingDirectory</key>
    <string>$PROJECT_DIR</string>
    <key>StandardOutPath</key>
    <string>$PROJECT_DIR/.claude/logs/squad-$agent.log</string>
    <key>StandardErrorPath</key>
    <string>$PROJECT_DIR/.claude/logs/squad-$agent.error.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/opt/homebrew/bin</string>
    </dict>
</dict>
</plist>
EOF

    echo "Created: $plist_path"
}

# Create log directory
mkdir -p "$PROJECT_DIR/.claude/logs"

ACTION="${1:-status}"

case "$ACTION" in
    install)
        echo "Installing heartbeat schedules..."
        echo ""

        create_plist "architect" 0
        create_plist "dev" 2
        create_plist "critic" 4

        echo ""
        echo "Loading agents..."

        launchctl load "$LAUNCH_AGENTS_DIR/com.neuralsquad.architect.plist" 2>/dev/null || true
        launchctl load "$LAUNCH_AGENTS_DIR/com.neuralsquad.dev.plist" 2>/dev/null || true
        launchctl load "$LAUNCH_AGENTS_DIR/com.neuralsquad.critic.plist" 2>/dev/null || true

        echo ""
        echo "✅ Heartbeats installed!"
        echo ""
        echo "Schedule:"
        echo "  Architect: :00, :15, :30, :45"
        echo "  Dev:       :02, :17, :32, :47"
        echo "  Critic:    :04, :19, :34, :49"
        echo ""
        echo "Logs: .claude/logs/squad-*.log"
        ;;

    uninstall)
        echo "Removing heartbeat schedules..."

        launchctl unload "$LAUNCH_AGENTS_DIR/com.neuralsquad.architect.plist" 2>/dev/null || true
        launchctl unload "$LAUNCH_AGENTS_DIR/com.neuralsquad.dev.plist" 2>/dev/null || true
        launchctl unload "$LAUNCH_AGENTS_DIR/com.neuralsquad.critic.plist" 2>/dev/null || true

        rm -f "$LAUNCH_AGENTS_DIR/com.neuralsquad.architect.plist"
        rm -f "$LAUNCH_AGENTS_DIR/com.neuralsquad.dev.plist"
        rm -f "$LAUNCH_AGENTS_DIR/com.neuralsquad.critic.plist"

        echo "✅ Heartbeats removed!"
        ;;

    status)
        echo "Heartbeat Status:"
        echo ""

        for agent in architect dev critic; do
            plist="$LAUNCH_AGENTS_DIR/com.neuralsquad.$agent.plist"
            if [ -f "$plist" ]; then
                if launchctl list | grep -q "com.neuralsquad.$agent"; then
                    echo "  ✅ $agent: installed and loaded"
                else
                    echo "  ⚠️  $agent: installed but not loaded"
                fi
            else
                echo "  ❌ $agent: not installed"
            fi
        done

        echo ""
        echo "Commands:"
        echo "  Install:   bash .claude/scripts/squad/cron-setup.sh install"
        echo "  Uninstall: bash .claude/scripts/squad/cron-setup.sh uninstall"
        ;;

    *)
        echo "Usage: $0 {install|uninstall|status}"
        exit 1
        ;;
esac
