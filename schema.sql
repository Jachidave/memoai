-- AuraNoted Meeting Notes App Schema
-- Generated for SQLite with Prisma-style migration

-- Enable foreign keys
PRAGMA foreign_keys = ON;

-- Users (optional, for future multi-user)
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY DEFAULT (hex(randomblob(16))),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Meeting transcriptions
CREATE TABLE IF NOT EXISTS transcriptions (
  id TEXT PRIMARY KEY DEFAULT (hex(randomblob(16))),
  file_name TEXT NOT NULL,
  audio_path TEXT, -- path to stored audio file
  audio_size INTEGER, -- file size in bytes
  transcription TEXT,
  ai_provider TEXT, -- which provider was used
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- AI analysis results
CREATE TABLE IF NOT EXISTS ai_analyses (
  id TEXT PRIMARY KEY DEFAULT (hex(randomblob(16))),
  transcription_id TEXT NOT NULL,
  summary TEXT,
  action_items TEXT, -- JSON array stored as TEXT in SQLite
  key_topics TEXT,
  participants TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (transcription_id) REFERENCES transcriptions(id) ON DELETE CASCADE
);

-- Notes
CREATE TABLE IF NOT EXISTS notes (
  id TEXT PRIMARY KEY DEFAULT (hex(randomblob(16))),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  ai_summary TEXT,
  transcription_id TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (transcription_id) REFERENCES transcriptions(id) ON DELETE SET NULL
);

-- AI provider settings (single row)
CREATE TABLE IF NOT EXISTS ai_settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL, -- JSON config stored as TEXT
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Insert default AI settings
INSERT OR IGNORE INTO ai_settings (key, value) VALUES ('provider', '{"name":"local","model":"llama3.2","endpoint":"http://localhost:11434"}');

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_transcriptions_created_at ON transcriptions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_transcriptions_file_name ON transcriptions(file_name);
CREATE INDEX IF NOT EXISTS idx_notes_created_at ON notes(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notes_updated_at ON notes(updated_at DESC);
CREATE INDEX IF NOT EXISTS idx_notes_title ON notes(title);
CREATE INDEX IF NOT EXISTS idx_ai_analyses_transcription_id ON ai_analyses(transcription_id);

-- Initial data
INSERT OR IGNORE INTO ai_settings (key, value) VALUES
  ('version', '1.0');