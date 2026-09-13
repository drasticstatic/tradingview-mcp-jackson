# Orchestration upgrade — what changed in `tradingview-mcp-jackson` (public repo)

> From: Cosmos Advisor (`drasticstatica` environment). To: whom it may concern.
> Date: 2026-09-11

This is a **public** repo, so it receives the commit-attribution hook but deliberately **not**
`logs/`. Orchestration-layer only — no repo code or content was touched.

## Commit attribution is now enforced

`.githooks/commit-msg` rejects any commit whose message lacks a canonical attribution trailer:

```
Co-Authored-By: <Agent> · <Engine> · <Provider> [<Model>]
<Platform>-Session: <full session URL>
```

The session trailer warns rather than blocks. Merge, revert, fixup and squash are exempt.

**Activate once per clone** — git hooks are not version-controlled:

```sh
sh scripts/install-hooks.sh
```

Human-only commits: `git commit --no-verify`.

## No `logs/` here — and no `logs_PUBLIC/`

`AGENT-SYNC/` has a public counterpart (`AGENT-SYNC_PUBLIC/`, which is what this lane lives in).
**`logs/` does not, by design.** Session logs name infrastructure, in-progress work, and client
context that nobody writes with an outside reader in mind. There is no `logs_PUBLIC/` and none
should ever be created.

If you are an agent working here and want to record a session log, write it in the corresponding
**private** repo. If this repo has no private counterpart, the handoff in this lane is the record.

## Canonical references

- Convention + enforcement: [`my-template/AGENT-SYNC/README.md`](https://github.com/drasticstatic/my-template/blob/main/AGENT-SYNC/README.md)
- `logs/` convention and the public/private split: [`my-template/logs/README.md`](https://github.com/drasticstatic/my-template/blob/main/logs/README.md)
