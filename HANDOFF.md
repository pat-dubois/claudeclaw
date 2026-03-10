# ClaudeClaw - Session Handoff

## Last Session
**Date:** 2026-03-10 11:00
**Location:** /Users/Shared/tilli-os/claudeclaw

## Current State
Bot is running via launchd (`com.claudeclaw.app`). Phases 1-4, 8, 11, and 12 are complete (minus file sending test and TTS tuning). Cloudflare Access protects the dashboard at 71111.patdubois.com with one-time PIN auth. Memory signals tightened, salience decay differentiated, banner rebranded. Cloudflare API token stored globally for future automation.

**KNOWN BUG:** Dashboard is not showing memories or data panels. Needs troubleshooting -- may be related to auth changes (Cf-Access header flow) or the memory/decay parameter changes. This is the first thing to fix next session.

## Completed This Session
- [x] Phase 11.1: Cloudflare Access via API (app: Tilli Dashboard, email: spacepat34@gmail.com, 30-day sessions)
- [x] Phase 11.2: docs/SECURITY.md documenting bypassPermissions model
- [x] Phase 12.1: Flexoki rainbow TILLI banner (matches status line palette)
- [x] Phase 12.2: notify.sh hardened (--max-time 10, HTTP status error reporting)
- [x] Phase 12.4: Memory signals tightened (removed 'my', added 'i like'/'i hate', skip system msgs)
- [x] Phase 12.5: Salience decay differentiated (semantic 0.99, episodic 0.98, threshold 0.05)
- [x] Dashboard auth simplified (CF Access header OR token -- no token needed via tunnel)
- [x] Cloudflare API token stored in ~/.claude/.env for future use
- [x] Established naming: Telegram-facing agents = TilliOS agents
- [x] Clarified 3-layer architecture: global skills -> TilliOS agents -> Claude Code subagents

## In Progress
- [ ] Dashboard data panels not loading (BUG -- troubleshoot first next session)
- [ ] File sending test via Telegram (just needs manual test)
- [ ] TTS voice tuning — deferred (Pat plans local TTS project)
- [ ] Phase 6: Gmail/Calendar/Slack integration (future heavier session)
- [ ] Phase 9: Multi-agent team (TilliOS agents -- future tilli-os/ work)

## Next Step (CRITICAL)
**Do this first:** Troubleshoot why the dashboard isn't showing memories/data. Check if it's an auth issue (CF Access header not passing chatId correctly), a query param issue (token was part of URL which also carried chatId), or a data issue from the decay/signal changes. Start by hitting the API endpoints directly: `curl -H "Cf-Access-Authenticated-User-Email: spacepat34@gmail.com" http://localhost:3141/api/memories?chatId=<CHAT_ID>` vs the old token method.

Then: file sending test (quick manual check via Telegram), and this folder is mostly done. Future system work moves to tilli-os/.

## Working Commands
```bash
# Service management
launchctl start com.claudeclaw.app
launchctl stop com.claudeclaw.app
npm run build && launchctl stop com.claudeclaw.app && launchctl start com.claudeclaw.app

# Tunnel management
launchctl start com.cloudflare.claudeclaw-tunnel
launchctl stop com.cloudflare.claudeclaw-tunnel

# Cloudflare API (token in ~/.claude/.env)
CF_TOKEN=$(grep CLOUDFLARE_API_TOKEN ~/.claude/.env | cut -d= -f2)
curl -s -H "Authorization: Bearer $CF_TOKEN" "https://api.cloudflare.com/client/v4/accounts/9ff731c7fd48ad6f260e04ea4ef8e848/access/apps" | python3 -m json.tool

# Scheduled tasks
node dist/schedule-cli.js list
node dist/schedule-cli.js create "prompt" "cron"

# TilliDB
/Users/Shared/tilli-os/bin/tillidb status
/Users/Shared/tilli-os/bin/tillidb memory recent 5

# Dashboard debug
curl http://localhost:3141/api/memories?token=<TOKEN>&chatId=<CHAT_ID>

# Logs
tail -f /tmp/claudeclaw.log
```

## Notes for Future Self
- Dashboard bug is likely chatId-related: the old URL had `?token=X&chatId=Y`, new CF Access flow may not be passing chatId
- Cloudflare API token is scoped to patdubois.com with Access, Tunnel, Workers, Pages, DNS, Zone Settings permissions
- CF Account ID: 9ff731c7fd48ad6f260e04ea4ef8e848
- Pat wants to do terminal design (TILLI branding) but won't derail current work
- Pat's big vision: end-of-day agent that ties together conversations, Granola transcripts, voice dumps, logbook, calendar -- extracts ideas and surfaces patterns. This is tilli-os/ level work.
- Pat prefers API automation over web UI walkthroughs
- 95% of future system work happens in tilli-os/, not claudeclaw/
