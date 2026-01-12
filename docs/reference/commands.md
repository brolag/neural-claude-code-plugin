# Reference: Commands

Complete list of all slash commands.

---

## Core Commands

| Command | Description |
|---------|-------------|
| `/evolve` | Run self-improvement cycle |
| `/health` | System health check |
| `/question` | Answer any question |

---

## Memory Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/remember <fact>` | Save to memory | `/remember API uses JWT` |
| `/recall <query>` | Search memory | `/recall database` |
| `/forget <id>` | Remove from memory | `/forget jwt-fact` |

---

## Loop Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/loop "task"` | Unified loop (v3) | `/loop "Fix all errors"` |
| `/loop "task" --afk` | AFK mode (sandbox) | `/loop "Build API" --afk` |
| `/loop "task" --once` | Single iteration | `/loop "Quick fix" --once` |
| `/loop-plan "task"` | Plan before loop | `/loop-plan "Add auth"` |
| `/loop-start "task"` | Start loop (legacy) | `/loop-start "task" --max 20` |
| `/loop-status` | Check progress | `/loop-status` |
| `/loop-cancel` | Stop active loop | `/loop-cancel` |
| `/loop-init` | Initialize loop files | `/loop-init` |

**Loop Options:**
- `--max <n>` - Maximum iterations (default: 20)
- `--promise "<text>"` - Completion phrase
- `--type <type>` - Loop type: feature, coverage, lint, entropy
- `--afk` - Run in Docker sandbox
- `--once` - Single iteration only

---

## Todo Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/todo-new "task"` | Create todo.md | `/todo-new "Build API"` |
| `/todo-check` | Check progress | `/todo-check` |

---

## AI Collaboration Commands

| Command | Description |
|---------|-------------|
| `/ai-collab <problem>` | Get all AI perspectives |
| `/pv-mesh <problem>` | Parallel Multi-AI (3x faster) |
| `/plan-execute <task>` | Opus plans + Gemini executes |
| `/route <task>` | Get routing recommendation |
| `/pv <problem>` | Parallel verification (single AI) |

---

## Research Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/research-swarm <topic>` | Parallel research agents | `/research-swarm "React vs Vue"` |
| `/yt-learn <url>` | Learn from YouTube | `/yt-learn https://...` |
| `/pdf-learn <file>` | Learn from PDF | `/pdf-learn ./doc.pdf` |
| `/gh-learn <url>` | Learn from GitHub repo | `/gh-learn https://github.com/...` |

---

## Teleport Commands

| Command | Description |
|---------|-------------|
| `/teleport` | Switch to cloud Claude |
| `/teleport-sync export` | Export memory for cloud |
| `/teleport-sync import` | Import memory from cloud |
| `/teleport-sync status` | Check sync status |

---

## Meta Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/meta:agent <name>` | Create agent | `/meta:agent security-checker` |
| `/meta:skill <name>` | Create skill | `/meta:skill api-testing` |
| `/meta:prompt <name>` | Create command | `/meta:prompt deploy` |
| `/meta:improve <name>` | Sync expertise | `/meta:improve project` |
| `/meta:eval` | Run tests | `/meta:eval` |
| `/meta:brain` | System dashboard | `/meta:brain` |

---

## Output Style Commands

| Command | Description |
|---------|-------------|
| `/output-style default` | Standard responses |
| `/output-style yaml` | Structured YAML |
| `/output-style table` | Markdown tables |
| `/output-style concise` | Minimal output |
| `/output-style tts` | With audio summary |
| `/output-style html` | Generate HTML |
| `/output-style genui` | Rich UI |

---

## Prompt Engineering Commands

| Command | Description |
|---------|-------------|
| `/prompt-review <file>` | Assess quality (CRISP-E) |
| `/prompt-improve <file>` | Multi-AI improvement |
| `/prompt-validate <file>` | Verify links/claims |

---

## Worktree Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/wt-new <name>` | Create worktree | `/wt-new feature-auth` |
| `/wt-list` | List worktrees | `/wt-list` |
| `/wt-merge <name>` | Merge worktree | `/wt-merge feature-auth` |
| `/wt-clean <name>` | Remove worktree | `/wt-clean feature-auth` |

---

## TDD Commands

| Command | Description |
|---------|-------------|
| `/tdd` | Start TDD workflow |
| `/debug` | Start debugging workflow |
