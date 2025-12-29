#!/bin/bash
# Log skill execution for performance analysis
# Usage: ./log-skill-execution.sh <skill_name> <trigger_type> <outcome> [duration]

set -e

SKILL_NAME="${1:-unknown}"
TRIGGER_TYPE="${2:-manual}"  # manual | auto | suggested
OUTCOME="${3:-started}"      # started | completed | dismissed | failed
DURATION="${4:-}"            # optional, in seconds

# Paths
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
EVENTS_FILE="$PROJECT_DIR/.claude/memory/events/$(date +%Y-%m-%d).jsonl"
PERFORMANCE_FILE="$PROJECT_DIR/.claude/memory/skill-performance.json"

# Ensure directories exist
mkdir -p "$(dirname "$EVENTS_FILE")"

# Log event
EVENT="{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"event\":\"skill_execution\",\"skill\":\"$SKILL_NAME\",\"trigger\":\"$TRIGGER_TYPE\",\"outcome\":\"$OUTCOME\""
if [ -n "$DURATION" ]; then
    EVENT="$EVENT,\"duration_seconds\":$DURATION"
fi
EVENT="$EVENT}"

echo "$EVENT" >> "$EVENTS_FILE"

# Update performance file if outcome is terminal (completed, dismissed, failed)
if [ "$OUTCOME" = "completed" ] || [ "$OUTCOME" = "dismissed" ] || [ "$OUTCOME" = "failed" ]; then

    # Create performance file if it doesn't exist
    if [ ! -f "$PERFORMANCE_FILE" ]; then
        cat > "$PERFORMANCE_FILE" << 'EOF'
{
  "skills": {},
  "updated_at": null
}
EOF
    fi

    # Update using jq if available, otherwise use simple append
    if command -v jq &> /dev/null; then
        # Read current data
        CURRENT=$(cat "$PERFORMANCE_FILE")

        # Get current stats for this skill
        TOTAL=$(echo "$CURRENT" | jq -r ".skills[\"$SKILL_NAME\"].total_executions // 0")
        AUTO=$(echo "$CURRENT" | jq -r ".skills[\"$SKILL_NAME\"].auto_triggered // 0")
        MANUAL=$(echo "$CURRENT" | jq -r ".skills[\"$SKILL_NAME\"].manual_triggered // 0")
        COMPLETED=$(echo "$CURRENT" | jq -r ".skills[\"$SKILL_NAME\"].completed // 0")
        DISMISSED=$(echo "$CURRENT" | jq -r ".skills[\"$SKILL_NAME\"].dismissed // 0")
        FAILED=$(echo "$CURRENT" | jq -r ".skills[\"$SKILL_NAME\"].failed // 0")

        # Increment counters
        TOTAL=$((TOTAL + 1))
        if [ "$TRIGGER_TYPE" = "auto" ]; then
            AUTO=$((AUTO + 1))
        else
            MANUAL=$((MANUAL + 1))
        fi

        case "$OUTCOME" in
            completed) COMPLETED=$((COMPLETED + 1)) ;;
            dismissed) DISMISSED=$((DISMISSED + 1)) ;;
            failed)    FAILED=$((FAILED + 1)) ;;
        esac

        # Calculate rates
        if [ $TOTAL -gt 0 ]; then
            COMPLETION_RATE=$(echo "scale=2; $COMPLETED / $TOTAL" | bc)
            DISMISSAL_RATE=$(echo "scale=2; $DISMISSED / $TOTAL" | bc)
        else
            COMPLETION_RATE="0.00"
            DISMISSAL_RATE="0.00"
        fi

        # Update JSON
        UPDATED=$(echo "$CURRENT" | jq --arg skill "$SKILL_NAME" \
            --argjson total "$TOTAL" \
            --argjson auto "$AUTO" \
            --argjson manual "$MANUAL" \
            --argjson completed "$COMPLETED" \
            --argjson dismissed "$DISMISSED" \
            --argjson failed "$FAILED" \
            --arg completion_rate "$COMPLETION_RATE" \
            --arg dismissal_rate "$DISMISSAL_RATE" \
            --arg last_used "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
            --arg updated_at "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
            '.skills[$skill] = {
                "total_executions": $total,
                "auto_triggered": $auto,
                "manual_triggered": $manual,
                "completed": $completed,
                "dismissed": $dismissed,
                "failed": $failed,
                "completion_rate": ($completion_rate | tonumber),
                "dismissal_rate": ($dismissal_rate | tonumber),
                "last_used": $last_used
            } | .updated_at = $updated_at')

        echo "$UPDATED" > "$PERFORMANCE_FILE"
    fi
fi

echo "Logged: $SKILL_NAME ($TRIGGER_TYPE) -> $OUTCOME"
