---
description: Changelog Architect - Analyze Claude Code changelog for synergies
allowed-tools: WebFetch, Read, Write
---

# /changelog-architect

Changelog Architect Analysis

## Description

Analyze Claude Code changelog to discover feature synergies and unlock hidden value.

## Usage

```
/changelog-architect
```

## Prompt

Invoke the changelog-architect skill to:

1. Fetch the latest Claude Code changelog from GitHub
2. Apply first-principles analysis to decompose new features
3. Map synergies between new and existing capabilities
4. Synthesize high-value workflows
5. Recommend actionable next steps

Focus on discovering emergent value - combinations that are worth more than the sum of their parts.

## Examples

```
/changelog-architect
```

Outputs a comprehensive analysis with:
- New capabilities summary
- First principles breakdown
- Synergy map with ratings
- Concrete workflow recommendations
- Skills/agents to create

## Output Format

```markdown
# Changelog Architecture Analysis

**Versions Analyzed**: [list]
**Analysis Date**: [date]

## New Capabilities Summary
[Quick overview of what's new]

## First Principles Breakdown
| Feature | Core Capability | Constraints Removed |
|---------|-----------------|---------------------|

## Synergy Map
| Existing | New | Potential | Rating |
|----------|-----|-----------|--------|

## High-Value Workflows
1. **[Name]**: [Description]

## Recommendations
- [ ] Create skill: ...
- [ ] Update config: ...
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Fetch failed | GitHub unavailable | Retry or use cached changelog |
| No new versions | Already up to date | Check less frequently |
| Parse error | Changelog format changed | Update parser logic |

**Fallback**: If fetch fails, analyze local cached changelog if available.
