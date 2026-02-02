---
description: Interactive installer for Neural Claude Code skills
allowed-tools: Bash, Read, Write
---

# Install Skills Command

Interactive installer for skills from the Neural Claude Code plugin repository.

## Usage

```bash
# Interactive mode (recommended)
/install-skills

# View installation status
/install-skills --status

# Dry run (preview without installing)
/install-skills --dry-run

# Install recommended bundle
/install-skills --recommended
```

## Features

### Interactive Menu System

Pure bash menu interface with:
- Category selection (Development, Quality, Research, Knowledge)
- Multi-select skill selection
- Scope selection (Project, Global, Both)
- Automatic dependency resolution
- Installation preview and confirmation

### Installation Scopes

| Scope | Location | Use Case |
|-------|----------|----------|
| **Project** | `./.claude/skills/` | Project-specific skills |
| **Global** | `~/.claude/skills/` | Available in all projects |
| **Both** | Both locations | Maximum availability |

### Recommended Bundle

One-click installation of curated essential skills:
- `debugging` - Systematic root cause analysis
- `tdd` - Test-Driven Development
- `deep-research` - Multi-phase research
- `slop-scan` - Technical debt detection
- `slop-fix` - Auto-fix safe issues
- `overseer` - PR review before merge

## Available Skills by Category

### Development Skills (3 skills)
- **debugging** - 4-phase root cause analysis
- **tdd** - RED-GREEN-REFACTOR cycle enforcement
- **react-best-practices** - React/Next.js optimization (40+ rules)

### Quality Skills (5 skills)
- **stop-slop** - Remove AI writing patterns
- **slop-scan** - Detect technical debt
- **slop-fix** - Auto-fix safe slop issues
- **overseer** - Review PRs/diffs before merge
- **code-reviewer** - Two-stage quality checks

### Research & Learning (1 skill)
- **deep-research** - Multi-source orchestrated research

### Knowledge & Planning (1 skill)
- **knowledge-management** - PARA-based second brain

## Installation Process

The installer performs these steps:

1. **Initialization**
   - Check prerequisites (bash 4+, jq, python3)
   - Load skills registry
   - Detect current installation status

2. **Skill Selection**
   - Browse by category
   - Multi-select interface
   - View already-installed skills

3. **Dependency Resolution**
   - Auto-detect dependencies
   - Add missing dependencies to install list
   - Show dependency tree

4. **Installation**
   - Create target directories
   - Copy skill.md + references
   - Update registry
   - Log installation

5. **Validation**
   - Verify files copied
   - Check YAML frontmatter
   - Generate summary report

## Output Format

```markdown
## Installation Complete!

**Scope**: project
**Installed**: 5 skills

### Installed Skills ✓

- debugging
- tdd
- slop-scan
- slop-fix
- overseer

### Dependencies Added

- (none)

### Usage Examples

/debug          # debugging
/tdd            # tdd
/slop-scan      # slop-scan
/slop-fix       # slop-fix
/overseer       # overseer

### Next Steps

1. Use skills with their trigger commands
2. Run /help to see all available commands
3. Check CLAUDE.md for project-specific configuration
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Prerequisites missing | bash 4+, jq, or python3 not installed | Install with: `brew install bash jq python3` |
| Registry not found | Plugin not properly initialized | Check plugin installation |
| Permission denied | Can't write to target directory | Check directory permissions |
| Skill source missing | Corrupted plugin installation | Re-clone plugin repository |

**Fallback**: If interactive mode fails, manually copy skills from plugin `skills/` directory to project `.claude/skills/` directory.

## Implementation Details

### Skills Registry

Location: `.claude/skills-registry.json`

Tracks:
- Available skills by category
- Skill metadata (name, description, trigger, dependencies)
- Installation status (project vs global)
- Recommendations

### Log Files

Location: `~/.claude/setup/logs/install-{timestamp}.json`

Records:
- Installation timestamp
- Selected skills
- Installation scope
- Success/failure status
- Error messages

### Safety Features

- Idempotent (safe to run multiple times)
- Dry-run mode for preview
- Automatic dependency resolution
- Rollback on failure
- Installation validation

## Integration

This command is part of the Neural Claude Code plugin system.

After installation, skills are immediately available for use through:
- Command triggers (e.g., `/debug`, `/slop-scan`)
- Automatic activation (e.g., React code triggers `react-best-practices`)
- Skill tool invocation

---

**Version**: 1.0.0
**Created**: 2026-02-01
