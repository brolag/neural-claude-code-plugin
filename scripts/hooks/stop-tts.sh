#!/bin/bash
# Stop Hook - TTS Summary
# Extracts TTS summary from transcript and plays via ElevenLabs
# Supports multi-voice with agent identification

# Source user's shell config to get API keys
if [ -f "$HOME/.zshrc" ]; then
  eval "$(grep -E '^export\s+ELEVENLABS' "$HOME/.zshrc" 2>/dev/null)" 2>/dev/null || true
fi

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$HOME/Sites/neural-claude-code-plugin}"
DEBUG_LOG="/tmp/stop-tts-debug.log"

log_debug() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$DEBUG_LOG"
}

# Read JSON metadata from stdin
HOOK_DATA=$(cat 2>/dev/null || echo "{}")

# Extract cwd from hook data for finding session file
CWD=$(echo "$HOOK_DATA" | jq -r '.cwd // empty' 2>/dev/null)
if [ -z "$CWD" ]; then
  CWD="$PWD"
fi

# Read agent name from session file
SESSION_FILE="$CWD/.claude/data/current-session.json"
if [ -f "$SESSION_FILE" ]; then
  AGENT_NAME=$(jq -r '.agent_name // "Agent"' "$SESSION_FILE" 2>/dev/null)
else
  AGENT_NAME="Agent"
fi
log_debug "Agent name: $AGENT_NAME"

# Voice configuration - female voices only
VOICE_CONFIG="$HOME/.claude/tts-voices.json"

# Create default config with female voices if missing
if [ ! -f "$VOICE_CONFIG" ]; then
  mkdir -p "$HOME/.claude"
  cat > "$VOICE_CONFIG" << 'VOICES'
{
  "voice_pool": [
    {"id": "21m00Tcm4TlvDq8ikWAM", "name": "Rachel"},
    {"id": "EXAVITQu4vr4xnSDxMaL", "name": "Bella"},
    {"id": "AZnzlk1XvdvUeBnXmlld", "name": "Domi"},
    {"id": "MF3mGyEYCl7XYWbV9V6O", "name": "Elli"},
    {"id": "jBpfuIE2acCO8z3wKNLl", "name": "Gigi"},
    {"id": "oWAxZDx7w5VEj9dCyTzz", "name": "Grace"},
    {"id": "XB0fDUnXU5powFXDhCwa", "name": "Charlotte"},
    {"id": "pFZP5JQG7iQjIQuC4Bk1", "name": "Lily"}
  ],
  "agent_voices": {},
  "announce": true
}
VOICES
  log_debug "Created voice config with female voices"
fi

# Get or assign voice for this agent
VOICE_ID=$(jq -r --arg agent "$AGENT_NAME" '.agent_voices[$agent] // empty' "$VOICE_CONFIG" 2>/dev/null)

if [ -z "$VOICE_ID" ]; then
  # Auto-assign: pick random voice from pool
  POOL_SIZE=$(jq '.voice_pool | length' "$VOICE_CONFIG")
  RANDOM_IDX=$((RANDOM % POOL_SIZE))
  VOICE_ID=$(jq -r ".voice_pool[$RANDOM_IDX].id" "$VOICE_CONFIG")
  VOICE_NAME=$(jq -r ".voice_pool[$RANDOM_IDX].name" "$VOICE_CONFIG")

  log_debug "Auto-assigned voice $VOICE_NAME ($VOICE_ID) to agent $AGENT_NAME"

  # Save assignment
  jq --arg agent "$AGENT_NAME" --arg voice "$VOICE_ID" \
    '.agent_voices[$agent] = $voice' "$VOICE_CONFIG" > "$VOICE_CONFIG.tmp" && \
    mv "$VOICE_CONFIG.tmp" "$VOICE_CONFIG"
fi

export ELEVENLABS_VOICE_ID="$VOICE_ID"
log_debug "Using voice: $VOICE_ID"

# Extract transcript_path from JSON
TRANSCRIPT_PATH=$(echo "$HOOK_DATA" | jq -r '.transcript_path // empty' 2>/dev/null)

if [ -z "$TRANSCRIPT_PATH" ]; then
  log_debug "No transcript_path in hook data"
  exit 0
fi

# Expand tilde if present
TRANSCRIPT_PATH="${TRANSCRIPT_PATH/#\~/$HOME}"

if [ ! -f "$TRANSCRIPT_PATH" ]; then
  log_debug "Transcript file not found: $TRANSCRIPT_PATH"
  exit 0
fi

log_debug "Reading transcript: $TRANSCRIPT_PATH"

# Find last assistant message with TTS markers in TEXT content (not tool_use)
TTS_TEXT=$(grep 'TTS_SUMMARY' "$TRANSCRIPT_PATH" | \
  grep '"role":"assistant"' | \
  grep '"type":"text"' | \
  tail -1 | \
  jq -r '.message.content[] | select(.type=="text") | .text' 2>/dev/null | \
  awk '/---TTS_SUMMARY---/{flag=1; next} /---END_TTS---/{flag=0} flag' | \
  tr '\n' ' ' | \
  xargs)

log_debug "Extracted TTS text: $TTS_TEXT"

# Skip if empty
if [ -z "$TTS_TEXT" ]; then
  log_debug "TTS text is empty"
  exit 0
fi

# Prepend agent announcement
TTS_TEXT="$AGENT_NAME reporting. $TTS_TEXT"
log_debug "Final TTS text: $TTS_TEXT"

# Call ElevenLabs TTS script
if [ -x "$PLUGIN_ROOT/scripts/tts/elevenlabs.sh" ]; then
  log_debug "Calling ElevenLabs script with voice $ELEVENLABS_VOICE_ID"
  echo "$TTS_TEXT" | "$PLUGIN_ROOT/scripts/tts/elevenlabs.sh"
else
  log_debug "ElevenLabs script not found, using say fallback"
  if command -v say &>/dev/null; then
    nohup say "$TTS_TEXT" &>/dev/null &
  fi
fi

exit 0
