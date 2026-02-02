---
name: knowledge-management
description: Use when user mentions capturing ideas, connecting notes, finding patterns in knowledge base, evolving understanding, or organizing second brain content.
allowed-tools: Read, Write, Edit, Glob, Grep
language: auto
---

# Knowledge Management Skill

Comprehensive knowledge management for a PARA-based second brain system.

## Language-Aware Routing (Pattern 8)

This skill automatically detects and adapts to the user's language context.

### Detection Logic

1. **Input language**: Analyze user's message language
2. **Target folder context**: Check existing notes in target folder
3. **User preference**: Check user's language setting (if set)
4. **Default**: English for technical, Spanish for personal

### Language Rules

| Context | Language | Template |
|---------|----------|----------|
| 02_areas/personal/ | Spanish | Spanish metadata, Spanish content |
| 02_areas/desarrollo/ | Spanish | Spanish but code comments in English |
| 03_resources/programming/ | English | English technical format |
| User says "en español" | Spanish | Override to Spanish |
| User says "in English" | English | Override to English |

### Auto-Detection

When processing input:
1. Check for Spanish keywords: "captura", "guarda", "recuerda", "idea"
2. Check for English keywords: "capture", "save", "remember", "idea"
3. Check target folder's existing notes (80%+ same language = match)
4. Apply detected language to output

## When Claude Should Use This Skill

- User mentions "capture", "save this", "remember this idea"
- User asks to "connect notes", "find related", "link concepts"
- User wants to "find patterns", "evolve knowledge", "track learning"
- User asks about their knowledge base structure or organization
- Working with notes in the 00_inbox/, 01_projects/, 02_areas/, 03_resources/ folders

## Capabilities

### 1. Intelligent Capture
Process raw input into structured knowledge:
- Apply progressive summarization techniques
- Generate appropriate metadata and tags
- Suggest optimal PARA location
- Create connections to existing knowledge

### 2. Connection Building
Find and create connections between notes:
- Analyze vault content for patterns
- Identify cross-domain bridges
- Update MOCs with new connections
- Discover knowledge gaps

### 3. Knowledge Evolution
Track how knowledge develops over time:
- Map knowledge network topology
- Identify hub nodes and bridges
- Detect emergence patterns
- Predict future connections

## PARA Structure

```
00_inbox/       - Capture first, process later
01_projects/    - Active work with deadlines
02_areas/       - Ongoing responsibilities
03_resources/   - Reference material
04_archive/     - Inactive items
05_daily/       - Daily notes and journals
```

## Processing Workflow

1. **Capture** -> 00_inbox/ with timestamp
2. **Clarify** -> Determine type and destination
3. **Organize** -> Move to correct PARA location
4. **Connect** -> Link to related notes and MOCs
5. **Evolve** -> Track patterns over time

## Connection Types

| Type | Description |
|------|-------------|
| Project-Resource | Link projects to supporting knowledge |
| Area-Project | Connect responsibilities to active work |
| Cross-pollination | Unexpected connections between domains |
| Evolution | Track how ideas develop over time |

## Output Formats

- Wiki-style links: `[[Note Name]]`
- Tags: `#topic #subtopic`
- Metadata: YAML frontmatter
- MOC updates: Map of Content linking

## Usage

```bash
# Capture a new idea to inbox
/capture "Idea about using energy levels for task scheduling"

# Find connections for a specific note
/connect "03_resources/programming/AI-coding-patterns.md"

# Process inbox items
/process inbox

# Search for related knowledge
/knowledge search "prompt engineering"

# Build connections across vault
/knowledge evolve
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| PARA folder not found | Missing directory structure | Create folders: 00_inbox/, 01_projects/, 02_areas/, 03_resources/, 04_archive/ |
| Duplicate note detected | Note with same name already exists | Rename new note with date suffix or merge with existing note |
| Invalid wiki link | Referenced note does not exist | Create the missing note or fix the link to an existing note |
| MOC update failed | Map of Content file locked or missing | Check MOC file exists and is writable, create if necessary |
| Tag index out of sync | Tags in notes don't match index | Rebuild tag index by scanning all notes in vault |

**Fallback**: If automated knowledge management fails, manually place the note in 00_inbox/ with a timestamp filename, add basic tags in YAML frontmatter, and process during the next inbox review session.
