# Rendering Patterns - DOM Performance

## Prevent Hydration Mismatch Without Flickering

**Problem**: Client-only values (localStorage, window size) cause hydration errors or flicker.

```tsx
// BAD: Breaks SSR
function Theme() {
  // Error: localStorage is undefined on server
  const theme = localStorage.getItem('theme')
  return <div className={theme}>{children}</div>
}

// BAD: Causes flicker
function Theme() {
  const [theme, setTheme] = useState('light')

  useEffect(() => {
    setTheme(localStorage.getItem('theme') || 'light')
  }, [])
  // Flickers: renders light, then switches to dark

  return <div className={theme}>{children}</div>
}

// GOOD: Inline script runs before hydration
function ThemeWrapper({ children }: { children: ReactNode }) {
  return (
    <>
      <div id="theme-wrapper">{children}</div>
      <script
        dangerouslySetInnerHTML={{
          __html: `(function() {
            try {
              var theme = localStorage.getItem('theme') || 'light';
              var el = document.getElementById('theme-wrapper');
              if (el) el.className = theme;
            } catch (e) {}
          })();`,
        }}
      />
    </>
  )
}
```

## Animate Wrapper Divs, Not SVG Elements

**Problem**: Animating SVG elements directly prevents hardware acceleration.

```tsx
// BAD: SVG animation on CPU
function Icon({ isActive }) {
  return (
    <svg
      className={isActive ? 'scale-110' : 'scale-100'}
      style={{ transition: 'transform 0.2s' }}
    >
      <path d="..." />
    </svg>
  )
}

// GOOD: Wrapper div gets GPU acceleration
function Icon({ isActive }) {
  return (
    <div
      className={isActive ? 'scale-110' : 'scale-100'}
      style={{ transition: 'transform 0.2s' }}
    >
      <svg>
        <path d="..." />
      </svg>
    </div>
  )
}
```

## Use content-visibility for Long Lists

```tsx
// For long lists that extend below the fold
function LongList({ items }) {
  return (
    <ul>
      {items.map(item => (
        <li
          key={item.id}
          style={{
            contentVisibility: 'auto',
            containIntrinsicSize: '0 50px'  // Estimated height
          }}
        >
          <ExpensiveComponent data={item} />
        </li>
      ))}
    </ul>
  )
}
```

**Note**: Browser skips rendering off-screen items until they scroll into view.

## Explicit Conditional Rendering

```tsx
// BAD: && can render falsy values
function UserCount({ count }) {
  return <div>{count && <span>{count} users</span>}</div>
  // When count is 0, renders "0" instead of nothing!
}

// GOOD: Explicit ternary
function UserCount({ count }) {
  return <div>{count > 0 ? <span>{count} users</span> : null}</div>
}

// GOOD: Boolean coercion
function UserCount({ count }) {
  return <div>{!!count && <span>{count} users</span>}</div>
}
```

## Reduce SVG Precision

```tsx
// BAD: Excessive precision
<path d="M12.345678901234 24.567890123456..." />

// GOOD: 2 decimal places sufficient
<path d="M12.35 24.57..." />
```

Tip: Use SVGO to optimize SVGs automatically.

## Hoist Static JSX

```tsx
// BAD: Creates new element reference every render
function Component({ dynamic }) {
  return (
    <div>
      <header>Static Header</header>  {/* Recreated each render */}
      <main>{dynamic}</main>
    </div>
  )
}

// GOOD: Hoist static elements
const StaticHeader = <header>Static Header</header>

function Component({ dynamic }) {
  return (
    <div>
      {StaticHeader}  {/* Same reference */}
      <main>{dynamic}</main>
    </div>
  )
}
```

## Use React.Activity for Visibility (React 19+)

```tsx
import { Activity } from 'react'

function TabPanel({ isActive, children }) {
  return (
    <Activity mode={isActive ? 'visible' : 'hidden'}>
      {children}
    </Activity>
  )
}
// Hidden content preserves state but doesn't render
```

---
Tags: #rendering #dom #hydration #animation
