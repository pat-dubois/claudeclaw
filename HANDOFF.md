# ClaudeClaw - Session Handoff

## Last Session
**Date:** 2026-03-10 09:44
**Location:** /Users/Shared/tilli-os/claudeclaw

## Current State
Bot is running via launchd (`com.claudeclaw.app`). Phases 1-4 fully complete, Phase 8 (Scheduled Tasks) now operational. Morning briefing task running weekdays at 8 AM — tested successfully at 9:40 AM, result arrived clean in Telegram. Two bugs fixed in upstream code: schedule-cli arg parsing and removed noisy task announcement. Database is `tilli.db` accessed via `tillidb` CLI.

## Completed This Session
- [x] Phase 8: Created morning briefing scheduled task (ID: `18811248`, weekdays 8 AM)
- [x] Phase 8: Tested schedule-cli list, pause, resume — all working
- [x] Phase 8: Verified dashboard shows task with active pill, countdown, controls
- [x] Phase 8: Ran live test at 9:40 AM — briefing arrived in Telegram with journal recap, weather, AI news
- [x] Fixed bug: schedule-cli `--agent` flag parsing removed argv[0] when flag absent (upstream bug)
- [x] Fixed: removed "Scheduled task running:" announcement from scheduler (noise before results)
- [x] Updated install checklist Phase 8 items

## In Progress
- [ ] Phase 5 (Additional Voice): deferred — Pat plans a local TTS project soon
- [ ] Phase 6 (Bundled Skills): deferred — Gmail/Calendar will have enhancements; Slack TBD
- [ ] Dashboard customization (Pat is excited about this)
- [ ] Phase 11: Security — Cloudflare Access for dashboard (recommended next)
- [ ] Phase 12: Quick wins — file sending test, banner, notify.sh review

## Next Step (CRITICAL)
**Do this first:** Phase 8 is done. Next priorities are Phase 11 (Cloudflare Access for dashboard security) and Phase 12 quick wins (file sending test, banner customization). Phase 6 (Gmail/Calendar/Slack) is the next big integration push when Pat is ready for a heavier session.

Tomorrow morning: verify the 8 AM briefing fires and arrives clean (no announcement preamble).

## Working Commands
```bash
# Service management
launchctl start com.claudeclaw.app
launchctl stop com.claudeclaw.app
npm run build && launchctl stop com.claudeclaw.app && launchctl start com.claudeclaw.app

# Tunnel management
launchctl start com.cloudflare.claudeclaw-tunnel
launchctl stop com.cloudflare.claudeclaw-tunnel

# Scheduled tasks
node dist/schedule-cli.js list
node dist/schedule-cli.js create "prompt" "cron"
node dist/schedule-cli.js pause <id>
node dist/schedule-cli.js resume <id>
node dist/schedule-cli.js delete <id>

# TilliDB
/Users/Shared/tilli-os/bin/tillidb status
/Users/Shared/tilli-os/bin/tillidb memory recent 5

# Health check
npm run status

# Logs
tail -f /tmp/claudeclaw.log
```

## Notes for Future Self
- Database is `tilli.db` (not claudeclaw.db) — use tillidb CLI, never hardcode DB paths
- STORE_DIR: `/Users/Shared/tilli-os/store/` (not default)
- NEVER use `npm start` directly, always use launchctl
- Install checklist is a SYMLINK to vault
- Dashboard URL: `https://71111.patdubois.com`
- schedule-cli had upstream bug (fixed): `--agent` flag parsing removed argv[0] when absent — worth reporting to Mark
- Scheduler announcement removed — tasks now deliver results silently
- Pat wants future briefings routed to email or dedicated channel (not main DM)
- Pat prefers CLIs over MCPs where possible
