---
description: Teleport Memory Bridge - Sync memory state between local CLI and cloud (claude.ai) sessions
allowed-tools: Read, Write, Bash
---

# Teleport Memory Bridge

Synchronize memory state when teleporting between local CLI and cloud (claude.ai) sessions. This enables hybrid execution: start locally, migrate to cloud for better web access, return with results.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    TELEPORT MEMORY BRIDGE                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  LOCAL CLI                              CLOUD (claude.ai)        │
│  ┌─────────────────┐                   ┌─────────────────┐      │
│  │ Memory Files    │                   │ No Filesystem   │      │
│  │ - facts/        │                   │ Better Web      │      │
│  │ - events/       │   /teleport       │ Cloud MCPs      │      │
│  │ - learnings/    │ ───────────────▶  │                 │      │
│  │ - active_context│                   │ + Memory Blob   │      │
│  └─────────────────┘                   └─────────────────┘      │
│                                                                  │
│  EXPORT: Pack memory into portable blob                          │
│  IMPORT: Unpack memory blob back to local                        │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Commands

### Export Memory for Teleport

```bash
/teleport-sync export
```

Packs local memory into a portable format for injection into cloud session.

**What's included:**
- Recent facts (last 7 days)
- Active context summary
- Relevant learnings index
- Current project state

**Output:** JSON blob copied to clipboard, ready for /remote-env

### Import Memory from Cloud

```bash
/teleport-sync import "<blob>"
```

Imports memory blob from a cloud session back to local.

### Status Check

```bash
/teleport-sync status
```

Shows current memory state and last sync info.

## Usage

```bash
# Before teleporting to cloud
/teleport-sync export

# (Teleport to cloud, do work)
# /teleport

# (In cloud: paste the exported blob into context)

# (Return from cloud with results)
# /teleport --return

# Import any new knowledge from cloud session
/teleport-sync import "{ ... blob from cloud ... }"

# Check sync status
/teleport-sync status
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Invalid blob format | Malformed JSON or wrong version | Verify blob is complete, check for truncation |
| Checksum mismatch | Blob corrupted during transfer | Re-export from source session |
| Merge conflict | Same fact modified in both sessions | Manual review prompted, newer timestamp wins by default |
| Context overflow | Too much memory to export | Use `--compact` flag for minimal export |
| Cloud session expired | Teleport session ended | Start new cloud session, re-import |

**Fallback**: If sync fails, memory state is preserved locally. Cloud changes can be manually copied from the cloud session output.

## Technical Details

### Size Limits

- Max blob size: 50KB (fits in most clipboard limits)
- Max facts: 20 most recent
- Context: 5KB max
- Learnings: 10 most relevant

### Merge Strategy

1. **Facts**: Newer timestamp wins
2. **Context**: Cloud context appends to local
3. **Learnings**: Union of both sets
