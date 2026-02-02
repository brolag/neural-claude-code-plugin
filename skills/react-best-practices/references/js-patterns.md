# JavaScript Patterns - Micro-Optimizations

## Batch DOM CSS Changes

```typescript
// BAD: Multiple style changes trigger multiple reflows
element.style.width = '100px'
element.style.height = '200px'
element.style.margin = '10px'

// GOOD: Single reflow via class
element.className = 'new-style'

// GOOD: Single reflow via cssText
element.style.cssText = 'width: 100px; height: 200px; margin: 10px;'
```

## Build Index Maps for Repeated Lookups

```typescript
// BAD: O(n) lookup on every iteration
users.forEach(user => {
  const department = departments.find(d => d.id === user.departmentId)
  // ...
})

// GOOD: O(1) lookup after one-time index build
const deptById = new Map(departments.map(d => [d.id, d]))

users.forEach(user => {
  const department = deptById.get(user.departmentId)
  // ...
})
```

## Cache Property Access in Loops

```typescript
// BAD: Property access on each iteration
for (let i = 0; i < array.length; i++) {
  console.log(array[i])
}

// GOOD: Cache length
for (let i = 0, len = array.length; i < len; i++) {
  console.log(array[i])
}

// BETTER: Use for...of when index not needed
for (const item of array) {
  console.log(item)
}
```

## Use toSorted() for Immutability

```typescript
// BAD: Mutates original array
const sorted = items.sort((a, b) => a.price - b.price)
// items is now mutated!

// GOOD: Returns new array (ES2023+)
const sorted = items.toSorted((a, b) => a.price - b.price)
// items unchanged

// Also: toReversed(), toSpliced(), with()
```

## Use Set/Map for O(1) Lookups

```typescript
// BAD: O(n) array search
const selectedIds = [1, 2, 3, 4, 5]
items.filter(item => selectedIds.includes(item.id))  // O(n*m)

// GOOD: O(1) Set lookup
const selectedSet = new Set([1, 2, 3, 4, 5])
items.filter(item => selectedSet.has(item.id))  // O(n)
```

## Hoist RegExp Creation

```typescript
// BAD: Creates new RegExp on each call
function validate(input: string) {
  const pattern = /^[a-z]+$/i  // Created every call
  return pattern.test(input)
}

// GOOD: Create once, reuse
const ALPHA_PATTERN = /^[a-z]+$/i

function validate(input: string) {
  return ALPHA_PATTERN.test(input)
}
```

## Single-Pass Min/Max (Avoid Sorting)

```typescript
// BAD: O(n log n) for min/max
const sorted = items.toSorted((a, b) => a.value - b.value)
const min = sorted[0]
const max = sorted[sorted.length - 1]

// GOOD: O(n) single pass
let min = items[0], max = items[0]
for (const item of items) {
  if (item.value < min.value) min = item
  if (item.value > max.value) max = item
}

// GOOD: Using Math.min/max for numbers
const values = items.map(i => i.value)
const min = Math.min(...values)
const max = Math.max(...values)
```

## Early Length Check

```typescript
// BAD: Iterates even when lengths differ
function arraysEqual(a: any[], b: any[]) {
  return a.every((item, i) => item === b[i])
}

// GOOD: Early exit on length mismatch
function arraysEqual(a: any[], b: any[]) {
  if (a.length !== b.length) return false
  return a.every((item, i) => item === b[i])
}
```

## Combine Iterations

```typescript
// BAD: Three passes through array
const doubled = items.map(x => x * 2)
const filtered = doubled.filter(x => x > 10)
const sum = filtered.reduce((a, b) => a + b, 0)

// GOOD: Single pass
const sum = items.reduce((acc, x) => {
  const doubled = x * 2
  return doubled > 10 ? acc + doubled : acc
}, 0)
```

## Cache Storage Access

```typescript
// BAD: Multiple localStorage reads
function getSettings() {
  const theme = localStorage.getItem('theme')
  const locale = localStorage.getItem('locale')
  const fontSize = localStorage.getItem('fontSize')
  // Each is a synchronous I/O operation
}

// GOOD: Single read, cache in memory
let settingsCache: Settings | null = null

function getSettings() {
  if (!settingsCache) {
    settingsCache = JSON.parse(localStorage.getItem('settings') || '{}')
  }
  return settingsCache
}
```

---
Tags: #javascript #performance #optimization #patterns
