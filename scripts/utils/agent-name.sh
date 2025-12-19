#!/bin/bash
# Generate Agent Name
# Uses Ollama for creative names, with fallback

set -e

# Try Ollama first (5 second timeout)
if command -v ollama &>/dev/null; then
  NAME=$(timeout 5 ollama run llama3.2:1b "Generate exactly one creative feminine single-word agent name (like Aurora, Luna, Nova), just the name nothing else:" 2>/dev/null | head -1 | tr -d '[:space:]' | head -c 15)

  if [ -n "$NAME" ] && [ ${#NAME} -ge 2 ]; then
    echo "$NAME"
    exit 0
  fi
fi

# Fallback to random feminine names
NAMES=("Nova" "Luna" "Aurora" "Iris" "Stella" "Aria" "Lyra" "Freya" "Athena" "Celeste" "Diana" "Electra" "Flora" "Gaia" "Hera" "Ivy" "Jade" "Kira" "Lila" "Maya" "Nyla" "Opal" "Pearl" "Quinn" "Ruby" "Sage" "Terra" "Uma" "Vera" "Willow" "Xena" "Yara" "Zara" "Amber" "Bella" "Cleo" "Dawn" "Echo" "Faye" "Grace" "Hazel" "Isla" "Juno" "Kaia" "Lena" "Mira" "Nora" "Olive")

echo "${NAMES[$RANDOM % ${#NAMES[@]}]}"
