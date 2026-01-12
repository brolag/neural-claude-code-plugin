# Explanation: Agent Expert Pattern

Why and how Claude learns from every interaction.

---

## The Problem

Traditional AI assistants:

```
Session 1: User explains project structure
Session 2: User explains project structure again
Session 3: User explains project structure again
...forever
```

Every session starts from zero. Users waste time re-establishing context.

---

## The Solution: Agent Expert

```
Session 1: User explains → Claude saves to expertise
Session 2: Claude loads expertise → Already knows
Session 3: Claude loads expertise → Knows even more
...gets smarter
```

---

## The Learning Loop

```
┌─────────────────────────────────────────────────────────────┐
│                    ACT-LEARN CYCLE                           │
│                                                              │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐              │
│   │  READ    │ → │ EXECUTE  │ → │  LEARN   │ ──┐           │
│   │expertise │    │  task    │    │patterns  │   │           │
│   └──────────┘    └──────────┘    └──────────┘   │           │
│        ↑                                          │           │
│        └──────────────────────────────────────────┘           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 1. READ Expertise

At session start, Claude loads:
- Project understanding (tech stack, structure)
- Patterns (conventions that worked)
- Lessons learned (insights from past)
- User preferences (personal style)

### 2. EXECUTE Task

Claude works on the user's request, informed by loaded expertise.

### 3. LEARN Patterns

After significant work, Claude identifies:
- New patterns that worked
- Lessons from this session
- User preferences discovered

### 4. UPDATE Expertise

Learnings are saved to expertise files, ready for next session.

---

## What Gets Learned

### Understanding
```yaml
understanding:
  architecture: "React frontend, Node.js API"
  key_files:
    - src/App.tsx
    - api/routes/
```

"What is this project?"

### Patterns
```yaml
patterns:
  - "Use functional components with hooks"
  - "API routes follow REST conventions"
  - "Tests go in __tests__ folders"
```

"How should I do things here?"

### Lessons
```yaml
lessons_learned:
  - "Running tests before commit catches most issues"
  - "User prefers detailed commit messages"
```

"What did I learn from past mistakes?"

### Preferences
```yaml
user_preferences:
  - "Conventional commits with emoji"
  - "Spanish for comments, English for code"
```

"How does this user like things?"

---

## Learning Triggers

Learning happens when:

1. **Task completion** - After finishing significant work
2. **Explicit prompt** - User says "learn this"
3. **Evolve command** - `/evolve` analyzes patterns
4. **Meta-improve** - `/meta:improve` syncs expertise

---

## Learning Checkpoint

After significant actions, Claude prompts:

```
📝 LEARNING CHECKPOINT

You've completed 8 significant actions.
Consider updating .claude/expertise/project.yaml with:

• Patterns: Repeatable workflows that worked
• Lessons: Insights from this execution
• Preferences: User behaviors learned
```

This makes learning visible and intentional.

---

## Confidence Scoring

Patterns track confidence:

```yaml
patterns:
  - pattern: "Use async/await over callbacks"
    successes: 15
    failures: 2
    confidence: 0.88
```

**Formula:** `confidence = successes / (successes + failures + 1)`

**Thresholds:**
- Above 0.7 → Promote to shared expertise
- Below 0.3 → Prune from expertise

---

## Why This Matters

### Traditional Assistant
- Stateless between sessions
- User repeats context constantly
- No accumulated value
- Same quality forever

### Agent Expert
- Remembers between sessions
- Context persists and grows
- Accumulated knowledge
- Improves over time

---

## Analogy: New Employee

**Day 1:** Needs everything explained
**Week 1:** Remembers some things, asks fewer questions
**Month 1:** Knows the patterns, works independently
**Year 1:** Expert who improves the team

Agent Expert gives Claude this same trajectory.

---

## Related

- [Architecture](architecture.md) - System overview
- [How to: Create Expertise](../how-to/meta-agents.md) - Practical guide
- [Tutorial: First Expertise](../tutorials/02-first-expertise.md) - Step-by-step
