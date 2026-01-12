# How to: Run Research Tasks

Use parallel research agents and deep research hooks for thorough investigation.

---

## Quick Research

Just ask Claude:

```bash
What are the best practices for React 19 Server Components?
```

Claude will search and synthesize information.

---

## Research Swarm (Parallel)

For comprehensive research, use multiple agents:

```bash
/research-swarm "Compare Next.js vs Remix vs Astro for e-commerce"
```

This launches **5 parallel research agents**:
- Academic perspective
- Practical/implementation view
- Contrarian/devil's advocate
- Future trends
- Historical context

Results are synthesized into a comprehensive report.

---

## Deep Research (Extended)

For research during loops, use the deep research hook:

1. Add topics to the queue:
```bash
echo "GraphQL best practices|https://graphql.org/learn/,https://www.apollographql.com/docs/" >> .claude/loop/research-queue.txt
```

2. Run a loop - the hook executes after iterations with 10-minute timeout

3. Find results in `.claude/loop/research-results.md`

---

## GitHub Repo Learning

Learn from a GitHub repository:

```bash
/gh-learn https://github.com/vercel/next.js
```

Extracts:
- Architecture patterns
- Code conventions
- Key abstractions

---

## YouTube Learning

Extract knowledge from videos:

```bash
/yt-learn https://youtube.com/watch?v=abc123
```

Creates structured notes with:
- Key insights
- Actionable takeaways
- Notable quotes

---

## PDF Learning

Extract from PDF documents:

```bash
/pdf-learn ./whitepaper.pdf
```

Options:
- `--focus "security"` - Focus on specific topic
- `--summary` - Quick overview only
- `--pages 1-10` - Specific pages

---

## Teleport for Web Research

When you need heavy web access:

```bash
# Export memory before teleporting
/teleport-sync export

# Go to cloud Claude (better web access)
/teleport

# (Do research in cloud)

# Return and import findings
/teleport-sync import "<blob>"
```

---

## Best Practices

1. **Be specific** - "React 19 Server Components caching" > "React"
2. **Use swarms for comparisons** - Multiple perspectives help
3. **Capture learnings** - `/remember` key insights
4. **Check existing knowledge** - `/recall` before researching

---

## Related

- [Reference: Commands](../reference/commands.md) - Research commands
- [Explanation: Patterns](../explanation/patterns.md) - Research swarm architecture
