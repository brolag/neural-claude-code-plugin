# Neural Claude Code Plugin

A self-improving agentic system for Claude Code that implements the **Agent Expert** pattern - agents that execute AND learn.

## Installation

```bash
# Step 1: Add the marketplace
claude plugin marketplace add brolag/neural-claude-code-plugin

# Step 2: Install the plugin
claude plugin install neural-claude-code@brolag --scope user

# Step 3: Set up hooks (enables TTS)
export CLAUDE_PLUGIN_ROOT="$HOME/Sites/neural-claude-code-plugin"
bash "$CLAUDE_PLUGIN_ROOT/scripts/setup-hooks.sh"

# Step 4: Restart Claude Code
```

Or via slash commands in Claude Code:
```
/plugin marketplace add brolag/neural-claude-code-plugin
/plugin install neural-claude-code@brolag --scope user
```

Then run the hook setup script from your terminal.

> **First time?** See the [Complete Setup Guide](docs/SETUP.md) for detailed instructions including prerequisites, ElevenLabs TTS, and Ollama setup.

## Features

### Output Styles (v1.2.0)

Switch response formats mid-session with `/output-style <name>`:

| Style | Description |
|-------|-------------|
| `default` | Standard conversational responses |
| `table` | Organized markdown tables |
| `yaml` | Highly structured YAML (best for complex tasks) |
| `concise` | Minimal tokens, maximum signal |
| `tts` | Audio summary via ElevenLabs at response end |
| `html` | Generate HTML documents, open in browser |
| `genui` | Full generative UI with rich styling |

### Status Lines (v1.2.0)

Dynamic status bar with session state tracking:

| Version | Shows |
|---------|-------|
| `v1` | Model, directory, git branch |
| `v2` | + Last prompt with emoji indicator |
| `v3` | + Agent name + trailing prompts |

Format: `🟣 opus │ 💡 create readme │ Nova │ main +2`

Emoji indicators: ❓ Questions, 💡 Create, 🔧 Fix, 🗑️ Delete, ✅ Test

### ElevenLabs TTS (v1.2.0)

Text-to-speech on task completion:
- Use `/output-style tts` to enable
- Summaries extracted via `---TTS_SUMMARY---` markers
- Automatic audio playback (macOS)

Requires `ELEVENLABS_API_KEY` environment variable.

### Agent Names (v1.2.0)

Creative agent names generated via Ollama (llama3.2:1b) to identify multiple Claude Code instances running in parallel.

### Meta-Agentics (The System That Builds The System)

| Component | Command/Agent | Purpose |
|-----------|---------------|---------|
| Meta-Prompt | `/meta/prompt` | Creates new commands |
| Meta-Improve | `/meta/improve` | Syncs expertise files with schema validation |
| Meta-Eval | `/meta/eval` | Test agents against golden tasks |
| Meta-Brain | `/meta/brain` | System health dashboard |
| Meta-Agent | `meta-agent` | Creates new agents |
| Meta-Skill | `meta-skill` | Creates new skills |

### Universal Commands

| Command | Purpose |
|---------|---------|
| `/question <anything>` | Answer any question (project, web, general) |
| `/meta:agent <name> <purpose>` | Create a new project-specific agent |
| `/meta:skill <name> <purpose>` | Create a new project-specific skill |
| `/meta:prompt <name> <purpose>` | Create a new command |
| `/meta:improve <name>` | Sync agent expertise with reality |
| `/meta:eval <name>` | Run automated tests |
| `/meta:brain` | View system health and status |

### Multi-AI Collaboration

| Agent | Strength | Best For |
|-------|----------|----------|
| `codex` | Terminal-Bench #1 | DevOps, long sessions, CLI |
| `gemini` | 1501 Elo | Algorithms, free tier |
| `multi-ai` | All three | Consensus, high-stakes decisions |

#### Intelligent Routing

The `multi-ai` agent uses intelligent routing to pick the best AI:

```yaml
task_classification:
  type: [algorithm|architecture|devops|review|debug|explain]
  complexity: [simple|moderate|complex]
  risk_level: [low|medium|high|critical]
```

| Condition | Routes To | Reason |
|-----------|-----------|--------|
| Algorithm problems | Gemini | 1501 Elo (highest) |
| Architecture decisions | Claude | 80.9% SWE-bench |
| DevOps/CLI tasks | Codex | Terminal-Bench leader |
| Critical decisions | ALL | Maximum validation |

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

### Confidence Scoring

Patterns track their effectiveness:

```yaml
patterns:
  - pattern: "Use PARA methodology for organization"
    confidence: 0.85  # (successes / (successes + failures + 1))
    successes: 17
    failures: 3
    last_used: "2024-12-18"
```

Low-confidence patterns (< 0.3) are auto-pruned with `--prune`.

### Schema Validation

All expertise files are validated against `schemas/expertise.schema.json`:
- Required fields: `domain`, `version`, `last_updated`, `understanding`
- Confidence scores: 0.0-1.0 range
- Valid date formats

## Tiered Memory Architecture

### Scope Tiers

```
┌─────────────────────────────────────────────────┐
│                 GLOBAL MEMORY                    │
│            ~/.claude/memory/                     │
│  - User preferences across all projects          │
│  - Universal patterns and learnings              │
└─────────────────────────────────────────────────┘
                      ↓ inherits
┌─────────────────────────────────────────────────┐
│                PROJECT MEMORY                    │
│           .claude/memory/                        │
│  - Project-specific facts                        │
│  - Codebase patterns                             │
└─────────────────────────────────────────────────┘
```

### Temperature Tiers

| Tier | Location | Access Speed | Use For |
|------|----------|--------------|---------|
| Hot | Context window | Instant | Current session |
| Warm | `.claude/memory/` | Seconds | Recent facts/events |
| Cold | Archives, CLAUDE.md | Manual | Historical data |

## Project Setup

After installing the plugin, initialize it in your project:

```bash
cd /path/to/your/project
claude
```

Then in Claude Code:
```
> setup claude
```

This creates:
- `.claude/data/` - Session state (gitignored)
- `.claude/expertise/` - Agent learning files
- `.claude/memory/` - Project-specific memory

For detailed setup including ElevenLabs TTS and Ollama, see [Complete Setup Guide](docs/SETUP.md).

## Quick Start

```bash
# Install the plugin
claude plugin marketplace add brolag/neural-claude-code-plugin
claude plugin install neural-claude-code@brolag --scope user

# In any project, initialize
> setup claude

# Check system health
> /meta/brain

# Switch output style
> /output-style yaml

# Ask questions
> /question where is the authentication logic?

# Get multi-AI consensus
> /ai-collab Should we use REST or GraphQL?

# Sync expertise after changes
> /meta/improve project
```

> **See also:** [Fullstack App Example](examples/fullstack-app-setup.md) for a complete walkthrough of using the plugin to build a React + Node.js app.

## Architecture

```
neural-claude-code-plugin/
├── .claude-plugin/
│   ├── plugin.json          # Plugin manifest
│   └── marketplace.json     # Marketplace config
├── commands/
│   ├── meta/
│   │   ├── prompt.md        # Create prompts (--dry-run)
│   │   ├── improve.md       # Sync expertise (--prune)
│   │   ├── eval.md          # Run tests
│   │   └── brain.md         # System status
│   ├── question.md          # Universal Q&A
│   └── output-style.md      # Switch output styles
├── output-styles/           # Response format templates
│   ├── default.md
│   ├── table.md
│   ├── yaml.md
│   ├── concise.md
│   ├── tts.md
│   ├── html.md
│   └── genui.md
├── status-lines/            # Status bar scripts
│   ├── v1.sh
│   ├── v2.sh
│   └── v3.sh
├── scripts/
│   ├── setup-hooks.sh       # One-time hook setup
│   ├── hooks/
│   │   ├── session-start.sh
│   │   ├── user-prompt.sh
│   │   └── stop-tts.sh
│   ├── tts/
│   │   └── elevenlabs.sh
│   └── utils/
│       └── agent-name.sh
├── agents/
│   ├── meta-agent.md        # Creates agents
│   ├── cognitive-amplifier.md
│   ├── insight-synthesizer.md
│   ├── framework-architect.md
│   ├── codex.md             # OpenAI Codex
│   ├── gemini.md            # Google Gemini
│   └── multi-ai.md          # Orchestrator + routing
├── skills/
│   ├── meta-skill/          # Creates skills
│   ├── deep-research/
│   ├── content-creation/
│   ├── project-setup/
│   ├── memory-system/       # Tiered memory
│   ├── worktree-manager/
│   └── pattern-detector/
├── schemas/
│   └── expertise.schema.json # Validation schema
├── templates/
│   └── expertise.template.yaml
├── hooks/
│   └── hooks.json           # Hook registrations
├── docs/
│   └── SETUP.md             # Complete setup guide
├── examples/
│   └── fullstack-app-setup.md # Real-world usage example
├── LICENSE
├── CHANGELOG.md
└── README.md
```

## New in v1.2.0

- **Output Styles**: 7 response formats (default, table, yaml, concise, tts, html, genui)
- **Status Lines**: 3 versions with model, prompt, agent name, git info
- **ElevenLabs TTS**: Audio summaries on task completion
- **Agent Names**: Ollama-generated names for multi-instance identification
- **Session State**: JSON tracking in `.claude/data/current-session.json`
- **Hooks System**: SessionStart, UserPromptSubmit, Stop hooks

## New in v1.1.0

- **Expertise Schema Validation**: JSON Schema for expertise files
- **Confidence Scoring**: Track pattern effectiveness (0.0-1.0)
- **Auto-Pruning**: Remove low-confidence patterns with `--prune`
- **`/meta/eval`**: Automated testing against golden tasks
- **`/meta/brain`**: System health dashboard
- **Git-triggered learning**: Auto-improve on commits
- **Tiered Memory**: Global + project memory hierarchy
- **Intelligent AI Routing**: Task-based routing matrix
- **`--dry-run` mode**: Preview changes before writing

## Requirements

| Requirement | Required | Purpose |
|-------------|----------|---------|
| Claude Code CLI | Yes | Core functionality |
| `jq` | Yes | JSON processing for hooks |
| Codex CLI | No | Multi-AI collaboration |
| Gemini CLI | No | Multi-AI collaboration |
| Ollama + llama3.2:1b | No | Creative agent names |
| `ELEVENLABS_API_KEY` | No | Text-to-speech summaries |

## Documentation

| Document | Description |
|----------|-------------|
| [Complete Setup Guide](docs/SETUP.md) | Step-by-step installation and configuration |
| [Fullstack App Example](examples/fullstack-app-setup.md) | Real-world usage with React + Node.js |
| [CHANGELOG](CHANGELOG.md) | Version history and changes |

## License

MIT

## Author

Alfredo Bonilla ([@brolag](https://github.com/brolag))
