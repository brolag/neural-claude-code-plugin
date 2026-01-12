# How to: Create Custom Agents and Skills

Use meta-agents to extend Neural Claude Code with your own components.

---

## Create a Custom Agent

```bash
/meta:agent security-checker
```

Or describe what you need:

```
Create an agent that reviews code for security vulnerabilities
```

Claude creates:
- `.claude/agents/security-checker.md`
- Proper tool permissions
- Domain expertise integration

---

## Create a Custom Skill

```bash
/meta:skill api-testing
```

Or describe the workflow:

```
Create a skill for testing API endpoints with curl
```

Claude creates:
- `.claude/skills/api-testing/skill.md`
- `.claude/skills/api-testing/tests.json`
- Trigger phrases

---

## Create a Custom Command

```bash
/meta:prompt daily-standup
```

Creates a new slash command for your workflow.

---

## Agent vs Skill vs Command

| Type | Complexity | Use Case |
|------|------------|----------|
| **Command** | Simple | Single action (`/deploy`) |
| **Skill** | Medium | Workflow with steps |
| **Agent** | Complex | Specialized domain expertise |

---

## Example: Security Agent

```markdown
# Security Checker Agent

## Purpose
Review code changes for security vulnerabilities.

## Triggers
- "check security"
- "security review"
- Pull request reviews

## Tools
- Read (examine code)
- Grep (search patterns)
- Glob (find files)

## Expertise
- OWASP Top 10
- Language-specific vulnerabilities
- Authentication/authorization patterns
```

---

## Example: Testing Skill

```markdown
# API Testing Skill

## Trigger
/test-api <endpoint>

## Steps
1. Parse endpoint URL
2. Detect expected method (GET/POST/etc)
3. Run curl command
4. Parse response
5. Report status

## Tools
- Bash (curl commands)
- Read (config files)
```

---

## Sync Expertise After Creation

After Claude learns from using your new agent/skill:

```bash
/meta:improve project
```

Updates expertise files with new patterns.

---

## Evaluate Your Components

Test against golden tasks:

```bash
/meta:eval
```

Runs automated tests to verify behavior.

---

## System Dashboard

Check health of all components:

```bash
/meta:brain
```

Shows:
- Expertise file health
- Agent/skill activation status
- Memory statistics

---

## Related

- [Reference: Agents](../reference/agents.md) - Built-in agents
- [Reference: Skills](../reference/skills.md) - Built-in skills
- [Explanation: Agent Expert Pattern](../explanation/agent-expert.md) - How learning works
