#!/bin/bash
# Neural Squad - Send @mention between agents
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SQUAD_DIR="$PROJECT_DIR/.claude/squad"
MESSAGES_DIR="$SQUAD_DIR/messages"

TO_AGENT="$1"
MESSAGE="$2"
FROM_AGENT="${3:-human}"

if [ -z "$TO_AGENT" ] || [ -z "$MESSAGE" ]; then
    echo "Usage: $0 <to-agent> \"message\" [from-agent]"
    echo ""
    echo "Examples:"
    echo "  $0 architect \"Please review the auth spec\""
    echo "  $0 dev \"Ready for implementation\" architect"
    echo "  $0 critic \"Need urgent review\" dev"
    exit 1
fi

# Validate agent exists
if [ ! -f "$SQUAD_DIR/agents/$TO_AGENT.json" ]; then
    echo "Error: Agent not found: $TO_AGENT"
    echo "Available: architect, dev, critic"
    exit 1
fi

# Create message
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
MSG_ID="${FROM_AGENT}-${TO_AGENT}-${TIMESTAMP}"
MSG_FILE="$MESSAGES_DIR/${MSG_ID}.json"

cat > "$MSG_FILE" << EOF
{
  "id": "$MSG_ID",
  "from": "$FROM_AGENT",
  "to": "$TO_AGENT",
  "message": "$MESSAGE",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "read": false
}
EOF

echo ""
echo "## Message Sent"
echo ""
echo "**To**: @$TO_AGENT"
echo "**From**: $FROM_AGENT"
echo "**Message**: $MESSAGE"
echo ""
echo "Agent will receive on next heartbeat."

# Log activity
echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"agent\":\"$FROM_AGENT\",\"type\":\"mention\",\"message\":\"@$TO_AGENT: $MESSAGE\"}" >> "$SQUAD_DIR/activity/heartbeat.jsonl"

# Optional: Send Telegram notification
if [ -f "$PROJECT_DIR/.claude/scripts/.telegram-config" ]; then
    source "$PROJECT_DIR/.claude/scripts/.telegram-config"
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d text="📩 @$TO_AGENT mentioned by $FROM_AGENT: $MESSAGE" \
        > /dev/null 2>&1
fi
