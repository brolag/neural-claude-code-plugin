#!/bin/bash
# User Prompt Submit Hook
# Tracks prompts in session state for status line

set -e

DATA_DIR="$PWD/.claude/data"
SESSION_FILE="$DATA_DIR/current-session.json"

# Get the prompt from environment or stdin
PROMPT="${USER_PROMPT:-}"
if [ -z "$PROMPT" ]; then
  PROMPT=$(cat 2>/dev/null || echo "")
fi

# Skip if no session file or empty prompt
if [ ! -f "$SESSION_FILE" ] || [ -z "$PROMPT" ]; then
  exit 0
fi

# Truncate prompt for storage (first 100 chars)
TRUNCATED_PROMPT=$(echo "$PROMPT" | head -c 100 | tr '\n' ' ')

# Update session file with new prompt (keep last 5)
TEMP_FILE=$(mktemp)
jq --arg prompt "$TRUNCATED_PROMPT" '
  .prompts = ([$prompt] + .prompts)[:5] |
  .last_prompt_at = (now | strftime("%Y-%m-%dT%H:%M:%SZ"))
' "$SESSION_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$SESSION_FILE"

exit 0
