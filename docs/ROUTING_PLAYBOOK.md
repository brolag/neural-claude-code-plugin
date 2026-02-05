# Multi-AI Routing Playbook

Quick reference for optimal AI routing. Use `/route <task>` for detailed analysis.

## The 60-Second Decision

```
Is it...
├── Boilerplate/syntax/example? → Qwen (FREE)
├── Algorithm/data transform?   → Gemini (89% savings)
├── DevOps/terminal/scripts?    → Codex (65% savings)
├── Security/architecture?      → Opus (stay here)
└── Multi-step complex task?    → Plan-Execute pattern
```

## Quick Commands

| Task Type | Command | Savings |
|-----------|---------|---------|
| Simple code | `ollama run qwen2.5-coder:7b "..."` | 100% |
| Algorithm | `gemini -y "..."` | 89% |
| DevOps | `codex exec "..."` | 65% |
| Complex | `/plan-execute <task>` | 60-70% |
| Research | `/research <topic>` | Uses best per phase |

## When NOT to Route Away from Opus

1. **Security code** - Auth, encryption, data access
2. **Architecture decisions** - System design, trade-offs
3. **First-time patterns** - Novel implementations
4. **Financial/legal** - Payment flows, compliance
5. **Multi-file coordination** - Complex dependencies

**Rule**: If a bug costs more than token savings, use Opus.

## The Plan-Execute Pattern

For complex tasks with clear goals:

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ OPUS PLANS  │ ──▶ │GEMINI EXECS │ ──▶ │OPUS REVIEWS │
│   (5-10%)   │     │  (70-80%)   │     │  (10-20%)   │
└─────────────┘     └─────────────┘     └─────────────┘
```

**Invoke**: `/plan-execute <task>`

**Savings**: 60-70% on multi-step implementations

## Model Strengths

| Model | Best At | SWE-bench | Cost |
|-------|---------|-----------|------|
| **Opus 4.6** | Accuracy, planning, security | 80.8% | $$ |
| **Gemini 3** | Algorithms, speed | 1501 Elo | $ |
| **Codex** | Terminal, long sessions | #1 Terminal | $$ |
| **Qwen** | Boilerplate, explanations | Local | FREE |

## Daily Routing Habits

### Morning
- Use `/daily` (runs on Opus, that's fine)
- Route boilerplate generation to Qwen

### During Work
- Algorithm tasks → Gemini
- DevOps automation → Codex
- Stay in Opus for architecture discussions

### End of Day
- Code review → Codex (fresh perspective)
- Documentation → Gemini (fast, good enough)

## Cost Tracking

Estimated monthly savings with proper routing:

| Spend Level | Without Routing | With Routing | Savings |
|-------------|-----------------|--------------|---------|
| Light ($20/mo) | $20 | $8 | $12 |
| Medium ($50/mo) | $50 | $18 | $32 |
| Heavy ($100/mo) | $100 | $35 | $65 |

## Remember

> "Pay architects to think, juniors to code, seniors to review."

Same principle: Pay Opus to plan, Gemini to execute, Codex to verify.
