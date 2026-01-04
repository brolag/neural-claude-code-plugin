#!/bin/bash
# Index Learnings Script
# Scans inbox and facts to build a searchable learnings index

set -e

PROJECT_ROOT="${1:-$PWD}"
MEMORY_DIR="$PROJECT_ROOT/.claude/memory"
LEARNINGS_DIR="$MEMORY_DIR/learnings"
INDEX_FILE="$LEARNINGS_DIR/index.json"
INBOX_DIR="$PROJECT_ROOT/inbox"
FACTS_DIR="$MEMORY_DIR/facts"

mkdir -p "$LEARNINGS_DIR"

# Initialize index if doesn't exist
if [ ! -f "$INDEX_FILE" ]; then
  echo '{"version":"1.0","last_indexed":null,"entries":[],"tags":{},"stats":{"total_entries":0,"by_source":{},"by_domain":{}}}' > "$INDEX_FILE"
fi

# Temporary file for building entries
ENTRIES_TMP=$(mktemp)
echo "[" > "$ENTRIES_TMP"
FIRST=true

index_file() {
  local file="$1"
  local source="$2"

  [ ! -f "$file" ] && return

  local filename=$(basename "$file")
  local title=""
  local domain="general"
  local tags=""
  local summary=""
  local size=$(wc -c < "$file" | tr -d ' ')
  local modified=$(stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%SZ" "$file" 2>/dev/null || date -r "$file" +%Y-%m-%dT%H:%M:%SZ)

  # Extract title from first H1 or filename
  title=$(grep -m1 "^# " "$file" 2>/dev/null | sed 's/^# //' || echo "$filename")

  # Extract domain from tags or filename patterns
  if grep -q "#domain/" "$file" 2>/dev/null; then
    domain=$(grep -o "#domain/[a-z-]*" "$file" | head -1 | sed 's/#domain\///')
  elif [[ "$filename" == *"finance"* ]] || [[ "$filename" == *"financial"* ]]; then
    domain="finance"
  elif [[ "$filename" == *"github"* ]] || [[ "$filename" == *"code"* ]]; then
    domain="engineering"
  elif [[ "$filename" == *"youtube"* ]] || [[ "$filename" == *"agentic"* ]]; then
    domain="ai"
  fi

  # Extract tags
  tags=$(grep -o "#[a-z/-]*" "$file" 2>/dev/null | tr '\n' ',' | sed 's/,$//' || echo "")

  # Extract summary (first paragraph after title, max 200 chars)
  summary=$(sed -n '/^# /,/^$/p' "$file" 2>/dev/null | tail -n +2 | head -5 | tr '\n' ' ' | cut -c1-200 || echo "")

  # Add comma separator if not first
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    echo "," >> "$ENTRIES_TMP"
  fi

  # Write entry
  cat >> "$ENTRIES_TMP" << EOF
  {
    "id": "$(echo "$file" | md5 | cut -c1-8)",
    "path": "$file",
    "source": "$source",
    "title": $(echo "$title" | jq -Rs .),
    "domain": "$domain",
    "tags": $(echo "$tags" | jq -Rs .),
    "summary": $(echo "$summary" | jq -Rs .),
    "size_bytes": $size,
    "indexed_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "modified_at": "$modified"
  }
EOF
}

# Index inbox files
if [ -d "$INBOX_DIR" ]; then
  for file in "$INBOX_DIR"/*.md; do
    [ -f "$file" ] && index_file "$file" "inbox"
  done
fi

# Index facts
if [ -d "$FACTS_DIR" ]; then
  for file in "$FACTS_DIR"/*.md "$FACTS_DIR"/*.json; do
    [ -f "$file" ] && index_file "$file" "facts"
  done
fi

echo "]" >> "$ENTRIES_TMP"

# Count entries and build stats
ENTRY_COUNT=$(grep -c '"id":' "$ENTRIES_TMP" || echo "0")
INBOX_COUNT=$(grep -c '"source": "inbox"' "$ENTRIES_TMP" || echo "0")
FACTS_COUNT=$(grep -c '"source": "facts"' "$ENTRIES_TMP" || echo "0")

# Build final index
cat > "$INDEX_FILE" << EOF
{
  "version": "1.0",
  "last_indexed": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "last_summarized": null,
  "stats": {
    "total_entries": $ENTRY_COUNT,
    "by_source": {
      "inbox": $INBOX_COUNT,
      "facts": $FACTS_COUNT
    }
  },
  "entries": $(cat "$ENTRIES_TMP")
}
EOF

rm -f "$ENTRIES_TMP"

echo "Indexed $ENTRY_COUNT learnings ($INBOX_COUNT from inbox, $FACTS_COUNT from facts)"
