---
description: Self-improvement cycle - analyze patterns, run evaluations, and evolve the system
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, Task
---

# System Evolution

Run the self-improvement cycle to analyze usage patterns and evolve the Neural Claude Code system.

## What This Does

1. **Analyze Event Logs** - Review `.claude/memory/events/` for usage patterns
2. **Detect Patterns** - Find repeated workflows that could be automated
3. **Run Evaluations** - Test system against golden tasks
4. **Update Expertise** - Refine agent mental models based on learnings
5. **Suggest Improvements** - Recommend new skills, commands, or agents

## Process

### Phase 1: Gather Data
```
Read .claude/memory/events/*.jsonl
Aggregate tool usage statistics
Identify command frequency
```

### Phase 2: Pattern Analysis
Use the pattern-detector skill to find:
- Repeated tool sequences (3+ occurrences)
- Common workflows that could become skills
- Manual tasks that could be automated

### Phase 3: Evaluation
Run golden tasks from `.claude/eval/golden-tasks.json`:
- Memory system tests
- Multi-AI collaboration tests
- Worktree management tests
- Project setup tests

### Phase 4: Expertise Update
For each `.claude/expertise/*.yaml` file:
- Validate patterns against actual usage
- Update confidence scores
- Prune low-confidence patterns (< 0.3)
- Add newly discovered patterns

### Phase 5: Generate Report
Create `.claude/memory/evolution-report.md` with:
- Usage statistics
- Patterns detected
- Evaluation results
- Improvement suggestions
- Health score (0-100)

## Example Output

```markdown
# Evolution Report - 2024-12-18

## Session Analysis
- Sessions analyzed: 5
- Total events: 127
- Tools used: Read (45), Edit (32), Bash (28), Grep (22)

## Patterns Detected
1. Read → Edit → Write (23x) - Code modification pattern
2. Glob → Grep → Read (18x) - Code search pattern
3. Bash(git) → Write (12x) - Git workflow pattern

## Automation Opportunities
- [ ] Create skill: "code-search" for pattern #2
- [ ] Create command: "/refactor" for pattern #1

## Evaluation Results
| Task | Status | Notes |
|------|--------|-------|
| Memory Remember | PASS | 0.8s |
| Multi-AI Collab | SKIP | No API keys |
| Worktree Create | PASS | 1.2s |
| Project Setup | PASS | 0.5s |

## Expertise Updates
- knowledge-management.yaml: +2 patterns, confidence avg 0.78
- second-brain.yaml: +1 lesson learned

## Health Score: 76/100
- Memory capture: Active ✓
- Event logging: Active ✓
- Pattern detection: Needs data (< 100 events)
- Skill creation: Ready ✓
```

## Frequency
- **Recommended**: Weekly or after major work sessions
- **Trigger**: Can be automated via cron or session count threshold

## Related Commands
- `/meta/eval` - Run evaluation tests only
- `/meta/improve <agent>` - Sync single agent's expertise
- `/meta/brain` - View system health dashboard

## Tips
- Run after accumulating 50+ events for meaningful patterns
- Review suggestions before auto-creating skills
- Use `--dry-run` to preview changes without applying
