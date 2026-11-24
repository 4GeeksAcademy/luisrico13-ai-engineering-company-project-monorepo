---
name: monorepo-structure
description: Where every kind of file belongs in the Brasaland monorepo; forbids parallel app trees.
scope: always
alwaysApply: true
---

# Rule: Monorepo structure

**Scope:** `always` — applies to every session and every change, regardless of the files touched.

## Why

The template already maps every responsibility to one folder. Agents that create their own `apps/` or
`backend/` folders split the codebase in two and make every later milestone harder. Brasaland needs **one**
website, **one** backoffice and **one** central API.

## Rules

1. **Read before you write.** Before creating or editing anything inside a folder, read that folder's `README.md`.
2. **Application layer — fixed locations:**
   - Public corporate website → `uis/website/` (home route `/`, brand and copy aligned with `BRIEFING.md`).
   - Internal company app → `uis/backoffice/` (its own layout, separate from the website, entry view on `/`). Operations, HR, procurement, training and executive views are **sections of this app**, not new apps.
   - Backend → `services/`. One centralized FastAPI app (planned `services/api/`) with one router per domain (`locations`, `menus`, `sales`, `customers`, `suppliers`…). A separate worker folder in `services/` only when it must run independently.
3. **Forbidden at the repo root:** `apps/`, `app/`, `frontend/`, `backend/`, `api/`, `src/`, `server/`, `client/`, `web/` or any other new top-level folder. If one seems necessary → stop and ask.
4. **Other layers:** data → `data/{raw,pipelines,process,eval}`; product AI agents → `agents/<name>/` (from `agents/_template/`); product skills → `skills/<name>/`; MCP servers → `mcps/<name>/`; n8n flows → `workflows/`; shared code used by 2+ folders → `packages/<name>/`; schemas/templates/assets → `shared/`; cross-cutting docs/ADRs → `docs/`; Docker/deploy/CI → `infra/`; local orchestration → root `docker-compose.yml`; one-file scripts → `scripts/`; internal CLIs → `internal/`.
5. **`.agents/` ≠ `agents/`.** `.agents/` configures coding agents (how we develop). `agents/` and `skills/` hold Brasaland product code. Never mix them.
6. **One subfolder per concern** with its own `README.md` (purpose, tech, how to run). When you add a subfolder, also list it in the parent folder's README.
7. **No duplicated contracts.** A type used by both `uis/` and `services/` lives in `packages/shared/` (requires confirmation, see `AGENTS.md` §4).

## How to verify

- `git status --porcelain | awk '{print $2}' | cut -d/ -f1 | sort -u` lists only folders that already exist in the template (or root files explicitly approved).
- Every new subfolder under `uis/`, `services/`, `agents/`, `mcps/`, `packages/`, `data/pipelines/` contains a `README.md`.
