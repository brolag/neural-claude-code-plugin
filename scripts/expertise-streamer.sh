#!/bin/bash
# Expertise Streaming Pipeline
# Pattern 7: Real-time expertise updates during active sessions
#
# Unlike the watcher (which queues updates for next session),
# the streamer injects updates IMMEDIATELY into the running session.
#
# Usage:
#   ./expertise-streamer.sh start   - Start streaming
#   ./expertise-streamer.sh stop    - Stop streaming
#   ./expertise-streamer.sh inject "message"  - Manual injection
#   ./expertise-streamer.sh status  - Check streaming status

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXPERTISE_DIR="$PROJECT_DIR/.claude/expertise"
LOG_FILE="$PROJECT_DIR/.claude/logs/expertise-streamer.log"
PID_FILE="$PROJECT_DIR/.claude/logs/expertise-streamer.pid"

mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" >> "$LOG_FILE"
}

extract_diff() {
    local file="$1"
    local domain=$(basename "$file" .yaml)
    if command -v git &> /dev/null && git -C "$PROJECT_DIR" rev-parse --git-dir &> /dev/null; then
        local additions=$(git -C "$PROJECT_DIR" diff --no-color -- "$file" 2>/dev/null | grep "^+" | grep -v "^+++" | head -5 | sed 's/^+//' | tr '\n' '; ' | head -c 200)
        if [ -n "$additions" ]; then
            echo "[$domain] New: $additions"
            return
        fi
    fi
    echo "[$domain] Updated"
}

inject_to_session() {
    local message="$1"
    local INJECTION_FILE="$PROJECT_DIR/.claude/memory/session-injections.jsonl"
    echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"type\":\"expertise_stream\",\"message\":\"$message\"}" >> "$INJECTION_FILE"
    log "Injected: $message"
}

start_streaming() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "Streamer already running (PID: $PID)"
            return 0
        fi
    fi

    log "Starting expertise streamer..."

    if ! command -v fswatch &> /dev/null; then
        echo "fswatch not found. Install with: brew install fswatch"
        return 1
    fi

    (
        fswatch -0 -l 0.3 -e ".*" -i "\\.yaml$" "$EXPERTISE_DIR" | while read -d "" file; do
            if [[ "$file" =~ manifest\.yaml$ ]]; then continue; fi
            if [[ ! "$file" =~ \.yaml$ ]]; then continue; fi
            diff_summary=$(extract_diff "$file")
            log "Streaming: $diff_summary"
            inject_to_session "🧠 Live expertise update: $diff_summary"
        done
    ) &

    echo $! > "$PID_FILE"
    log "Streamer started (PID: $(cat $PID_FILE))"
    echo "Expertise streamer started (PID: $(cat $PID_FILE))"
}

stop_streaming() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            kill "$PID"
            rm "$PID_FILE"
            echo "Expertise streamer stopped"
        else
            rm "$PID_FILE"
            echo "Streamer was not running"
        fi
    else
        echo "Streamer is not running"
    fi
}

status_streaming() {
    echo "=== Expertise Streaming Status ==="
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "Streamer: RUNNING (PID: $PID)"
        else
            echo "Streamer: STOPPED"
        fi
    else
        echo "Streamer: NOT RUNNING"
    fi
}

consume_stream() {
    INJECTION_FILE="$PROJECT_DIR/.claude/memory/session-injections.jsonl"
    if [ ! -f "$INJECTION_FILE" ] || [ ! -s "$INJECTION_FILE" ]; then return 0; fi
    while IFS= read -r line; do
        MESSAGE=$(echo "$line" | grep -o '"message":"[^"]*"' | cut -d'"' -f4)
        if [ -n "$MESSAGE" ]; then
            echo "{\"systemMessage\": \"$MESSAGE\"}"
        fi
    done < "$INJECTION_FILE"
    > "$INJECTION_FILE"
}

case "${1:-}" in
    start) start_streaming ;;
    stop) stop_streaming ;;
    status) status_streaming ;;
    inject) inject_to_session "$2"; echo "Injected: $2" ;;
    consume) consume_stream ;;
    *)
        echo "Usage: $0 {start|stop|status|inject|consume}"
        echo "  start       - Start live streaming"
        echo "  stop        - Stop streaming"
        echo "  status      - Check status"
        echo "  inject msg  - Manual injection"
        echo "  consume     - Consume pending (for hooks)"
        exit 1
        ;;
esac
