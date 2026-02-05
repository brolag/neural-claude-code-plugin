# Explanation: Multi-AI Strategy

Why using Claude, Codex, and Gemini together produces better results.

---

## The Insight

Different AIs excel at different tasks:

| AI | Benchmark | Strength |
|----|-----------|----------|
| **Claude** | 80.8% SWE-bench (Opus 4.6) | Accuracy, edge cases, architecture |
| **Codex** | #1 Terminal-Bench | DevOps, long sessions, practical |
| **Gemini** | 1501 Elo (algorithms) | Performance, math, free tier |

No single AI is best at everything.

---

## Why Diversity Helps

### Cognitive Diversity

Each AI has different:
- Training data
- Reasoning patterns
- Blind spots
- Strengths

### Error Reduction

When AIs agree: High confidence
When AIs disagree: Investigate further

### Complete Coverage

| Task | Best AI | Why |
|------|---------|-----|
| Security review | Claude | Thorough analysis |
| CI/CD setup | Codex | Terminal mastery |
| Algorithm design | Gemini | Mathematical reasoning |

---

## Three Collaboration Modes

### 1. Direct Routing

Route a task to the best AI:

```
Ask Codex to set up Docker

Ask Gemini to optimize this algorithm

Ask Claude to review security
```

**When:** You know which AI is best for the task.

### 2. Sequential Collaboration

Get all perspectives in sequence:

```
/ai-collab Should we use microservices?
```

Claude → Codex → Gemini → Synthesis

**When:** Important decisions needing multiple viewpoints.
**Time:** 45-60 seconds

### 3. Parallel Collaboration

Get all perspectives simultaneously:

```
/pv-mesh What's our caching strategy?
```

Claude ─┐
Codex  ─┼─▶ Synthesis
Gemini ─┘

**When:** Need speed + diversity.
**Time:** 15-20 seconds

---

## The Plan-Execute Pattern

For multi-step tasks, combine strengths optimally:

```
┌────────────────┐     ┌────────────────┐     ┌────────────────┐
│  OPUS 4.6      │     │  GEMINI FLASH  │     │  OPUS 4.6      │
│  (Planning)    │ ──▶ │  (Execution)   │ ──▶ │  (Review)      │
│  5-10% tokens  │     │  70-80% tokens │     │  10-20% tokens │
└────────────────┘     └────────────────┘     └────────────────┘
```

**Why it works:**
- Planning needs accuracy → Opus (expensive, best)
- Execution is often simple → Gemini (cheap, fast)
- Review needs accuracy → Opus (expensive, best)

**Result:** 60-70% cost savings vs Opus-only

---

## Cost Optimization

| Approach | Cost | Quality |
|----------|------|---------|
| Opus only | $$$$  | Highest |
| Plan-Execute | $$ | High |
| Gemini only | $ | Good for algorithms |
| Local (Qwen) | Free | Good for boilerplate |

---

## Smart Routing Decision Tree

```
Is it a terminal/DevOps task?
├─ Yes → Codex
└─ No
   Is it algorithmic/mathematical?
   ├─ Yes → Gemini
   └─ No
      Is it complex/architectural?
      ├─ Yes → Claude
      └─ No
         Is it multi-step?
         ├─ Yes → Plan-Execute
         └─ No → Claude (default)
```

---

## Real-World Examples

### Example 1: Add Authentication

```
/plan-execute Add JWT authentication to the API
```

- Opus plans: File structure, routes, middleware
- Gemini executes: Simple implementations
- Opus reviews: Security verification

### Example 2: CI/CD Pipeline

```
Ask Codex to set up GitHub Actions with Docker
```

Codex excels at terminal commands and DevOps patterns.

### Example 3: Algorithm Optimization

```
Ask Gemini to improve the time complexity of this search
```

Gemini has highest competitive programming Elo.

### Example 4: Critical Decision

```
/pv-mesh Should we migrate to microservices?
```

All three AIs analyze independently, then synthesize.

---

## Prerequisites

Multi-AI requires installing additional CLIs:

- **Codex:** `codex` CLI (OpenAI)
- **Gemini:** `gemini` CLI (Google)
- **Claude:** Already using it!

---

## Related

- [How to: Multi-AI](../how-to/multi-ai.md) - Practical guide
- [Reference: Commands](../reference/commands.md) - AI commands
