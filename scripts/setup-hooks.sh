#!/bin/bash
# Neural Claude Code Plugin - Hook Setup Script
# Adds TTS and session hooks to Claude Code settings

set -e

SETTINGS_FILE="$HOME/.claude/settings.json"
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$HOME/Sites/neural-claude-code-plugin}"

echo "🔧 Neural Claude Code - Hook Setup"
echo "==================================="
echo ""

# Check for jq
if ! command -v jq &>/dev/null; then
  echo "❌ jq is required but not installed."
  echo ""
  echo "Install with:"
  echo "  macOS:  brew install jq"
  echo "  Ubuntu: sudo apt-get install jq"
  exit 1
fi

# Check plugin exists
if [ ! -d "$PLUGIN_ROOT" ]; then
  echo "❌ Plugin not found at: $PLUGIN_ROOT"
  echo ""
  echo "Set CLAUDE_PLUGIN_ROOT or install plugin first."
  exit 1
fi

# Create settings directory if needed
mkdir -p "$HOME/.claude"

# Create default settings if file doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
  echo '{}' > "$SETTINGS_FILE"
  echo "📝 Created new settings file"
fi

# Backup existing settings
cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"
echo "💾 Backed up settings to $SETTINGS_FILE.backup"

# Define hooks to add (Claude Code 2.0 format)
# IMPORTANT: matcher must be a string ("") not an object ({}) for lifecycle events
HOOKS_JSON=$(cat <<EOF
{
  "Stop": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "bash $PLUGIN_ROOT/scripts/hooks/stop-tts.sh",
          "timeout": 15000
        }
      ]
    }
  ],
  "SessionStart": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "bash $PLUGIN_ROOT/scripts/hooks/session-start.sh",
          "timeout": 5000
        }
      ]
    }
  ]
}
EOF
)

# Merge hooks into settings
UPDATED=$(jq --argjson hooks "$HOOKS_JSON" '
  .hooks = (.hooks // {}) * $hooks
' "$SETTINGS_FILE")

echo "$UPDATED" > "$SETTINGS_FILE"

echo ""
echo "✅ Hooks installed successfully!"
echo ""
echo "Hooks added:"
echo "  • SessionStart → Loads context and initializes session"
echo "  • Stop → TTS summary (plays audio after responses)"
echo ""
echo "⚠️  Restart Claude Code for changes to take effect"
echo ""

# Check for ElevenLabs key
if [ -z "$ELEVENLABS_API_KEY" ]; then
  echo "📢 TTS requires ELEVENLABS_API_KEY"
  echo ""
  echo "Add to your ~/.zshrc or ~/.bashrc:"
  echo "  export ELEVENLABS_API_KEY=\"your-api-key\""
  echo ""
  echo "Get a key at: https://elevenlabs.io"
  echo ""
fi

echo "Done! Run '/doctor' in Claude Code to verify."
