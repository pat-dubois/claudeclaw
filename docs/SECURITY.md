# ClaudeClaw Security Model

## Layers of Protection

### 1. Telegram Chat Lock (`ALLOWED_CHAT_ID`)
The bot only responds to one Telegram chat ID. All other messages are silently dropped at `bot.ts:isAuthorised()`. This is the primary access control.

### 2. Dashboard Auth
- **Cloudflare Access (Zero Trust):** Email-based authentication at the CDN edge. Blocks unauthenticated requests before they reach the tunnel.
- **Token auth (defense-in-depth):** Dashboard requires `?token=DASHBOARD_TOKEN` in the query string. Even if Access is bypassed, the token is still required.

### 3. Service Isolation
- Bot runs as a macOS launchd service (`com.claudeclaw.app`) under Pat's user account
- Tunnel runs as a separate launchd service (`com.cloudflare.claudeclaw-tunnel`)
- No ports exposed to the internet except through the Cloudflare tunnel

---

## Permission Model: `bypassPermissions`

### What It Means

The bot runs with these SDK options (`agent.ts:157-158`):

```typescript
permissionMode: 'bypassPermissions',
allowDangerouslySkipPermissions: true,
```

This means Claude can execute ANY tool without interactive permission prompts:
- **Bash:** Run any shell command
- **Read/Write/Edit:** Access any file the user account can reach
- **WebSearch/WebFetch:** Make network requests
- **MCP tools:** Call any connected MCP server (Exa, Firecrawl, QMD, etc.)

### Why This Is Acceptable

1. **Headless requirement:** There is no terminal to approve prompts. Without bypass, any tool call would hang indefinitely waiting for input that can never arrive.
2. **Single-user:** The bot is locked to one Telegram chat ID on a personal machine. There is no multi-user scenario.
3. **Local machine:** The bot runs on Pat's Mac with Pat's file permissions. It can only access what Pat can access.

### Risks to Be Aware Of

- **Prompt injection via forwarded content:** If Pat forwards a crafted message to the bot, the content could contain instructions that Claude follows. Mitigation: Claude's training includes prompt injection resistance, but it's not perfect.
- **Unattended scheduled tasks:** The morning briefing and other scheduled tasks run without Pat watching. If a task prompt is poorly constructed, Claude could take unexpected actions. Mitigation: Keep scheduled task prompts specific and bounded.
- **Cascading tool use:** A single user message could trigger a chain of tool calls (e.g., web search -> download -> execute). This is by design but worth understanding.

### Future: Per-Agent Restrictions

When TilliOS agents (Phase 9) are deployed, consider using `disallowedTools` in agent.yaml to restrict agents by role:

```yaml
# Example: read-only research agent
disallowedTools:
  - Write
  - Edit
  - Bash
```

The SDK supports:
- `allowedTools: string[]` -- whitelist (others blocked)
- `disallowedTools: string[]` -- blacklist (others allowed)
- `canUseTool: function` -- custom per-call permission logic

For the main bot, `bypassPermissions` remains the right choice. For specialized agents with narrower roles, `disallowedTools` provides defense-in-depth without breaking functionality.
