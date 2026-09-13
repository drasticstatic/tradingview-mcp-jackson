# `created-by-cosmos/`

Handoffs written by Cosmos agents. **One lane for all of them** — no environment or expert suffix.

## Why a single lane

This started as two directories, `created-by-cosmos_Advisor-drasticstatic` and
`…-drasticstatica`, one per Cosmos environment. The names differed by a single trailing letter,
which is exactly the kind of distinction that looks meaningful in a directory listing and tells you
nothing useful. Worse, it pushed a fact into the *path* that belongs in the *document*.

A handoff should say who wrote it and where it ran. If it does that, the path doesn't need to, and a
reader browsing `AGENT-SYNC/` sees one obvious place to look instead of two near-identical ones.

The same reasoning covers the code-review experts (PR Author, Deep Code Reviewer, PR Risk Analyzer,
and the rest). They do not get their own lanes. Cosmos Advisor is the coordination liaison: work
that needs recording lands here, attributed in the header, regardless of which expert did it.

## Header convention

Every handoff opens with enough provenance to be read years later by someone who no longer has the
session:

```markdown
# <Title>

**From:** Cosmos Advisor · environment `drasticstatic`
**Session:** https://cosmos.augmentcode.com/session?agentId=<id>
**Date:** YYYY-MM-DD
**For:** <who picks this up — Mystarch, Alfred, Christopher, or whoever next opens this repo>
```

Environment matters enough to state, because it determines what the author could actually see.
`drasticstatic` reaches all 32 repositories; `drasticstatica` was the narrower setup chat. A claim
like "verified across the fleet" is only credible from an environment that can see the fleet.

## Naming

`YYYY-MM-DD_short-description.md` — dates sort correctly and read unambiguously.

## What belongs here

Durable cross-session context: decisions and the reasoning behind them, work left deliberately
unfinished and why, findings another agent would otherwise rediscover the hard way.

Not: routine progress narration, or anything that is already obvious from the commit history.

---

*Private repositories use `AGENT-SYNC/`. Public repositories use `AGENT-SYNC_PUBLIC/` and must never
contain an `AGENT-SYNC/`. Convention source:
[`my-template`](https://github.com/drasticstatic/my-template).*
