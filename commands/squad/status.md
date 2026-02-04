---
description: Show Neural Squad status - agents, tasks, and activity
allowed-tools: Bash, Read
---

# /squad-status

Display the current status of the Neural Squad system.

## What This Shows

1. **Agent Status**: Each agent's state, current task, last heartbeat
2. **Task Queue**: Kanban-style count of tasks in each stage
3. **Recent Activity**: Last 5 heartbeat events
4. **Worktrees**: Active git worktrees for agents

## Usage

```bash
/squad-status
```

## Execution

Run the status script:

```bash
bash .claude/scripts/squad/status.sh
```

## Output Format

```
╔══════════════════════════════════════════════════════════════╗
║                    NEURAL SQUAD STATUS                       ║
╚══════════════════════════════════════════════════════════════╝

═══ AGENTS ═══

Architect (architect)
  Role:   Specifications and orchestration
  Status: idle
  Task:   none
  Last:   2026-02-03T10:00:00Z

Dev (dev)
  Role:   TDD implementation
  Status: working
  Task:   task-001
  Last:   2026-02-03T10:02:00Z

Critic (critic)
  Role:   Anti-slop review and approval
  Status: idle
  Task:   none
  Last:   never

═══ TASK QUEUE ═══

┌─────────┬──────────┬────────────┬──────────┬────────┐
│ INBOX   │ ASSIGNED │ IN-PROGRESS│ REVIEW   │ DONE   │
├─────────┼──────────┼────────────┼──────────┼────────┤
│    2    │    1     │     1      │    0     │   5    │
└─────────┴──────────┴────────────┴──────────┴────────┘

═══ RECENT ACTIVITY ═══

  10:02:00 dev [task_start] Starting task: task-001
  10:00:00 architect [heartbeat] HEARTBEAT_OK - no work

═══ WORKTREES ═══

/Users/.../sb                      main
/Users/.../worktrees/squad-architect  squad/architect
/Users/.../worktrees/squad-dev        squad/dev
/Users/.../worktrees/squad-critic     squad/critic

─────────────────────────────────────────────────────────────────
Commands: /squad-task create | /squad-msg | /squad-standup
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| "No agents found" | Squad not initialized | Run `/squad-init` first |
| "No activity" | Fresh installation | Create tasks to generate activity |
| "jq: command not found" | Missing dependency | Install jq: `brew install jq` |

**Fallback**: If status script fails, read agent files directly from `.claude/squad/agents/`.
