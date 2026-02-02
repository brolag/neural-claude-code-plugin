# Async Patterns - Eliminating Waterfalls

## Promise.all() for Independent Operations

**Impact**: 2-10x improvement

When async operations don't depend on each other's results, execute them simultaneously:

```typescript
// BAD: Sequential execution (3 round trips)
async function loadData() {
  const user = await fetchUser()      // Wait 200ms
  const posts = await fetchPosts()    // Wait 200ms
  const comments = await fetchComments() // Wait 200ms
  return { user, posts, comments }    // Total: 600ms
}

// GOOD: Parallel execution (1 round trip)
async function loadData() {
  const [user, posts, comments] = await Promise.all([
    fetchUser(),      // Start immediately
    fetchPosts(),     // Start immediately
    fetchComments()   // Start immediately
  ])
  return { user, posts, comments }  // Total: ~200ms
}
```

## Defer await Until Needed

Move `await` into branches where data is actually used:

```typescript
// BAD: Await blocks even when not needed
async function handleRequest(type: string) {
  const data = await fetchData()  // Always waits

  if (type === 'simple') {
    return { simple: true }  // Didn't need data!
  }
  return { data }
}

// GOOD: Await only when needed
async function handleRequest(type: string) {
  const dataPromise = fetchData()  // Start immediately

  if (type === 'simple') {
    return { simple: true }  // Skip await entirely
  }
  return { data: await dataPromise }  // Await only here
}
```

## Start Promises Early, Await Late

```typescript
// BAD: Late start
async function getProfile(userId: string) {
  const user = await getUser(userId)
  const friends = await getFriends(userId)  // Could have started earlier
  return { user, friends }
}

// GOOD: Early start, late await
async function getProfile(userId: string) {
  const userPromise = getUser(userId)
  const friendsPromise = getFriends(userId)  // Start both

  const user = await userPromise
  const friends = await friendsPromise
  return { user, friends }
}
```

## Dependency-Based Parallelization

Use `better-all` for complex dependencies:

```typescript
import { all } from 'better-all'

const results = await all({
  user: () => fetchUser(),
  posts: () => fetchPosts(),
  // comments depends on posts
  comments: ['posts', ({ posts }) => fetchComments(posts.map(p => p.id))]
})
```

## Strategic Suspense Boundaries

```tsx
// BAD: Entire page waits for data
async function Page() {
  const data = await fetchData()  // Blocks everything
  return (
    <Layout>
      <Sidebar />
      <DataDisplay data={data} />
      <Footer />
    </Layout>
  )
}

// GOOD: Only data section waits
function Page() {
  return (
    <Layout>
      <Sidebar />  {/* Renders immediately */}
      <Suspense fallback={<Loading />}>
        <DataSection />  {/* Streams when ready */}
      </Suspense>
      <Footer />  {/* Renders immediately */}
    </Layout>
  )
}

async function DataSection() {
  const data = await fetchData()
  return <DataDisplay data={data} />
}
```

### When NOT to Use Suspense

- Layout-critical data affecting element positioning
- Above-the-fold SEO-sensitive content
- Minimal queries where overhead doesn't justify benefits
- When layout shifts would harm UX

---
Tags: #async #performance #waterfall #suspense
