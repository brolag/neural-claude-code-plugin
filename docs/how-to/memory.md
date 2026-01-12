# How to: Use the Memory System

Save facts, recall information, and manage persistent memory across sessions.

---

## Save a Fact

```bash
/remember The API uses JWT tokens with 24h expiry
```

Facts are saved to `.claude/memory/facts/` and persist across sessions.

**Examples:**
```bash
/remember The deployment script is in scripts/deploy.sh
/remember Production database is PostgreSQL on AWS RDS
/remember User prefers conventional commits with emoji
```

---

## Recall Information

```bash
/recall authentication
```

Searches your saved facts for relevant matches.

**Examples:**
```bash
/recall database        # Find database-related facts
/recall API             # Find API-related facts
/recall deployment      # Find deployment info
```

---

## Forget a Fact

```bash
/forget <fact-id>
```

Remove a fact from memory. Get the fact ID from `/recall`.

---

## Memory Tiers

| Tier | Location | Speed | Use Case |
|------|----------|-------|----------|
| **Hot** | Context window | Instant | Current conversation |
| **Warm** | `.claude/memory/` | Seconds | Facts, events, patterns |
| **Cold** | Archives | Manual | Old session logs |

---

## Global vs Project Memory

**Project memory** (default):
```bash
/remember API key rotates monthly
# Saved to: .claude/memory/facts/
```

**Global memory** (shared across projects):
```bash
/remember --global My GitHub username is brolag
# Saved to: ~/.claude/memory/facts/
```

---

## Best Practices

1. **Be specific** - "JWT tokens expire in 24h" > "Uses JWT"
2. **Include location** - "Config is in `src/config/`"
3. **Update, don't duplicate** - Use `/forget` before adding updated info
4. **Recall before asking** - Check memory before researching

---

## Related

- [Reference: Commands](../reference/commands.md) - Full command syntax
- [Explanation: Architecture](../explanation/architecture.md) - How memory works
