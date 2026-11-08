# Architecture: AuraNoted Meeting Notes App (a rebuild of AuraNoted's core features)

## Stack

| layer | choice | why |
| --- | --- | --- |
| web | Next.js (App Router) + TypeScript | Match AuraNoted's React foundation, add server actions for AI processing |
| database | SQLite via Prisma ORM | Local-first app, no network dependency, matches AuraNoted's better-sqlite3 |
| auth | None (local only) | AuraNoted is personal use, no user accounts needed |
| payments | N/A | Personal use, no monetization |
| email | N/A | No email notifications in current scope |
| jobs | Node.js cron | Background transcription and AI processing |
| hosting | Vercel (for web) or Electron (desktop) | Web-first approach, Electron for offline capability |

## Schema

Tables: 4. Access rules: data-layer checks (no RLS needed for single-user).

```sql
-- Users (optional, for future multi-user)
create table users (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now()
);

-- Meeting transcriptions
create table transcriptions (
  id uuid primary key default gen_random_uuid(),
  file_name text not null,
  audio_path text, -- path to stored audio file
  transcription text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- AI analysis results
create table ai_analyses (
  id uuid primary key default gen_random_uid(),
  transcription_id uuid references transcriptions(id) on delete cascade,
  summary text,
  action_items jsonb not null default '[]',
  key_topics jsonb not null default '[]',
  participants jsonb not null default '[]',
  created_at timestamptz not null default now()
);

-- Notes
create table notes (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  content text not null,
  ai_summary text,
  transcription_id uuid references transcriptions(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- AI provider settings (single row)
create table ai_settings (
  key text primary key,
  value jsonb not null,
  updated_at timestamptz not null default now()
);

-- Indexes
create index idx_transcriptions_created_at on transcriptions(created_at);
create index idx_notes_created_at on notes(created_at);
create index idx_notes_updated_at on notes(updated_at);
create index idx_ai_analyses_transcription_id on ai_analyses(transcription_id);
```

## API

| method path | does | who | input | output | flow |
| --- | --- | --- | --- | --- | --- |
| POST /api/transcriptions | Save audio file and metadata | Authenticated (or anonymous) | FormData with file | Transcription ID | F01 |
| POST /api/analyze | Trigger AI analysis | Authenticated | Transcription ID | AIAnalysis ID | F01 |
| POST /api/notes | Create/save a note | Authenticated | {title, content, ...} | Note ID | F02 |
| GET /api/notes | List all notes | Authenticated | - | Note[] | F02 |
| GET /api/notes/[id] | Get single note | Authenticated | ID | Note | F03 |
| PUT /api/notes/[id] | Update note | Authenticated | Partial<Note> | Updated Note | F03 |
| DELETE /api/notes/[id] | Delete note | Authenticated | - | Success | - |
| GET /api/settings/ai | Get AI provider settings | Authenticated | - | AIProvider config | - |
| PUT /api/settings/ai | Update AI provider settings | Authenticated | AIProvider config | Updated config | F04 |

Webhooks in: None
Webhooks out: None
Jobs: 
- `transcription-worker` - polls for audio files, triggers Whisper
- `ai-processing-worker` - processes transcriptions with Ollama/OpenAI

## The parts that bite

- time zones: Stored in UTC, displayed in local browser timezone
- idempotency: Transcription/analysis jobs must handle duplicate triggers
- races: Two users cannot book same time slot (not applicable - local app)
- file size limits: Audio files capped at 100MB
- offline: Web version requires network; Electron version works offline
- AI costs: API-based processing has per-token costs
- model latency: Ollama queries can take 5-30 seconds

## Build order

1. Vertical slice: Upload -> Process -> View Note (S02 -> S03)
   - Tables: transcriptions, ai_analyses, notes
   - Routes: /api/transcriptions, /api/analyze, /api/notes, GET /api/notes
2. Must-haves:
   - Audio file upload validation
   - AI provider configuration UI
   - Notes list view
   - Note editor
3. Should-haves:
   - Action items extraction
   - Key topics detection
   - Participants identification
   - Local storage persistence
4. Fixes from replica-entrepreneur:
   - Add error recovery for failed AI processing
   - Implement file size validation
   - Add progress indicators for long operations