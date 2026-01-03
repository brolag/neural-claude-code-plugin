#!/bin/bash
# Post Tool Use Hook
# Logs all tool usage to events for pattern analysis
# Also tracks Skill tool usage for performance metrics

MEMORY_DIR="$PWD/.claude/memory"
EVENTS_DIR="$MEMORY_DIR/events"
TODAY=$(date +%Y-%m-%d)
EVENT_LOG="$EVENTS_DIR/$TODAY.jsonl"
SKILL_LOG_SCRIPT="$PWD/.claude/scripts/log-skill-execution.sh"

# Ensure directory exists
mkdir -p "$EVENTS_DIR"

# Read tool info from stdin (Claude passes JSON with tool details)
INPUT=$(cat)

# Try multiple patterns to extract tool name
TOOL_NAME=""

# Pattern 1: "tool_name":"X"
if [ -z "$TOOL_NAME" ]; then
    TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*:.*"\([^"]*\)".*/\1/')
fi

# Pattern 2: "name":"X"
if [ -z "$TOOL_NAME" ]; then
    TOOL_NAME=$(echo "$INPUT" | grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*:.*"\([^"]*\)".*/\1/')
fi

# Pattern 3: tool_name field in different format
if [ -z "$TOOL_NAME" ]; then
    TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // .name // empty' 2>/dev/null)
fi

# Only log if we got valid input and it's not empty
if [ -n "$TOOL_NAME" ] && [ "$TOOL_NAME" != "null" ]; then
    # Create event entry
    EVENT="{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"event\":\"tool_use\",\"tool_name\":\"$TOOL_NAME\"}"

    # Append to log
    echo "$EVENT" >> "$EVENT_LOG" 2>/dev/null || true

    # === SKILL TRACKING ===
    # If this is the Skill tool, extract skill name and log it
    if [ "$TOOL_NAME" = "Skill" ]; then
        # Extract skill name from input
        SKILL_NAME=""

        # Try to get skill name from "skill":"X" pattern
        SKILL_NAME=$(echo "$INPUT" | grep -o '"skill"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*:.*"\([^"]*\)".*/\1/')

        # Fallback: try jq
        if [ -z "$SKILL_NAME" ]; then
            SKILL_NAME=$(echo "$INPUT" | jq -r '.skill // .input.skill // empty' 2>/dev/null)
        fi

        # Log skill execution if we found the skill name
        if [ -n "$SKILL_NAME" ] && [ "$SKILL_NAME" != "null" ] && [ -x "$SKILL_LOG_SCRIPT" ]; then
            # Log as "started" - completion tracking would need PreToolUse + PostToolUse correlation
            bash "$SKILL_LOG_SCRIPT" "$SKILL_NAME" "manual" "completed" 2>/dev/null &
        fi
    fi
fi

exit 0
