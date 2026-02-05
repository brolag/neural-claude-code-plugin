---
description: Implement security changes with full verification cycle
allowed-tools: Bash, Read, Write, Edit, Grep, Glob, Task, TaskCreate, TaskUpdate, WebFetch
---

# /secure-api - Security-First API Changes

Implements security-related changes with mandatory verification. Never marks complete until verified locally.

## Usage

```bash
/secure-api "Add RLS to users table"
/secure-api "Fix SQL injection in search endpoint"
/secure-api "Add rate limiting to auth routes"
/secure-api "Implement input validation for user forms"
```

## Prompt

You are implementing a security-related change. This requires extra diligence.

**Input**: $ARGUMENTS

### Security Change Protocol

**CRITICAL**: Do NOT mark this task complete until ALL steps are verified.

### Step 1: Create Feature Branch

```bash
BRANCH="security/$(echo "$ARGUMENTS" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | head -c 40)"
git checkout -b "$BRANCH"
```

### Step 2: Analyze Current State

Before making changes:
1. Identify all affected files
2. Check for existing security patterns
3. Look for related tests
4. Document current behavior

### Step 3: Implement Security Fix

Apply the security change:
- Follow OWASP guidelines
- Use parameterized queries (never string concatenation for SQL)
- Validate all inputs
- Sanitize all outputs
- Use proper authentication/authorization checks

### Step 4: Run Tests (MANDATORY)

```bash
npm test
# or
yarn test
# or
python -m pytest
```

If tests fail, FIX THEM before proceeding.

### Step 5: Local Verification (MANDATORY)

Verify the endpoint works:

```bash
# Example verification - adapt to actual endpoint
curl -X POST http://localhost:3000/api/endpoint \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}' \
  -w "\n%{http_code}\n"
```

### Step 6: Security Checklist

Before marking complete, verify:
- [ ] No SQL injection vulnerabilities
- [ ] Input validation in place
- [ ] Output sanitization applied
- [ ] Authentication checks correct
- [ ] Authorization checks correct
- [ ] Tests passing
- [ ] Local verification successful

### Step 7: Report

Only after ALL above steps pass:

```markdown
## Security Change: [description]

**Branch**: `security/[name]`
**Status**: ✅ VERIFIED

### Security Measures Applied
- [measure 1]
- [measure 2]

### Files Modified
| File | Security Change |
|------|-----------------|
| `path/file.ts` | Added input validation |

### Tests
✅ All security tests passing

### Verification
✅ Endpoint tested locally with:
- Valid input: ✅ 200 OK
- Invalid input: ✅ 400 Bad Request
- Unauthorized: ✅ 401 Unauthorized

### Next Steps
```bash
git push -u origin security/[name]
gh pr create --title "Security: [description]" --body "..." --label "security"
```
```

## Output Format

Always output verification results. Never skip verification.

## Error Handling

| Error | Resolution |
|-------|------------|
| Tests fail | Fix tests before proceeding - security changes must not break existing functionality |
| Verification fails | Debug and fix - do not proceed until verified |
| Local server not running | Start server, then verify |

**Fallback**: If verification cannot be completed, clearly state what remains unverified and why.

## Notes

- Security changes are NEVER partially complete
- All verification steps are mandatory
- Branch naming uses `security/` prefix for visibility
- Always add security label to PRs
