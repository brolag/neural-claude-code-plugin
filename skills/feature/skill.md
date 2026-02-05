---
name: feature
description: Implement a feature following branch-first workflow. Creates feature branch, implements, tests, and prepares for PR.
trigger: /feature <description>
allowed-tools: Bash, Read, Write, Edit, Grep, Glob, Task
---

# Feature Implementation Skill

Standardized workflow for implementing features that avoids protected branch friction.

## Usage

```bash
/feature "Add user authentication with OAuth"
/feature "Fix pagination bug in dashboard"
/feature "Refactor API error handling"
```

## Workflow

When the user triggers this skill:

### Step 1: Create Feature Branch

```bash
# Generate branch name from description
BRANCH_NAME="feature/$(echo "<description>" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')"
git checkout -b "$BRANCH_NAME"
```

### Step 2: Create Todo List

Use TaskCreate to track progress:
- [ ] Understand requirements
- [ ] Implement changes
- [ ] Run tests
- [ ] Fix any TypeScript/lint errors
- [ ] Verify locally
- [ ] Prepare PR description

### Step 3: Implement

- Make necessary code changes
- Follow existing patterns in codebase
- Keep changes focused on the feature

### Step 4: Test & Verify

```bash
# Run tests
npm test  # or project-specific command

# TypeScript check
npx tsc --noEmit  # if TypeScript project
```

### Step 5: Prepare for PR

Output:
- Summary of changes made
- Files modified
- Test results
- Suggested PR description

## Output Format

```markdown
## Feature: [description]

**Branch**: `feature/description-slug`
**Status**: ✅ Ready for PR

### Changes Made
- [List of changes]

### Files Modified
- `path/to/file.ts` - [what changed]

### Test Results
✅ All tests passing (X tests)

### Suggested PR Description

## Summary
[Brief description]

## Changes
- [Bullet points]

## Testing
- [How to test]
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Branch already exists | Name collision | Add timestamp suffix |
| Tests failing | Code issues | Fix before proceeding |
| TypeScript errors | Type mismatches | Fix all TS errors |
| No test command | Missing config | Skip tests, warn user |

**Fallback**: If any step fails critically, report status and let user decide next steps.

## Notes

- Always creates a new branch (never pushes to main)
- Runs tests automatically before marking complete
- Integrates with existing project test setup
- Works with TypeScript, JavaScript, Python projects
