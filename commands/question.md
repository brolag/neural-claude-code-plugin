---
description: Answer any question - about the project, codebase, or general knowledge
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch
argument-hint: <your question>
---

# /question - Universal Question Answering

Answer any question with the best available method.

## Arguments
`$ARGUMENTS` - Your question

## Protocol

### Step 1: Check for Project Expertise

First, check if this project has expertise files:
```
.claude/expertise/*.yaml
```

If found, use Agent Expert pattern (read expertise first, validate, then answer).

### Step 2: Classify Question Type

| Type | Indicators | Method |
|------|------------|--------|
| **Project** | "this project", "codebase", "how does", "where is" | Expertise + code search |
| **Current** | "latest", "today", "2024/2025", "news", "recent" | Web search |
| **General** | Everything else | Direct answer + web if uncertain |

### Step 3: Execute Based on Type

#### For Project/Codebase Questions
```
1. Read .claude/expertise/*.yaml (if exists)
2. Search codebase with Glob/Grep
3. Read relevant files
4. Answer with file:line references
```

#### For Current Events / Recent Info
```
1. Use WebSearch with current year
2. Fetch relevant sources if needed
3. Synthesize with citations
```

#### For General Knowledge
```
1. Answer directly from knowledge
2. If uncertain, verify with WebSearch
3. Provide confident, concise answer
```

### Step 4: Format Response

```markdown
## Answer

[Direct, concise answer]

### Details
[Supporting information if needed]

### Sources
- [Files, expertise, or web sources used]
```

## Examples

```
/question where is the authentication logic?
→ Searches codebase, returns file:line locations

/question how does the planning skill work?
→ Reads .claude/skills/planning/, explains

/question what's new with React 19?
→ Web search, synthesizes recent info

/question explain dependency injection
→ Direct knowledge answer
```

## Quality Standards

- **Concise** - answer directly first
- **Specific** - include file paths, line numbers, sources
- **Honest** - say "I don't know" if uncertain
- **Adaptive** - use expertise files when available
