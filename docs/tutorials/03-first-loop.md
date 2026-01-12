# Tutorial 3: Your First Loop

*Time: 15 minutes*

Run an autonomous coding session where Claude works independently.

---

## What is a Neural Loop?

Neural Loops let Claude:
- Work on a task **autonomously**
- Run tests **automatically** after each change
- **Continue iterating** until the task is complete
- Work for **hours** without manual intervention

It's like pair programming, but you can walk away.

---

## Step 1: Create a Simple Task

Let's start with something small. Create a test file that we want Claude to make pass.

```bash
# Create a simple test
echo 'test("adds numbers", () => {
  expect(add(2, 3)).toBe(5);
});' > add.test.js
```

## Step 2: Start the Loop

```bash
claude
```

Then run:

```
/loop-start "Create an add function that makes add.test.js pass" --max 5 --promise "TESTS_PASS"
```

**What this means:**
- `--max 5` - Stop after 5 iterations maximum
- `--promise "TESTS_PASS"` - Claude outputs this when done

## Step 3: Watch It Work

Claude will:
1. Read the test file
2. Create `add.js` with the function
3. Run tests automatically
4. If tests fail, iterate and fix
5. Output `TESTS_PASS` when complete

## Step 4: Check the Result

After the loop completes:

```bash
cat add.js
npm test  # or your test command
```

You should have a working `add` function!

---

## Loop Commands

| Command | Description |
|---------|-------------|
| `/loop-start "task"` | Start a loop |
| `/loop-status` | Check current progress |
| `/loop-cancel` | Stop the loop |

---

## Best Practices

### 1. Start Small
```
/loop-start "Fix the TypeScript error in utils.ts" --max 5
```
Not:
```
/loop-start "Refactor the entire codebase" --max 100
```

### 2. Include Validation
```
/loop-start "Add validation to UserForm. Run 'npm test' to verify." --max 10
```

### 3. Set Reasonable Limits
- Simple fixes: `--max 5`
- Medium features: `--max 15`
- Large features: `--max 25`

### 4. Use Clear Success Criteria
```
/loop-start "All tests pass and TypeScript has no errors" --promise "ALL_GREEN"
```

---

## What's Next?

You've completed the tutorials! You now know how to:
- Install Neural Claude Code
- Create expertise files
- Run autonomous loops

**Ready to dive deeper?**

- [How-to Guides](../how-to/) - Recipes for specific tasks
- [Reference](../reference/) - Complete command list
- [Explanation](../explanation/) - Understand the architecture

---

## Quick Reference

```bash
# Start a loop
/loop-start "task description" --max 20 --promise "DONE"

# Check status
/loop-status

# Cancel if stuck
/loop-cancel

# Plan before looping (safer)
/loop-plan "complex task description"
```
