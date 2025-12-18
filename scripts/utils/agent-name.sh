#!/bin/bash
# Generate Agent Name
# Uses Ollama for creative names, with fallback

set -e

# Try Ollama first (5 second timeout)
if command -v ollama &>/dev/null; then
  NAME=$(timeout 5 ollama run llama3.2:1b "Generate exactly one creative single-word agent name, just the name nothing else:" 2>/dev/null | head -1 | tr -d '[:space:]' | head -c 15)

  if [ -n "$NAME" ] && [ ${#NAME} -ge 2 ]; then
    echo "$NAME"
    exit 0
  fi
fi

# Fallback to random name
NAMES=("Nova" "Cipher" "Echo" "Spark" "Prism" "Flux" "Nexus" "Pulse" "Zen" "Arc" "Byte" "Core" "Delta" "Helix" "Ion" "Lux" "Orbit" "Quark" "Rune" "Sync" "Vex" "Warp" "Zephyr" "Atlas" "Blaze" "Crest" "Drift" "Edge" "Frost" "Glide" "Haze" "Jade" "Kite" "Luna" "Mist" "Neon" "Opal" "Peak" "Quest" "Ridge" "Sage" "Tide" "Umbra" "Volt" "Wave" "Xenon" "Yonder" "Zenith")

echo "${NAMES[$RANDOM % ${#NAMES[@]}]}"
