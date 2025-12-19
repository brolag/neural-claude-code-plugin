---
description: "Create a new skill for the project. Usage: /meta:skill <name> <purpose>"
allowed-tools: Read, Write, Glob, Grep
---

# Create Skill Command

Generate a new project-specific skill that Claude can autodiscover.

## Arguments

- `$ARGUMENTS` - Skill name and purpose (e.g., "deploy Handles deployment to production")

## Process

### 1. Parse Arguments

Extract from $ARGUMENTS:
- **name**: kebab-case skill name (first word)
- **purpose**: Skill description (remaining words)

If no arguments provided, ask the user:
- What should the skill be called?
- What does it do?
- What phrases should trigger it?

### 2. Check for Existing Skill

Look for:
```
.claude/skills/<name>/
```

If exists, ask user to confirm overwrite or choose different name.

### 3. Create Skill Directory Structure

```
.claude/skills/<name>/
├── skill.md           # Main skill definition
├── expertise.yaml     # Mental model for learning
└── templates/         # Optional templates
```

### 4. Generate skill.md

Create `.claude/skills/<name>/skill.md`:

```markdown
---
name: {name}
description: {purpose}. Use when user mentions "{name}", "{trigger phrases}", or related tasks.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# {Name} Skill

{purpose}

## When Claude Should Use This

- User mentions "{name}" or related terms
- User describes: {purpose}
- Context suggests this skill is appropriate

## Expertise File

Mental model: `expertise.yaml` (in this directory)

Read first, validate, then execute.

## Capabilities

### Primary Function
{purpose}

### Process
1. Read expertise.yaml for context
2. Gather required information
3. Execute the task
4. Update expertise with learnings

## Self-Improvement

After using this skill, update expertise.yaml with:
- Patterns that worked well
- Edge cases discovered
- User preferences learned
- Optimizations identified

## Output

Report results to user with:
- What was done
- Any issues encountered
- Suggestions for improvement
```

### 5. Generate expertise.yaml

Create `.claude/skills/<name>/expertise.yaml`:

```yaml
# {Name} Skill Expertise
# Mental model - auto-updated

domain: {domain from purpose}
version: 1
last_updated: {timestamp}

purpose: "{purpose}"

trigger_phrases:
  - "{name}"
  - "{derived triggers}"

patterns:
  successful: []
  failed: []

user_preferences: []

optimizations_discovered: []

common_requests: []
```

### 6. Report Success

```markdown
## Skill Created

**Name**: {name}
**Location**: `.claude/skills/{name}/`

### Files Created
- `skill.md` - Skill definition
- `expertise.yaml` - Learning file

### Trigger Phrases
- "{name}"
- {derived triggers}

### Usage
Claude will autodiscover this skill when you mention trigger phrases or describe tasks matching: {purpose}

### Next Steps
1. Test the skill by using trigger phrases
2. Check expertise.yaml after use for learnings
3. Customize skill.md for your specific needs
```
