# How to: Use Multi-AI Collaboration

Route tasks to the best AI for the job and get multiple perspectives.

---

## Quick Routing

Route directly to a specific AI:

```bash
Ask Codex to set up the CI/CD pipeline

Ask Gemini to optimize this sorting algorithm

Ask Claude to review this architecture decision
```

---

## Get All Perspectives

Use `/ai-collab` for important decisions:

```bash
/ai-collab Should we use REST or GraphQL for this API?
```

Each AI analyzes from their strength:
- **Claude**: Accuracy, edge cases, maintainability
- **Codex**: Practical implementation, DevOps concerns
- **Gemini**: Performance, algorithmic efficiency

---

## Parallel Multi-AI (Fastest)

Use `/pv-mesh` for 3x faster consensus:

```bash
/pv-mesh What's the best caching strategy for this API?
```

Runs all three AIs simultaneously in isolated contexts.

| Method | Time | Use When |
|--------|------|----------|
| `/ai-collab` | 45-60s | Need detailed analysis |
| `/pv-mesh` | 15-20s | Need fast consensus |

---

## Plan-Execute Pattern (Cheapest)

For multi-step tasks, use Opus to plan and Gemini to execute:

```bash
/plan-execute Add user authentication with JWT tokens
```

**How it works:**
1. Opus 4.6 creates detailed plan (accurate, best reasoning)
2. Gemini executes simple steps (cheap, fast)
3. Opus reviews results (expensive, accurate)

**Savings:** ~60-70% vs Opus-only

---

## When to Use Each AI

| Task Type | Best AI | Why |
|-----------|---------|-----|
| Architecture decisions | Claude | 80.8% SWE-bench accuracy |
| Algorithm optimization | Gemini | Highest competitive coding Elo |
| DevOps / CI/CD | Codex | Terminal-Bench leader |
| Long autonomous sessions | Codex | 7+ hour context |
| Quick implementations | Gemini | Fast + free tier |
| Security review | Claude | Thorough edge case analysis |

---

## Smart Routing

Use `/route` to get a recommendation:

```bash
/route implement binary search in Python
# → Recommends: Gemini (algorithmic task)

/route set up Docker deployment
# → Recommends: Codex (DevOps task)

/route review authentication flow for vulnerabilities
# → Recommends: Claude (security task)
```

---

## Prerequisites

Multi-AI requires:
- **Codex**: `codex` CLI installed
- **Gemini**: `gemini` CLI installed
- **Claude**: Already using it!

---

## Related

- [Reference: Commands](../reference/commands.md) - Full command syntax
- [Explanation: Multi-AI Strategy](../explanation/multi-ai.md) - Why this works
