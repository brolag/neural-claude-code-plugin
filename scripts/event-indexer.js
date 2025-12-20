#!/usr/bin/env node
/**
 * Event Log Indexer
 * Analyzes JSONL event logs to detect patterns for /evolve command
 * Learning Loop Fix #3: Makes pattern detection actually work
 */

const fs = require('fs');
const path = require('path');

const MEMORY_DIR = path.join(process.cwd(), '.claude', 'memory');
const EVENTS_DIR = path.join(MEMORY_DIR, 'events');
const INDEX_FILE = path.join(MEMORY_DIR, 'pattern-index.json');

// ============================================
// EVENT PARSING
// ============================================

function parseEventLog(filePath) {
    if (!fs.existsSync(filePath)) return [];
    return fs.readFileSync(filePath, 'utf8')
        .trim().split('\n').filter(Boolean)
        .map(line => { try { return JSON.parse(line); } catch { return null; } })
        .filter(Boolean);
}

function loadAllEvents(daysBack = 30) {
    const events = [];
    const now = new Date();
    for (let i = 0; i < daysBack; i++) {
        const date = new Date(now);
        date.setDate(date.getDate() - i);
        const filePath = path.join(EVENTS_DIR, `${date.toISOString().split('T')[0]}.jsonl`);
        if (fs.existsSync(filePath)) events.push(...parseEventLog(filePath));
    }
    return events;
}

// ============================================
// PATTERN DETECTION
// ============================================

function extractToolSequences(events, n = 3) {
    const toolEvents = events.filter(e => e.tool_name);
    const ngrams = [];
    for (let i = 0; i <= toolEvents.length - n; i++) {
        ngrams.push(toolEvents.slice(i, i + n).map(e => e.tool_name).join(' → '));
    }
    return ngrams;
}

function detectPatterns(events, minOccurrences = 3) {
    const patterns = [];

    // 3-grams
    const trigrams = extractToolSequences(events, 3);
    const counts = {};
    trigrams.forEach(seq => counts[seq] = (counts[seq] || 0) + 1);

    for (const [pattern, count] of Object.entries(counts)) {
        if (count >= minOccurrences) {
            patterns.push({
                type: 'workflow',
                sequence: pattern,
                occurrences: count,
                confidence: Math.min(0.95, (count / trigrams.length) * 2 + 0.1),
                suggestion: `Consider creating a skill for: ${pattern}`
            });
        }
    }

    return patterns.sort((a, b) => b.confidence - a.confidence);
}

// ============================================
// INDEX GENERATION
// ============================================

function generateIndex(daysBack = 30) {
    console.log(`Analyzing events from last ${daysBack} days...`);
    const events = loadAllEvents(daysBack);
    console.log(`Loaded ${events.length} events`);

    const patterns = detectPatterns(events);
    const toolFrequency = {};
    events.filter(e => e.tool_name).forEach(e => {
        toolFrequency[e.tool_name] = (toolFrequency[e.tool_name] || 0) + 1;
    });

    const index = {
        generated_at: new Date().toISOString(),
        events_analyzed: events.length,
        patterns: patterns.slice(0, 20),
        tool_frequency: toolFrequency,
        recommendations: patterns.filter(p => p.confidence > 0.5).slice(0, 3).map(p => ({
            type: 'create_skill',
            priority: 'high',
            description: p.suggestion,
            confidence: p.confidence
        }))
    };

    fs.mkdirSync(MEMORY_DIR, { recursive: true });
    fs.writeFileSync(INDEX_FILE, JSON.stringify(index, null, 2));
    console.log(`Index written to ${INDEX_FILE}`);

    console.log('\nTop patterns:');
    patterns.slice(0, 5).forEach(p => {
        console.log(`  [${(p.confidence * 100).toFixed(0)}%] ${p.sequence} (${p.occurrences}x)`);
    });

    return index;
}

// CLI
const command = process.argv[2] || 'index';
if (command === 'index') generateIndex(parseInt(process.argv[3]) || 30);
else if (command === 'patterns' && fs.existsSync(INDEX_FILE)) {
    console.log(JSON.stringify(JSON.parse(fs.readFileSync(INDEX_FILE)).patterns, null, 2));
}
