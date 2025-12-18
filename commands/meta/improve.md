---
description: Self-improve command - sync agent/skill expertise with reality
allowed-tools: Read, Write, Edit, Glob, Grep
argument-hint: [agent-or-skill-name]
---

# Self-Improve: Expertise Synchronization

Sync an agent or skill's mental model (expertise file) with the actual codebase/vault state.

## Arguments
- `$ARGUMENTS` - Name of agent or skill to improve (e.g., "knowledge-management", "cognitive-amplifier")

## Self-Improvement Protocol

### Step 1: Load Current Expertise
Read the expertise file:
```
.claude/expertise/<name>.yaml
```

### Step 2: Validate Against Reality

For each element in the expertise file:
1. **File locations**: Verify files still exist at documented paths
2. **Patterns**: Check if patterns are still accurate
3. **Understanding**: Validate assumptions against current state

### Step 3: Discover New Information

Scan the relevant domain for:
- New files that should be tracked
- Changed patterns
- New user preferences (from recent usage)
- Updated relationships

### Step 4: Update Expertise File

Modify the YAML file with:
```yaml
# Updated fields
last_updated: [current timestamp]
version: [increment]

# New discoveries
understanding:
  key_files: [updated list]
  patterns: [refined patterns]

lessons_learned:
  - "[New insight from this sync]"

# Resolved questions
open_questions: [remaining questions only]
```

### Step 5: Report Changes

Output:
- What was validated
- What was updated
- What new insights were discovered
- What questions were resolved
- What questions remain

## Usage Examples

```bash
# Improve knowledge management skill
/meta/improve knowledge-management

# Improve strategic advisor agent
/meta/improve strategic-advisor

# Improve entire second brain understanding
/meta/improve second-brain
```

## Quality Standards

Updates must:
- Be based on actual evidence, not assumptions
- Preserve valuable historical insights
- Add concrete, actionable learnings
- Remove outdated information
- Maintain YAML validity
