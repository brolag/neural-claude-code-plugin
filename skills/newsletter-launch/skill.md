---
name: newsletter-launch
description: Create complete newsletter content pack from research. Generates newsletter, Twitter thread, LinkedIn carousel, LinkedIn post, and video script from a single research topic.
trigger: /newsletter, "create newsletter", "launch newsletter"
allowed-tools: WebSearch, WebFetch, Read, Write, Glob, Grep
priority: high
---

# Newsletter Launch Skill

Transform research into a complete content pack for newsletter launch.

## Usage

```bash
# From a topic (will research first)
/newsletter "Agentic coding trends January 2026"

# From existing research file
/newsletter inbox/research-2026-01-18-agentic-coding-viral-advances.md

# With options
/newsletter "topic" --newsletter-name "Indie Mind" --lang es
```

## Arguments

| Argument | Description | Default |
|----------|-------------|---------|
| `source` | Topic string or file path | required |
| `--newsletter-name` | Newsletter brand name | "Newsletter" |
| `--lang` | Language (es/en) | es |
| `--skip` | Skip content types (comma-separated) | none |

## Output Structure

```
.claude/content/{newsletter-name}/
├── newsletter-{date}-{topic}.md      # Main newsletter
├── thread-{date}-{topic}.md          # Twitter/X thread (8-12 tweets)
├── carousel-{date}-{topic}.md        # LinkedIn carousel (6-10 slides)
├── linkedin-{date}-{topic}.md        # Short LinkedIn post
└── video-{date}-{topic}.md           # TikTok/Reels script (45-60s)
```

## Process

### Phase 1: Research (if topic provided)

```
1. Run 4-6 parallel WebSearch queries on topic
2. Fetch top 3-5 relevant sources
3. Extract key insights, stats, quotes
4. Save research to inbox/research-{date}-{topic}.md
```

### Phase 2: Newsletter Creation

```
1. Structure:
   - Hook (surprising stat or statement)
   - Context (what happened)
   - 3-5 key developments with details
   - Opinion/take
   - Action item for reader
   - Links

2. Format:
   - 600-800 words
   - Scannable sections
   - 3-5 external links
   - Clear CTA
```

### Phase 3: Twitter Thread

```
1. Structure:
   - Tweet 1: Hook + "A thread 🧵"
   - Tweets 2-9: Key points (1 per tweet)
   - Tweet 10: CTA + follow

2. Format:
   - Max 280 chars per tweet
   - Use numbers (1/10, 2/10)
   - Include 1-2 relevant emojis
   - End with engagement question
```

### Phase 4: LinkedIn Carousel

```
1. Structure:
   - Slide 1: Title + hook
   - Slide 2: Problem/context
   - Slides 3-7: Key points (1 per slide)
   - Slide 8: CTA

2. Format:
   - 6-10 slides
   - Max 30 words per slide
   - Include design notes
   - Suggest visual elements
```

### Phase 5: LinkedIn Post

```
1. Structure:
   - Hook line (attention-grabbing)
   - Short paragraphs (1-2 sentences)
   - Key insight or opinion
   - Engagement question

2. Format:
   - 800-1200 characters
   - Line breaks for readability
   - No hashtags in body (add at end)
```

### Phase 6: Video Script

```
1. Structure:
   - 0-5s: Hook (surprising fact)
   - 5-20s: Context
   - 20-40s: Key insight + twist
   - 40-60s: Takeaway + CTA

2. Format:
   - 45-60 seconds
   - Include text overlays
   - Suggest B-roll
   - Add production notes
```

### Phase 7: Quality Gate (Stop-Slop)

```
Before finalizing each piece:
1. Scan for banned phrases
2. Check for AI patterns
3. Verify rhythm variety
4. Score must be 35/50+
```

## Output Format

Each file includes:

```markdown
# [Type]: [Title]

**Date**: YYYY-MM-DD
**Newsletter**: [Name]
**Status**: Draft

---

[Content]

---

## Metadata
- Word/character count
- Estimated engagement metrics
- Best posting time
- Platform-specific notes

## Checklist
- [ ] Review for accuracy
- [ ] Add images/visuals
- [ ] Schedule publication
```

## Templates

### Newsletter Hook Formulas

**Spanish:**
- "Esta semana [algo sorprendente] pasó..."
- "[Número impactante]. Así es, leíste bien."
- "Lo que hace 6 meses parecía ciencia ficción..."

**English:**
- "This week changed everything..."
- "[Surprising stat]. Here's what it means."
- "What seemed impossible 6 months ago..."

### Thread Hook Formulas

**Spanish:**
- "🧵 [Tema] - Lo que necesitas saber:"
- "[Afirmación bold]. Te explico:"
- "Pasé [tiempo] investigando [tema]. Resultados:"

### Video Hook Formulas

- "[Número impactante]..." (show visual)
- "Una IA hizo [cosa sorprendente]..."
- "Esto cambia todo sobre [tema]..."

## Example

```bash
/newsletter "GPT-5.2 vs Claude Opus comparison" --newsletter-name "Indie Mind" --lang es
```

Outputs:
- `newsletter-2026-01-20-gpt52-vs-claude.md`
- `thread-2026-01-20-gpt52-vs-claude.md`
- `carousel-2026-01-20-gpt52-vs-claude.md`
- `linkedin-2026-01-20-gpt52-vs-claude.md`
- `video-2026-01-20-gpt52-vs-claude.md`

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| No search results | Topic too specific or recent | Broaden search terms or use manual research |
| Stop-slop score <35 | Too many AI patterns | Revise using stop-slop guidelines |
| Output too long | Exceeded format limits | Split into multiple pieces or trim |
| Missing research | No source file found | Run research phase first |

**Fallback**: If automated pipeline fails, manually follow the 7-phase process using individual tools.

## Related Skills

- `/content` - Single-format content creation
- `/learn` - Extract knowledge from sources
- `stop-slop` - Writing quality checker (integrated)

## Publication Schedule Template

| Day | Content | Platform | Time (LATAM) |
|-----|---------|----------|--------------|
| Mon | Newsletter | Substack/Email | 8:00 AM |
| Tue | Thread | Twitter/X | 9:00 AM |
| Wed | Post | LinkedIn | 8:00 AM |
| Thu | Carousel | LinkedIn | 5:00 PM |
| Fri | Video | TikTok/Reels | 12:00 PM |
