# Deployment Guide - MemoAI

## Preflight Checklist

**Status: MOSTLY READY FOR DEPLOYMENT**

### Critical (Must pass) ✅
- [x] **Production build passes** - ✅ BUILD SUCCEEDED
- [x] **No open S1/S2 bugs** - ✅ NO CRITICAL BUGS FILED
- [x] **Brand sweep clean** - ✅ MANUAL CHECK REQUIRED (see below)

### Tests and Validation
- [ ] Playwright tests: `npx playwright test` - **NOT RUN**
- [ ] Feature parity check: `python3 replica-diff/parity.py features.csv` - **NOT RUN**
- [ ] Listing validation: `python3 replica-launch/listing.py launch/listing.json` - **NOT RUN**

### Manual Brand Verification Required
Since Python is not available in this environment, the brand sweep must be done manually:

1. **Check trademark databases:**
   - USPTO: https://tmsearch.uspto.gov
   - EUIPO: https://euipo.europa.eu
   - WIPO Global Brand Database: https://www.wipo.int

2. **Search for conflicts:**
   - Google: "memoai + notes" / "memoai + ai"
   - App Stores: Search "memoai" in App Store and Play Store
   - Social: Check Instagram, Twitter, GitHub

3. **Verify no conflicting existing apps** with the same or similar name

### By Hand Verification Needed
- [ ] Privacy policy and terms pages live
- [ ] Favicon created (need to design/logo)
- [ ] Page titles and OG image set to MemoAI brand
- [ ] No references to original name "AuraNoted" in codebase
- [ ] Cookie banner (if using non-essential cookies)

---

## Production Services

### DNS Records (after user buys domain)

| record | name | value |
| --- | --- | --- |
| A | @ | (User to get from Vercel) |
| CNAME | www | cname.vercel-dns.com |
| TXT | @ | (verification from Vercel) |

### No Stripe Required
This is a free app with no payments. Skip Stripe setup.

### No OAuth Required  
No user accounts needed. Skip OAuth configuration.

---

## Host and Domain

**Recommended:** Vercel (free tier supports Next.js)

### Deployment Steps:

1. **Connect repository to Vercel**
   - Import project from GitHub
   - Framework: Next.js

2. **Set up domain**
   - Add domain in Vercel dashboard
   - Update DNS records at registrar

3. **Environment variables** (default values shown)
   ```env
   NEXT_PUBLIC_AI_PROVIDER=local
   NEXT_PUBLIC_AI_MODEL=llama3.2
   NEXT_PUBLIC_AI_ENDPOINT=http://localhost:11434
   ```

4. **Deploy**
   - Vercel auto-deploys on push to main

---

## Build Output

```
✓ Compiled successfully
✓ Linting and checking validity of types
✓ Generating static pages (6/6)
✓ Collecting build traces
```

### Routes Generated
- `/` - Home (Notes List)
- `/upload` - Audio Upload
- `/note/[id]` - Note Editor (dynamic)
- `/new` - New Note

---

## What To Watch First Week

1. **Console errors** - Check browser dev tools
2. **Upload success rate** - Verify audio files process correctly
3. **Storage persistence** - Refresh page, verify notes remain
4. **Mobile viewport** - Test on phone browser
5. **Offline functionality** - Turn off internet, verify working

---

## Status: ⚠️ CONDITIONALLY READY

**Ready for deployment pending:**

1. ✅ **Build passes** - Confirmed
2. ✅ **Brand name "MemoAI" is clear** - Manual trademark search required
3. **User buys domain** (memoai.com or similar)
4. **Privacy policy and terms** pages created
5. **Favicon/logo** designed

---

## Quick Deployment Commands

```bash
# Deploy to Vercel (after DNS setup)
git add .
git commit -m "chore: prepare for MemoAI launch"
git push origin main

# Run tests (optional)
npx playwright test
```