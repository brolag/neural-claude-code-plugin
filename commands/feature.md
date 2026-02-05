---
description: Implement a feature with branch-first workflow
allowed-tools: Bash, Read, Write, Edit, Grep, Glob, Task, TaskCreate, TaskUpdate, TaskList
---

# /feature - Branch-First Feature Implementation

Implements features following the branch-first workflow to avoid protected branch friction.

## Usage

```bash
/feature "Add user authentication"
/feature "Fix the pagination bug"
/feature "Refactor error handling in API"
```

## Prompt

You are implementing a feature using the branch-first workflow.

**Input**: $ARGUMENTS

### Step 1: Create Feature Branch

First, create a descriptive feature branch:

```bash
# Sanitize description for branch name
BRANCH=$(echo "$ARGUMENTS" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | head -c 50)
git checkout -b "feature/$BRANCH"
```

### Step 2: Create Task List

Use TaskCreate to track each step:
1. Analyze requirements
2. Implement changes
3. Run tests
4. Fix TypeScript/lint errors
5. Verify locally

### Step 3: Implement

Make the necessary changes. Use existing patterns in the codebase.

### Step 4: Test

```bash
# Try common test commands
npm test 2>/dev/null || yarn test 2>/dev/null || python -m pytest 2>/dev/null || echo "No test command found"

# TypeScript check if applicable
npx tsc --noEmit 2>/dev/null || true
```

### Step 5: Report

Output a summary with:
- Branch name
- Changes made
- Test results
- Files modified
- Suggested PR description

## Output Format

```markdown
## Feature Implemented: [description]

**Branch**: `feature/[name]`
**Status**: ✅ Ready for PR | ⚠️ Needs attention

### Changes
- [change 1]
- [change 2]

### Files Modified
| File | Change |
|------|--------|
| `path/file.ts` | Added X |

### Tests
✅ Passing: X | ❌ Failing: Y

### Next Steps
```bash
git push -u origin feature/[name]
gh pr create --title "[description]" --body "..."
```
```

## Error Handling

| Error | Resolution |
|-------|------------|
| Branch exists | Add date suffix: `feature/name-20260205` |
| Tests fail | Fix issues, re-run tests |
| TypeScript errors | Fix all TS errors before continuing |
| Protected branch push | Already handled - we use feature branches |

**Fallback**: Report current state, let user decide next steps.
