---
name: slop-fix
description: Automatically fix safe slop issues from slop-scan reports
trigger: /slop-fix
allowed-tools: Read, Edit, Write, Bash, Grep, Glob
---

# Slop Fix Skill

Automatically fix slop issues identified by `/slop-scan`. Execute safe, low-risk refactors.

## Usage

```bash
# Fix all safe issues
/slop-fix

# Fix specific issue type
/slop-fix --type unused-imports

# Dry run (preview changes)
/slop-fix --dry-run

# Fix with auto-commit
/slop-fix --commit
```

## What Can Be Auto-Fixed (Safe List)

### 1. Dead Code Removal
- Unused imports
- Commented-out code blocks
- Unreferenced functions/variables (verified with Grep)
- Empty files

### 2. Simple Refactors
- Extract duplicated code to helper functions
- Rename variables for clarity (local scope only)
- Add missing docstrings
- Format code (prettier, black, etc.)

### 3. Low-Risk Improvements
- Add missing type hints
- Add simple error handling (try/catch)
- Replace magic numbers with constants
- Add missing tests (basic unit tests)

### 4. Dependency Cleanup
- Update outdated packages (patch versions only)
- Remove unused dependencies

## What CANNOT Be Auto-Fixed (Human Review Required)

- Security vulnerabilities (flag for human)
- Complex logic changes
- API breaking changes
- Database schema changes
- Major refactors (>100 lines changed)
- Anything with confidence <80%

## Execution Process

1. **Read Slop Report**: Parse issues from `/slop-scan`
2. **Filter Safe Issues**: Only take auto-fixable ones
3. **Verify Safety**:
   - Run tests before changes
   - Check git status (no uncommitted work)
   - Verify file exists and is readable
4. **Make Changes**: One issue at a time
5. **Verify**: Run tests after each fix
6. **Commit**: Atomic commits per fix
7. **Report**: Log what was fixed

## Output Format

```markdown
## Slop Fixer Report: [Project Name]

**Fix Date**: [YYYY-MM-DD]
**Issues Addressed**: X
**Auto-Fixed**: Y
**Flagged for Human**: Z

---

### Auto-Fixed Issues ✅

| Issue | Location | Fix Applied | Test Status |
|-------|----------|-------------|-------------|
| Unused import | utils.py:1 | Removed `import os` | ✅ Pass |
| Duplicated code | api/*.py | Extracted to `validate_input()` | ✅ Pass |
| Missing docstring | models.py:42 | Added function docstring | ✅ Pass |

---

### Commits Created

- `fix: remove unused imports (5 files)`
- `refactor: extract duplicated validation logic`
- `docs: add missing docstrings to public APIs`

---

### Flagged for Human Review 🚩

| Issue | Reason | Recommendation |
|-------|--------|----------------|
| SQL injection | Security critical | Review and fix manually |
| God class refactor | >500 lines, complex | Plan refactor sprint |

---

### Metrics

- **Before**: 45 slop issues
- **After**: 18 slop issues
- **Improvement**: 60% reduction
- **Test Coverage**: 67% → 72%

---

### Next Steps

1. Review flagged issues (2 critical)
2. Merge auto-fix commits
3. Re-run `/slop-scan` to verify
```

## Safety Rules

1. **Always run tests before AND after changes**
2. **Never fix if tests are already failing**
3. **One fix per commit** (easy rollback)
4. **Confidence threshold**: Only fix if >80% confident
5. **Verify with grep before deleting** (ensure truly unused)
6. **Create branch** for batch fixes, not main
7. **Ask human** if uncertain

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Tests failing | Broke functionality | Rollback immediately (git reset --hard) |
| File not found | Wrong path | Skip and continue with next issue |
| Permission denied | Can't write file | Flag for manual fix |

**Fallback**: If a fix fails, rollback immediately, log the failure, flag for human review, and continue with next issue.

## Git Commit Message Format

```
fix: [brief description]

Auto-fixed by Slop Fixer
Issue: [issue description]
Location: [file:line]
Test Status: ✅ All tests passing

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
```

## Integration

Requires:
- `/slop-scan` - Provides the issues to fix

Works with:
- `/overseer` - Reviews the fix PRs before merge
- `/tdd` - Ensures tests exist before fixing

---

**Version**: 1.0.0
**Created**: 2026-02-01
