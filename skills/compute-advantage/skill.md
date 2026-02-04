---
name: compute-advantage
description: Calculate Compute Advantage ratio - the core metric of agentic leverage. Use when user says "/ca", "compute advantage", "calculate leverage", or wants to measure agentic ROI.
trigger: /ca, "compute advantage", "calculate leverage", "agentic roi"
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Compute Advantage Calculator

Measure your agentic coding leverage with the Compute Advantage formula.

## The Formula

```
         Compute Scaling × Autonomy Duration
CA = ─────────────────────────────────────────
         Time + Effort + Monetary Cost
```

## Variables Explained

| Variable | What It Means | How to Measure |
|----------|---------------|----------------|
| **Compute Scaling** | How much AI compute you're using | Tokens consumed / baseline (1x = manual, 10x = heavy agent use) |
| **Autonomy Duration** | How long agents work independently | Minutes without human intervention |
| **Time** | Human time invested | Minutes you spent on the task |
| **Effort** | Cognitive load factor | 1-5 scale (1=trivial, 5=complex) |
| **Monetary Cost** | API/compute costs | USD spent on the task |

## Interpretation

| CA Score | Level | Meaning |
|----------|-------|---------|
| < 1.0 | ❌ Negative | You'd be faster doing it manually |
| 1.0 - 2.0 | ⚠️ Break-even | Slight advantage, room to improve |
| 2.0 - 5.0 | ✅ Good | Solid agentic leverage |
| 5.0 - 10.0 | 🚀 Excellent | High-efficiency agentic workflow |
| > 10.0 | 🔥 Elite | ZTE-level performance |

## Usage

```bash
# Quick calculate
/ca

# Calculate with values
/ca compute=5 autonomy=45 time=10 effort=2 cost=0.50

# Log a session
/ca log "Implemented auth feature" --compute=8 --autonomy=60 --time=15 --effort=3 --cost=1.20

# View history
/ca history

# Weekly CA report
/ca report
```

## Interactive Calculator

When running `/ca` without parameters:

```markdown
## Compute Advantage Calculator

### Input Your Session Data

**Compute Scaling** (1-10): ___
How heavily did you use AI?
- 1 = occasional copilot suggestions
- 5 = active agent assistance
- 10 = full autonomous agent fleet

**Autonomy Duration** (minutes): ___
How long did agents work without you?

**Human Time** (minutes): ___
How much time did YOU spend?

**Effort Level** (1-5): ___
- 1 = trivial task
- 3 = moderate complexity
- 5 = highly complex

**Monetary Cost** (USD): ___
API costs for this session

---

### Your Result

CA = (8 × 45) / (10 + 3 + 0.50)
CA = 360 / 13.50
CA = **26.7x** 🔥 Elite

You achieved 26.7x leverage on this task!
```

## CA Data Structure

Save to `.claude/memory/kpis/ca-sessions.json`:

```json
{
  "sessions": [
    {
      "timestamp": "2026-02-03T14:30:00Z",
      "task": "Implemented auth feature",
      "compute_scaling": 8,
      "autonomy_min": 60,
      "human_time_min": 15,
      "effort": 3,
      "cost_usd": 1.20,
      "ca_score": 24.9,
      "notes": "Used /loop with TDD"
    }
  ],
  "averages": {
    "weekly_ca": 12.5,
    "monthly_ca": 10.2,
    "best_session": 45.0,
    "worst_session": 0.8
  }
}
```

## Optimization Tips

### To Increase CA:

**Increase Numerator:**
- Use more compute (parallel agents, background tasks)
- Extend autonomy (better CRAFT prompts, fewer interruptions)
- Use `/loop` for longer autonomous sessions

**Decrease Denominator:**
- Reduce human time (better specs upfront)
- Lower effort (reuse patterns, templates)
- Optimize costs (cache-aware prompts, right-size models)

### Common Anti-Patterns:

| Anti-Pattern | CA Impact | Fix |
|--------------|-----------|-----|
| Micro-managing agents | ⬇️ Kills autonomy | Trust the loop, review at end |
| Vague prompts | ⬇️ Increases iterations | Use CRAFT framework |
| No cost tracking | ❓ Hidden costs | Track API spend |
| Over-engineering prompts | ⬇️ High time/effort | 80/20 rule on specs |

## Weekly Report

```markdown
## Compute Advantage Report - Week 5

### Summary
| Metric | Value | Trend |
|--------|-------|-------|
| Avg CA | 8.4x | ⬆️ +2.1 |
| Best Session | 32.0x | auth feature |
| Worst Session | 1.2x | debugging edge case |
| Total Autonomy | 4.5 hrs | ⬆️ +1 hr |

### CA Distribution
[████░░░░░░] < 2x: 10% (investigate these)
[████████░░] 2-5x: 40%
[██████████] 5-10x: 35%
[████░░░░░░] > 10x: 15% 🔥

### Top Insights
1. CRAFT prompts → 3x better autonomy
2. /loop sessions avg 12x vs 4x manual
3. TDD approach → fewer review cycles
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| CA < 1.0 warning | Negative leverage detected | Review workflow, consider manual approach for this task type |
| Missing cost data | No API cost tracked | Estimate based on tokens or check billing dashboard |
| Invalid effort value | Value not 1-5 | Use scale: 1=trivial, 2=easy, 3=moderate, 4=hard, 5=complex |
| No autonomy data | Autonomy = 0 | You were in-loop the whole time, that's fine for some tasks |
| Division by zero | All denominator values = 0 | At minimum, human time should be > 0 |

**Fallback**: If you can't calculate exact CA, use the quick estimate:
- In-Loop work: ~1-2x CA
- Out-Loop work: ~3-8x CA
- ZTE work: ~10-50x CA

## Integration

- **KPI Skill**: CA is the meta-metric that combines all 4 KPIs
- **Loop Skill**: Auto-logs CA when loop completes
- **Cost Tracking**: Feeds monetary cost data

---

*The single number that measures your agentic leverage*
