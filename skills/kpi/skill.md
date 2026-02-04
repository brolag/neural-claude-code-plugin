---
name: kpi
description: Track agentic coding KPIs - Plan Velocity, Review Velocity, Autonomy Duration, Loop State. Use when user says "/kpi", "track metrics", "measure productivity", or wants to see agentic performance.
trigger: /kpi, "track kpi", "measure agentic", "show metrics"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# KPI Tracking Skill

Track the 4 core metrics of Agentic Coding performance.

## The 4 KPIs

| KPI | What It Measures | Target |
|-----|------------------|--------|
| **Plan Velocity** | Time from intent → actionable spec | < 10 min |
| **Review Velocity** | Time per code review cycle | < 5 min |
| **Autonomy Duration** | Time agents work without human intervention | > 30 min |
| **Loop State** | % of work in In-Loop / Out-Loop / ZTE | 20/60/20 |

## Loop States Explained

```
┌─────────────────────────────────────────────────────────────┐
│ IN-LOOP (10% autonomy)                                      │
│ Human prompts every step, reviews every output              │
│ "Write this function" → review → "Now add tests" → review   │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ OUT-LOOP (60% autonomy)                                     │
│ Human gives task, agent executes multiple steps             │
│ "Implement auth feature" → agent works → human reviews end  │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ ZTE - Zero Touch Engineering (95% autonomy)                 │
│ Agent fleet ships autonomously, human reviews PRs           │
│ "Ship the roadmap" → agents build → CI validates → PR ready │
└─────────────────────────────────────────────────────────────┘
```

## Usage

```bash
# Quick KPI dashboard
/kpi

# Log a planning session
/kpi plan 8 "Auth feature spec"

# Log a review cycle
/kpi review 3 "PR #42 auth implementation"

# Log autonomy session
/kpi autonomy 45 "Feature built with /loop"

# Log loop state for a task
/kpi state out-loop "Implemented caching layer"

# Weekly report
/kpi report

# Set targets
/kpi target autonomy 60
```

## KPI Data Structure

Save to `.claude/memory/kpis/YYYY-MM-DD.json`:

```json
{
  "date": "2026-02-03",
  "plan_sessions": [
    {"duration_min": 8, "task": "Auth feature spec", "timestamp": "09:30"}
  ],
  "review_sessions": [
    {"duration_min": 3, "task": "PR #42", "timestamp": "14:15"}
  ],
  "autonomy_sessions": [
    {"duration_min": 45, "task": "Feature with /loop", "timestamp": "10:00"}
  ],
  "loop_states": [
    {"state": "out-loop", "task": "Caching layer", "timestamp": "11:30"}
  ],
  "summary": {
    "avg_plan_velocity": 8,
    "avg_review_velocity": 3,
    "total_autonomy_min": 45,
    "loop_distribution": {"in-loop": 20, "out-loop": 60, "zte": 20}
  }
}
```

## KPI Dashboard Output

```markdown
## Agentic KPIs - 2026-02-03

### Plan Velocity
⚡ 8 min avg (target: <10 min) ✅
Sessions: 3 | Best: 5 min | Worst: 12 min

### Review Velocity
⚡ 3 min avg (target: <5 min) ✅
Sessions: 5 | Best: 2 min | Worst: 6 min

### Autonomy Duration
🤖 45 min total | 15 min avg session
Target: >30 min per session ✅

### Loop State Distribution
[██████████░░░░░░░░░░] In-Loop: 20%
[████████████████████████████░░] Out-Loop: 60%
[████░░░░░░░░░░░░░░░░] ZTE: 20%

### Compute Advantage Score
📊 CA = (Compute × Autonomy) / (Time + Effort + Cost)
Current: 4.2x leverage (Good)
```

## Weekly Report

```markdown
## Weekly Agentic Report - Week 5, 2026

### Trends
| KPI | This Week | Last Week | Change |
|-----|-----------|-----------|--------|
| Plan Velocity | 7 min | 12 min | ⬇️ 42% better |
| Review Velocity | 4 min | 5 min | ⬇️ 20% better |
| Autonomy | 180 min | 90 min | ⬆️ 100% more |
| ZTE % | 25% | 15% | ⬆️ 10pp |

### Highlights
- Best autonomy session: 90 min (feature X)
- Moved 3 tasks from In-Loop → Out-Loop
- First ZTE deployment: auth microservice

### Areas to Improve
- Plan velocity still high on complex features
- Need more CRAFT templates for common patterns
```

## Compute Advantage Formula

```
CA = (Compute Scaling × Autonomy Duration) / (Time + Effort + Monetary Cost)

Where:
- Compute Scaling = tokens consumed / baseline tokens
- Autonomy Duration = minutes without human intervention
- Time = human minutes invested
- Effort = complexity factor (1-5)
- Monetary Cost = API cost in USD
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No KPI data found | First time using or file missing | Initialize with `/kpi init` |
| Invalid duration | Negative or unrealistic value | Use positive integers for minutes |
| Unknown loop state | State not in-loop/out-loop/zte | Use only: in-loop, out-loop, zte |
| Report generation failed | Insufficient data | Need at least 3 days of data for trends |
| Target not set | Trying to compare against undefined target | Set targets with `/kpi target <kpi> <value>` |

**Fallback**: If KPI tracking data is unavailable, estimate based on session duration and task complexity. Log manually with timestamps.

## Integration Points

- **Neural Loop**: Auto-logs autonomy duration when loop completes
- **Git commits**: Can infer review velocity from commit timestamps
- **Task system**: Tracks loop state per task
- **Memory system**: Persists all KPI data for long-term trends

---

*Part of the Agentic Coding measurement system*
