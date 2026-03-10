# ClaudeClaw - Session Handoff

## Last Session
**Date:** 2026-03-10 00:14
**Location:** /Users/Shared/tilli-os/claudeclaw

## Current State
Bot is running via launchd (`com.claudeclaw.app`). Phases 1-4 fully complete. Voice (STT + TTS with ElevenLabs), photo analysis (Claude vision), video analysis (Gemini), and dashboard are all working. Dashboard accessible remotely at `https://71111.patdubois.com` via permanent Cloudflare tunnel (auto-starts via launchd). Install checklist is symlinked from vault — single source of truth.

## Completed This Session
- [x] Symlinked install checklist (vault version is canonical, linked into claudeclaw/)
- [x] Phase 2: Tested voice output (ElevenLabs TTS), /voice toggle, TTS cascade — all working
- [x] Phase 3: Tested photo analysis (Claude vision) and video analysis (Gemini) — all working
- [x] Phase 4: Generated DASHBOARD_TOKEN, added to .env, rebuilt, verified dashboard loads with all 4 panels + live chat overlay
- [x] Phase 4 remote: Created permanent Cloudflare tunnel (`claudeclaw-dashboard`), routed `71111.patdubois.com`, set up launchd auto-start (`com.cloudflare.claudeclaw-tunnel`)

## In Progress
- [ ] Phase 5 (Additional Voice): deferred — Pat plans a local TTS project soon
- [ ] Phase 6 (Bundled Skills): deferred — Gmail/Calendar will have enhancements; Slack TBD
- [ ] Dashboard customization (Pat is excited about this)

## Next Step (CRITICAL)
**Do this first:** Pat wants to customize the dashboard and continue through the checklist. Phase 8 (Scheduled Tasks) is low-hanging fruit — already works, just needs first task created. Phase 6 (Gmail/Calendar/Slack) is the next big integration push.

Also on Pat's radar: CLI tools over MCPs where possible, and deeper voice/TTS work as a standalone project.

## Working Commands
```bash
# Service management
launchctl start com.claudeclaw.app
launchctl stop com.claudeclaw.app
npm run build && launchctl stop com.claudeclaw.app && launchctl start com.claudeclaw.app

# Tunnel management
launchctl start com.cloudflare.claudeclaw-tunnel
launchctl stop com.cloudflare.claudeclaw-tunnel

# Health check
npm run status

# Logs
tail -f /tmp/claudeclaw.log
tail -f /tmp/cloudflared-tunnel.log
```

## Notes for Future Self
- STORE_DIR points to `/Users/Shared/tilli-os/store/` (not the default `store/` in claudeclaw)
- Database is at `/Users/Shared/tilli-os/store/claudeclaw.db`
- NEVER use `npm start` directly, always use launchctl
- Install checklist is a SYMLINK to vault (`/Users/Shared/patdubois/TILLI OS/ClaudeClaw Install Checklist.md`)
- Dashboard URL: `https://71111.patdubois.com` (71111 = "tilli" digital signature)
- Tunnel plist: `/Users/patdubois/Library/LaunchAgents/com.cloudflare.claudeclaw-tunnel.plist`
- Cloudflared config: `/Users/patdubois/.cloudflared/config.yml`
- The brew service for cloudflared doesn't work for named tunnels — we use a custom launchd plist instead
- Voice came back as an unexpected macOS voice Pat had set before — he may want to change ELEVENLABS_VOICE_ID
- Pat confirmed: through Telegram, bot has access to ALL global skills (`~/.claude/skills/`)
- Pat wants to explore CLIs over MCPs where the option exists
