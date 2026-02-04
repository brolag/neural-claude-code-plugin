#!/bin/bash
# Neural Squad - Status Display
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SQUAD_DIR="$PROJECT_DIR/.claude/squad"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║                    NEURAL SQUAD STATUS                       ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Agent Status
echo -e "${CYAN}═══ AGENTS ═══${NC}"
echo ""

for agent_file in "$SQUAD_DIR"/agents/*.json; do
    if [ -f "$agent_file" ]; then
        agent_id=$(jq -r '.id' "$agent_file")
        agent_name=$(jq -r '.name' "$agent_file")
        agent_role=$(jq -r '.role' "$agent_file")
        agent_status=$(jq -r '.status' "$agent_file")
        current_task=$(jq -r '.current_task // "none"' "$agent_file")
        last_heartbeat=$(jq -r '.last_heartbeat // "never"' "$agent_file")

        # Status color
        case "$agent_status" in
            idle)     status_color="${GREEN}" ;;
            working)  status_color="${YELLOW}" ;;
            error)    status_color="${RED}" ;;
            *)        status_color="${NC}" ;;
        esac

        echo -e "${BOLD}$agent_name${NC} ($agent_id)"
        echo -e "  Role:   $agent_role"
        echo -e "  Status: ${status_color}$agent_status${NC}"
        echo -e "  Task:   $current_task"
        echo -e "  Last:   $last_heartbeat"
        echo ""
    fi
done

# Task Counts
echo -e "${CYAN}═══ TASK QUEUE ═══${NC}"
echo ""

count_tasks() {
    local dir="$1"
    find "$dir" -name "*.json" 2>/dev/null | wc -l | tr -d ' '
}

inbox_count=$(count_tasks "$SQUAD_DIR/tasks/inbox")
assigned_count=$(count_tasks "$SQUAD_DIR/tasks/assigned")
in_progress_count=$(count_tasks "$SQUAD_DIR/tasks/in-progress")
review_count=$(count_tasks "$SQUAD_DIR/tasks/review")
done_count=$(count_tasks "$SQUAD_DIR/tasks/done")

# Kanban-style display
echo -e "┌─────────┬──────────┬────────────┬──────────┬────────┐"
echo -e "│ ${BOLD}INBOX${NC}   │ ${BOLD}ASSIGNED${NC} │ ${BOLD}IN-PROGRESS${NC}│ ${BOLD}REVIEW${NC}  │ ${BOLD}DONE${NC}   │"
echo -e "├─────────┼──────────┼────────────┼──────────┼────────┤"
printf "│   %2d    │    %2d    │     %2d     │    %2d    │   %2d   │\n" \
    "$inbox_count" "$assigned_count" "$in_progress_count" "$review_count" "$done_count"
echo -e "└─────────┴──────────┴────────────┴──────────┴────────┘"
echo ""

# Recent Activity
echo -e "${CYAN}═══ RECENT ACTIVITY ═══${NC}"
echo ""

if [ -f "$SQUAD_DIR/activity/heartbeat.jsonl" ]; then
    tail -5 "$SQUAD_DIR/activity/heartbeat.jsonl" 2>/dev/null | while read line; do
        ts=$(echo "$line" | jq -r '.timestamp' 2>/dev/null)
        agent=$(echo "$line" | jq -r '.agent' 2>/dev/null)
        type=$(echo "$line" | jq -r '.type' 2>/dev/null)
        msg=$(echo "$line" | jq -r '.message' 2>/dev/null)

        # Type color
        case "$type" in
            heartbeat)    type_color="${GREEN}" ;;
            task_start)   type_color="${YELLOW}" ;;
            task_complete) type_color="${BLUE}" ;;
            error)        type_color="${RED}" ;;
            *)            type_color="${NC}" ;;
        esac

        echo -e "  ${ts:11:8} ${BOLD}$agent${NC} ${type_color}[$type]${NC} $msg"
    done
else
    echo "  No activity logged yet."
fi

echo ""
echo -e "${CYAN}═══ WORKTREES ═══${NC}"
echo ""
git worktree list 2>/dev/null | grep -E "squad-|main" || echo "  No squad worktrees found."

echo ""
echo -e "─────────────────────────────────────────────────────────────────"
echo -e "Commands: ${BOLD}/squad-task create${NC} | ${BOLD}/squad-msg${NC} | ${BOLD}/squad-standup${NC}"
echo ""
