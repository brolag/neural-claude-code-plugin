# Tutorial 2: Your First Expertise File

*Time: 10 minutes*

Teach Claude about your project so it remembers context between sessions.

---

## What is Expertise?

Expertise files are YAML documents that store:
- **Understanding** - What Claude knows about your project
- **Patterns** - Coding conventions and workflows
- **Lessons** - Insights from past interactions
- **Preferences** - Your personal style choices

Without expertise, Claude forgets everything between sessions. With expertise, it gets smarter over time.

---

## Step 1: Create the Directory

```bash
cd ~/your-project
mkdir -p .claude/expertise
```

## Step 2: Create Your Expertise File

Create `.claude/expertise/project.yaml`:

```yaml
domain: my_project
version: 1
last_updated: 2026-01-12

understanding:
  project_type: "web-app"  # or: cli, library, api, etc.
  tech_stack:
    - typescript
    - react
    - nodejs
  structure:
    frontend: "src/"
    backend: "api/"
    tests: "__tests__/"

patterns:
  - "Use functional components with hooks"
  - "API routes follow REST conventions"
  - "Tests go in __tests__ folders"

lessons_learned: []

user_preferences: []
```

Customize this for your project!

## Step 3: Start Claude

```bash
claude
```

You should see Claude load your expertise at startup:

```
🧠 Loaded expertise: project (v1)
```

## Step 4: Verify It Works

Ask Claude:

```
What do you know about this project?
```

Claude should reference your expertise file's understanding section.

## Step 5: Let It Learn

As you work, Claude will suggest updates. When it says:

```
📝 LEARNING CHECKPOINT
Consider updating expertise with:
• Patterns: [new pattern discovered]
```

Run `/meta:improve project` to sync learnings.

---

## Tips

**Start simple** - Begin with basics, let it grow organically

**Be specific** - "Components use TypeScript strict mode" > "Uses TypeScript"

**Update regularly** - Run `/evolve` weekly to detect new patterns

---

## What's Next?

Your project now has a memory! Let's run autonomous coding sessions:

**[Tutorial 3: Your First Loop →](03-first-loop.md)**

---

## Example Expertise Files

### React App
```yaml
domain: react_dashboard
understanding:
  tech_stack: [react, typescript, tailwind, vite]
  key_files:
    - src/App.tsx
    - src/components/
patterns:
  - "Use Tailwind for styling, no CSS files"
  - "Components in PascalCase"
```

### Python API
```yaml
domain: fastapi_service
understanding:
  tech_stack: [python, fastapi, postgresql, docker]
  key_files:
    - app/main.py
    - app/routers/
patterns:
  - "Use Pydantic for validation"
  - "Async endpoints only"
```

### CLI Tool
```yaml
domain: my_cli
understanding:
  tech_stack: [rust, clap]
  key_files:
    - src/main.rs
    - src/commands/
patterns:
  - "Use clap derive macros"
  - "Error handling with anyhow"
```
