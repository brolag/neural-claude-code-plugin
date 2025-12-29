# Task Tool Usage Guide

**Goal**: Increase Task tool usage to 5%+ of tool calls.

## Why Use Task Tool (Sub-Agents)?

| Direct Tools | Task Tool (Sub-Agents) |
|--------------|------------------------|
| Simple, focused queries | Complex, exploratory searches |
| 1-2 file operations | Multi-file investigation |
| Known file paths | Unknown file locations |
| Quick lookups | Deep research |

**Key Insight**: Sub-agents have **fresh context**, so they don't pollute your main conversation with exploration noise.

## When to Use Task Tool

### ALWAYS Use Task for:

1. **Codebase Exploration**
   - Bad: Multiple Glob + Grep + Read calls
   - Good: `Task(Explore) "How does X work?"`

2. **Research Questions**
   - Bad: WebSearch + WebFetch + manual synthesis
   - Good: `Task(deep-research) "Research best practices for X"`

3. **Multi-File Changes**
   - Bad: Read file1, Read file2, Edit file1, Edit file2
   - Good: `Task(general-purpose) "Update all files that use old API"`

4. **Planning Complex Features**
   - Bad: Think in main context
   - Good: `Task(Plan) "Design implementation for feature X"`

## Agent Selection Quick Reference

| Need | Use Agent |
|------|-----------|
| "How does X work?" | `Explore` |
| "Find all files that..." | `Explore` |
| "Plan implementation of..." | `Plan` |
| "Design architecture for..." | `Plan` |
| Research question | `deep-research` |
| Long DevOps/terminal task | `codex` |
| Algorithm problem | `gemini` |
| Critical decision | `multi-ai` |
| Complex multi-step task | `general-purpose` |

## Quick Decision Tree

```
Is it a simple file read?
├─ YES → Use Read tool directly
└─ NO → Continue...

Is it exploration/research?
├─ YES → Task(Explore) or Task(deep-research)
└─ NO → Continue...

Will it require 3+ tool calls?
├─ YES → Task(general-purpose)
└─ NO → Do it directly

Is it architecture/planning?
├─ YES → Task(Plan)
└─ NO → Do it directly
```

## Parallel Agent Pattern

For independent tasks, launch multiple agents in ONE message:

```
Task(Explore) "Analyze auth module"
Task(Explore) "Analyze payment module"
```

Both run concurrently, results synthesized after.

## Anti-Patterns to Fix

| Anti-Pattern | Instead Use |
|--------------|-------------|
| Grep → Read → Grep → Read | `Task(Explore)` |
| Multiple sequential WebSearch | `Task(deep-research)` |
| Reading 5+ files to understand | `Task(Explore)` |

## Add to Your CLAUDE.md

Copy this section to your project's CLAUDE.md:

```markdown
## Task Tool / Sub-Agent Usage

Use Task tool instead of direct tool calls when:

| Situation | Use |
|-----------|-----|
| Exploring codebase | `Task(Explore)` |
| Research questions | `Task(deep-research)` |
| Multi-file investigation | `Task(general-purpose)` |
| Architecture planning | `Task(Plan)` |
| 3+ tool calls needed | `Task(general-purpose)` |
| Need AI consensus | `Task(multi-ai)` |

**Quick Decision**: If you're about to do Grep → Read → Grep → Read,
stop and use `Task(Explore)` instead.

**Parallel Agents**: For independent tasks, launch multiple Task calls
in ONE message.
```

---

*Part of Neural Claude Code Plugin*
