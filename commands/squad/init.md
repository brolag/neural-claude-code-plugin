---
description: Initialize Neural Squad multi-agent system with worktrees
allowed-tools: Bash, Read, Write
---

# /squad-init

Initialize the Neural Squad multi-agent orchestration system.

## What This Does

1. Creates the squad directory structure:
   - `.claude/squad/tasks/{inbox,assigned,in-progress,review,done}/`
   - `.claude/squad/agents/`
   - `.claude/squad/messages/`
   - `.claude/squad/activity/`

2. Creates three agent worktrees:
   - `squad-architect` - Specifications and orchestration
   - `squad-dev` - TDD implementation
   - `squad-critic` - Anti-slop review

3. Sets up agent-specific CLAUDE.md files with role constraints

## Usage

```bash
/squad-init
```

## Execution

Run the initialization script:

```bash
bash .claude/scripts/squad/init.sh
```

## Output Format

```markdown
## Neural Squad Initialized

### Agents Created
- Architect: ../worktrees/squad-architect (branch: squad/architect)
- Dev: ../worktrees/squad-dev (branch: squad/dev)
- Critic: ../worktrees/squad-critic (branch: squad/critic)

### Task Queue Structure
- inbox/ - New tasks waiting for specs
- assigned/ - Tasks with specs, ready for dev
- in-progress/ - Tasks being implemented
- review/ - Tasks awaiting critic review
- done/ - Completed tasks

### Next Steps
1. Create a task: `/squad-task create "Your task"`
2. Check status: `/squad-status`
3. Launch an agent: `cd ../worktrees/squad-architect && claude`
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| "Branch exists" | Previous incomplete run | Delete branch: `git branch -D squad/agent-name` |
| "Worktree exists" | Previous incomplete run | Remove: `git worktree remove ../worktrees/squad-*` |
| "Permission denied" | Script not executable | Run: `chmod +x .claude/scripts/squad/*.sh` |

**Fallback**: If worktree creation fails, the script will skip existing worktrees and continue.
