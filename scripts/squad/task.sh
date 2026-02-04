#!/bin/bash
# Neural Squad - Task Management
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SQUAD_DIR="$PROJECT_DIR/.claude/squad"
TASKS_DIR="$SQUAD_DIR/tasks"

ACTION="${1:-list}"
shift || true

case "$ACTION" in
    create)
        TITLE="$1"
        PRIORITY="${2:-medium}"

        if [ -z "$TITLE" ]; then
            echo "Error: Title required"
            echo "Usage: $0 create \"Task title\" [priority]"
            exit 1
        fi

        TASK_ID="$(date +%Y%m%d-%H%M%S)"
        TASK_FILE="$TASKS_DIR/inbox/${TASK_ID}.json"
        TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

        cat > "$TASK_FILE" << EOF
{
  "id": "$TASK_ID",
  "title": "$TITLE",
  "description": "",
  "priority": "$PRIORITY",
  "created_by": "human",
  "created_at": "$TIMESTAMP",
  "status": "inbox",
  "assigned_to": null,
  "spec": null,
  "acceptance_criteria": [],
  "implementation": null,
  "review": null,
  "history": [
    {"status": "inbox", "timestamp": "$TIMESTAMP", "by": "human"}
  ]
}
EOF

        echo ""
        echo "## Task Created"
        echo ""
        echo "**ID**: $TASK_ID"
        echo "**Title**: $TITLE"
        echo "**Priority**: $PRIORITY"
        echo "**Status**: inbox"
        echo ""
        echo "Task added to queue. Architect will pick up on next heartbeat."
        echo "Or run manually: cd ../worktrees/squad-architect && claude"
        ;;

    list)
        STATUS="${1:-all}"

        if [ "$STATUS" = "all" ]; then
            DIRS="inbox assigned in-progress review done"
        else
            DIRS="$STATUS"
        fi

        for dir in $DIRS; do
            dir_path="$TASKS_DIR/$dir"
            if [ -d "$dir_path" ]; then
                count=$(find "$dir_path" -name "*.json" 2>/dev/null | wc -l | tr -d ' ')
                echo ""
                echo "## Tasks: $dir ($count)"
                echo ""

                if [ "$count" -gt 0 ]; then
                    echo "| ID | Title | Priority | Created |"
                    echo "|----|-------|----------|---------|"

                    for task_file in "$dir_path"/*.json; do
                        if [ -f "$task_file" ]; then
                            id=$(jq -r '.id' "$task_file")
                            title=$(jq -r '.title' "$task_file")
                            priority=$(jq -r '.priority' "$task_file")
                            created=$(jq -r '.created_at' "$task_file")
                            echo "| $id | $title | $priority | ${created:0:16} |"
                        fi
                    done
                else
                    echo "No tasks."
                fi
            fi
        done
        ;;

    show)
        TASK_ID="$1"
        if [ -z "$TASK_ID" ]; then
            echo "Error: Task ID required"
            exit 1
        fi

        TASK_FILE=$(find "$TASKS_DIR" -name "${TASK_ID}.json" 2>/dev/null | head -1)

        if [ -z "$TASK_FILE" ]; then
            echo "Error: Task not found: $TASK_ID"
            exit 1
        fi

        echo ""
        echo "## Task: $TASK_ID"
        echo ""
        cat "$TASK_FILE" | jq .
        ;;

    move)
        TASK_ID="$1"
        NEW_STATUS="$2"

        if [ -z "$TASK_ID" ] || [ -z "$NEW_STATUS" ]; then
            echo "Error: Task ID and status required"
            echo "Usage: $0 move <task-id> <status>"
            exit 1
        fi

        # Validate status
        case "$NEW_STATUS" in
            inbox|assigned|in-progress|review|done) ;;
            *)
                echo "Error: Invalid status: $NEW_STATUS"
                echo "Valid: inbox, assigned, in-progress, review, done"
                exit 1
                ;;
        esac

        TASK_FILE=$(find "$TASKS_DIR" -name "${TASK_ID}.json" 2>/dev/null | head -1)

        if [ -z "$TASK_FILE" ]; then
            echo "Error: Task not found: $TASK_ID"
            exit 1
        fi

        NEW_DIR="$TASKS_DIR/$NEW_STATUS"
        NEW_FILE="$NEW_DIR/${TASK_ID}.json"
        TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

        # Update status and history
        jq --arg status "$NEW_STATUS" --arg ts "$TIMESTAMP" \
            '.status = $status | .history += [{"status": $status, "timestamp": $ts, "by": "human"}]' \
            "$TASK_FILE" > /tmp/task.json

        mv /tmp/task.json "$NEW_FILE"
        rm -f "$TASK_FILE"

        echo "Moved $TASK_ID to $NEW_STATUS"
        ;;

    *)
        echo "Unknown action: $ACTION"
        echo "Usage: $0 {create|list|show|move}"
        exit 1
        ;;
esac
