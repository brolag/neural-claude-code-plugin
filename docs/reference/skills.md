# Reference: Skills

Built-in reusable skills.

---

## Core Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `memory-system` | `/remember`, `/recall`, `/forget` | Persistent memory |
| `project-setup` | `/setup`, "init project" | Initialize .claude structure |
| `evaluator` | `/eval` | Run evaluation tests |

---

## Learning Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `youtube-learner` | `/yt-learn <url>` | Extract from YouTube videos |
| `deep-research` | Research queries | Multi-source investigation |
| `content-creation` | Content requests | Create from knowledge |
| `knowledge-management` | Knowledge queries | Capture and connect notes |

---

## Development Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `tdd` | `/tdd` | RED-GREEN-REFACTOR cycle |
| `debugging` | `/debug` | 4-phase root cause analysis |
| `parallel-verification` | `/pv` | AlphaGo-style verification |

---

## Workflow Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `worktree-manager` | `/wt-*` commands | Git worktree management |
| `pattern-detector` | `/evolve` | Find automation patterns |
| `skill-builder` | "create a skill" | Generate new skills |
| `meta-skill` | Meta requests | Create skills from patterns |

---

## AI Orchestration Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `plan-execute` | `/plan-execute` | Opus + Gemini orchestration |

---

## Prompt Engineering Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `prompt-engineering` | `/prompt-*` | CRISP-E framework |

---

## Productivity Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `energy-system` | Energy mentions | Track energy levels |
| `planning` | Planning requests | GTD/PARA methodologies |

---

## Skill Properties

Each skill has:

```yaml
name: skill-name
description: What it does
trigger: /command or "phrase"
allowed-tools: Tool1, Tool2
```

---

## Creating Custom Skills

```bash
/meta:skill my-custom-skill
```

See: [How to: Create Custom Skills](../how-to/meta-agents.md)
