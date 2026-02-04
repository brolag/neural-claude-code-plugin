---
description: Create and manage Neural Squad tasks
allowed-tools: Bash, Read, Write
---

# /squad-task

Create and manage tasks in the Neural Squad system.

## Subcommands

### `/squad-task create "<title>" [--priority high|medium|low]`

Create a new task in the inbox.

**Process**:
1. Generate unique task ID (timestamp-based)
2. Create task JSON in `.claude/squad/tasks/inbox/`
3. Notify architect (if Telegram configured)

### `/squad-task list [status]`

List tasks by status (inbox, assigned, in-progress, review, done).

### `/squad-task show <task-id>`

Show full details of a specific task.

### `/squad-task move <task-id> <status>`

Manually move a task between stages.

## Usage

```bash
# Create new task
/squad-task create "Add user authentication"

# With priority
/squad-task create "Fix critical bug" --priority high

# List inbox
/squad-task list inbox

# Show task details
/squad-task show 20260203-143022

# Move task
/squad-task move 20260203-143022 assigned
```

## Execution

When creating a task, generate the following structure:

```bash
TASK_ID="$(date +%Y%m%d-%H%M%S)"
TASK_FILE=".claude/squad/tasks/inbox/${TASK_ID}.json"
```

Task JSON format:
```json
{
  "id": "20260203-143022",
  "title": "Add user authentication",
  "description": "",
  "priority": "medium",
  "created_by": "human",
  "created_at": "2026-02-03T14:30:22Z",
  "status": "inbox",
  "assigned_to": null,
  "spec": null,
  "acceptance_criteria": [],
  "implementation": null,
  "review": null,
  "history": [
    {"status": "inbox", "timestamp": "2026-02-03T14:30:22Z", "by": "human"}
  ]
}
```

## Output Format

### Create
```markdown
## Task Created

**ID**: 20260203-143022
**Title**: Add user authentication
**Priority**: medium
**Status**: inbox

Task added to queue. Architect will pick up on next heartbeat.
```

### List
```markdown
## Tasks: inbox (2)

| ID | Title | Priority | Created |
|----|-------|----------|---------|
| 20260203-143022 | Add user authentication | medium | 2 min ago |
| 20260203-142815 | Fix login bug | high | 5 min ago |
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| "Title required" | No title provided | Add title in quotes |
| "Invalid status" | Wrong status name | Use: inbox, assigned, in-progress, review, done |
| "Task not found" | Invalid task ID | Check with `/squad-task list` |
| "Cannot move" | Invalid transition | Check workflow in config.json |

**Fallback**: If script fails, create task JSON manually in inbox/.
