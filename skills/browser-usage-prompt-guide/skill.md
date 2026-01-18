---
name: browser-usage-prompt-guide
description: Guide for creating browser usage prompts - specialized prompts for automating websites using Claude Chrome extension. Use when designing automation workflows, creating website-specific skills, or structuring browser interaction instructions.
trigger: /browser-prompt-guide
---

# Browser Usage Prompt Guide

A comprehensive guide for creating specialized prompts that automate browser interactions using the Claude Chrome extension.

## What Are Browser Usage Prompts?

Browser usage prompts are structured instructions that:
1. **Define the website structure** - DOM elements, navigation patterns, content layout
2. **Specify interaction sequences** - Clicks, forms, scrolling, waiting
3. **Handle dynamic content** - JavaScript-rendered elements, lazy loading
4. **Extract and process data** - Screenshots, text, network requests

## Prerequisites

- Claude Code version 2.0.73+
- Claude Chrome extension version 1.0.36+
- Run Claude with `claude --chrome` or enable via `/chrome`

## MCP Tool Reference

The `claude-in-chrome` MCP provides 26 tools across 6 categories:

### Input Automation (7 tools)
| Tool | Purpose | Parameters |
|------|---------|------------|
| `click` | Click elements | selector, button, clickCount |
| `drag` | Drag and drop | startSelector, endSelector |
| `fill` | Fill input fields | selector, value |
| `fill_form` | Fill entire forms | formData (object) |
| `handle_dialog` | Handle alerts/confirms | accept, promptText |
| `hover` | Hover over elements | selector |
| `upload_file` | Upload files | selector, filePath |

### Navigation (7 tools)
| Tool | Purpose | Parameters |
|------|---------|------------|
| `navigate_page` | Go to URL | url, tabId |
| `new_page` | Open new tab | url |
| `list_pages` | Get all tabs | - |
| `select_page` | Switch tabs | tabId |
| `close_page` | Close tab | tabId |
| `navigate_page_history` | Back/forward | direction |
| `wait_for` | Wait for element | selector, timeout |

### Debugging (4 tools)
| Tool | Purpose | Parameters |
|------|---------|------------|
| `evaluate_script` | Run JavaScript | script |
| `list_console_messages` | Read console | - |
| `take_screenshot` | Capture screen | fullPage, selector |
| `take_snapshot` | DOM snapshot | - |

### Network (2 tools)
| Tool | Purpose | Parameters |
|------|---------|------------|
| `list_network_requests` | View requests | filter |
| `get_network_request` | Request details | requestId |

### Performance (3 tools)
| Tool | Purpose | Parameters |
|------|---------|------------|
| `performance_start_trace` | Begin tracing | - |
| `performance_stop_trace` | End tracing | - |
| `performance_analyze_insight` | Get insights | - |

### Emulation (3 tools)
| Tool | Purpose | Parameters |
|------|---------|------------|
| `emulate_cpu` | Throttle CPU | slowdownFactor |
| `emulate_network` | Simulate network | preset |
| `resize_page` | Change viewport | width, height |

## Browser Usage Prompt Template

```yaml
---
name: {website}-automation
description: Automate {task} on {website}. Use when user wants to {use cases}.
trigger: /{command}
---

# {Website} Automation Skill

{Brief description of what this automation does}

## Target Website

**URL Pattern**: `{domain.com/path/*}`
**Authentication**: {Required/Optional/None}
**JavaScript Required**: {Yes/No}

## Website Structure

### Key Pages
| Page | URL Pattern | Purpose |
|------|-------------|---------|
| {Page 1} | `/path1` | {Description} |
| {Page 2} | `/path2` | {Description} |

### Critical Selectors
```css
/* Main content */
.content-container
article.main-content

/* Navigation */
nav.primary-nav
button.menu-toggle

/* Forms */
form#login-form
input[name="username"]
input[name="password"]
button[type="submit"]

/* Dynamic elements */
[data-testid="load-more"]
.infinite-scroll-trigger
```

### Common Modal/Overlay Patterns
```css
/* Cookie consent */
.cookie-banner
button.accept-cookies

/* Popups */
.modal-overlay
button.close-modal
```

## Process

### Phase 1: Initialize Browser Context
```
1. Get browser context (createIfEmpty: true)
2. Navigate to target URL
3. Wait for page load (2-3 seconds)
4. Handle any blocking elements (cookies, modals)
```

### Phase 2: Authentication (if required)
```
1. Check if already logged in (look for user indicators)
2. If not, navigate to login page
3. Fill credentials (or prompt user)
4. Handle 2FA if present
5. Wait for redirect to authenticated page
```

### Phase 3: Navigate to Target
```
1. Navigate to specific section/page
2. Wait for content to load
3. Handle any intermediary dialogs
```

### Phase 4: Perform Actions
```
1. {Action 1 - e.g., click button}
2. {Action 2 - e.g., fill form}
3. {Action 3 - e.g., scroll for content}
4. Wait between actions (avoid rate limiting)
```

### Phase 5: Extract/Capture
```
1. Take screenshot(s)
2. Extract text content
3. Capture network data if needed
4. Save artifacts
```

## MCP Tool Invocations

### Standard Flow
```javascript
// 1. Get context
mcp__claude-in-chrome__tabs_context_mcp({ createIfEmpty: true })

// 2. Navigate
mcp__claude-in-chrome__navigate_page({ url: "https://...", tabId: TAB_ID })

// 3. Wait for element
mcp__claude-in-chrome__wait_for({ selector: ".content", timeout: 5000 })

// 4. Interact
mcp__claude-in-chrome__click({ selector: "button.action" })
mcp__claude-in-chrome__fill({ selector: "input.search", value: "query" })

// 5. Scroll for dynamic content
mcp__claude-in-chrome__evaluate_script({
  script: "window.scrollBy(0, window.innerHeight)"
})

// 6. Capture
mcp__claude-in-chrome__take_screenshot({ fullPage: true })
```

## Handling Edge Cases

### Rate Limiting
```
- Add delays between actions (1-3 seconds)
- Limit requests per minute
- Back off exponentially on errors
```

### Dynamic Content
```
- Use wait_for before interacting
- Scroll incrementally, waiting for content
- Check for loading indicators
```

### Authentication Walls
```
- Detect login pages
- Pause and request user intervention
- Handle session expiration mid-flow
```

### Popups and Modals
```
- Dismiss cookie banners first
- Close promotional modals
- Handle confirmation dialogs
```

## Output Format

### Captured Data
```markdown
# {Website} Capture: {Topic}

**Source**: {URL}
**Captured**: {timestamp}
**Status**: {success/partial/failed}

## Content
{Extracted content}

## Screenshots
![Screenshot 1](path/to/screenshot1.png)

## Notes
{Any issues or observations}
```

### Storage Location
| Type | Path |
|------|------|
| Screenshots | `inbox/screenshots/{website}/` |
| Data files | `inbox/{website}-{date}.md` |
| Logs | `.claude/logs/browser/` |

## Quality Criteria

- [ ] All target elements successfully found
- [ ] No uncaught errors in console
- [ ] Content fully loaded before capture
- [ ] Authentication state preserved
- [ ] Rate limits respected
- [ ] Artifacts saved with proper naming

## Example Usage

```bash
# Basic usage
/{command} {arguments}

# With options
/{command} {url} --screenshot --full-page

# Multiple items
/{command} {url1} {url2} {url3}
```
```

## Creating Your Own Browser Usage Prompt

### Step 1: Analyze the Target Website

1. **Manual exploration**: Navigate the site, identify key pages
2. **Inspect elements**: Find reliable CSS selectors
3. **Watch network**: Understand API calls and data loading
4. **Test authentication**: Understand login flow
5. **Identify blockers**: Cookies, modals, CAPTCHAs

### Step 2: Document the Structure

Create a map of:
- URL patterns for different pages
- CSS selectors for key elements
- Authentication requirements
- Dynamic content loading patterns
- Common blocking elements

### Step 3: Define the Workflow

Break down into phases:
1. **Setup** - Browser context, navigation
2. **Auth** - Login if needed
3. **Navigate** - Get to target content
4. **Interact** - Perform required actions
5. **Extract** - Capture data/screenshots
6. **Save** - Store artifacts properly

### Step 4: Handle Edge Cases

Document solutions for:
- Content not loading
- Elements not found
- Authentication failures
- Rate limiting
- Network errors

### Step 5: Test and Iterate

- Run the full workflow manually first
- Test with different input variations
- Verify error handling works
- Optimize wait times

## Best Practices

### Selector Strategies
```css
/* Prefer (stable) */
[data-testid="element"]
[aria-label="Submit"]
#unique-id

/* Avoid (fragile) */
.class-name-v2
div > div > div > span
.generated-class-abc123
```

### Wait Strategies
```javascript
// Explicit waits (preferred)
wait_for({ selector: ".content-loaded" })

// Fixed delays (fallback)
// Use sparingly, prefer element-based waits
```

### Error Recovery
```
1. Retry failed actions (max 3 times)
2. Take diagnostic screenshot on failure
3. Log console errors
4. Provide clear error messages
5. Save partial results when possible
```

## Usage

```bash
# Get guidance on creating a browser automation prompt
/browser-prompt-guide

# Create a prompt for a specific website
/browser-prompt-guide "twitter.com profile scraping"

# Review an existing browser skill
/browser-prompt-guide --review .claude/skills/x-learner/skill.md
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Element not found | Selector changed or dynamic | Use more stable selectors (data-testid, aria-label) |
| Timeout waiting | Content slow to load | Increase timeout, add explicit waits |
| Auth required | Session expired | Prompt user to login manually |
| Rate limited | Too many requests | Add delays between actions |
| Modal blocking | Popup/cookie banner | Dismiss blockers before main actions |

**Fallback**: If browser automation fails completely, fall back to WebFetch for basic HTML content extraction where possible.

## Related Resources

- [Claude Chrome Extension Docs](https://code.claude.com/docs/en/chrome)
- [Chrome DevTools MCP](https://github.com/anthropics/claude-code-browser-mcp)
- Existing skills: `/x-learn`, `/gh-learn`, `/learn`
