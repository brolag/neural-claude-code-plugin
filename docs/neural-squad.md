# Neural Squad - Multi-Agent Orchestration

Secure multi-agent system using Claude Code, worktrees, and file-based communication.

## Overview

Neural Squad is a 3-agent team with strict role separation and anti-slop enforcement:

| Agent | Role | Capabilities |
|-------|------|--------------|
| **Architect** | Specifications | Write CRAFT specs, create/assign tasks |
| **Dev** | TDD Implementation | Write tests, write code, RED-GREEN-REFACTOR |
| **Critic** | Anti-Slop Review | Approve/reject code, two-stage gate |

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│              NEURAL SQUAD - Anti-Slop Edition               │
├─────────────────────────────────────────────────────────────┤
│   WORKFLOW: Architect → Dev → Critic (NO self-approval)    │
│                                                              │
│   ┌───────────┐     ┌───────────┐     ┌───────────┐        │
│   │ ARCHITECT │ ──▶ │    DEV    │ ──▶ │  CRITIC   │        │
│   │  (Specs)  │     │   (TDD)   │     │ (Review)  │        │
│   └───────────┘     └───────────┘     └───────────┘        │
│        │                                    │               │
│        └──────── REJECT loops back ─────────┘               │
└─────────────────────────────────────────────────────────────┘
```

## Installation

The skill is included in Neural Claude Code. Initialize with:

```bash
/squad-init
```

This creates:
- Directory structure under `.claude/squad/`
- Agent configuration files
- Git worktrees for each agent (`../worktrees/squad-*`)

## Commands

| Command | Description |
|---------|-------------|
| `/squad-init` | Initialize squad system with worktrees |
| `/squad-status` | Show current status (agents, tasks, activity) |
| `/squad-task create "title"` | Create new task in inbox |
| `/squad-task list [status]` | List tasks by status |
| `/squad-task show <id>` | Show task details |
| `/squad-task move <id> <status>` | Move task to different status |
| `/squad-standup` | Daily standup report with KPIs |
| `/squad-cron install` | Setup automated heartbeats (macOS) |
| `/squad-cron status` | Check heartbeat status |
| `/squad-cron uninstall` | Remove automated heartbeats |

## Task Flow (Kanban)

```
inbox → assigned → in-progress → review → done
  │         │           │           │        │
  │         │           │           │        └─ APPROVED by Critic
  │         │           │           └─ Awaiting review
  │         │           └─ Dev implementing (TDD)
  │         └─ Has CRAFT spec from Architect
  └─ New task created
```

## Agent Roles

### Architect

Writes CRAFT specifications before any implementation.

**CRAFT Framework:**
- **C**ontext: Current state, tech stack, constraints
- **R**equirements: Objective, success criteria, out of scope
- **A**ctions: Always do, ask first, never do
- **F**low: Step-by-step execution plan
- **T**ests: Verification commands, completion promise

### Dev

Implements using strict TDD protocol.

**Protocol:**
1. **RED** - Write failing test
2. **GREEN** - Minimum code to pass
3. **REFACTOR** - Only if tests pass

Cannot approve own work.

### Critic

Two-stage review with anti-slop enforcement.

**Stage 1: Spec Compliance**
- Does it meet all acceptance criteria?
- Do tests cover the requirements?

**Stage 2: Anti-Slop Checklist**
- No over-engineering
- No placeholder code
- No unrequested improvements
- No verbose comments
- No scope creep
- Tests verify behavior
- Minimum viable implementation

## Worktrees

Each agent works in a separate git worktree:

```
../worktrees/
├── squad-architect/   # Specs and orchestration
├── squad-dev/         # TDD implementation
└── squad-critic/      # Code review
```

Benefits:
- Isolated branches per agent
- No merge conflicts
- Clean git history
- Easy rollback

## Heartbeat Pattern

Agents wake up periodically (default: every 15 minutes):

```
1. Wake up (cron trigger)
2. Check for work in queue
3. If work: Process one task
4. Exit (fresh context next time)
```

Staggered schedule:
- Architect: :00, :15, :30, :45
- Dev: :02, :17, :32, :47
- Critic: :04, :19, :34, :49

## TAC Integration

Neural Squad implements Tactical Agentic Coding principles:

### KPIs

| KPI | Agent | Description |
|-----|-------|-------------|
| Plan Velocity | Architect | Minutes to write spec |
| Autonomy Duration | Dev | Minutes of uninterrupted work |
| Review Velocity | Critic | Minutes to review |

Track with:
```bash
/kpi plan 8 "feature name"
/kpi autonomy 45 "feature name"
/kpi review 3 "feature name"
```

### Compute Advantage

```
CA = (Compute × Autonomy) / (Time + Effort + Cost)
```

Neural Squad maximizes CA through:
- Pay-per-heartbeat (not always-on)
- Fresh context each cycle
- Automated task flow

## File Structure

```
.claude/squad/
├── config.json              # Squad configuration
├── agents/                  # Agent definitions
│   ├── architect.json
│   ├── dev.json
│   └── critic.json
├── tasks/                   # Kanban queue
│   ├── inbox/
│   ├── assigned/
│   ├── in-progress/
│   ├── review/
│   └── done/
├── messages/                # Inter-agent communication
├── activity/                # Heartbeat logs (JSONL)
└── learnings/               # Agent learnings
```

## Security Boundaries

| Agent | Can Write | Cannot |
|-------|-----------|--------|
| Architect | `.claude/squad/**`, `docs/**` | Code files, merge |
| Dev | `src/**`, `tests/**` | Squad config, approve own work |
| Critic | `reviews/**`, tasks | Code files, create tasks |

**Human Approval Required:**
- Merge to main
- Delete files
- Deploy/publish
- Create new agents

## Quick Start

```bash
# 1. Initialize
/squad-init

# 2. Create a task
/squad-task create "Add user authentication"

# 3. Check status
/squad-status

# 4. Launch agents manually (Phase 1)
cd ../worktrees/squad-architect && claude
cd ../worktrees/squad-dev && claude
cd ../worktrees/squad-critic && claude

# 5. Or setup automated heartbeats (Phase 2+)
/squad-cron install
```

## Troubleshooting

| Error | Cause | Resolution |
|-------|-------|------------|
| "Squad not initialized" | First run | Run `/squad-init` |
| "Worktree exists" | Previous run | `git worktree remove ../worktrees/squad-*` |
| "No tasks in queue" | Empty queue | Create task with `/squad-task create` |
| "Agent not found" | Invalid agent | Check `.claude/squad/agents/` |

## Related

- [CRAFT Framework](/skills/craft/skill.md)
- [KPI Tracking](/skills/kpi/skill.md)
- [TDD Skill](/skills/tdd/skill.md)
- [Worktree Manager](/skills/worktree-manager/skill.md)

---

*Neural Squad v1.0 - The team that never sleeps, but always rests.*
