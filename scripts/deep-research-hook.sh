#!/bin/bash
# Deep Research Hook
# Pattern 9: 10-Minute Research Hooks
#
# This hook runs AFTER neural loop iterations to perform deep web research.
# With the 10-minute timeout (600s), it can:
# - Scrape full articles, not just snippets
# - Cross-reference multiple sources
# - Build comprehensive research corpus
#
# Trigger: Only runs if a research task is queued

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
RESEARCH_QUEUE="$PROJECT_DIR/.claude/loop/research-queue.txt"
RESEARCH_OUTPUT="$PROJECT_DIR/.claude/loop/research-results.md"
LOG_FILE="$PROJECT_DIR/.claude/logs/deep-research.log"

mkdir -p "$(dirname "$LOG_FILE")"
mkdir -p "$(dirname "$RESEARCH_QUEUE")"

log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" >> "$LOG_FILE"
}

# Check if research is queued
if [ ! -f "$RESEARCH_QUEUE" ] || [ ! -s "$RESEARCH_QUEUE" ]; then
    exit 0
fi

log "Deep research hook triggered"

# Read research tasks
TASKS=$(cat "$RESEARCH_QUEUE")
TASK_COUNT=$(echo "$TASKS" | wc -l | xargs)

log "Processing $TASK_COUNT research tasks"

# Initialize results file
cat > "$RESEARCH_OUTPUT" << EOF
# Deep Research Results
Generated: $(date)
Tasks: $TASK_COUNT

---

EOF

# Process each task
while IFS= read -r task; do
    if [ -z "$task" ]; then continue; fi

    log "Researching: $task"

    # Parse task format: "TOPIC|URL1,URL2,URL3"
    TOPIC=$(echo "$task" | cut -d'|' -f1)
    URLS=$(echo "$task" | cut -d'|' -f2)

    echo "## $TOPIC" >> "$RESEARCH_OUTPUT"
    echo "" >> "$RESEARCH_OUTPUT"

    if [ -n "$URLS" ]; then
        IFS=',' read -ra URL_ARRAY <<< "$URLS"
        for url in "${URL_ARRAY[@]}"; do
            log "  Fetching: $url"
            CONTENT=$(curl -s --max-time 120 "$url" 2>/dev/null | head -c 50000)
            if [ -n "$CONTENT" ]; then
                TEXT=$(echo "$CONTENT" | sed 's/<[^>]*>//g' | tr -s ' \n' | head -c 5000)
                echo "### Source: $url" >> "$RESEARCH_OUTPUT"
                echo "" >> "$RESEARCH_OUTPUT"
                echo "$TEXT" >> "$RESEARCH_OUTPUT"
                echo "" >> "$RESEARCH_OUTPUT"
                echo "---" >> "$RESEARCH_OUTPUT"
                echo "" >> "$RESEARCH_OUTPUT"
                log "  Scraped $(echo "$TEXT" | wc -c | xargs) chars"
            else
                log "  Failed to fetch $url"
                echo "### Source: $url (fetch failed)" >> "$RESEARCH_OUTPUT"
                echo "" >> "$RESEARCH_OUTPUT"
            fi
        done
    else
        echo "Topic queued. Add URLs for deep scraping." >> "$RESEARCH_OUTPUT"
        echo "" >> "$RESEARCH_OUTPUT"
    fi
done <<< "$TASKS"

# Finalize
TOTAL_CHARS=$(wc -c < "$RESEARCH_OUTPUT" | xargs)
log "Research complete: $TOTAL_CHARS chars"

echo "" >> "$RESEARCH_OUTPUT"
echo "---" >> "$RESEARCH_OUTPUT"
echo "Total: $TOTAL_CHARS characters" >> "$RESEARCH_OUTPUT"

# Clear queue
> "$RESEARCH_QUEUE"

echo "{\"systemMessage\": \"📚 Deep research complete ($TASK_COUNT topics, $TOTAL_CHARS chars). Results in .claude/loop/research-results.md\"}"

log "Hook complete"
exit 0
