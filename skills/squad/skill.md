---
name: squad
description: Neural Squad - Multi-agent orchestration with anti-slop enforcement. Use when user says "/squad", "squad status", "create squad task", or wants to manage the agent team.
trigger: /squad, /squad-init, /squad-status, /squad-task
allowed-tools: Bash, Read, Write, Glob
---

# Neural Squad - Multi-Agent Orchestration

Secure multi-agent system using Claude Code, worktrees, and file-based communication.

## Overview

Neural Squad is a 3-agent team with strict role separation:

| Agent | Role | Capabilities |
|-------|------|--------------|
| **Architect** | Specifications | Write specs, create/assign tasks, define interfaces |
| **Dev** | TDD Implementation | Write tests, write code, refactor (RED-GREEN-REFACTOR) |
| **Critic** | Anti-Slop Review | Review code, approve/reject, two-stage gate |

## Commands

### `/squad-init`
Initialize the squad system with worktrees.

```bash
bash .claude/scripts/squad/init.sh
```

### `/squad-status`
Show current squad status (agents, tasks, activity).

```bash
bash .claude/scripts/squad/status.sh
```

### `/squad-task create "<title>"`
Create a new task in the inbox.

```bash
bash .claude/scripts/squad/task.sh create "Task title"
```

### `/squad-task list [status]`
List tasks by status.

```bash
bash .claude/scripts/squad/task.sh list inbox
bash .claude/scripts/squad/task.sh list assigned
bash .claude/scripts/squad/task.sh list all
```

### `/squad-task show <id>`
Show task details.

```bash
bash .claude/scripts/squad/task.sh show 20260203-143022
```

### `/squad-task move <id> <status>`
Move task to different status.

```bash
bash .claude/scripts/squad/task.sh move 20260203-143022 assigned
```

### `/squad-standup`
Daily standup report with KPIs.

```bash
bash .claude/scripts/squad/standup.sh
bash .claude/scripts/squad/standup.sh --telegram
```

### `/squad-cron [install|uninstall|status]`
Manage automated heartbeats.

```bash
bash .claude/scripts/squad/cron-setup.sh status
bash .claude/scripts/squad/cron-setup.sh install
bash .claude/scripts/squad/cron-setup.sh uninstall
```

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

## File Structure

```
.claude/squad/
├── config.json              # Squad configuration
├── agents/                  # Agent definitions
│   ├── architect.json
│   ├── dev.json
│   └── critic.json
├── tasks/                   # Kanban queue
│   ├── inbox/               # New tasks
│   ├── assigned/            # With specs
│   ├── in-progress/         # Being worked
│   ├── review/              # Awaiting critic
│   └── done/                # Completed
├── messages/                # Inter-agent communication
├── activity/                # Heartbeat logs
└── learnings/               # Agent learnings

../worktrees/
├── squad-architect/         # Architect's worktree
├── squad-dev/               # Dev's worktree
└── squad-critic/            # Critic's worktree
```

## TAC Principles Applied

- **Compute Advantage**: Pay-per-heartbeat, not always-on
- **Fresh Context**: Each heartbeat = clean context
- **Two-Stage Review**: Critic checks spec compliance, then code quality
- **TDD Everything**: Dev enforces RED-GREEN-REFACTOR
- **Anti-Slop**: Critic rejects over-engineering, scope creep

## TAC Integration (v1.7.0)

| Command | Agent | Purpose |
|---------|-------|---------|
| `/craft` | Architect | Generate CRAFT specs |
| `/kpi plan <min>` | Architect | Track Plan Velocity |
| `/kpi autonomy <min>` | Dev | Track Autonomy Duration |
| `/kpi review <min>` | Critic | Track Review Velocity |
| `/ca log` | Dev | Calculate Compute Advantage |
| `/cost` | All | Track API costs |

### Metrics Flow

```
Architect writes spec → /kpi plan 8 "auth feature"
Dev implements        → /kpi autonomy 45 "auth feature"
                      → /ca log "auth" --compute=5 --autonomy=45 --time=10 --effort=2 --cost=0.85
Critic reviews        → /kpi review 3 "auth feature"
```

## Launching Agents

Manual launch (recommended for Phase 1):
```bash
# Terminal 1 - Architect
cd ../worktrees/squad-architect && claude

# Terminal 2 - Dev
cd ../worktrees/squad-dev && claude

# Terminal 3 - Critic
cd ../worktrees/squad-critic && claude
```

Heartbeat (for cron - Phase 2+):
```bash
bash .claude/scripts/squad/heartbeat.sh architect
bash .claude/scripts/squad/heartbeat.sh dev
bash .claude/scripts/squad/heartbeat.sh critic
```

## Output Format

```markdown
## Neural Squad: [action]

**Status**: [result]

### Agents
| Agent | Status | Current Task |
|-------|--------|--------------|
| Architect | idle | - |
| Dev | working | task-001 |
| Critic | idle | - |

### Task Queue
inbox: 2 | assigned: 1 | in-progress: 1 | review: 0 | done: 5
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| "Squad not initialized" | First run | Run `/squad-init` |
| "Worktree exists" | Previous run | `git worktree remove ../worktrees/squad-*` |
| "No tasks in queue" | Empty queue | Create task with `/squad-task create` |
| "Agent not found" | Invalid agent | Check `.claude/squad/agents/` |

**Fallback**: If scripts fail, manually inspect `.claude/squad/` files.

## Security Boundaries

- **Architect**: Can't write code, can't approve
- **Dev**: Can't approve own work, can't merge
- **Critic**: Can't write code, can't create tasks
- **Human**: Required for merge to main, deploy, delete
