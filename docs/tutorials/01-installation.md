# Tutorial 1: Installation

*Time: 5 minutes*

Get Neural Claude Code running on your machine.

---

## Prerequisites

- [Claude Code CLI](https://claude.ai/download) installed
- Git
- macOS, Linux, or WSL

## Step 1: Clone the Plugin

```bash
git clone https://github.com/brolag/neural-claude-code-plugin ~/Sites/neural-claude-code-plugin
```

## Step 2: Run Setup

```bash
cd ~/Sites/neural-claude-code-plugin
chmod +x scripts/setup-hooks.sh
./scripts/setup-hooks.sh
```

This configures:
- Session hooks (start/stop tracking)
- TTS integration (optional)
- Status line (optional)

## Step 3: Add Environment Variable

Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
export CLAUDE_PLUGIN_ROOT="$HOME/Sites/neural-claude-code-plugin"
```

Then reload:

```bash
source ~/.zshrc  # or source ~/.bashrc
```

## Step 4: Verify Installation

```bash
claude --version
```

You should see Claude Code v2.1.x or later.

## Step 5: Test in a Project

```bash
cd ~/your-project
mkdir -p .claude/expertise
claude
```

If you see Claude start normally, you're ready!

---

## What's Next?

Now that Neural Claude Code is installed, let's teach it about your project:

**[Tutorial 2: Your First Expertise File →](02-first-expertise.md)**

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `claude: command not found` | Install Claude Code CLI first |
| Setup script fails | Check you have `jq` installed: `brew install jq` |
| Hooks don't fire | Verify `CLAUDE_PLUGIN_ROOT` is set correctly |

Need more help? [Open an issue](https://github.com/brolag/neural-claude-code-plugin/issues)
