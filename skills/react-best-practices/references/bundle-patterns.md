# Bundle Patterns - Size Optimization

## Avoid Barrel File Imports

**Impact**: 15-70% faster dev boot, 28% faster builds, 40% faster cold starts

### The Problem

Barrel files re-export multiple modules from a single `index.js`:

```typescript
// node_modules/lucide-react/index.js (barrel file)
export { Check } from './icons/check'
export { X } from './icons/x'
// ... 1,581 more exports
```

When bundler marks library as external, it can't tree-shake:

```tsx
// This innocent import...
import { Check } from 'lucide-react'

// ...loads ALL 1,583 modules (~2.8s extra)
```

### Solution 1: Direct File Imports

```tsx
// BAD: Barrel import
import { Check, X, Search } from 'lucide-react'
import { Button, TextField } from '@mui/material'

// GOOD: Direct imports
import Check from 'lucide-react/dist/esm/icons/check'
import X from 'lucide-react/dist/esm/icons/x'
import Search from 'lucide-react/dist/esm/icons/search'
import Button from '@mui/material/Button'
import TextField from '@mui/material/TextField'
```

### Solution 2: Next.js optimizePackageImports

```js
// next.config.js
module.exports = {
  experimental: {
    optimizePackageImports: [
      'lucide-react',
      '@mui/material',
      '@mui/icons-material',
      'lodash',
      'date-fns',
      'rxjs',
      'react-use'
    ]
  }
}
```

### Commonly Affected Libraries

| Library | Barrel Modules |
|---------|---------------|
| lucide-react | 1,583 |
| @mui/material | 2,225 |
| @mui/icons-material | 5,000+ |
| lodash | 600+ |
| date-fns | 200+ |
| react-icons | 40,000+ |

## Dynamic Imports for Heavy Components

**Impact**: Reduces initial bundle, improves TTI and LCP

```tsx
// BAD: Synchronous import (adds ~300KB to main chunk)
import { MonacoEditor } from './monaco-editor'

function CodePanel({ code }: { code: string }) {
  return <MonacoEditor value={code} />
}

// GOOD: Dynamic import (loads on demand)
import dynamic from 'next/dynamic'

const MonacoEditor = dynamic(
  () => import('./monaco-editor').then(m => m.MonacoEditor),
  {
    ssr: false,
    loading: () => <CodeSkeleton />
  }
)

function CodePanel({ code }: { code: string }) {
  return <MonacoEditor value={code} />
}
```

### Good Candidates for Dynamic Import

- Code editors (Monaco, CodeMirror)
- Rich text editors (TipTap, Slate)
- Chart libraries (Chart.js, D3)
- PDF viewers
- Map components
- Admin-only features
- Below-the-fold content

## Conditional Module Loading

```tsx
// Load polyfills only when needed
if (!window.IntersectionObserver) {
  await import('intersection-observer')
}

// Load features based on user
const AdminPanel = user.isAdmin
  ? dynamic(() => import('./AdminPanel'))
  : null
```

## Preload Based on User Intent

```tsx
import { useRouter } from 'next/router'

function ProductCard({ product }) {
  const router = useRouter()

  // Preload on hover
  const handleMouseEnter = () => {
    router.prefetch(`/product/${product.id}`)
  }

  return (
    <div onMouseEnter={handleMouseEnter}>
      {/* ... */}
    </div>
  )
}
```

---
Tags: #bundle #optimization #imports #dynamic
