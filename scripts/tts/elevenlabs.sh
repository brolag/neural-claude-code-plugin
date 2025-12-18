#!/bin/bash
# ElevenLabs Text-to-Speech
# Converts text to speech and plays it

set -e

# Configuration
VOICE_ID="${ELEVENLABS_VOICE_ID:-21m00Tcm4TlvDq8ikWAM}"  # Rachel voice
MODEL_ID="${ELEVENLABS_MODEL_ID:-eleven_monolingual_v1}"
API_KEY="${ELEVENLABS_API_KEY:-}"

# Check for API key
if [ -z "$API_KEY" ]; then
  echo "Warning: ELEVENLABS_API_KEY not set, skipping TTS" >&2
  exit 0
fi

# Get text from stdin or argument
TEXT="${1:-}"
if [ -z "$TEXT" ]; then
  TEXT=$(cat 2>/dev/null || echo "")
fi

# Skip if empty
if [ -z "$TEXT" ]; then
  exit 0
fi

# Truncate to 500 chars for API limits
TEXT=$(echo "$TEXT" | head -c 500)

# Create temp file for audio
AUDIO_FILE=$(mktemp /tmp/claude-tts-XXXXXX.mp3)

# Call ElevenLabs API
HTTP_STATUS=$(curl -s -w "%{http_code}" -o "$AUDIO_FILE" \
  -X POST "https://api.elevenlabs.io/v1/text-to-speech/$VOICE_ID" \
  -H "Accept: audio/mpeg" \
  -H "Content-Type: application/json" \
  -H "xi-api-key: $API_KEY" \
  -d "{
    \"text\": $(echo "$TEXT" | jq -Rs .),
    \"model_id\": \"$MODEL_ID\",
    \"voice_settings\": {
      \"stability\": 0.5,
      \"similarity_boost\": 0.75
    }
  }" 2>/dev/null)

# Check response
if [ "$HTTP_STATUS" != "200" ]; then
  echo "ElevenLabs API error: HTTP $HTTP_STATUS" >&2
  rm -f "$AUDIO_FILE"
  exit 1
fi

# Play audio (macOS)
if command -v afplay &>/dev/null; then
  afplay "$AUDIO_FILE" &
# Linux fallback
elif command -v mpv &>/dev/null; then
  mpv --no-video "$AUDIO_FILE" &>/dev/null &
elif command -v play &>/dev/null; then
  play "$AUDIO_FILE" &>/dev/null &
fi

# Clean up after playback
(sleep 30 && rm -f "$AUDIO_FILE") &>/dev/null &

exit 0
