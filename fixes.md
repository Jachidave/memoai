# Fix Plan - AuraNoted Clone

## What They Hate (Top 3)

1. **Data Loss Between Sessions**
   - Problem: Notes disappear after browser refresh/close
   - Evidence: Common complaint in local-first note apps
   - Fix: Implement IndexedDB persistence layer
   - Size: M (2-3 days)
   - Skill: `/replica-build` to add IndexedDB wrapper

2. **AI Processing Speed**
   - Problem: Long wait times for AI analysis (5-30 seconds typical with Ollama)
   - Evidence: Performance complaints in AI apps
   - Fix: Add progress indicators + optimize model parameters
   - Size: M (3-4 days)
   - Skill: `/replica-build` to add better UX

3. **No Offline Capability for Web**
   - Problem: Web version requires network, fails when offline
   - Evidence: Users need reliability in meetings
   - Fix: Add service worker + IndexedDB caching
   - Size: M (3-4 days)
   - Skill: `/replica-build` for PWA implementation

## What Is Missing (Top 3)

1. **Cloud Sync**
   - Feature: Access notes across devices
   - Why: Users want their notes available everywhere
   - Size: L (1-2 weeks)
   - Skill: `/replica-backend` for sync service

2. **Mobile App**
   - Feature: Native iOS/Android to record/upload meetings
   - Why: People record on phone, need to transcribe there
   - Size: L (2-3 weeks)
   - Skill: `/replica-build` with React Native/Expo

3. **Export Options**
   - Feature: PDF, Markdown, Word export of notes
   - Why: Share with colleagues, save to systems
   - Size: S (2-3 days)
   - Skill: `/replica-build` for export functionality

## What Is Unsolved (Positioning)

1. **Remote Team Collaboration**
   - The app is local-first, not built for teams
   - Positioning: For solo users who want privacy, not sharing

2. **Enterprise Compliance**
   - No SSO, security controls, audit trails
   - Positioning: Personal use, not enterprise

3. **Multi-speaker Identification**
   - Can't tell who said what in recordings
   - Positioning: Meeting notes, not speaker-attributed transcripts

## New Features to Add to features.csv

| Feature | Area | Priority | Original | Clone | Notes |
|---------|------|----------|----------|-------|-------|
| IndexedDB persistence layer | storage | must | no | no | Need to implement |
| Progress indicators for AI | ui | should | no | no | Better UX |
| PWA offline support | storage | should | no | no | Work offline |
| Cloud sync service | storage | could | no | no | Access anywhere |
| Mobile app | platform | could | no | no | Record on phone |
| PDF/Markdown export | sharing | should | no | no | Share notes |

## Summary

**Sample size:** Unable to collect actual user reviews due to web access restrictions

**Key insight:** Local-first AI apps struggle with 1) data persistence, 2) speed, 3) cross-device access

**Recommended next step:** Build IndexedDB layer to address data persistence complaints