#!/bin/bash
# Expertise Watcher Script
# Pattern 2: Self-Improving Agent Mesh
#
# Watches .claude/expertise/*.yaml for changes and broadcasts updates
# to all active agents via systemMessage injection.
#
# Usage:
#   ./expertise-watcher.sh start   - Start watching in background
#   ./expertise-watcher.sh stop    - Stop the watcher
#   ./expertise-watcher.sh status  - Check if watcher is running
#   ./expertise-watcher.sh test    - Test the broadcast mechanism

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXPERTISE_DIR="$PROJECT_DIR/.claude/expertise"
LOG_FILE="$PROJECT_DIR/.claude/logs/expertise-watcher.log"
PID_FILE="$PROJECT_DIR/.claude/logs/expertise-watcher.pid"
BROADCAST_QUEUE="$PROJECT_DIR/.claude/logs/broadcast-queue.txt"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" >> "$LOG_FILE"
}

extract_change() {
    local file="$1"
    local domain=$(basename "$file" .yaml)
    local patterns=$(grep -c "^\s*-" "$file" 2>/dev/null || echo "0")
    echo "[$domain] Updated (patterns: $patterns)"
}

broadcast_update() {
    local file="$1"
    local change_summary="$2"
    echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"type\":\"expertise_update\",\"file\":\"$file\",\"summary\":\"$change_summary\"}" >> "$BROADCAST_QUEUE"
    log "Broadcast queued: $change_summary"
}

start_watcher() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "Watcher already running (PID: $PID)"
            return 0
        fi
    fi

    log "Starting expertise watcher..."

    if ! command -v fswatch &> /dev/null; then
        echo "fswatch not found. Install with: brew install fswatch"
        log "ERROR: fswatch not installed"
        return 1
    fi

    (
        fswatch -0 -e ".*" -i "\\.yaml$" "$EXPERTISE_DIR" | while read -d "" file; do
            sleep 0.5
            if [[ ! "$file" =~ \.yaml$ ]]; then continue; fi
            if [[ "$file" =~ manifest\.yaml$ ]]; then continue; fi
            change_summary=$(extract_change "$file")
            log "Detected change: $file -> $change_summary"
            broadcast_update "$file" "$change_summary"
            touch "$EXPERTISE_DIR/.reload-trigger"
        done
    ) &

    echo $! > "$PID_FILE"
    log "Watcher started (PID: $(cat $PID_FILE))"
    echo "Expertise watcher started (PID: $(cat $PID_FILE))"
}

stop_watcher() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            kill "$PID"
            rm "$PID_FILE"
            log "Watcher stopped (PID: $PID)"
            echo "Expertise watcher stopped"
        else
            rm "$PID_FILE"
            echo "Watcher was not running (stale PID file removed)"
        fi
    else
        echo "Watcher is not running"
    fi
}

status_watcher() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "Expertise watcher is RUNNING (PID: $PID)"
            if [ -f "$BROADCAST_QUEUE" ]; then
                RECENT=$(tail -5 "$BROADCAST_QUEUE" 2>/dev/null)
                if [ -n "$RECENT" ]; then
                    echo ""
                    echo "Recent broadcasts:"
                    echo "$RECENT"
                fi
            fi
            return 0
        fi
    fi
    echo "Expertise watcher is NOT running"
    return 1
}

consume_broadcasts() {
    if [ ! -f "$BROADCAST_QUEUE" ]; then return 0; fi
    while IFS= read -r line; do
        SUMMARY=$(echo "$line" | grep -o '"summary":"[^"]*"' | cut -d'"' -f4)
        if [ -n "$SUMMARY" ]; then
            echo "{\"systemMessage\": \"🧠 Expertise update: $SUMMARY\"}"
        fi
    done < "$BROADCAST_QUEUE"
    > "$BROADCAST_QUEUE"
}

case "${1:-}" in
    start) start_watcher ;;
    stop) stop_watcher ;;
    status) status_watcher ;;
    consume) consume_broadcasts ;;
    *)
        echo "Usage: $0 {start|stop|status|consume}"
        echo "  start   - Start the expertise file watcher"
        echo "  stop    - Stop the watcher"
        echo "  status  - Check watcher status"
        echo "  consume - Consume pending broadcasts (for hooks)"
        exit 1
        ;;
esac
