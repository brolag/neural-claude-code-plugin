# Server Patterns - Server-Side Performance

## React.cache() for Per-Request Deduplication

**Impact**: High - eliminates redundant DB queries within a request

```typescript
import { cache } from 'react'

// Wrap expensive operations
export const getCurrentUser = cache(async () => {
  const session = await auth()
  if (!session?.user?.id) return null

  return await db.user.findUnique({
    where: { id: session.user.id },
    include: { preferences: true }
  })
})

// In any component - calls deduplicated automatically
async function Header() {
  const user = await getCurrentUser()  // Query 1
  return <nav>{user?.name}</nav>
}

async function Sidebar() {
  const user = await getCurrentUser()  // Reuses Query 1
  return <aside>{user?.preferences.theme}</aside>
}
```

### Best Use Cases

- Authentication checks
- User profile fetching
- Permission verification
- Frequently accessed data within a request

## LRU Cache for Cross-Request Caching

For data shared across multiple requests:

```typescript
import LRU from 'lru-cache'

const cache = new LRU<string, any>({
  max: 500,
  ttl: 1000 * 60 * 5  // 5 minutes
})

export async function getCachedProduct(id: string) {
  const cached = cache.get(id)
  if (cached) return cached

  const product = await db.product.findUnique({ where: { id } })
  cache.set(id, product)
  return product
}
```

## Minimize Serialization at RSC Boundaries

**Problem**: Data passed from Server to Client Components gets serialized

```tsx
// BAD: Serializes entire user object
async function Page() {
  const user = await getUser()  // { id, name, email, preferences, history, ... }
  return <ClientComponent user={user} />  // All fields serialized
}

// GOOD: Pass only needed fields
async function Page() {
  const user = await getUser()
  return (
    <ClientComponent
      userName={user.name}
      userTheme={user.preferences.theme}
    />
  )
}
```

## Parallelize Data Fetching with Component Composition

```tsx
// BAD: Sequential in parent
async function Page() {
  const user = await getUser()
  const posts = await getPosts()  // Waits for user
  const comments = await getComments()  // Waits for posts

  return (
    <div>
      <UserCard user={user} />
      <PostList posts={posts} />
      <CommentList comments={comments} />
    </div>
  )
}

// GOOD: Parallel via component composition
function Page() {
  return (
    <div>
      <Suspense fallback={<UserSkeleton />}>
        <UserSection />  {/* Fetches user */}
      </Suspense>
      <Suspense fallback={<PostsSkeleton />}>
        <PostsSection />  {/* Fetches posts */}
      </Suspense>
      <Suspense fallback={<CommentsSkeleton />}>
        <CommentsSection />  {/* Fetches comments */}
      </Suspense>
    </div>
  )
}

// Each section fetches independently and streams when ready
async function UserSection() {
  const user = await getUser()
  return <UserCard user={user} />
}
```

## Server Actions Best Practices

```typescript
'use server'

export async function updateProfile(formData: FormData) {
  // Validate early
  const name = formData.get('name')
  if (!name || typeof name !== 'string') {
    return { error: 'Invalid name' }
  }

  // Use cache for auth check
  const user = await getCurrentUser()
  if (!user) {
    return { error: 'Unauthorized' }
  }

  // Perform update
  await db.user.update({
    where: { id: user.id },
    data: { name }
  })

  // Revalidate related paths
  revalidatePath('/profile')

  return { success: true }
}
```

---
Tags: #server #rsc #cache #performance
