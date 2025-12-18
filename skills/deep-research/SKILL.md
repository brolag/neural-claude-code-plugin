---
description: Conduct comprehensive multi-source research with systematic analysis and knowledge integration. Use when user needs thorough investigation, deep dive analysis, or research on complex topics.
allowed-tools: Read, Write, Edit, Glob, Grep, WebSearch, WebFetch
---

# Deep Research Skill

Systematic multi-source research with analysis and knowledge integration.

## When Claude Should Use This Skill

- User mentions "research", "investigate", "deep dive"
- User asks for "comprehensive analysis", "thorough investigation"
- Complex topics requiring multiple source validation
- User needs current information beyond knowledge cutoff
- Technical evaluation or comparison tasks

## Research Protocol

### Phase 1: Planning & Scoping
```xml
<research_scope>
- Define primary research question
- Identify 3-5 key subtopics
- Determine credible source types needed
- Set depth and breadth parameters
</research_scope>
```

### Phase 2: Multi-Source Investigation
Execute **minimum 5 web searches** with progressive refinement:

1. **Broad overview**: "{topic} comprehensive guide 2025"
2. **Academic/expert**: "{topic} research papers expert analysis"
3. **Current trends**: "{topic} latest developments 2025"
4. **Practical applications**: "{topic} implementation case studies"
5. **Critical perspectives**: "{topic} challenges limitations"

### Phase 3: Analysis
For each source, document:
- **Credibility**: Source authority and recency
- **Key insights**: 3-5 main findings
- **Contradictions**: Conflicting information
- **Gaps**: Information still needed

### Phase 4: Knowledge Synthesis
Cross-reference with vault:
- Search `03_resources/` for related content
- Check `01_projects/` for relevant context
- Identify connections to current work

### Phase 5: Documentation
Create structured output:
```
03_resources/Research/
└── {Topic}_Research_{Date}.md
    ├── Executive Summary
    ├── Key Findings
    ├── Source Analysis
    ├── Contradictions & Gaps
    ├── Connections to Projects
    ├── Action Items
    └── Bibliography
```

## Quality Standards

- Minimum 5 web searches
- 3+ credible sources per major finding
- Cross-validation of key claims
- Explicit uncertainty acknowledgment
- Actionable insights extraction

## Output Deliverables

1. **Research MOC**: Comprehensive overview
2. **Subtopic Notes**: Detailed findings
3. **Connection Map**: Links to vault content
4. **Action Plan**: Next steps
5. **Source Repository**: Organized bibliography
