#!/bin/bash
# Session Start Hook
# Initializes session state, generates agent name, loads output style

set -e

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$HOME/Sites/neural-claude-code-plugin}"
DATA_DIR="$PWD/.claude/data"
SESSION_FILE="$DATA_DIR/current-session.json"
CONFIG_FILE="$PWD/.claude/settings.local.json"

# Create data directory if needed
mkdir -p "$DATA_DIR"

# Generate session ID
SESSION_ID="session-$(date +%s)-$$"

# Generate agent name using Ollama (with timeout and fallback)
generate_agent_name() {
  local name=""

  # Try Ollama first (5 second timeout)
  if command -v ollama &>/dev/null; then
    name=$(timeout 5 ollama run llama3.2:1b "Generate exactly one creative single-word agent name, just the name nothing else:" 2>/dev/null | head -1 | tr -d '[:space:]' | head -c 15)
  fi

  # Fallback to random name if Ollama fails
  if [ -z "$name" ] || [ ${#name} -lt 2 ]; then
    local names=("Nova" "Cipher" "Echo" "Spark" "Prism" "Flux" "Nexus" "Pulse" "Zen" "Arc" "Byte" "Core" "Delta" "Helix" "Ion" "Lux" "Orbit" "Quark" "Rune" "Sync" "Vex" "Warp" "Zephyr")
    name="${names[$RANDOM % ${#names[@]}]}"
  fi

  echo "$name"
}

AGENT_NAME=$(generate_agent_name)

# Get current output style from config or default
OUTPUT_STYLE="default"
if [ -f "$CONFIG_FILE" ]; then
  OUTPUT_STYLE=$(jq -r '.outputStyle // "default"' "$CONFIG_FILE" 2>/dev/null)
fi

# Create session state file
cat > "$SESSION_FILE" << EOF
{
  "session_id": "$SESSION_ID",
  "agent_name": "$AGENT_NAME",
  "project": "$(basename "$PWD")",
  "output_style": "$OUTPUT_STYLE",
  "started_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "prompts": []
}
EOF

# Load output style prompt if exists
STYLE_FILE="$PLUGIN_ROOT/output-styles/$OUTPUT_STYLE.md"
if [ -f "$STYLE_FILE" ]; then
  echo ""
  echo "# Output Style: $OUTPUT_STYLE"
  echo ""
  cat "$STYLE_FILE"
  echo ""
fi

# Log session start
echo "[Session $SESSION_ID started with agent '$AGENT_NAME' using '$OUTPUT_STYLE' style]" >&2
