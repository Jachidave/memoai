# Test Plan - AuraNoted Clone

## Flow Coverage

| Flow ID | Flow Name | Status | Tests Written |
|---------|-----------|--------|---------------|
| F01 | User processes a meeting recording | done | F01-H1, F01-E3 |
| F02 | User views saved meeting notes | done | F02-H1, F02-E2 |
| F03 | User creates a new note | done | F03-H1, F03-E1 |
| F04 | User changes AI provider | partial | F04-H1, F04-E2 |

---

## F01 - User processes a meeting recording

### Happy Path (H)
- H1: Select audio file → Upload → Process → See generated note with summary, action items, topics, participants ✓

### Edge Cases (E)
- E1: Empty input (no file selected) - Button disabled ✓
- E2: Invalid file type - Error message shows ✓
- E3: Double click on submit - Idempotent operation, no duplicate ✓

### Negative Cases (N)
- N1: File too large (>100MB) - File size validation needed ⚠️