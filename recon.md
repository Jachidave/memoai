# Recon map: AuraNoted Meeting Notes App (Web)

Scope: AI-powered meeting notes with local/offline capabilities
For: Personal and small team use
Date: 2026-11-07

## Sources

| # | source | URL | notes |
| --- | --- | --- | --- |
| 1 | Project codebase | projects/AuraNoted/ | Full implementation with Electron, React, TypeScript |
| 2 | README.md | projects/AuraNoted/README.md | Feature list, tech stack, database schema |
| 3 | WELCOME.md | projects/AuraNoted/WELCOME.md | Current implementation status |
| 4 | package.json | projects/AuraNoted/package.json | Dependencies and scripts |

## Core loop

Upload meeting audio, transcribe it, generate AI-powered summary with action items, key topics, and participants, then save/share the notes.

## Screens

| ID | screen | route / how to reach | purpose | key components | states seen |
| --- | --- | --- | --- | --- | --- |
| S01 | Notes List | `/` | List all saved meeting notes | NoteList, header nav | empty (no notes), filled (notes list), loading |
| S02 | Audio Upload & Process | `/upload` | Upload audio file and process with AI | AudioUploader, file input, process button | empty (no file), file selected, processing, error |
| S03 | Note Editor | `/note/:id` | View/edit a generated meeting note | NoteEditor, preview | empty, filled, editing |
| S04 | New Note Editor | `/new` | Create a new note from scratch | NoteEditor | empty, filled, editing |
| S05 | AI Settings | Modal trigger → Settings | Configure AI provider (Ollama/OpenAI/Claude) | Settings form, provider selector | default, loading |

## Flows

```
F01 User processes a meeting recording
    S02 (upload) -> S02 (processing) -> S01 (back to notes)
    happy path clicks: 3 (select file -> process -> see result)
    edge: file type invalid, processing error, no Ollama running

F02 User views saved meeting notes
    S01 (notes list) -> S03 (note detail)
    happy path clicks: 1
    edge: no notes, note deleted by another session

F03 User creates a new note
    S01 (notes list) -> S04 (new note)
    happy path clicks: 1
    edge: empty content

F04 User changes AI provider
    S02 (upload) -> S05 (settings modal)
    happy path clicks: 2
    edge: invalid API key, missing model
```

## Components

| component | variants | states | used on |
| --- | --- | --- | --- |
| AudioUploader | primary | default, selected, processing, error | S02 |
| NoteList | - | empty, filled, loading | S01 |
| NoteEditor | view, edit | empty, filled, saving | S03, S04 |
| Header | - | default | S01, S02 |
| SettingsModal | - | default, loading, error | S05 |
| Button | primary, secondary, ghost | default, hover, focus, disabled, loading | all |
| Input | text, file, password | default, error, disabled | S02, S05 |
| Textarea | - | default, empty, error | S04 |

## Inferred data model

```
User
    id: uuid primary key
    ai_provider: JSON config for AI provider settings
    created_at: timestamptz
    evidence: App.tsx settings state, types/index.ts AIProvider type
    confidence: high

MeetingTranscription
    id: uuid primary key
    file_name: text not null
    audio_buffer: blob (for storage)
    transcription: text
    created_at: timestamptz
    evidence: types/index.ts, services/database.ts, components/AudioUploader.tsx
    confidence: high

AIAnalysis
    id: uuid primary key
    transcription_id: uuid references MeetingTranscription(id) on delete cascade
    summary: text
    action_items: json (array of strings)
    key_topics: json (array of strings)
    participants: json (array of strings)
    created_at: timestamptz
    evidence: types/index.ts AIAnalysis type, services/database.ts
    confidence: high

Note
    id: uuid primary key
    title: text
    content: text
    ai_summary: text nullable
    meeting_transcription_id: uuid nullable references MeetingTranscription(id) on delete set null
    created_at: timestamptz
    updated_at: timestamptz
    evidence: types/index.ts Note type, services/database.ts
    confidence: high
```

Relationships:
- User 1-n MeetingTranscription
- MeetingTranscription 1-1 AIAnalysis
- MeetingTranscription 1-n Notes
- AIAnalysis 1-n Notes (via meeting_transcription_id)

## Feature matrix

See `features.csv`. Must: 4, should: 3, could: 2, skip: 0.

## Out of scope (cannot or should not be cloned)

- Real-time collaborative editing
- Third-party transcription services integration (OpenAI Whisper, Google Speech-to-text)
- Marketplace of third-party apps
- Network effects or user accounts (local only)

## Size

Screens 5, flows 4, entities 4. Hard parts: audio processing, AI integration, local storage. Size: M (production-ready web app with local storage).