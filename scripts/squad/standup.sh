#!/bin/bash
# Neural Squad - Daily Standup Report
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SQUAD_DIR="$PROJECT_DIR/.claude/squad"
KPI_DIR="$PROJECT_DIR/.claude/memory/kpis"
TODAY=$(date +%Y-%m-%d)

# Colors
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Count tasks in each status
count_tasks() {
    find "$SQUAD_DIR/tasks/$1" -name "*.json" 2>/dev/null | wc -l | tr -d ' '
}

# Get recent activity
get_activity() {
    if [ -f "$SQUAD_DIR/activity/heartbeat.jsonl" ]; then
        tail -10 "$SQUAD_DIR/activity/heartbeat.jsonl" 2>/dev/null
    fi
}

# Build report
echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║              NEURAL SQUAD - DAILY STANDUP                    ║${NC}"
echo -e "${BOLD}║                     $TODAY                              ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Task Summary
echo -e "${CYAN}═══ TASK SUMMARY ═══${NC}"
echo ""

inbox=$(count_tasks "inbox")
assigned=$(count_tasks "assigned")
in_progress=$(count_tasks "in-progress")
review=$(count_tasks "review")
done_count=$(count_tasks "done")

echo "📥 Inbox:       $inbox"
echo "📋 Assigned:    $assigned"
echo "🔨 In Progress: $in_progress"
echo "👀 Review:      $review"
echo "✅ Done:        $done_count"
echo ""

# Agent Status
echo -e "${CYAN}═══ AGENT STATUS ═══${NC}"
echo ""

for agent_file in "$SQUAD_DIR"/agents/*.json; do
    if [ -f "$agent_file" ]; then
        name=$(jq -r '.name' "$agent_file")
        status=$(jq -r '.status' "$agent_file")
        last=$(jq -r '.last_heartbeat // "never"' "$agent_file")

        if [ "$status" = "idle" ]; then
            echo -e "  ${GREEN}●${NC} $name: $status (last: ${last:11:8})"
        else
            echo -e "  ${YELLOW}●${NC} $name: $status (last: ${last:11:8})"
        fi
    fi
done
echo ""

# KPIs (if available)
echo -e "${CYAN}═══ TODAY'S KPIs ═══${NC}"
echo ""

KPI_FILE="$KPI_DIR/$TODAY.json"
if [ -f "$KPI_FILE" ]; then
    plan_vel=$(jq -r '.summary.avg_plan_velocity // "N/A"' "$KPI_FILE")
    review_vel=$(jq -r '.summary.avg_review_velocity // "N/A"' "$KPI_FILE")
    autonomy=$(jq -r '.summary.total_autonomy_min // 0' "$KPI_FILE")

    echo "⚡ Plan Velocity:    ${plan_vel} min avg"
    echo "⚡ Review Velocity:  ${review_vel} min avg"
    echo "🤖 Autonomy:         ${autonomy} min total"
else
    echo "  No KPI data for today yet."
    echo "  Track with: /kpi plan|review|autonomy <min> \"task\""
fi
echo ""

# Compute Advantage
CA_FILE="$KPI_DIR/ca-sessions.json"
if [ -f "$CA_FILE" ]; then
    avg_ca=$(jq -r '.averages.weekly_ca // "N/A"' "$CA_FILE")
    echo -e "${CYAN}═══ COMPUTE ADVANTAGE ═══${NC}"
    echo ""
    echo "📊 Weekly Avg CA: ${avg_ca}x"
    echo ""
fi

# Recent Activity
echo -e "${CYAN}═══ RECENT ACTIVITY ═══${NC}"
echo ""

if [ -f "$SQUAD_DIR/activity/heartbeat.jsonl" ]; then
    tail -5 "$SQUAD_DIR/activity/heartbeat.jsonl" 2>/dev/null | while read line; do
        ts=$(echo "$line" | jq -r '.timestamp' 2>/dev/null)
        agent=$(echo "$line" | jq -r '.agent' 2>/dev/null)
        type=$(echo "$line" | jq -r '.type' 2>/dev/null)
        msg=$(echo "$line" | jq -r '.message' 2>/dev/null)
        echo "  ${ts:11:8} [$agent] $type: $msg"
    done
else
    echo "  No activity logged yet."
fi
echo ""

# Tasks completed today
echo -e "${CYAN}═══ COMPLETED TODAY ═══${NC}"
echo ""

today_done=0
for task_file in "$SQUAD_DIR/tasks/done"/*.json; do
    if [ -f "$task_file" ]; then
        # Check if completed today
        last_status=$(jq -r '.history[-1].timestamp // ""' "$task_file")
        if [[ "$last_status" == "$TODAY"* ]]; then
            title=$(jq -r '.title' "$task_file")
            echo "  ✅ $title"
            ((today_done++)) || true
        fi
    fi
done

if [ "$today_done" -eq 0 ]; then
    echo "  No tasks completed today."
fi
echo ""

# Generate Telegram message if requested
if [ "$1" = "--telegram" ]; then
    MSG="🤖 *Neural Squad Standup - $TODAY*

📊 *Task Queue*
• Inbox: $inbox
• In Progress: $in_progress
• Review: $review
• Done today: $today_done

⚡ *KPIs*
• Plan Velocity: ${plan_vel:-N/A} min
• Review Velocity: ${review_vel:-N/A} min
• Autonomy: ${autonomy:-0} min

Use \`/squad-status\` for details."

    # Send to Telegram
    if [ -f "$PROJECT_DIR/.claude/scripts/.telegram-config" ]; then
        source "$PROJECT_DIR/.claude/scripts/.telegram-config"
        curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
            -d chat_id="${TELEGRAM_CHAT_ID}" \
            -d text="$MSG" \
            -d parse_mode="Markdown" > /dev/null
        echo "📱 Standup sent to Telegram!"
    else
        echo "⚠️  Telegram not configured. Set up .claude/scripts/.telegram-config"
    fi
fi

echo "─────────────────────────────────────────────────────────────────"
echo -e "Run ${BOLD}/squad-standup --telegram${NC} to send to Telegram"
echo ""
