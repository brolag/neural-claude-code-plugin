---
description: Check system status - what tools and features are actually available
allowed-tools: Bash, Read, Glob
---

# /status - System Status Check

Shows what tools, CLIs, and features are actually available in the current environment.

## Usage

```bash
/status
/status --verbose
```

## Prompt

Check the current system status and report what's available.

### Step 1: Check CLI Tools

```bash
# Core tools
echo "=== CLI Tools ==="
echo -n "codex: " && (codex --version 2>/dev/null || echo "not installed")
echo -n "gemini: " && (gemini --version 2>/dev/null || echo "not installed")
echo -n "gh: " && (gh --version 2>/dev/null | head -1 || echo "not installed")
echo -n "node: " && (node --version 2>/dev/null || echo "not installed")
echo -n "python: " && (python3 --version 2>/dev/null || echo "not installed")
```

### Step 2: Check Project Context

```bash
# Project detection
echo "=== Project ==="
[ -f "package.json" ] && echo "Type: Node.js" && cat package.json | grep -E '"name"|"typescript"' | head -2
[ -f "tsconfig.json" ] && echo "TypeScript: yes"
[ -f "pyproject.toml" ] && echo "Type: Python"
[ -f ".git" ] || [ -d ".git" ] && echo "Git: yes"
```

### Step 3: Check Neural Claude Code

```bash
# Neural features
echo "=== Neural Claude Code ==="
[ -d ".claude" ] && echo "Project initialized: yes" || echo "Project initialized: no"
[ -f ".claude/settings.json" ] && echo "Settings: configured"
[ -d ".claude/memory" ] && echo "Memory: active"
```

## Output Format

```markdown
## System Status

### CLI Tools
| Tool | Status | Version |
|------|--------|---------|
| Codex | ✅ | 0.79.0 |
| Gemini | ✅ | 0.18.4 |
| gh | ✅ | 2.x.x |
| node | ✅ | 20.x.x |

### Project
| Check | Status |
|-------|--------|
| Type | TypeScript/Node.js |
| Git | ✅ Initialized |
| Tests | `npm test` available |

### Neural Features
| Feature | Status |
|---------|--------|
| Memory | ✅ Active |
| Multi-AI | ✅ Available |
| Worktrees | ✅ Available |
| Neural Squad | ❌ Not configured |

### Available Commands
Based on your setup, you can use:
- `/feature` - Branch-first development
- `/secure-api` - Security changes with verification
- `/plan-execute` - Opus plans, Gemini executes
- `/ai-collab` - Multi-AI collaboration
- `/loop` - Autonomous coding loops
```

## Error Handling

| Error | Resolution |
|-------|------------|
| Command not found | Mark as "not installed" |
| Permission denied | Note in output |

**Fallback**: Report what could be detected, note what failed.
