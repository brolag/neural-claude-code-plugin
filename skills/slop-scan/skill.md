---
name: slop-scan
description: Scan codebase to detect accumulated slop, technical debt, and refactor opportunities
trigger: /slop-scan
allowed-tools: Glob, Grep, Read, Bash
---

# Slop Scan Skill

Deep scan of project codebases to find accumulated slop and technical debt.

## Usage

```bash
# Scan entire project
/slop-scan

# Scan specific directory
/slop-scan src/

# Quick scan (top issues only)
/slop-scan --quick
```

## What It Detects

### 1. Code Smells
- Functions >50 lines
- Files >500 lines
- Nested conditionals >3 levels
- Cyclomatic complexity >10
- God classes/modules

### 2. Duplication
- Copy-pasted code blocks
- Similar logic in multiple files
- Repeated patterns that could be abstracted

### 3. Dead Code
- Unused functions/classes
- Commented-out code >10 lines
- Unused imports
- Unreachable code

### 4. Technical Debt
- TODO/FIXME comments >1 month old
- Deprecated API usage
- Outdated dependencies
- Missing tests (coverage <70%)

### 5. Anti-Patterns
- Tight coupling
- Missing error handling
- Magic numbers
- Inconsistent naming

### 6. Performance Issues
- N+1 queries
- Inefficient loops
- Memory leaks (obvious ones)
- Missing indexes

## Scan Process

1. **Inventory**: List all files by type (exclude node_modules, .git, etc.)
2. **Priority Scan**: Start with most-changed files (git log)
3. **Pattern Detection**: Use Grep/Glob to find patterns
4. **Severity Scoring**: Rank issues by impact
5. **Actionable Report**: Group by "Quick Wins" vs "Deep Refactors"

## Output Format

```markdown
## Slop Detection Report: [Project Name]

**Scan Date**: [YYYY-MM-DD]
**Files Scanned**: X
**Issues Found**: Y
**Slop Level**: Low/Medium/High

---

### Executive Summary

- **Critical**: 3 issues (blocking, security)
- **High**: 12 issues (performance, duplication)
- **Medium**: 25 issues (code smells, naming)
- **Low**: 40 issues (formatting, comments)

---

### Critical Issues (Fix Now)

| Issue | Location | Impact | Effort |
|-------|----------|--------|--------|
| SQL injection | api/users.py:42 | Security risk | 15min |
| Memory leak | utils/cache.js:100 | Performance | 1hr |

---

### High Priority (This Week)

| Issue | Location | Impact | Effort |
|-------|----------|--------|--------|
| Duplicated auth logic | 3 files | Maintainability | 2hr |
| Missing error handling | api/*.py | Reliability | 30min |

---

### Quick Wins (Low Effort, High Impact)

- Remove 15 unused imports across 8 files (5min)
- Extract duplicated validation to utils (20min)
- Add missing docstrings to public APIs (30min)

---

### Deep Refactors (Plan Sprint)

- Refactor User model (god class, 800 lines) → 3-5 smaller classes (1 day)
- Replace deprecated Auth lib with modern alternative (2 days)
- Add missing tests (currently 45% coverage) → target 80% (3 days)

---

### Slop Hotspots (Most Problematic Files)

1. `src/api/users.py` - 12 issues (complexity, duplication, security)
2. `utils/helpers.js` - 8 issues (dead code, naming)
3. `models/base.py` - 6 issues (god class, coupling)

---

### Recommendations

1. **Immediate**: Fix 3 critical issues before next deploy
2. **This Week**: Quick wins batch (1-2 hours total)
3. **This Month**: Tackle top 2 deep refactors
4. **Ongoing**: Add pre-commit hooks to prevent slop

---

### Proposed PRs

- [x] PR #1: Remove unused imports and dead code
- [ ] PR #2: Extract duplicated auth logic to middleware
- [ ] PR #3: Add error handling to API endpoints
```

## Decision Rules

- **Slop Level High** (>30 critical/high issues): Pause new features, refactor sprint
- **Slop Level Medium** (10-30 issues): Weekly cleanup sessions
- **Slop Level Low** (<10 issues): Maintenance mode, preventive measures

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Permission denied | Can't read files | Check file permissions |
| No git history | Not a git repo | Skip git-based analysis |
| Tool not found | Missing linter | Install or skip analysis |

**Fallback**: If automated tools fail, perform manual code review on critical files.

## Integration

Works with:
- `/slop-fix` - Auto-fix safe issues
- `/overseer` - Review PRs for new slop
- `/debugging` - Root cause for bugs found

---

**Version**: 1.0.0
**Created**: 2026-02-01
