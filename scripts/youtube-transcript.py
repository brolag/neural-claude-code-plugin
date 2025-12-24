#!/usr/bin/env python3
"""
YouTube Transcript Extractor
Extracts transcripts from YouTube videos for learning purposes.

Usage:
    python3 youtube-transcript.py <youtube-url-or-id>

Returns JSON with:
    - success: boolean
    - video_id: extracted ID
    - transcript: full text
    - segments: array with timestamps
    - error: error message (if failed)
"""

import sys
import json
import re


def extract_video_id(url):
    """Extract video ID from various YouTube URL formats."""
    patterns = [
        r'(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})',
        r'^([a-zA-Z0-9_-]{11})$'  # Direct video ID
    ]

    for pattern in patterns:
        match = re.search(pattern, url)
        if match:
            return match.group(1)
    return None


def get_transcript(video_id):
    """Get transcript for a YouTube video."""
    try:
        from youtube_transcript_api import YouTubeTranscriptApi
    except ImportError:
        print("Installing youtube-transcript-api...", file=sys.stderr)
        import subprocess
        subprocess.check_call([sys.executable, "-m", "pip", "install", "youtube-transcript-api", "-q"])
        from youtube_transcript_api import YouTubeTranscriptApi

    try:
        # Create API instance
        ytt_api = YouTubeTranscriptApi()

        # Try to get transcript in preferred languages
        transcript = ytt_api.fetch(video_id, languages=['en', 'es', 'pt', 'de', 'fr', 'it'])

        # Format transcript
        full_text = ""
        segments = []
        for entry in transcript:
            full_text += entry.text + " "
            segments.append({"start": entry.start, "text": entry.text})

        return {
            "success": True,
            "video_id": video_id,
            "language": transcript.language_code if hasattr(transcript, 'language_code') else 'unknown',
            "transcript": full_text.strip(),
            "segments": segments
        }

    except Exception as e:
        return {
            "success": False,
            "video_id": video_id,
            "error": str(e)
        }


def main():
    if len(sys.argv) < 2:
        print(json.dumps({"success": False, "error": "Usage: youtube-transcript.py <youtube-url-or-id>"}))
        sys.exit(1)

    url = sys.argv[1]
    video_id = extract_video_id(url)

    if not video_id:
        print(json.dumps({"success": False, "error": f"Could not extract video ID from: {url}"}))
        sys.exit(1)

    result = get_transcript(video_id)
    print(json.dumps(result, ensure_ascii=False))


if __name__ == "__main__":
    main()
