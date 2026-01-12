# How to: Change Output Styles

Switch how Claude formats responses.

---

## Available Styles

| Style | Description | Use Case |
|-------|-------------|----------|
| `default` | Standard conversational | General use |
| `yaml` | Structured YAML format | Complex tasks, parsing |
| `table` | Markdown tables | Comparisons, data |
| `concise` | Minimal output | Quick answers |
| `tts` | With audio summary | Hands-free work |
| `html` | Generate HTML file | Documents, reports |
| `genui` | Rich generative UI | Interactive content |

---

## Switch Styles

```bash
/output-style yaml
```

Applies immediately to current session.

---

## YAML Style

Best for structured, parseable output:

```bash
/output-style yaml
```

Response format:
```yaml
task: analyze_code
findings:
  - type: bug
    file: src/utils.ts
    line: 42
    description: Null pointer exception
recommendations:
  - Add null check before access
```

---

## Table Style

Best for comparisons:

```bash
/output-style table
```

Response format:
| Option | Pros | Cons |
|--------|------|------|
| REST | Simple, cacheable | Overfetching |
| GraphQL | Flexible | Complexity |

---

## Concise Style

Minimal tokens, maximum signal:

```bash
/output-style concise
```

Response: Short, direct answers without explanation.

---

## TTS Style

Audio summary at end of responses:

```bash
/output-style tts
```

Requires ElevenLabs API key:
```bash
export ELEVENLABS_API_KEY="your-key"
```

---

## HTML Style

Generate and open HTML documents:

```bash
/output-style html
```

Creates HTML file and opens in browser.

---

## GenUI Style

Rich, styled interactive output:

```bash
/output-style genui
```

Best for visual content and reports.

---

## Reset to Default

```bash
/output-style default
```

---

## Related

- [Reference: Commands](../reference/commands.md) - All commands
