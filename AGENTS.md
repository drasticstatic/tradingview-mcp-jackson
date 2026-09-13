# AGENTS.md
> AI Agent Configuration — tradingview-mcp-jackson
> Read by: Claude Code, Cursor, GitHub Copilot, and other AI coding assistants.
> See `CLAUDE.md` for Claude Code–specific rules.

---

## ⚠ FIRST: sync this clone before you touch anything

```sh
git pull --rebase --autostash
```

Run this at the **start of every session**, before reading deeply or editing. Several agents and
Christopher push to these repos — including Cosmos agents that run unattended while nobody is at the
machine — so a clone can be behind by the time you open it.

**`--autostash` is what makes this safe on a dirty tree.** It stashes uncommitted changes, rebases
onto the remote, then reapplies them. Your in-progress work survives. Without it, `git pull --rebase`
refuses to run and you are tempted into something worse.

Why it matters more than it sounds:

- A stale clone **does not fail early.** It fails at push time, after the work is done, as a
  non-fast-forward rejection — the most expensive moment to discover it.
- The tempting fix at that point is `git push --force`, which discards whatever someone else pushed
  in the meantime. Syncing first removes the temptation.
- If a rebase does conflict, stop and resolve it deliberately. A conflict is information: someone
  else changed the same lines, and you want to know that *before* building on top of them.

**Fresh clone?** Also run `sh scripts/install-hooks.sh` — git hooks are not version-controlled, so
the commit-attribution hook stays inert until this clone is pointed at `.githooks/`. Details:
[`scripts/README.md`](./scripts/README.md).

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

## Override System

Create `AGENTS.override.md` for temporary task-specific rules (e.g., "read-only mode during market hours — no chart changes"). Delete when done. Template: `~/code/my-template/AGENTS.override.md`

---

## Canonical References

- `CLAUDE.md` — Tool decision tree, context management rules, architecture notes
- `AGENTS.md` (this file) — Universal AI agent config
- `README.md` — Tool list and setup instructions

## Commit attribution (enforced by hook)

Every commit must carry two git trailers:

```
Co-Authored-By: <Agent> · <Engine> · <Provider> [<Model>]                  # direct
Co-Authored-By: <Agent> · <Engine> · <Gateway> · <Provider> [<Model>]      # proxied
<Platform>-Session: <full session URL>
```

Model in **square brackets**, separator is U+00B7 MIDDLE DOT ( · ). Add `<Gateway>` **only when
inference is proxied** — it names what *routed* the request (`NVIDIA NIM`, `OpenRouter`), never who
made the model (`Z.ai`, `Moonshot AI`, `MiniMax`). The field order mirrors the `/model` selector
string, so `anthropic/nvidia_nim/z-ai/glm4.7` transcribes to `NVIDIA NIM · Z.ai [GLM-4.7]` —
read it left to right rather than memorising it. Local runtimes (`Ollama`, `llama.cpp`,
`LM Studio`) have no gateway: the weights ran on your machine, so the runtime is the Provider. The session
trailer is a **separate** line — folding it onto the `Co-Authored-By:` line breaks git trailer
parsing. Use the full session URL, never a truncated prefix. Key varies by platform:
`Claude-Session:` for Claude Code CLI, `Cosmos-Session:` for Cosmos.

`.githooks/commit-msg` rejects non-conforming commits. **Activate it once per clone:**

```sh
sh scripts/install-hooks.sh
```

Human-only commits: `git commit --no-verify`. **Canonical spec — single source of truth. Do not restate the field table locally; link it:**
[`my-template/AGENT-SYNC/README.md`](https://github.com/drasticstatic/my-template/blob/main/AGENT-SYNC/README.md)
