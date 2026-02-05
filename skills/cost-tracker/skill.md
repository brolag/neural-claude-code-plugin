---
name: cost-tracker
description: Track API costs in real-time for Compute Advantage calculations. Use when user says "/cost", "track spending", "api costs", or wants to monitor agentic expenses.
trigger: /cost, "track cost", "api spending", "token usage"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Cost Tracker Skill

Track API costs in real-time to feed into Compute Advantage calculations.

## Pricing Reference (2026)

| Model | Input (per 1M tokens) | Output (per 1M tokens) |
|-------|----------------------|------------------------|
| Claude Opus 4.6 | $5.00 | $25.00 |
| Claude Sonnet 4 | $3.00 | $15.00 |
| Claude Haiku | $0.25 | $1.25 |
| GPT-4o | $2.50 | $10.00 |
| Codex (GPT-5.2) | $5.00 | $20.00 |
| Gemini Flash | Free tier / $0.15 | Free tier / $0.60 |
| **Opus 4.6 Prompt Caching** | | |
| - Cache Write (5min TTL) | $6.25 | - |
| - Cache Write (1hr TTL) | $10.00 | - |
| - Cache Hits | $0.50 | - |
| **Opus 4.6 Batch API** | $2.50 | $12.50 |

## Usage

```bash
# View today's costs
/cost

# Log a session cost
/cost log 0.85 "Auth feature implementation"

# Estimate cost for a task
/cost estimate "Build REST API" --model opus

# View weekly breakdown
/cost report

# Set budget alerts
/cost budget 50 --weekly

# View costs by project
/cost by-project

# Export for accounting
/cost export --format csv
```

## Cost Data Structure

Save to `.claude/memory/kpis/costs.json`:

```json
{
  "daily": {
    "2026-02-03": {
      "sessions": [
        {
          "timestamp": "09:30",
          "task": "Auth feature",
          "model": "opus",
          "input_tokens": 50000,
          "output_tokens": 15000,
          "cost_usd": 1.88,
          "duration_min": 45
        }
      ],
      "total_usd": 5.42,
      "total_tokens": {
        "input": 180000,
        "output": 45000
      }
    }
  },
  "budgets": {
    "weekly": 50,
    "monthly": 150
  },
  "alerts": {
    "threshold_percent": 80,
    "notify": true
  }
}
```

## Cost Dashboard

```markdown
## API Costs - 2026-02-03

### Today
💰 $5.42 spent
📊 225K tokens used (180K in / 45K out)

### By Model
| Model | Cost | % |
|-------|------|---|
| Opus 4.6 | $1.40 | 77% |
| Sonnet 4 | $1.02 | 19% |
| Haiku | $0.20 | 4% |

### By Task
| Task | Cost | Tokens |
|------|------|--------|
| Auth feature | $1.88 | 65K |
| API refactor | $2.15 | 80K |
| Bug fixes | $1.39 | 80K |

### Budget Status
Weekly: $18.50 / $50.00 (37%)
[███████░░░░░░░░░░░░░] ✅ On track

Monthly: $42.30 / $150.00 (28%)
[█████░░░░░░░░░░░░░░░] ✅ On track

### Cost per Hour of Autonomy
💡 $3.20/hr (excellent efficiency)
```

## Cost Estimation

When running `/cost estimate "<task>"`:

```markdown
## Cost Estimate: Build REST API

### Assumptions
- Complexity: Medium (3/5)
- Estimated tokens: ~150K in, 40K out
- Model: Claude Opus 4.6

### Estimate
| Scenario | Tokens | Cost |
|----------|--------|------|
| Optimistic | 120K | $2.40 |
| Expected | 190K | $4.75 |
| Pessimistic | 300K | $8.50 |

### Recommendations
- Use Sonnet for exploration: saves ~60%
- Use CRAFT prompt: reduces iterations ~30%
- Use /loop with Haiku for lint: saves ~90%
```

## Auto-Tracking Integration

### With Claude CLI

```bash
# Claude CLI logs tokens to stderr
# Parse and log automatically via hook

# In .claude/settings.json hooks:
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": ".*",
        "command": "bash ~/.claude/scripts/cost-tracker.sh"
      }
    ]
  }
}
```

### Cost Tracker Script

```bash
#!/bin/bash
# ~/.claude/scripts/cost-tracker.sh

# Parse token usage from Claude CLI output
# Add to daily costs file
# Check budget alerts

COSTS_FILE=".claude/memory/kpis/costs.json"
TODAY=$(date +%Y-%m-%d)

# Extract tokens from session (implementation depends on CLI output format)
# Log to costs file
# Alert if over budget
```

## Budget Alerts

```markdown
## ⚠️ Budget Alert

You've used 85% of your weekly budget ($42.50 / $50.00)

### Recommendations
1. Switch to Sonnet/Haiku for remaining tasks
2. Use cached prompts where possible
3. Batch similar operations

### Top Cost Drivers This Week
| Task | Cost | Suggestion |
|------|------|------------|
| Complex refactor | $15.00 | Use /loop with checkpoints |
| Exploration | $12.00 | Use Haiku for initial search |
| Debugging | $8.50 | Use TDD to catch issues earlier |
```

## Weekly Cost Report

```markdown
## Weekly Cost Report - Week 5, 2026

### Summary
| Metric | Value | vs Last Week |
|--------|-------|--------------|
| Total Cost | $48.20 | ⬆️ +12% |
| Total Tokens | 1.2M | ⬆️ +8% |
| Cost/Autonomy Hr | $2.80 | ⬇️ -15% (better!) |
| Avg CA Score | 8.5x | ⬆️ +2.1 |

### Cost Distribution
[████████████████░░░░] Opus: 65% ($31.33)
[████████░░░░░░░░░░░░] Sonnet: 25% ($12.05)
[██░░░░░░░░░░░░░░░░░░] Haiku: 8% ($3.86)
[█░░░░░░░░░░░░░░░░░░░] Other: 2% ($0.96)

### Efficiency Trends
- Best day: Tuesday ($4.20, 3 features shipped)
- Worst day: Thursday ($12.50, debugging session)
- Improvement: -15% cost per autonomous hour

### Insights
1. CRAFT prompts saved ~$8 vs unstructured
2. /loop with TDD reduced debugging costs 40%
3. Haiku for linting saved $15 vs Opus

### Next Week Targets
- Stay under $50 weekly budget
- Improve cost/autonomy to $2.50/hr
- Shift 10% more to Haiku for simple tasks
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No cost data | First time using or file missing | Initialize with `/cost init` |
| Parse error | Invalid token count format | Enter tokens as numbers (e.g., 50000, not "50K") |
| Budget file missing | Budgets not set | Set with `/cost budget <amount> --weekly` |
| Negative cost | Invalid calculation | Check token counts are positive |
| Model not found | Unknown model in pricing | Use known models or add custom pricing |

**Fallback**: If auto-tracking fails, manually log costs with `/cost log <amount> "<task>"`. Estimate tokens at ~1000 tokens per minute of interaction.

## Integration

- **Compute Advantage**: Feeds "Monetary Cost" into CA formula
- **KPI Dashboard**: Shows cost efficiency metrics
- **Loop**: Auto-logs session costs when loop completes
- **Route**: Informs model selection for cost optimization

---

*Know your costs, maximize your leverage*
