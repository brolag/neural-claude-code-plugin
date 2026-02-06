---
description: Garbage collect the second brain - find and clean unused files, stale facts, duplicate notes, and bloated directories
allowed-tools: Bash, Read, Write, Glob, Grep, Edit, Task, AskUserQuestion
argument-hint: [--dry-run] [--aggressive] [--area <inbox|facts|events|scripts>]
---

# /cleanse - Second Brain Garbage Collector

Audit and clean the second brain: find duplicates, stale data, bloated directories, and unused files.

## Usage

```bash
/cleanse                    # Full audit + interactive cleanup
/cleanse --dry-run          # Audit only, show what would be cleaned
/cleanse --aggressive       # Also archive old event logs and compress
/cleanse --area inbox       # Only clean specific area
/cleanse --area facts       # Only audit facts
/cleanse --area events      # Only handle event logs
/cleanse --area scripts     # Only check scripts for bloat
```

## Arguments

`$ARGUMENTS` - Options for the cleanse

| Option | Description |
|--------|-------------|
| `--dry-run` | Show what would be cleaned without making changes |
| `--aggressive` | Include event log archival and compression |
| `--area <name>` | Focus on specific area: `inbox`, `facts`, `events`, `scripts`, `skills` |

## Process

### Phase 1: Audit

Scan all areas and build a garbage report:

```
1. INBOX (inbox/*.md)
   - Find duplicate/similar filenames (same topic, same date)
   - Find oversized notes (>30KB may need splitting)
   - Count zz-archived items that could be permanently removed
   - Check for stale items (>30 days unprocessed)

2. FACTS (.claude/memory/facts/*.json)
   - Read each fact and check for staleness
   - Look for: completed sprints, passed dates, resolved tasks
   - Check for duplicate content across facts

3. EVENT LOGS (.claude/memory/events/*.jsonl)
   - Calculate total size
   - Identify logs older than 2 weeks
   - Check if compressed archives exist in events-archive/

4. SCRIPTS (.claude/scripts/)
   - Find node_modules/ directories (should be gitignored)
   - Find files > 100KB
   - Check for unused scripts

5. SKILLS (.claude/skills/)
   - Find stray directories (.claude dirs inside skills)
   - Check for empty or placeholder skills
   - Identify archived skills that could be removed
```

### Phase 2: Report

Present findings in a structured report:

```markdown
## Cleanse Report

### Garbage Found

| Area | Issue | Size | Items |
|------|-------|------|-------|
| inbox | Duplicate notes | 180KB | 8 files |
| facts | Stale facts | 12KB | 5 files |
| events | Old logs (>2 weeks) | 84MB | 11 files |
| scripts | node_modules | 29MB | 1 dir |

### Total Recoverable: ~113 MB

### Recommended Actions
1. [action]
2. [action]
```

### Phase 3: Interactive Cleanup

Ask user which actions to execute:

```
AskUserQuestion: "Which garbage collection actions should I execute?"
Options:
- All recommended actions
- Safe only (no deletions, only archive/rename)
- Let me review first
- Skip (dry run only)
```

### Phase 4: Execute

For each approved action:

**Inbox Duplicates:**
- Use Task agent to read all duplicates, consolidate into one canonical note
- Rename originals with `zz-archived-` prefix (safety hooks block deletion)

**Stale Facts:**
- Move to `.claude/memory/facts/archived/` subdirectory

**Event Logs (if --aggressive):**
- Compress old logs with gzip to `.claude/memory/events-archive/`
- Note: deletion of originals requires manual action (safety hook protected)

**Scripts Bloat:**
- Delete `node_modules/` directories
- Verify `.gitignore` includes `node_modules/`

**Stray Directories:**
- Note: `.claude/skills/` is protected by safety hooks - provide manual command

### Phase 5: Summary

```markdown
## Cleanse Complete

| Action | Before | After | Saved |
|--------|--------|-------|-------|
| node_modules | 29MB | 0 | 29MB |
| Inbox notes | 27 active | 20 active | 8 consolidated |
| Facts | 20 | 15 | 5 archived |

### Manual Actions Needed
(items blocked by safety hooks)

```bash
# Protected paths - run manually if desired
rm .claude/memory/events/2026-01-*.jsonl
rm -r .claude/skills/*/lessons/.claude/
```
```

## Implementation Details

### Duplicate Detection Algorithm

```python
# Group inbox files by topic prefix
# Files with same date + similar name = likely duplicates
# Example: agentic-*-2026-02-03.md -> group "agentic-2026-02-03"

import re
groups = {}
for file in inbox_files:
    # Extract topic and date
    match = re.match(r'(.+?)(?:-\d{4}-\d{2}-\d{2})?\.md$', file)
    if match:
        topic = match.group(1)
        groups.setdefault(topic, []).append(file)

# Groups with 3+ files are likely duplicates
duplicates = {k: v for k, v in groups.items() if len(v) >= 3}
```

### Fact Staleness Check

A fact is stale if:
- References a completed sprint or past weekly plan
- Contains a date that's >30 days old AND is a task/progress type
- Is a session summary (captured in evolution logs)
- References a project that's been archived

### Safety Hook Awareness

The damage-control hook blocks:
- `rm -rf` patterns
- Deletions from `.claude/memory/`
- Deletions from `.claude/skills/`

Workarounds:
- Use `mv` to archive instead of `rm`
- Create `archived/` subdirectories
- Rename with `zz-archived-` prefix
- Provide manual commands for protected paths

## Output Format

```markdown
## Cleanse Report - {DATE}

### Scan Results

| Area | Files | Size | Issues |
|------|-------|------|--------|
| inbox/ | {n} | {size} | {n} duplicates, {n} stale |
| facts/ | {n} | {size} | {n} stale |
| events/ | {n} | {size} | {n} archivable |
| scripts/ | {n} | {size} | {n} bloated |
| skills/ | {n} | {size} | {n} stray |

### Garbage Found
1. {description} ({size})
2. {description} ({size})

### Actions Taken
- [x] {action} (-{size})
- [x] {action} (-{size})

### Manual Actions Needed
```bash
{command}
```

### Health Score Impact
Before: {score}/100
After: {score}/100 (+{delta})
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Safety hook blocked deletion | Protected path | Archive/rename instead, provide manual command |
| Consolidation agent timeout | Large files | Increase timeout or consolidate fewer files |
| No duplicates found | Clean inbox | Skip to next phase |
| Events dir too large to read | JSONL files > 256KB | Use Bash for analysis instead of Read |

**Fallback**: If any phase fails, continue to next phase and report partial results.

## Examples

```bash
# Standard cleanup
/cleanse

# Preview only
/cleanse --dry-run

# Deep clean including event compression
/cleanse --aggressive

# Just clean inbox
/cleanse --area inbox

# Just audit facts
/cleanse --area facts --dry-run
```

## Related Commands

| Command | Purpose |
|---------|---------|
| `/evolve` | Full system evolution (includes health score) |
| `/recall` | Search knowledge base |
| `/remember` | Save a fact |
| `/forget` | Remove a fact |
