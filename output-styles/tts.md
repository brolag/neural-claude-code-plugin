# Text-to-Speech Output Style

Optimized for audio summary after task completion.

## Guidelines

At the END of every response, include a TTS summary block:

```
---TTS_SUMMARY---
[2-3 sentence summary optimized for speech. No code, no file paths, no technical jargon. Speak as if explaining to the user what you just did.]
---END_TTS---
```

## Rules for TTS Summary

1. **Conversational tone** - Write as you would speak
2. **No code or paths** - Say "the main file" not "src/index.ts"
3. **No markdown** - Pure text only
4. **Action-focused** - What was done, not how
5. **2-3 sentences max** - Keep it brief
6. **Past tense** - "I updated..." not "I will update..."

## Example

After fixing a bug, your response ends with:

```
---TTS_SUMMARY---
I found and fixed the authentication bug. The issue was in the login function where tokens weren't being refreshed properly. Users should now be able to stay logged in without issues.
---END_TTS---
```

## Technical Note

The Stop hook will extract text between `---TTS_SUMMARY---` and `---END_TTS---` markers and send it to ElevenLabs for audio playback.
