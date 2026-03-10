# ClaudeClaw - Session Handoff

## Last Session
**Date:** 2026-03-09 22:31
**Location:** /Users/Shared/tilli-os/claudeclaw

## Current State
Bot is running via launchd (`com.claudeclaw.app`), core install is complete (Phase 1). Voice keys configured but TTS output not yet tested. Dashboard not yet enabled (needs token). Created comprehensive architecture doc and install checklist in vault. Pat now understands the CLI vs SDK distinction and how terminal sessions relate to Telegram bot sessions.

## Completed This Session
- [x] Architecture deep-dive: explained how ClaudeClaw works (terminal vs Telegram, CLI vs SDK)
- [x] Created vault doc: `TILLI OS/How ClaudeClaw Works.md` with Mermaid diagrams
- [x] Analyzed full README and created 12-phase install checklist with ~80 items
- [x] Created vault doc: `TILLI OS/ClaudeClaw Install Checklist.md` (Obsidian-flavored)
- [x] Copied checklist to claudeclaw folder for local reference
- [x] Audited current install state: Phase 1 complete, Phase 2-3 90% done

## In Progress
- [ ] Phase 2 voice testing (keys configured, output not tested)
- [ ] Phase 3 video testing (key + skill installed, not tested)
- [ ] Phase 4 dashboard setup (not started, highest-value next step)

## Next Step (CRITICAL)
**Do this first:** Set up the dashboard (Phase 4). Generate a token, add to .env, rebuild, test `/dashboard` in Telegram.

Follow-up: Test voice output and video analysis (Phases 2-3 just need verification sends).

## Working Commands
```bash
# Service management
launchctl start com.claudeclaw.app
launchctl stop com.claudeclaw.app
npm run build && launchctl stop com.claudeclaw.app && launchctl start com.claudeclaw.app

# Health check
npm run status

# Logs
tail -f /tmp/claudeclaw.log
```

## Notes for Future Self
- STORE_DIR points to `/Users/Shared/tilli-os/store/` (not the default `store/` in claudeclaw)
- Database is at `/Users/Shared/tilli-os/store/claudeclaw.db`
- NEVER use `npm start` directly, always use launchctl
- The install checklist lives in two places: vault (`TILLI OS/`) and here in claudeclaw folder
