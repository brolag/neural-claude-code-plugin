# Neural Claude Code Plugin

A self-improving agentic system for Claude Code that implements the **Agent Expert** pattern - agents that execute AND learn.

## Installation

```bash
# From GitHub
claude plugin install github:brolag/neural-claude-code-plugin --scope user

# From local path
claude plugin install ~/Sites/neural-claude-code-plugin --scope user
```

## Features

### Meta-Agentics (The System That Builds The System)

| Component | Command/Agent | Purpose |
|-----------|---------------|---------|
| Meta-Prompt | `/meta/prompt` | Creates new commands |
| Meta-Improve | `/meta/improve` | Syncs expertise files |
| Meta-Agent | `meta-agent` | Creates new agents |
| Meta-Skill | `meta-skill` | Creates new skills |

### Universal Commands

| Command | Purpose |
|---------|---------|
| `/question <anything>` | Answer any question (project, web, general) |
| `/meta/prompt <name> <purpose>` | Create a new command |
| `/meta/improve <name>` | Sync agent expertise with reality |

### Multi-AI Collaboration

| Agent | Strength | Best For |
|-------|----------|----------|
| `codex` | Terminal-Bench #1 | DevOps, long sessions, CLI |
| `gemini` | 1501 Elo | Algorithms, free tier |
| `multi-ai` | All three | Consensus, high-stakes decisions |

### Cognitive Agents

| Agent | Purpose |
|-------|---------|
| `cognitive-amplifier` | Complex decisions, bias detection |
| `insight-synthesizer` | Cross-domain pattern discovery |
| `framework-architect` | Transform content → frameworks |

### Skills

| Skill | Triggers |
|-------|----------|
| `deep-research` | "research", "investigate", "deep dive" |
| `content-creation` | "create content", "write post" |
| `project-setup` | "setup claude", "init project" |
| `memory-system` | "remember", "recall", "forget" |
| `worktree-manager` | "/wt-new", "/wt-list", "/wt-merge" |
| `pattern-detector` | "/evolve", "find patterns" |

## The Agent Expert Pattern

Traditional agents forget. Agent Experts learn.

```
┌─────────────────────────────────────┐
│       AGENT EXPERT CYCLE            │
│                                     │
│  1. READ    → Load expertise file   │
│  2. VALIDATE → Check against code   │
│  3. EXECUTE  → Perform task         │
│  4. IMPROVE  → Update expertise     │
│                                     │
└─────────────────────────────────────┘
```

### How It Works

1. **Expertise Files** (`.claude/expertise/*.yaml`) store an agent's "mental model"
2. **Before tasks**, agents read their expertise file first
3. **After tasks**, agents update their expertise with learnings
4. **Over time**, agents become true experts on your codebase

### Example Expertise File

```yaml
# .claude/expertise/project.yaml
domain: my_project
version: 3
last_updated: 2024-12-18

understanding:
  key_files:
    - src/index.ts
    - src/api/routes.ts
  patterns:
    - "Controllers use dependency injection"
    - "All API routes require auth middleware"

lessons_learned:
  - "Database migrations must run before tests"
  - "Use snake_case for database columns"
```

## Project Setup

After installing, run in any project:

```
"setup claude" or "init project"
```

This creates:
- `.claude/` directory structure
- Project-specific agents
- Expertise files for your codebase

## Quick Start

```bash
# Install the plugin
claude plugin install github:brolag/neural-claude-code-plugin --scope user

# In any project, initialize
> setup claude

# Ask questions
> /question where is the authentication logic?

# Create new agents
> Create an agent for reviewing database schemas

# Sync expertise after changes
> /meta/improve project
```

## Architecture

```
neural-claude-code-plugin/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── commands/
│   ├── meta/
│   │   ├── prompt.md        # Create prompts
│   │   └── improve.md       # Sync expertise
│   └── question.md          # Universal Q&A
├── agents/
│   ├── meta-agent.md        # Creates agents
│   ├── cognitive-amplifier.md
│   ├── insight-synthesizer.md
│   ├── framework-architect.md
│   ├── codex.md             # OpenAI Codex
│   ├── gemini.md            # Google Gemini
│   └── multi-ai.md          # Orchestrator
├── skills/
│   ├── meta-skill/          # Creates skills
│   ├── deep-research/
│   ├── content-creation/
│   ├── project-setup/
│   ├── memory-system/
│   ├── worktree-manager/
│   └── pattern-detector/
├── LICENSE
├── CHANGELOG.md
└── README.md
```

## Requirements

- Claude Code CLI
- Optional: Codex CLI (`codex`) for multi-AI
- Optional: Gemini CLI (`gemini`) for multi-AI

## License

MIT

## Author

Alfredo Bonilla ([@brolag](https://github.com/brolag))
