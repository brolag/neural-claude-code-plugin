#!/bin/bash
# Neural Squad - Agent Heartbeat
# Runs every 15 minutes via cron, staggered per agent
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SQUAD_DIR="$PROJECT_DIR/.claude/squad"

AGENT="${1:-architect}"
AGENT_FILE="$SQUAD_DIR/agents/$AGENT.json"
WORKTREES_DIR="$(dirname "$PROJECT_DIR")/worktrees"
AGENT_WT="$WORKTREES_DIR/squad-$AGENT"

# Logging
LOG_FILE="$SQUAD_DIR/activity/heartbeat.jsonl"
log_activity() {
    local type="$1"
    local message="$2"
    echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"agent\":\"$AGENT\",\"type\":\"$type\",\"message\":\"$message\"}" >> "$LOG_FILE"
}

# Check if agent exists
if [ ! -f "$AGENT_FILE" ]; then
    echo "Error: Agent not found: $AGENT"
    exit 1
fi

# Check if worktree exists
if [ ! -d "$AGENT_WT" ]; then
    echo "Error: Worktree not found: $AGENT_WT"
    exit 1
fi

echo "=== Neural Squad Heartbeat ==="
echo "Agent: $AGENT"
echo "Time:  $(date)"
echo ""

# Update last heartbeat
jq --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '.last_heartbeat = $ts' "$AGENT_FILE" > /tmp/agent.json
mv /tmp/agent.json "$AGENT_FILE"

# Check for @mentions
MENTIONS=$(find "$SQUAD_DIR/messages" -name "*-$AGENT-*.json" -newer "$AGENT_FILE" 2>/dev/null | wc -l | tr -d ' ')
if [ "$MENTIONS" -gt 0 ]; then
    echo "Found $MENTIONS new @mentions"
    log_activity "mention" "Processing $MENTIONS mentions"
fi

# Define task queue based on agent role
case "$AGENT" in
    architect)
        QUEUE_DIR="$SQUAD_DIR/tasks/inbox"
        NEXT_STATUS="assigned"
        ;;
    dev)
        QUEUE_DIR="$SQUAD_DIR/tasks/assigned"
        NEXT_STATUS="in-progress"
        ;;
    critic)
        QUEUE_DIR="$SQUAD_DIR/tasks/review"
        NEXT_STATUS="done"
        ;;
    *)
        echo "Unknown agent role: $AGENT"
        exit 1
        ;;
esac

# Check for tasks in queue
TASK_COUNT=$(find "$QUEUE_DIR" -name "*.json" 2>/dev/null | wc -l | tr -d ' ')
echo "Tasks in queue ($QUEUE_DIR): $TASK_COUNT"

if [ "$TASK_COUNT" -eq 0 ] && [ "$MENTIONS" -eq 0 ]; then
    echo "No work to do. HEARTBEAT_OK"
    log_activity "heartbeat" "HEARTBEAT_OK - no work"
    exit 0
fi

# Get first task
TASK_FILE=$(find "$QUEUE_DIR" -name "*.json" 2>/dev/null | head -1)

if [ -n "$TASK_FILE" ]; then
    TASK_ID=$(basename "$TASK_FILE" .json)
    TASK_TITLE=$(jq -r '.title' "$TASK_FILE")

    echo ""
    echo "--- Processing Task ---"
    echo "ID: $TASK_ID"
    echo "Title: $TASK_TITLE"
    echo ""

    # Update agent status
    jq --arg tid "$TASK_ID" '.status = "working" | .current_task = $tid' "$AGENT_FILE" > /tmp/agent.json
    mv /tmp/agent.json "$AGENT_FILE"

    log_activity "task_start" "Starting task: $TASK_ID"

    # Launch Claude in the agent's worktree
    echo "Launching Claude in $AGENT_WT..."
    echo ""

    # Build the prompt based on agent role
    case "$AGENT" in
        architect)
            PROMPT="You are the Architect agent. Process this task from inbox:

Task: $TASK_TITLE
File: $TASK_FILE

1. Read the task details
2. Write a detailed spec with PITER framework
3. Create acceptance criteria
4. Move task to assigned/ with spec attached
5. Exit when done"
            ;;
        dev)
            PROMPT="You are the Dev agent. Implement this task using TDD:

Task: $TASK_TITLE
File: $TASK_FILE

1. Read the spec carefully
2. RED: Write failing test
3. GREEN: Minimal code to pass
4. REFACTOR: Clean up if tests pass
5. Move task to review/ when complete
6. Exit when done"
            ;;
        critic)
            PROMPT="You are the Critic agent. Review this implementation:

Task: $TASK_TITLE
File: $TASK_FILE

1. Stage 1: Check spec compliance
2. Stage 2: Run anti-slop checklist
3. APPROVE → move to done/
4. REJECT → move to in-progress/ with feedback
5. Exit when done"
            ;;
    esac

    # Run Claude with prompt (non-interactive for cron)
    cd "$AGENT_WT"
    echo "$PROMPT" | claude --dangerously-skip-permissions -p "$PROMPT" --max-turns 10 2>&1 || {
        log_activity "error" "Claude exited with error"
        # Reset agent status
        jq '.status = "idle" | .current_task = null' "$AGENT_FILE" > /tmp/agent.json
        mv /tmp/agent.json "$AGENT_FILE"
        exit 1
    }

    # Reset agent status
    jq '.status = "idle" | .current_task = null' "$AGENT_FILE" > /tmp/agent.json
    mv /tmp/agent.json "$AGENT_FILE"

    log_activity "task_complete" "Completed task: $TASK_ID"
    echo ""
    echo "Task processing complete."
else
    echo "No tasks, processing mentions only..."
    log_activity "heartbeat" "HEARTBEAT_OK - mentions only"
fi

echo ""
echo "=== Heartbeat Complete ==="
