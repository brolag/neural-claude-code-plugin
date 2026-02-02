---
name: overseer
description: Review PRs and diffs for quality before merge - detect slop, security issues, and inconsistencies
trigger: /overseer
allowed-tools: Read, Grep, Glob, Bash
---

# Overseer Skill

Review code diffs/PRs for quality before merge. Detect slop, security issues, and inconsistencies.

## Usage

```bash
# Review current branch diff
/overseer

# Review specific PR
/overseer --pr 123

# Review specific files
/overseer src/api/

# Quick review (only critical issues)
/overseer --quick
```

## Review Checklist

For each diff:

### 1. Slop Detection
- Duplicated code
- Dead code (unused imports, functions)
- Hardcoded values that should be config
- Poor naming (vague variable names)
- Missing error handling
- Overly complex logic (nested ifs >3 levels)

### 2. Security Issues
- SQL injection risks
- XSS vulnerabilities
- Exposed secrets/API keys
- Missing input validation
- Unsafe file operations

### 3. Consistency
- Follows project's CLAUDE.md guidelines
- Code style matches existing files
- Tests included for new features
- Documentation updated if needed

### 4. Best Practices
- Language-specific best practices
- No premature optimization
- Single Responsibility Principle
- DRY violations

## Output Format

```markdown
## Overseer Review: [Feature/Fix Name]

**Score**: X/10

### Issues Found

| Severity | Issue | Location | Fix |
|----------|-------|----------|-----|
| High | SQL injection risk | file.py:42 | Use parameterized queries |
| Medium | Duplicated logic | utils.js:15-30 | Extract to helper function |
| Low | Missing docstring | api.py:100 | Add function documentation |

### Recommendation

- [ ] **APPROVE & MERGE** (score ≥8)
- [ ] **FIX REQUIRED** (score <8)

### Suggested Fixes

\`\`\`python
# Example fix for issue #1
# Replace:
query = f"SELECT * FROM users WHERE id = {user_id}"
# With:
query = "SELECT * FROM users WHERE id = ?"
cursor.execute(query, (user_id,))
\`\`\`

### Notes

[Any additional context or concerns]
```

## Decision Rules

- **Score 8-10**: Auto-approve for merge
- **Score 5-7**: Fix required, provide specific code suggestions
- **Score 1-4**: Major issues, block merge, detailed rewrite needed

## Anti-Slop Guards

- Never approve code without tests for new features
- Never approve hardcoded secrets
- Never approve obvious security vulnerabilities
- Flag any "TODO" or "FIXME" comments

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No diff found | No changes | Check branch or git status |
| Permission denied | Can't access files | Check file permissions |
| Git not found | Not a git repo | Use file-based review |

**Fallback**: If git diff fails, perform manual review by reading changed files directly.

## Integration

Works with:
- `/slop-scan` - Uses same slop detection rules
- `/slop-fix` - Can auto-fix issues found in review
- `/tdd` - Ensures tests exist for changes

---

**Version**: 1.0.0
**Created**: 2026-02-01
