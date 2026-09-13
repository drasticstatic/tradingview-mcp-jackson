# AGENT-SYNC_PUBLIC

Agent coordination that is **safe to publish**.

## Which directory does this repo use?

Decide once, by repository visibility. `scripts/scaffold-agent-sync.sh` makes the choice for you
and creates the right layout.

| | Private repo | Public repo |
|---|---|---|
| `AGENT-SYNC/` | ✅ the coordination lane | ❌ do not create |
| `AGENT-SYNC_PUBLIC/` | ✅ only for material meant to reach the public mirror | ✅ the coordination lane |
| `logs/` | ✅ | ❌ **never** — and no `logs_PUBLIC/` exists |

**Private repo.** `AGENT-SYNC/` is the working lane and is filtered out of the public mirror.
`AGENT-SYNC_PUBLIC/` is optional here — use it only for coordination you intend to publish. Both
live in the private source; the sync pipeline is what separates them.

**Public repo (no private counterpart).** `AGENT-SYNC_PUBLIC/` is the only lane. Repos like
`resume` and `gratitude-token-project_docs` work this way.

## Assume every word here is public

This directory is either already public or explicitly allowlisted to become public. Write
accordingly:

- No infrastructure detail, credentials, tokens, or internal hostnames
- No client, financial, legal, or custody specifics
- No in-progress work you would not want read by a stranger
- Link to private material by **pointer**, never by copying it inline

That last point is the working pattern: a public skill or handoff may reference `specs/…` in a
private repo by path, so the public artifact stays useful as a teaching example while the sensitive
detail stays private.

## Convention

Files are written **by** one agent, named for the **recipient**, inside the author's own lane:

```
AGENT-SYNC_PUBLIC/created-by-<author>/<RECIPIENT>_PROMPT_YYYYMMDD.md
```

Never add content to another agent's lane — create your own file instead.

## No logs here

`logs/` is private-repo-only and has no public counterpart by design. If you are an agent working
in a public repo and want to record a session log, write it in the corresponding private repo. See
[`logs/README.md`](../logs/README.md).
