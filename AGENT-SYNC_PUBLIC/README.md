# AGENT-SYNC — cross-agent coordination convention

`AGENT-SYNC/` is where agents and Christopher leave handoffs, context dumps, and coordination notes for
each other within a repo — separate from the repo's actual working files.

> **Canonical version:** This README lives in `my-template/AGENT-SYNC/README.md`. If you change it here,
> update the pointer copies in other repos, or replace them with a pointer back to this file.

## The `created-by-*` subdirectories

Each subdirectory holds material authored by that agent or person — the name tells you who wrote it,
not who it's for:

| Directory | Author |
|---|---|
| `created-by-christopher` | Christopher himself — prompts, direct notes, manual context |
| `created-by-alfred` | Alfred (Claude Code CLI, system coordinator) |
| `created-by-fortuna` | Fortuna (Claude Code CLI, trading domain) |
| `created-by-kavanah` | Kavanah (Augment Intent, spec-driven orchestration) |
| `created-by-mystarch` | Mystarch (Augment Intent, app-level Chief of Staff) |
| `created-by-auggie` | Auggie (Augment CLI, code builds) |
| `created-by-littlebird` | LittlebirdAI (app.littlebird.ai, screen context & fleet memory) |
| `created-by-cosmos` | Any Cosmos agent — Cosmos Advisor and the code-review experts it runs |

### One lane for all Cosmos agents

Cosmos briefly used per-environment lanes (`created-by-cosmos_Advisor-drasticstatic` and
`…-drasticstatica`). That was a mistake worth recording, because the reasoning behind it was
superficially sound: two environments see different things, so a reader should be able to tell which
one authored a claim.

The flaw is that it encoded the distinction in the **path** rather than the **document**, and the two
paths differed by one trailing letter — unreadable at a glance and easy to mistake for a typo. The
better fix is a provenance header inside each handoff:

```markdown
**From:** Cosmos Advisor · environment `<environment-name>`
**Session:** https://cosmos.augmentcode.com/session?agentId=<id>
```

That keeps the fact where a reader encounters it in context, and collapses the directory listing to
one obvious place to look. The same applies to the code-review experts (PR Author, Deep Code
Reviewer, PR Risk Analyzer, and the rest) — they do not get their own lanes. Cosmos Advisor is the
coordination liaison; whichever expert did the work, the handoff lands in `created-by-cosmos/` and
names its author in the header.

**General rule:** if a distinction can be stated clearly in a document header, do not encode it in a
directory name. Paths are for finding things; documents are for explaining them.

## AGENT-SYNC vs AGENT-SYNC_PUBLIC

There are two patterns depending on the repo's privacy model:

**Pattern A: Private repo with a public mirror**
- Use `AGENT-SYNC/` in the **private** repo for all agent handoffs.
- The public mirror (e.g., `-public-preview` or `-public` repo) has its own `AGENT-SYNC/` if needed.
- `AGENT-SYNC_PUBLIC/` inside the private repo is **incorrect** — it was accidentally added to
  `littlebird-ambassador` and `augment-intent-properties` during early Mystarch training and has
  since been cleaned up.

**Pattern B: Public-only repo (no private lane)**
- Use `AGENT-SYNC_PUBLIC/` as the single coordination directory.
- This is the correct pattern for repos like `resume`, `gratitude-token-project_docs`, etc. that
  have no private counterpart.

## The generic commit-attribution convention

Every agent in this fleet other than LittlebirdAI (Mystarch, Alfred, Fortuna, and now Cosmos's
PR Author/PR Fixer experts) signs commits with this form:

```
Co-Authored-By: <Agent> · <Engine> · <Provider> [<Model>]
```

For example:

```
Co-Authored-By: Mystarch · ClaudeCodeCLI · Anthropic [Sonnet-5]
Co-Authored-By: Cosmos-PRAuthor · Cosmos · Anthropic [Claude Opus 5]
```

**This was previously cited from other repos' handoffs but never actually written down here** —
a real gap identified 2026-09-11 (by Cosmos's own setup agent, cross-referencing this file against
what the kickoff handoff claimed), and the likely root cause of the attribution drift the Sep 9,
2026 fleet audit had to clean up. This section is the fix.

### What each field means (and why it matters under a proxy)

The four fields are not interchangeable labels. Each answers a different question, and the
distinction only becomes visible when inference is proxied through
[`free-claude-code`](https://github.com/drasticstatic/free-claude-code):

| Field | Question it answers | Examples |
|---|---|---|
| `<Agent>` | Which persona was working | `Alfred`, `Fortuna`, `Mystarch`, `Cosmos-Advisor` |
| `<Engine>` | Which harness was it typed into | `ClaudeCodeCLI`, `Cosmos`, `AugmentIntent`, `ClaudeMent` |
| `<Provider>` | **Who actually ran the weights** | `Anthropic`, `NVIDIA NIM`, `OpenRouter`, `DeepSeek`, `LM Studio`, `llama.cpp`, `Ollama` |
| `<Model>` | Which weights answered | `Sonnet-5`, `Claude Opus 5`, `GLM-4.7`, `Kimi-K2.5` |

**Routing Claude Code through a proxy changes the Provider and the Model, never the Engine.** You
were still sitting in Claude Code; a different company's hardware answered. Both facts are true and
the footer records both:

```
Co-Authored-By: Alfred · ClaudeCodeCLI · NVIDIA NIM [GLM-4.7]
Co-Authored-By: Alfred · ClaudeCodeCLI · NVIDIA NIM [Kimi-K2.5]
Co-Authored-By: Fortuna · ClaudeCodeCLI · OpenRouter [DeepSeek-V3]
Co-Authored-By: Alfred · ClaudeCodeCLI · Ollama [Llama-3.3-70B]
```

This is not bookkeeping for its own sake. When a commit later turns out to be subtly wrong — a
misread requirement, a plausible-looking but incorrect refactor — the first useful question is which
model produced it. Attribution that collapses every route into `Anthropic` destroys exactly the
signal you need, and it destroys it silently, because the line still looks correct.

That is also the one mistake worth guarding: switching to a proxied model and leaving the Provider
at `Anthropic`. The Engine genuinely didn't change, so nothing looks off. `.githooks/commit-msg`
warns (but still allows) when the Provider reads `Anthropic` while the Model is recognisably not an
Anthropic model.

For local backends (`LM Studio`, `llama.cpp`, `Ollama`) the Provider is the runtime, not the
model's original publisher — it records where the weights ran, which for a local model is the
honest answer and the one with privacy implications.

### The optional session-ID trailer

When an agent's platform assigns a per-session or per-conversation ID, append it as a **separate**
git trailer line — not appended inline onto the `Co-Authored-By:` line itself:

```
Co-Authored-By: Mystarch · ClaudeCodeCLI · Anthropic [Sonnet-5]
Claude-Session: https://claude.ai/code/session_01XHntH8UvqXQPq2zNkQMe6q
```

Use the full ID/URL, not a truncated prefix — traceability matters more than line length here, and
a short prefix risks collision as history grows. The trailer *key* varies by platform (
`Claude-Session:` for Claude Code CLI, `Cosmos-Session:` for Cosmos, etc.) since each platform's
session identifiers have their own shape.

**Why a separate trailer, not a second line on the `Co-Authored-By:` line, and not a same-key
second `Co-Authored-By:` line either:** git parses trailers as `Key: Value` pairs, one per line.
A line with no `Key:` prefix (like LittlebirdAI's second line below) is a plain text continuation,
not a second trailer — fine for a human-readable disclaimer, wrong for anything meant to be
machine-parseable. A properly keyed second line (`Claude-Session:`, distinct from
`Co-Authored-By:`) parses cleanly as its own trailer alongside the first.

## Enforcement: the `commit-msg` hook

Documenting the convention was not enough on its own — an audit on 2026-09-11 found **36 of 204**
commits in `anthropas-argus-alfred` and **183 of 856** in `trading-assistant` with no attribution
trailer at all, plus 15+ competing footer variants across the two. Writing it down is necessary;
rejecting the bad commit at the moment it is made is what actually holds the line.

`.githooks/commit-msg` blocks any commit whose message lacks a canonical `Co-Authored-By:` trailer,
and warns (without blocking) when a `<Platform>-Session:` trailer is absent. Merge, revert, fixup,
and squash commits are exempt.

**Git hooks are not version-controlled** — `.git/hooks/` never travels with a clone. The hook is
committed under `.githooks/` and activated per clone with `core.hooksPath`:

```sh
sh scripts/install-hooks.sh      # run once per clone, per machine
```

Until that runs, the hook is inert. Every agent should run it after cloning.

Human-only commits that genuinely have no agent co-author: `git commit --no-verify`.

### On backfilling old commits

The hook draws a line forward; it does not rewrite the past. Backfilling historical footers means
rewriting history, which changes every SHA — breaking `gitexporter` public mirrors, invalidating
the commit hashes cited throughout `AGENT-SYNC/` handoffs and `logs/`, and forcing every agent to
re-clone. For repos with a public mirror or an active fleet, the recommendation is **don't**: the
existing history is an honest record of a convention that did not exist yet. Each repo's owning
agent can decide, but the default is to draw the line here rather than rewrite behind it.

## `logs/` — the second area of confluence

`AGENT-SYNC/` answers *"what should the next agent do?"*. `logs/` answers *"what actually happened,
and when?"* — chronological, append-only. When a handoff omits a decision, the log is where it
stays recoverable.

```
logs/<agent>/YYYY/MM-Mon/session_YYYYMMDD_<engine>.md
```

**Private repos only.** Unlike `AGENT-SYNC/`, `logs/` has **no public counterpart** — there is no
`logs_PUBLIC/` and one should never be created. Session logs name infrastructure, in-progress work,
and client or financial context that nobody wrote with an outside reader in mind. `logs/` is
already denylisted in both `.github/workflows/sync-public.yml` (authoritative) and
`gitexporter.config.json` (local preview). Full convention and rationale: [`logs/README.md`](../logs/README.md).

## Who is LittlebirdAI?

[Littlebird](https://littlebird.ai) is Christopher's personal AI assistant. It observes his screen,
calendars, meetings, and chat history to build longitudinal context and keep the agent fleet aligned.
Unlike Claude Code CLI agents (Alfred, Fortuna), Littlebird lives in the chat layer and connects to
integrations (GitHub, Google Calendar, Gmail, etc.) to act on Christopher's behalf.

## The `created-by-Littlebird` structure

Each `created-by-Littlebird/` directory in a repo should contain:

| File | Purpose |
|---|---|
| `README.md` | Hub pointer + welcome to all agents + my role in this repo + disclaimer |
| `HANDOFF-{Agent}.md` | Specific coordination notes for that agent (e.g., `HANDOFF-Alfred.md`) |

Canonical copies to start from live in both patterns here in `my-template`:
`AGENT-SYNC/created-by-Littlebird/README.md` for Pattern A repos,
`AGENT-SYNC_PUBLIC/created-by-Littlebird/README.md` for Pattern B repos. The Pattern B copy was
missing until the Sep 9, 2026 fleet audit caught it — every Pattern B repo had a real one, but the
template itself didn't, so a new Pattern B repo had nothing to copy from.

Only link a `HANDOFF-{Agent}.md` from the table in `README.md` once the file actually exists — 9
dangling links (promised in the handoff table, never created) turned up in the Sep 9, 2026 fleet
audit.

## LittlebirdAI's commit signature

```
Co-Authored-By: LittlebirdAI · Desktop Oracle Observer & Fleet Shepherd
The Bird That Stewards the Gap — confirm observations with Christopher.
```

One `Co-Authored-By:` key — the second line is a plain continuation (a disclaimer, not a second
trailer). The format drifted across 3 variants in Littlebird's first week of GitHub access because
nothing documented it; this is the checkpoint to catch future drift against.

## Disclaimer: Observer-Generated Content

Content in `created-by-littlebird/` (and occasionally other agent lanes) is generated by LittlebirdAI.
While it strives for accuracy, observations are not guaranteed to be 100% correct and may occasionally
misinterpret context, miss nuance, or reflect stale assumptions. These handoffs are *coordination notes*,
not canonical artifacts. If anything seems off or contradicts what Christopher told you directly,
**consult Christopher before acting on it.** He is the single source of truth.

## Setting this up in a new repo

Copy this `AGENT-SYNC/` directory from `my-template` when bootstrapping a new repo — don't hand-create
the subdirectories individually each time. Include `.gitkeep` placeholders for empty directories.
