---
name: react-best-practices
description: >
  React and Next.js performance optimization guidelines from Vercel Engineering.
  Use when writing, reviewing, or refactoring React/Next.js code.
  Triggers on: React components, Next.js pages, data fetching, bundle optimization,
  performance improvements, async patterns, re-render issues.
version: 1.0.0
source: Vercel Engineering (github.com/vercel-labs/agent-skills)
---

# React Best Practices

Comprehensive performance optimization guide for React and Next.js applications.
40+ rules across 8 priority categories.

## When to Apply

- Writing new React components or Next.js pages
- Implementing data fetching (client or server-side)
- Reviewing code for performance issues
- Refactoring existing React/Next.js code
- Optimizing bundle size or load times

## Priority Framework

| Priority | Category | Impact |
|----------|----------|--------|
| 1 | Eliminating Waterfalls | CRITICAL |
| 2 | Bundle Size Optimization | CRITICAL |
| 3 | Server-Side Performance | HIGH |
| 4 | Client-Side Data Fetching | MEDIUM-HIGH |
| 5 | Re-render Optimization | MEDIUM |
| 6 | Rendering Performance | MEDIUM |
| 7 | JavaScript Performance | LOW-MEDIUM |
| 8 | Advanced Patterns | LOW |

---

## CRITICAL: Eliminating Waterfalls

### Use Promise.all() for Independent Operations

**Impact**: 2-10x faster

```typescript
// BAD: Sequential (3 round trips)
const user = await fetchUser()
const posts = await fetchPosts()
const comments = await fetchComments()

// GOOD: Parallel (1 round trip)
const [user, posts, comments] = await Promise.all([
  fetchUser(),
  fetchPosts(),
  fetchComments()
])
```

### Defer await Until Needed

- Move `await` into branches where data is actually used
- Start promises early, await late
- Use `better-all` for partial dependencies

### Strategic Suspense Boundaries

- Wrap only data-dependent sections with Suspense
- Static UI (sidebar, header, footer) renders immediately
- Trade-off: Faster initial paint vs potential layout shift

See: [references/async-patterns.md](references/async-patterns.md)

---

## CRITICAL: Bundle Size Optimization

### Avoid Barrel File Imports

**Impact**: 15-70% faster dev boot, 28% faster builds

```tsx
// BAD: Loads 1,583 modules
import { Check } from 'lucide-react'

// GOOD: Direct import
import Check from 'lucide-react/dist/esm/icons/check'
```

**Or use Next.js 13.5+ config:**
```js
// next.config.js
module.exports = {
  experimental: {
    optimizePackageImports: ['lucide-react', '@mui/material']
  }
}
```

**Commonly Affected Libraries:**
lucide-react, @mui/material, @mui/icons-material, @tabler/icons-react,
react-icons, @headlessui/react, @radix-ui/react-*, lodash, date-fns

### Dynamic Imports for Heavy Components

```tsx
import dynamic from 'next/dynamic'

const MonacoEditor = dynamic(
  () => import('./monaco-editor').then(m => m.MonacoEditor),
  { ssr: false }
)
```

See: [references/bundle-patterns.md](references/bundle-patterns.md)

---

## HIGH: Server-Side Performance

### React.cache() for Request Deduplication

```typescript
import { cache } from 'react'

export const getCurrentUser = cache(async () => {
  const session = await auth()
  if (!session?.user?.id) return null
  return await db.user.findUnique({
    where: { id: session.user.id }
  })
})
// Multiple calls = single query execution
```

### Other Server Patterns

- Use LRU cache for cross-request caching
- Minimize serialization at RSC boundaries (pass only needed fields)
- Parallelize data fetching with component composition

See: [references/server-patterns.md](references/server-patterns.md)

---

## MEDIUM: Re-render Optimization

### Extract to Memoized Components

```tsx
// BAD: Computation runs during render even when loading
function Avatar({ userId, isLoading }) {
  const avatarId = useMemo(() => computeAvatarId(userId), [userId])
  if (isLoading) return <Skeleton />
  return <img src={`/avatars/${avatarId}`} />
}

// GOOD: Computation skipped entirely when loading
function Parent({ userId, isLoading }) {
  if (isLoading) return <Skeleton />
  return <Avatar userId={userId} />
}

const Avatar = memo(({ userId }) => {
  const avatarId = computeAvatarId(userId)
  return <img src={`/avatars/${avatarId}`} />
})
```

### Other Re-render Patterns

- Defer state reads to usage point
- Lazy state initialization for expensive values
- Use `startTransition` for non-urgent updates
- Narrow effect dependencies to primitives
- Subscribe to derived state

See: [references/rerender-patterns.md](references/rerender-patterns.md)

---

## MEDIUM: Rendering Performance

### Prevent Hydration Mismatch Without Flickering

```tsx
function ThemeWrapper({ children }: { children: ReactNode }) {
  return (
    <>
      <div id="theme-wrapper">{children}</div>
      <script
        dangerouslySetInnerHTML={{
          __html: `(function() {
            var theme = localStorage.getItem('theme') || 'light';
            var el = document.getElementById('theme-wrapper');
            if (el) el.className = theme;
          })();`,
        }}
      />
    </>
  )
}
```

### Other Rendering Patterns

- Animate wrapper divs, not SVG elements (hardware acceleration)
- Use `content-visibility: auto` for long lists
- Explicit conditional rendering (`? :` not `&&`)
- Reduce SVG precision (2 decimal places sufficient)

See: [references/rendering-patterns.md](references/rendering-patterns.md)

---

## LOW-MEDIUM: JavaScript Performance

Quick wins for micro-optimization:

- Batch DOM CSS changes via classes or `cssText`
- Build index maps for repeated lookups
- Cache property access in loops
- Use `toSorted()` instead of `sort()` for immutability
- Use Set/Map for O(1) lookups
- Hoist RegExp creation outside loops
- Early length check for array comparisons

See: [references/js-patterns.md](references/js-patterns.md)

---

## Quick Checklist

Before shipping React/Next.js code:

- [ ] Independent async ops using `Promise.all()`?
- [ ] No barrel file imports from large libraries?
- [ ] Heavy components using dynamic imports?
- [ ] Server queries deduplicated with `React.cache()`?
- [ ] Expensive computations in memoized components?
- [ ] Suspense boundaries around data-dependent sections?

## Usage

```bash
# This skill activates automatically when:
# - Writing React/Next.js components
# - Reviewing code with performance implications
# - Refactoring data fetching patterns

# To explicitly invoke:
# Just mention "React best practices" or "optimize this React code"

# Example prompts that trigger this skill:
# "Review this component for performance issues"
# "Optimize this data fetching code"
# "Is this the best way to handle re-renders?"
```

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Pattern not applicable | Code isn't React/Next.js | Use general JavaScript patterns instead |
| Breaking change | Pattern requires newer React | Note React version requirement |
| Server/client mismatch | Pattern is SSR-only or CSR-only | Check component rendering context |
| Bundle analyzer needed | Can't assess bundle impact | Run `npx @next/bundle-analyzer` |
| Complex dependency | Optimization requires refactor | Start with Quick Checklist items |

**Fallback**: If specific patterns don't apply, follow the Quick Checklist for universal improvements.

## References

- [references/async-patterns.md](references/async-patterns.md) - Waterfall elimination
- [references/bundle-patterns.md](references/bundle-patterns.md) - Bundle optimization
- [references/server-patterns.md](references/server-patterns.md) - Server-side patterns
- [references/rerender-patterns.md](references/rerender-patterns.md) - Re-render optimization
- [references/rendering-patterns.md](references/rendering-patterns.md) - DOM rendering
- [references/js-patterns.md](references/js-patterns.md) - JavaScript micro-optimizations

---
Tags: #react #nextjs #performance #optimization #vercel
