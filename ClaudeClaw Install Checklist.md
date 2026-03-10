---
created: 2026-03-09
tags:
  - tilli-os
  - claudeclaw
  - checklist
---

# ClaudeClaw Install Checklist

Full installation checklist based on README analysis, March 9, 2026. Must-haves first, then optional features roughly in order of usefulness.

> [!info] Status Legend
> - [x] = confirmed working
> - [ ] = not yet done

---

## Phase 1: Core (MUST-HAVE)

These are non-negotiable. Without them, nothing works.

- [x] Node.js 20+ (v22.22.0 installed)
- [x] Git (v2.50.1 installed)
- [x] Claude Code CLI (v2.1.72 installed, logged in)
- [x] Telegram account (active)
- [x] Clone repo (forked to pat-dubois/claudeclaw, cloned to `/Users/Shared/tilli-os/claudeclaw/`)
- [x] `npm install` (dependencies installed)
- [x] `npm run build` (TypeScript compiled to `dist/`)
- [x] Create Telegram bot via @BotFather (bot token obtained)
- [x] `TELEGRAM_BOT_TOKEN` in `.env`
- [x] Get chat ID (send `/chatid` to bot)
- [x] `ALLOWED_CHAT_ID` in `.env`
- [x] Customize `CLAUDE.md` (global + project-level stacking working)
- [x] Send first message (bot responding)
- [x] SQLite database (auto-created at `/Users/Shared/tilli-os/store/claudeclaw.db`)
- [x] Session persistence (sessions table working, context carries across messages)
- [x] Memory system (FTS5 search + salience decay running)
- [x] Background service via launchd (`com.claudeclaw.app` running)
- [x] Health check (`npm run status` available)

> [!success] Phase 1 COMPLETE

---

## Phase 2: Voice (HIGH VALUE)

Voice in and voice out. The core phone experience.

- [x] `GROQ_API_KEY` in `.env` (Groq free tier, Whisper large-v3 for STT)
- [x] Voice input working (send voice notes, get transcription + execution)
- [x] `ELEVENLABS_API_KEY` in `.env` (ElevenLabs account set up)
- [x] `ELEVENLABS_VOICE_ID` in `.env` (voice cloned in Voice Lab, ID copied)
- [ ] Test voice output (send a message with "respond with voice", confirm audio comes back)
- [ ] Test `/voice` toggle (send `/voice` to toggle permanent voice replies on/off)
- [x] ffmpeg installed (needed for macOS `say` fallback, installed via Homebrew)
- [ ] Test TTS cascade (confirm fallback order: ElevenLabs -> macOS say)

> [!tip] Gradium is an additional TTS option (see [[#Phase 5 Additional Voice Options (NICE TO HAVE)|Phase 5]]) but not configured yet.

---

## Phase 3: Video Analysis (HIGH VALUE)

Send videos to Telegram, get analysis back.

- [x] `GOOGLE_API_KEY` in `.env` (Gemini API key from aistudio.google.com)
- [x] `gemini-api-dev` skill installed (copied to `~/.claude/skills/gemini-api-dev/`)
- [ ] Test video analysis (send a short video clip to bot, confirm Gemini analyzes it)
- [ ] Test photo analysis (send a photo with and without caption, confirm it works)

---

## Phase 4: Dashboard (HIGH VALUE)

Live web dashboard showing tasks, memory, health, cost.

- [ ] Generate `DASHBOARD_TOKEN`: `node -e "console.log(require('crypto').randomBytes(24).toString('hex'))"`
- [ ] Add `DASHBOARD_TOKEN` to `.env`
- [x] `DASHBOARD_PORT` in `.env` (set, default 3141)
- [ ] Rebuild + restart: `npm run build && launchctl stop com.claudeclaw.app && launchctl start com.claudeclaw.app`
- [ ] Test `/dashboard` command (send in Telegram, tap the link)
- [ ] Verify all 4 panels load (Scheduled Tasks, Memory Landscape, System Health, Tokens & Cost)
- [ ] Test live chat overlay (click chat button on dashboard, send a message, see streaming response)

### Dashboard Remote Access (optional sub-step)

- [x] cloudflared installed (via Homebrew)
- [ ] Quick tunnel test: `cloudflared tunnel --url http://localhost:3141`
- [ ] Permanent tunnel setup (create named tunnel, route DNS, `config.yml`)
- [ ] `DASHBOARD_URL` in `.env` (set to permanent tunnel URL)
- [ ] Auto-start tunnel: `brew services start cloudflared`

---

## Phase 5: Additional Voice Options (NICE TO HAVE)

Extra TTS providers for the voice cascade.

- [ ] Gradium AI account (free tier, 45k credits/month)
- [ ] `GRADIUM_API_KEY` in `.env`
- [ ] `GRADIUM_VOICE_ID` in `.env`
- [ ] Test 3-tier cascade (ElevenLabs -> Gradium -> macOS say)
- [ ] Tune ElevenLabs voice (adjust `stability`/`similarity_boost` in `src/voice.ts` if voice sounds off)

---

## Phase 6: Bundled Skills (HIGH VALUE)

These ship with ClaudeClaw in the `skills/` folder but need to be copied to `~/.claude/skills/` and configured.

### Gmail Skill

- [ ] Create Google Cloud project (console.cloud.google.com)
- [ ] Enable Gmail API
- [ ] Create OAuth credentials (Desktop app type)
- [ ] Download `credentials.json` to `~/.config/gmail/credentials.json`
- [ ] `GOOGLE_CREDS_PATH` in `.env` (or use default path)
- [ ] Run OAuth flow once (generates `token.json`)
- [ ] `GMAIL_TOKEN_PATH` in `.env` (or use default path)
- [ ] Copy skill: `cp -r skills/gmail ~/.claude/skills/gmail`
- [ ] Test: send "check my inbox" to bot

### Google Calendar Skill

- [ ] Enable Calendar API (same Google Cloud project)
- [ ] Run Calendar OAuth flow (generates separate token)
- [ ] `GCAL_TOKEN_PATH` in `.env` (or use default path)
- [ ] Copy skill: `cp -r skills/google-calendar ~/.claude/skills/google-calendar`
- [ ] Test: send "what's on my calendar today" to bot

### Slack Skill

- [ ] Create Slack app (api.slack.com/apps, "From scratch")
- [ ] Add 11 User Token Scopes: `channels:history`, `channels:read`, `chat:write`, `groups:history`, `groups:read`, `im:history`, `im:read`, `mpim:history`, `mpim:read`, `search:read`, `users:read`
- [ ] Install app to workspace
- [ ] Copy User OAuth Token (starts with `xoxp-`)
- [ ] `SLACK_USER_TOKEN` in `.env`
- [ ] Copy skill: `cp -r skills/slack ~/.claude/skills/slack`
- [ ] Test `/slack` command (should show recent conversations)
- [ ] Test Slack CLI: `node dist/slack-cli.js list`

---

## Phase 7: WhatsApp Bridge (NICE TO HAVE)

No API key needed. Uses your existing WhatsApp via Linked Devices.

- [ ] Start wa-daemon: `npx tsx scripts/wa-daemon.ts`
- [ ] Scan QR code (WhatsApp -> Settings -> Linked Devices -> scan within 30s)
- [ ] Session saved (stored in `store/waweb/`, only scan once)
- [ ] Test `/wa` command (should list recent WhatsApp chats)
- [ ] Test read + reply (open a chat, send a reply through bot)
- [ ] Test incoming notifications (have someone message you on WhatsApp, confirm notification in Telegram)
- [ ] Run wa-daemon as background service (separate from main bot process)

---

## Phase 8: Scheduled Tasks (ALREADY AVAILABLE)

The scheduler works out of the box. This is about actually using it.

- [ ] Create first scheduled task (e.g. "Every weekday at 8am, give me a morning briefing")
- [ ] Verify task runs: `node dist/schedule-cli.js list`
- [ ] Test pause/resume: `node dist/schedule-cli.js pause <id>` / `resume <id>`
- [ ] Dashboard shows tasks (verify in Scheduled Tasks panel, needs [[#Phase 4 Dashboard (HIGH VALUE)|Phase 4]])

---

## Phase 9: Multi-Agent Team (ADVANCED, OPTIONAL)

Specialist agents with separate Telegram bots, contexts, and personalities.

### Decide on agents

- [ ] Pick agent roles (templates available: comms, content, ops, research, or create custom)

### Per agent (repeat for each)

- [ ] Create Telegram bot via @BotFather (separate bot per agent)
- [ ] Add bot token to `.env` (e.g. `COMMS_BOT_TOKEN=...`)
- [ ] Configure `agents/<name>/agent.yaml` (name, description, token env var, model)
- [ ] Write `agents/<name>/CLAUDE.md` (focused personality and instructions)
- [ ] Optional: configure Obsidian context injection (vault path + folder assignments in `agent.yaml`)
- [ ] Build: `npm run build`
- [ ] Test start: `npm start -- --agent <name>`
- [ ] Send `/start` to agent bot (confirm it responds with name/role)
- [ ] Install as background service: `bash scripts/agent-service.sh install <name>`
- [ ] Set profile picture (generate avatar, upload via Bot API)

### Hive mind

- [ ] Verify `hive_mind` table (agents log actions for cross-agent visibility)
- [ ] Dashboard shows agent panels (Agent Status Cards + Hive Mind Feed)

### Agent creation wizard (alternative to manual)

- [ ] Run `npm run agent:create` (interactive walkthrough)

---

## Phase 10: Google Workspace CLI (OPTIONAL, ADVANCED)

Alternative to individual Gmail/Calendar skills. Covers ALL Google Workspace APIs from one tool.

- [ ] Clone Google Workspace CLI (github.com/googleworkspace/cli)
- [ ] Follow install instructions
- [ ] Reference in `CLAUDE.md` (so bot knows it's available)
- [ ] Test: e.g. "search my Google Drive for quarterly report"

---

## Phase 11: Security Hardening (OPTIONAL)

- [x] `ALLOWED_CHAT_ID` set (bot locked to Pat's account)
- [ ] Cloudflare Access (add login page in front of dashboard, free for up to 50 users)
- [ ] 2FA / TOTP for elevated actions (community has examples, would need custom code in `handleMessage()`)
- [ ] Review `bypassPermissions` implications (understand what Claude can do unattended)

---

## Phase 12: Customization & Polish

- [ ] Customize `banner.txt` (replace ASCII art with something personal)
- [ ] Tune memory signals (edit `SEMANTIC_SIGNALS` regex in `src/memory.ts` if needed)
- [ ] Tune salience decay (adjust 0.98 multiplier or 0.1 deletion threshold in `src/db.ts`)
- [ ] TTS voice tuning (adjust `stability`/`similarity_boost` in `src/voice.ts`)
- [ ] Review `notify.sh` (understand how Claude sends proactive Telegram updates)
- [ ] File sending test (ask Claude to create and send a file, confirm `[SEND_FILE:]` works)

---

## Quick Reference: .env Variables

| Variable                 | Status | Required?                  |
| :----------------------- | :----- | :------------------------- |
| `TELEGRAM_BOT_TOKEN`     | done   | Yes                        |
| `ALLOWED_CHAT_ID`        | done   | Yes                        |
| `ANTHROPIC_API_KEY`      | done   | Optional (bypasses Max sub) |
| `GROQ_API_KEY`           | done   | For voice input            |
| `ELEVENLABS_API_KEY`     | done   | For voice output           |
| `ELEVENLABS_VOICE_ID`    | done   | For voice output           |
| `GOOGLE_API_KEY`         | done   | For video analysis         |
| `STORE_DIR`              | done   | Custom DB location         |
| `DASHBOARD_PORT`         | done   | Dashboard port             |
| `DASHBOARD_TOKEN`        | todo   | Dashboard access           |
| `DASHBOARD_URL`          | todo   | Remote dashboard access    |
| `SLACK_USER_TOKEN`       | todo   | Slack integration          |
| `GOOGLE_CREDS_PATH`      | todo   | Gmail/Calendar OAuth       |
| `GMAIL_TOKEN_PATH`       | todo   | Gmail OAuth token          |
| `GCAL_TOKEN_PATH`        | todo   | Calendar OAuth token       |
| `GRADIUM_API_KEY`        | todo   | Alt voice output           |
| `GRADIUM_VOICE_ID`       | todo   | Alt voice output           |
| `CLAUDE_CODE_OAUTH_TOKEN`| n/a    | Override Claude account    |
| Agent bot tokens         | todo   | Multi-agent setup          |
