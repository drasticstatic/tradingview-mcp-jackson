# AGENTS.md
> AI Agent Configuration — tradingview-mcp-jackson
> Read by: Claude Code, Cursor, GitHub Copilot, and other AI coding assistants.
> See `CLAUDE.md` for Claude Code–specific rules.

---

## Project Overview

**tradingview-mcp-jackson** is an MCP (Model Context Protocol) server that controls a live TradingView Desktop app via Chrome DevTools Protocol (CDP). Provides 68+ tools for reading chart state, managing indicators, drawing levels, executing replay trades, and more.

**Upstream:** Forked — tracked as `upstream` remote for voluntary comparison.
**Visibility:** PRIVATE (working copy)
**Primary operator:** Fortuna reads via MCP; Auggie maintains the server

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| MCP server | Node.js / TypeScript |
| Protocol | Chrome DevTools Protocol (CDP) on port 9222 |
| Connection | TradingView Desktop (Electron) |
| Package manager | npm |

---

## Common Commands

```bash
# Install dependencies
npm install

# Build TypeScript
npm run build

# Start MCP server (registered via claude mcp add-json)
node dist/server.js

# Check for upstream changes (voluntary — review before applying)
git fetch upstream && git log HEAD..upstream/main --oneline
```

---

## Coding Standards

- Follow existing tool naming conventions (snake_case, descriptive)
- All tools return `{ success: true/false, ... }`
- Entity IDs from `chart_get_state` are session-specific — document this in tool descriptions
- Always use `summary: true` on `data_get_ohlcv` in examples to prevent context bloat

---

## Agent Boundaries

**Do:**
- Maintain compatibility with the existing tool interface
- Document new tools with clear parameter descriptions
- Test against a live TradingView Desktop instance before committing

**Don't:**
- Apply upstream changes without reviewing the diff first
- Modify chart state or place trades without user confirmation
- Add tools that execute trades (this MCP is analysis + read + UI control only)

---

## Security Rules

- Never read, display, or commit `.env` files or TradingView credentials
- CDP port 9222 is local-only — never expose to the network
- Before applying upstream changes: review every commit for unexpected behavior

---

## Canonical References

- `CLAUDE.md` — Tool decision tree, context management rules, architecture notes
- `AGENTS.md` (this file) — Universal AI agent config
- `README.md` — Tool list and setup instructions
