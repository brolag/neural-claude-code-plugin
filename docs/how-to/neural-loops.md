# How to: Run Neural Loops

Run autonomous coding sessions that iterate until complete.

---

## Start a Basic Loop

```bash
/loop-start "Fix all TypeScript errors" --max 10 --promise "TYPES_FIXED"
```

**Parameters:**
- `"task"` - What to accomplish
- `--max N` - Maximum iterations (default: 20)
- `--promise "TEXT"` - Output when complete

---

## Safer: Plan First

For complex tasks, plan before executing:

```bash
/loop-plan "Add user authentication with JWT"
```

This:
1. Analyzes the codebase
2. Creates a structured plan
3. Asks for approval
4. Then executes with safety limits

---

## Check Progress

```bash
/loop-status
```

Shows:
- Current iteration
- Max iterations
- Completion promise
- Active/inactive status

---

## Stop a Loop

```bash
/loop-cancel
```

Use when:
- Loop is stuck
- You need to change approach
- Something went wrong

---

## Loop Types

### Feature Loop (default)
```bash
/loop-start "Build REST API for users"
```

### Coverage Loop
```bash
/loop-start "Increase test coverage to 80%" --type coverage
```

### Lint Loop
```bash
/loop-start "Fix all ESLint errors" --type lint
```

### Entropy Loop
```bash
/loop-start "Clean up dead code and unused imports" --type entropy
```

---

## Todo-Driven Development

For complex features, create a todo first:

```bash
/todo-new "Build user management API"
```

This creates `todo.md` with:
- Phases
- Tasks per phase
- Validation steps

Then:
```bash
/loop-start "Follow todo.md step by step" --max 20 --promise "TODO_COMPLETE"
```

---

## Best Practices

### 1. Include Validation
```bash
# Good - includes test command
/loop-start "Add form validation. Run 'npm test' after changes" --max 10

# Bad - no way to verify
/loop-start "Add form validation" --max 10
```

### 2. Clear Success Criteria
```bash
# Good - measurable
/loop-start "All tests pass and 0 TypeScript errors" --promise "ALL_GREEN"

# Bad - vague
/loop-start "Make it work better" --promise "DONE"
```

### 3. Reasonable Limits
| Task Size | Recommended Max |
|-----------|-----------------|
| Bug fix | 5 |
| Small feature | 10 |
| Medium feature | 15-20 |
| Large feature | 25+ |

### 4. Use TDD
Write tests first, then loop:
```bash
/loop-start "Make all tests in auth.test.ts pass" --max 15
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Loop runs forever | Set lower `--max`, add clearer exit criteria |
| Loop exits early | Make success criteria more specific |
| Tests not running | Verify test command in your project |
| Stuck on same error | `/loop-cancel`, fix manually, restart |

---

## Related

- [Tutorial: Your First Loop](../tutorials/03-first-loop.md) - Step-by-step guide
- [Reference: Commands](../reference/commands.md) - All loop commands
