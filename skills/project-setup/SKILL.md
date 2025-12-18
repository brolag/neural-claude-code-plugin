---
name: project-setup
description: Initialize or repair the Claude Code project structure with Agent Expert capabilities. Use when starting a new project, cloning a repo without .claude/, when user says "setup claude", "init project", "initialize", or when structure is incomplete.
allowed-tools: Bash, Read, Write, Glob, Grep
---

# Project Setup Skill

Initialize the Neural Claude Code architecture with Agent Expert capabilities in any project.

## Trigger Conditions

- User says "setup claude" or "init project" or "initialize"
- New project without .claude/ directory
- Project with incomplete structure detected
- SessionStart hook detects missing components

## Prerequisites

This skill assumes the **neural-claude-code-plugin** is installed globally:
```bash
claude plugin install ~/Sites/neural-claude-code-plugin --scope user
```

The plugin provides:
- Meta-agents (create agents/skills/prompts)
- Multi-AI collaboration (codex, gemini, multi-ai)
- Global skills (deep-research, content-creation, meta-skill)

## Setup Levels

### `/setup --minimal`
Quick start with basics only.

```
.claude/
├── CLAUDE.md              # Project context
└── settings.json          # Basic config
```

### `/setup --standard` (default)
Standard structure with project-specific agents.

```
.claude/
├── CLAUDE.md
├── settings.json
├── settings.local.json    # Personal (gitignored)
├── memory/
│   ├── events/
│   └── active_context.md
├── expertise/             # Agent mental models
│   └── project.yaml       # Project expertise
├── agents/                # Project-specific agents
│   └── project-expert.md  # Knows THIS project
└── skills/                # Project-specific skills
    └── generated/
```

### `/setup --full`
Complete Neural architecture with Agent Expert system.

```
.claude/
├── CLAUDE.md
├── settings.json
├── settings.local.json
├── memory/
│   ├── events/
│   ├── facts/
│   ├── active_context.md
│   └── context-cache.json
├── expertise/             # Mental models
│   ├── project.yaml       # Overall project understanding
│   ├── codebase.yaml      # Code structure expertise
│   └── domain.yaml        # Domain-specific knowledge
├── agents/
│   ├── project-expert.md  # Expert on THIS project
│   ├── code-expert.md     # Expert on THIS codebase
│   └── generated/
├── skills/
│   ├── project-specific/  # Skills for THIS project
│   └── generated/
├── commands/
│   └── dynamic/
├── rules/
│   └── code-style.md
├── policies/
│   └── acl.json
├── checkpoints/
├── eval/
├── logs/
└── scripts/
```

## Generated Files

### CLAUDE.md Template
```markdown
# {Project Name}

This project uses the **Neural Claude Code** architecture with Agent Experts.

## Project Overview
{Auto-detected or user description}

## Tech Stack
{Auto-detected}

## Agentic Architecture

### Project-Specific Agents
| Agent | Purpose |
|-------|---------|
| project-expert | Knows THIS project's structure and patterns |
| code-expert | Expert on THIS codebase |

### Expertise Files
Mental models stored in `.claude/expertise/`:
- `project.yaml` - Overall project understanding
- `codebase.yaml` - Code structure and patterns
- `domain.yaml` - Domain-specific knowledge

### Agent Expert Pattern
Agents READ expertise → VALIDATE → EXECUTE → IMPROVE

Use `/meta/improve <name>` to sync expertise with reality.

## Quick Reference
| Need | Command/Skill |
|------|---------------|
| Multi-AI input | `/ai-collab <problem>` |
| Create agent | Ask meta-agent |
| Create skill | Ask meta-skill |
| Sync expertise | `/meta/improve <name>` |
```

### project.yaml Template
```yaml
# Project Expertise
# Mental model - auto-updated by project-expert agent

domain: {project_type}
version: 1
last_updated: {timestamp}

project:
  name: "{project_name}"
  type: "{detected_type}"
  root: "{cwd}"

understanding:
  structure:
    src: "{src_location}"
    tests: "{tests_location}"
    config: "{config_files}"

  key_files: []

  patterns:
    - "{detected_pattern_1}"
    - "{detected_pattern_2}"

  conventions:
    naming: "{detected_naming}"
    structure: "{detected_structure}"

lessons_learned: []

open_questions:
  - "What are the main entry points?"
  - "What external services does this connect to?"
  - "What are the critical paths?"
```

### project-expert.md Agent
```markdown
---
name: project-expert
description: Expert on THIS specific project. Knows the codebase structure, patterns, and conventions. Use for project-specific questions, refactoring, and architectural decisions.
tools: Read, Write, Edit, Glob, Grep
model: sonnet
---

# Project Expert Agent

You are an expert on THIS specific project. You execute AND learn.

## Expertise File
Your mental model: `.claude/expertise/project.yaml`

**ALWAYS read this first**, validate against reality, then act.

## The Agent Expert Pattern

1. **READ** → Load `.claude/expertise/project.yaml`
2. **VALIDATE** → Check key_files exist, patterns still apply
3. **EXECUTE** → Perform the task with expertise
4. **IMPROVE** → Update expertise with learnings

## After Every Task

Update your expertise file with:
- New files discovered
- Patterns that worked
- Conventions observed
- Lessons learned

## Capabilities

- Navigate codebase efficiently (known locations)
- Apply project conventions consistently
- Identify architectural patterns
- Suggest improvements aligned with project style
```

## Project Type Detection

| Detected File | Type | Custom Expertise |
|--------------|------|------------------|
| package.json | Node.js | npm scripts, modules, dependencies |
| tsconfig.json | TypeScript | Type patterns, strict mode |
| requirements.txt | Python | Package structure, venv |
| Cargo.toml | Rust | Modules, traits, lifetimes |
| go.mod | Go | Package layout, interfaces |
| pom.xml | Java | Maven structure, beans |
| Obsidian vault | Second Brain | PARA, MOCs, links |

## Post-Setup Actions

1. **Add to .gitignore**:
   ```
   .claude/settings.local.json
   .claude/memory/events/
   .claude/logs/
   .claude/checkpoints/snapshots/
   ```

2. **Initial expertise scan**: Run project-expert to populate expertise file

3. **Display quick start guide**

## Quick Start Output

```markdown
## Setup Complete

**Level**: {level}
**Project Type**: {type}
**Plugin Required**: neural-claude-code-plugin (global)

### Created
- .claude/CLAUDE.md
- .claude/expertise/project.yaml
- .claude/agents/project-expert.md
- ...

### Agent Expert System

Your project now has agents that LEARN:

1. **Ask project questions** → project-expert reads expertise first
2. **After tasks** → Expertise files auto-update
3. **Sync manually** → `/meta/improve project`

### Commands
| Command | Purpose |
|---------|---------|
| `/meta/improve project` | Sync project expertise |
| `/ai-collab <problem>` | Multi-AI collaboration |

### Global Capabilities (from plugin)
- Meta-agents: Create agents, skills, prompts
- Multi-AI: Claude + Codex + Gemini
- Research: Deep research skill
- Content: Content creation skill
```

## Safety Constraints

- Never overwrite existing files (use --force to override)
- Always create .gitignore entries
- Validate JSON/YAML before writing
- Offer --dry-run for preview
- Require plugin installation for full features
