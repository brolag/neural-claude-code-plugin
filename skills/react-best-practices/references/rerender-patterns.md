# Re-render Patterns - Optimization

## Extract to Memoized Components

**Key insight**: Component extraction enables early returns BEFORE expensive work.

```tsx
// BAD: useMemo alone - computation runs during every render
function Avatar({ userId, isLoading }) {
  // computeAvatarId runs even when isLoading is true
  const avatarId = useMemo(() => computeAvatarId(userId), [userId])

  if (isLoading) return <Skeleton />
  return <img src={`/avatars/${avatarId}`} />
}

// GOOD: Component extraction - computation skipped entirely
function Parent({ userId, isLoading }) {
  // Early return before ANY expensive work
  if (isLoading) return <Skeleton />
  return <Avatar userId={userId} />
}

const Avatar = memo(({ userId }) => {
  // Only runs when actually needed
  const avatarId = computeAvatarId(userId)
  return <img src={`/avatars/${avatarId}`} />
})
```

## Defer State Reads to Usage Point

```tsx
// BAD: Reads store on every render
function Component() {
  const items = useStore(state => state.items)  // Re-renders on ANY items change
  const [filter, setFilter] = useState('')

  const filtered = items.filter(i => i.name.includes(filter))
  return <List items={filtered} />
}

// GOOD: Read where used with selector
function Component() {
  const [filter, setFilter] = useState('')

  // Only re-renders when filtered result changes
  const filtered = useStore(
    state => state.items.filter(i => i.name.includes(filter)),
    shallow  // Use shallow comparison
  )

  return <List items={filtered} />
}
```

## Lazy State Initialization

```tsx
// BAD: Expensive computation on every render
function Editor() {
  // parseDocument runs every time component renders
  const [doc, setDoc] = useState(parseDocument(initialContent))
  // ...
}

// GOOD: Lazy initialization - runs only once
function Editor() {
  // parseDocument only runs on initial mount
  const [doc, setDoc] = useState(() => parseDocument(initialContent))
  // ...
}
```

## Use startTransition for Non-Urgent Updates

```tsx
import { useState, useTransition } from 'react'

function SearchResults() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState([])
  const [isPending, startTransition] = useTransition()

  const handleChange = (e) => {
    // Urgent: Update input immediately
    setQuery(e.target.value)

    // Non-urgent: Can be interrupted
    startTransition(() => {
      setResults(filterResults(e.target.value))
    })
  }

  return (
    <>
      <input value={query} onChange={handleChange} />
      {isPending && <Spinner />}
      <ResultsList results={results} />
    </>
  )
}
```

## Narrow Effect Dependencies

```tsx
// BAD: Object in dependency causes infinite loop
function Component({ config }) {
  useEffect(() => {
    initializeWith(config)
  }, [config])  // New object every render!
}

// GOOD: Extract primitives
function Component({ config }) {
  const { theme, locale } = config

  useEffect(() => {
    initializeWith({ theme, locale })
  }, [theme, locale])  // Primitives are stable
}
```

## Subscribe to Derived State

```tsx
// BAD: Recomputes on any store change
function TotalPrice() {
  const items = useStore(state => state.items)
  const total = items.reduce((sum, i) => sum + i.price, 0)
  return <span>${total}</span>
}

// GOOD: Subscribe to derived value directly
function TotalPrice() {
  const total = useStore(
    state => state.items.reduce((sum, i) => sum + i.price, 0)
  )
  return <span>${total}</span>
}
```

## useMemo vs Component Extraction

| Scenario | Best Approach |
|----------|---------------|
| Expensive calculation, always needed | `useMemo` |
| Expensive render, conditionally shown | Component extraction |
| Avoiding prop drilling | Neither - use context |
| Reference equality for deps | `useMemo` or `useCallback` |

---
Tags: #rerender #memo #optimization #state
