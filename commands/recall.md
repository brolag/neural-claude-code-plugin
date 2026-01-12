---
description: Search and retrieve facts from memory
allowed-tools: Read, Glob, Grep
argument-hint: <topic or keyword>
---

# /recall - Memory Retrieval

Search learnings, facts, and knowledge from the memory system.

## Usage

```bash
/recall <topic>                  # Search by topic
/recall ai agents                # Search by domain + keyword
/recall recent                   # Show recent learnings
/recall --refresh                # Rebuild index first
```

## Arguments
`$ARGUMENTS` - Topic, keyword, or domain to search for

## Protocol

### Step 1: Search Learnings Index

```bash
# Check if index exists
.claude/memory/learnings/index.json
```

Search entries by:
- Title match
- Domain match (ai, finance, engineering, business)
- Tags match

### Step 2: Search Strategy

| Query Type | Search Pattern |
|------------|----------------|
| **Domain** | "ai", "finance", "engineering" → filter by domain |
| **Keyword** | Grep through indexed files |
| **Recent** | Sort by modified_at, show newest |

### Step 3: Retrieve Full Content

Once matches found:
1. Read the source file (inbox/*.md or facts/*.json)
2. Extract relevant sections
3. Present with context

### Step 4: Format Response

```markdown
## Recalled: [Topic]

### From: [Source Title]
*Source: inbox/[filename].md | Indexed: [date]*

[Relevant content from the learning]

### Key Points
- Point 1
- Point 2

### Related
- [Other matching learnings if any]
```

## Examples

```bash
# Recall by domain
/recall ai agents
→ Returns learnings tagged with AI, agents

# Recall by keyword
/recall orchestration
→ Searches all learnings for "orchestration"

# Recall recent
/recall recent
→ Shows learnings from last 7 days

# Recall specific source
/recall claude-code
→ Finds all Claude Code related learnings
```

## Index Structure

The learnings index at `.claude/memory/learnings/index.json`:

```json
{
  "entries": [
    {
      "id": "abc123",
      "path": "/path/to/file.md",
      "source": "inbox|facts",
      "title": "Learning Title",
      "domain": "ai|finance|engineering|business|general",
      "tags": "#tag1,#tag2",
      "summary": "Brief summary...",
      "indexed_at": "2025-12-29T..."
    }
  ]
}
```

## Refresh Index

If learnings seem stale:
```bash
bash .claude/scripts/index-learnings.sh
```

## Output Format

```markdown
## Recalled: [Topic]

### From: [Source Title]
*Source: inbox/[filename].md | Indexed: [date]*

[Relevant content excerpt]

### Key Points
- Point 1
- Point 2

### Related Learnings
- [Other matching titles]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No index found | Index not created | Run `/recall --refresh` |
| No matches | Topic not in memory | Try broader terms or `/remember` first |
| Stale results | Index out of date | Run `bash .claude/scripts/index-learnings.sh` |
| Empty inbox | No learnings captured | Use `/yt-learn`, `/learn`, or `/remember` |

**Fallback**: If index missing, search inbox/*.md files directly.

## Quality Standards

- Return actual content, not just references
- Include source attribution
- Show related learnings when relevant
- Keep output focused on the query
