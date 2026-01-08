# Loop Coverage

Specialized Neural Loop for improving test coverage.

Based on Ralph Wiggum's "Test Coverage Loop" pattern.

## Usage

```
/loop-coverage [--target <percentage>] [--max <n>]
```

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `--target <n>` | 80 | Target coverage percentage |
| `--max <n>` | 30 | Maximum iterations |

## Examples

```bash
# Default: reach 80% coverage
/loop-coverage

# Custom target
/loop-coverage --target 95 --max 50

# Quick coverage boost
/loop-coverage --target 60 --max 10
```

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                 COVERAGE LOOP                                │
├─────────────────────────────────────────────────────────────┤
│  1. Run coverage report (npm run coverage / pytest --cov)   │
│  2. Parse uncovered lines                                    │
│  3. Pick MOST CRITICAL uncovered code path                   │
│  4. Write test for that specific path                        │
│  5. Run tests to verify                                      │
│  6. Update progress.txt with coverage delta                  │
│  7. Check if target reached → LOOP_COMPLETE                  │
│  8. Repeat until target or max iterations                    │
└─────────────────────────────────────────────────────────────┘
```

## Best Practices

1. **Critical paths first** - Don't test getters/setters, test business logic
2. **One test per iteration** - Small steps, frequent feedback
3. **Skip internal/private** - Focus on user-facing code
4. **Set realistic targets** - 100% is often not worth the effort

## Related

- `/loop-start` - General purpose loop
- `/loop-lint` - Linting cleanup loop
- `/loop-entropy` - Code smell cleanup
