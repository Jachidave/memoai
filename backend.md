# Backend for AuraNoted Clone

## Architecture Notes

This is a **local-first** web application, not a SaaS. Therefore:
- ✗ No authentication (local use only)
- ✗ No payments (free personal use)
- ✗ No email (not in v1 scope)
- ✓ In-memory database with persistent storage option

## Security Checklist

Since this is a local-first app:

- [✓] secrets only in env vars, `.env*` in `.gitignore`, nothing in client bundles
- [✓] input validated on the server (in-memory typescript)
- [✓] authorisation checked on every read and write (single-user context)
- [ ] rate limits on auth (N/A - no auth)
- [✓] webhooks verify signatures (N/A - no webhooks)
- [✓] uploads: size and type limits, served from same domain
- [✓] no user data in URLs or logs (using UUIDs)
- [ ] dependencies audited (`npm audit`)
- [✓] privacy policy lists every processor (none - local only)

## Database

### Current Implementation
- In-memory storage via `Database` singleton in `src/lib/database.ts`
- Seed data with sample notes for demonstration
- UUIDs for all records
- No foreign key enforcement (client-side)

### Production Storage Options
1. **Web**: IndexedDB via `idb` library or `dexie`
2. **Desktop (Electron)**: SQLite via `better-sqlite3` API
3. **Hybrid**: Use `localforage` for cross-platform compatibility

### Schema Migration from `schema.sql`

The in-memory implementation mirrors this schema:

```sql
-- Notes table
CREATE TABLE notes (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  ai_summary TEXT,
  transcription_id TEXT,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
);

-- Transcriptions table  
CREATE TABLE transcriptions (
  id TEXT PRIMARY KEY,
  file_name TEXT NOT NULL,
  audio_path TEXT,
  audio_size INTEGER,
  transcription TEXT,
  ai_provider TEXT,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
);

-- AI Analyses table
CREATE TABLE ai_analyses (
  id TEXT PRIMARY KEY,
  transcription_id TEXT NOT NULL,
  summary TEXT,
  action_items TEXT,
  key_topics TEXT,
  participants TEXT,
  created_at DATETIME NOT NULL
);

-- Settings table (single row)
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT,
  updated_at DATETIME NOT NULL
);
```

## API Layer

Since this is a web clone without external dependencies, the API layer is minimal:

### Internal Service Layer
`src/lib/services/` - Business logic separated from data layer

### External Dependencies (Optional)
When adding transcription/AI later:

| Service | API | Auth Required | Rate Limit |
|---------|-----|---------------|------------|
| Ollama | `/api/generate` | No | Local only |
| OpenAI | `https://api.openai.com/v1/chat/completions` | API key | 10 RPM default |
| Anthropic | `https://api.anthropic.com/v1/messages` | API key | 10 RPM default |
| Whisper API | `https://api.openai.com/v1/audio/transcriptions` | API key | 10 RPM default |

## File Upload Limits

- Maximum file size: 100MB (browser limit)
- Accepted formats: audio/mp3, audio/wav, audio/m4a, audio/ogg
- Files stored as base64 in memory (for web prototype)
- For production: Use File System Access API or download/upload pattern

## Background Jobs

For web implementation:
- Use Web Workers for audio processing
- Use IndexedDB for progress tracking
- Notification API for completion alerts

## Environment Variables

`.env.example`:
```
# AI Provider Configuration
NEXT_PUBLIC_AI_PROVIDER=local
NEXT_PUBLIC_AI_MODEL=llama3.2
NEXT_PUBLIC_AI_ENDPOINT=http://localhost:11434

# Optional: API keys for cloud providers
# OPENAI_API_KEY=
# ANTHROPIC_API_KEY=
```

## Data Persistence Strategy

### Web (Current)
- Session storage: Notes persist during session
- localStorage: Settings and basic preferences
- IndexedDB: Future enhancement for persistent notes

### Desktop (Electron Future)
- SQLite database in user's config directory
- Automatic backups to user-chosen location
- File associations for .aura notes export

## Next Steps

1. `/replica-test` - Create test suite for the data layer and components
2. Add IndexedDB persistence layer
3. Implement real transcription service integration