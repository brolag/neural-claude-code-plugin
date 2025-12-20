#!/bin/bash
# Post-Task Learning Hook
# Automatically prompts for expertise updates after significant tasks
# Learning Loop Fix #2: Closes the Act-Learn cycle

set -e

EXPERTISE_DIR="$PWD/.claude/expertise"
MEMORY_DIR="$PWD/.claude/memory"
EVENTS_DIR="$MEMORY_DIR/events"
TODAY=$(date +%Y-%m-%d)
EVENT_LOG="$EVENTS_DIR/$TODAY.jsonl"

# ============================================
# LEARNING TRIGGERS
# ============================================

count_significant_actions() {
    [ ! -f "$EVENT_LOG" ] && echo "0" && return

    # Count Write, Edit, Task tool uses since last session_start
    tac "$EVENT_LOG" 2>/dev/null | awk '
        /session_start/ { exit }
        /tool_name.*Write|tool_name.*Edit|tool_name.*Task/ { count++ }
        END { print count+0 }
    '
}

should_prompt_learning() {
    local action_count=$(count_significant_actions)
    [ "$action_count" -ge 5 ] && echo "true" || echo "false"
}

detect_relevant_domain() {
    [ ! -f "$EVENT_LOG" ] && echo "knowledge-management" && return

    local recent_tools=$(tail -20 "$EVENT_LOG" 2>/dev/null | grep -o '"tool_name":"[^"]*"' | sort | uniq -c | sort -rn | head -1)

    if echo "$recent_tools" | grep -q "Write\|Edit"; then
        echo "knowledge-management"
    elif echo "$recent_tools" | grep -q "WebSearch\|WebFetch"; then
        echo "strategic-advisor"
    elif echo "$recent_tools" | grep -q "Task"; then
        echo "cognitive-amplifier"
    else
        echo "second-brain"
    fi
}

# ============================================
# EXPERTISE UPDATE
# ============================================

update_expertise() {
    local domain="$1"
    local learning_type="$2"
    local content="$3"
    local expertise_file="$EXPERTISE_DIR/${domain}.yaml"

    [ ! -f "$expertise_file" ] && return 1

    # Backup
    cp "$expertise_file" "$expertise_file.bak"

    # Update version
    local current_version=$(grep "^version:" "$expertise_file" | cut -d':' -f2 | xargs)
    local new_version=$((current_version + 1))
    sed -i '' "s/^version: .*/version: $new_version/" "$expertise_file"
    sed -i '' "s/^last_updated: .*/last_updated: $TODAY/" "$expertise_file"

    # Log update
    echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"event\":\"expertise_updated\",\"domain\":\"$domain\",\"type\":\"$learning_type\",\"version\":$new_version}" >> "$EVENT_LOG"
}

# ============================================
# MAIN
# ============================================

main() {
    if [ "$(should_prompt_learning)" = "true" ]; then
        local domain=$(detect_relevant_domain)
        local action_count=$(count_significant_actions)

        echo ""
        echo "# Learning Checkpoint"
        echo ""
        echo "You've completed $action_count significant actions."
        echo "Consider updating \`.claude/expertise/${domain}.yaml\` with:"
        echo "- **Patterns**: Repeatable workflows that worked"
        echo "- **Lessons**: Insights from this execution"
        echo "- **Preferences**: User behaviors learned"
        echo ""

        # Log checkpoint
        echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"event\":\"learning_checkpoint\",\"domain\":\"$domain\",\"action_count\":$action_count}" >> "$EVENT_LOG" 2>/dev/null || true
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
