# Progress

Last updated: 2026-11-16

## Current state

- **Milestone:** AI-driven Engineering — agent infrastructure for the monorepo.
- **Branch:** `feature/agent-memory-bank`.
- **Application code:** none yet. `uis/` and `services/` only contain their template READMEs.
- **Agent infrastructure:**
  - `BRIEFING.md` — official Brasaland company briefing at the repo root.
  - `memory-bank/` — `projectbrief.md` (business), `techContext.md` (technical), `progress.md` (this file).
  - `AGENTS.md` — session start protocol, mandatory pre-commit workflow, protected paths.
  - `.agents/rules/` — `monorepo-structure.md` (always), `brasaland-domain-conventions.md` (file-pattern), `git-and-pr-conventions.md` (agent-requested).
  - `.agents/skills/update-memory-bank/` — skill + verification script.

## Next steps

1. Merge `feature/agent-memory-bank` into `main` after PR approval.
2. Decide the frontend framework for `uis/website` and `uis/backoffice` (record in `techContext.md`).
3. Decide database and scaffold the central FastAPI app in `services/api/` with a `/health` endpoint.
4. Add root `docker-compose.yml` wiring the API (and DB) for local development.
5. Configure lint/test tooling (Python: ruff + pytest via uv; TypeScript: eslint + test runner via pnpm) and add the commands to `AGENTS.md`.
6. Define first domain types (`Location`, `Money`, `MenuItem`) in `packages/shared`.

## Known issues / open questions

- The list of the 14 locations (names, cities) is not in `BRIEFING.md` — do not invent it; ask the developer.
- Frontend framework, database, auth and hosting are pending decisions.
- No automated lint/test commands exist yet; the pre-commit workflow runs only the memory-bank verification and `git diff --check` until they do.

## Changelog

### 2026-11-16

- Added `BRIEFING.md` (Brasaland general briefing) and pointed `CONTEXT.md` to it.
- Created memory bank (`projectbrief.md`, `techContext.md`, `progress.md`).
- Replaced the empty `AGENTS.md/` directory with the `AGENTS.md` protocol file.
- Added `.agents/rules/` (3 rules, one per scope type) and the `update-memory-bank` skill with `verify_memory_bank.sh`.
