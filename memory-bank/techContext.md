# Tech Context — Brasaland Digital Monorepo

> **Type:** technical context. Update this file in the **same change** that introduces a new dependency,
> tool, folder, service, environment variable or architectural decision.

## Tech stack

### Development environment (decided — from `.devcontainer/devcontainer.json`)

| Tool                         | Version / notes                                                             |
| ---------------------------- | --------------------------------------------------------------------------- |
| Base image                   | Ubuntu 24.04 (`mcr.microsoft.com/devcontainers/base:ubuntu-24.04`)          |
| Python                       | 3.12 (+ JupyterLab) · dependencies managed with **uv** (`uv sync`)          |
| Node.js                      | 22 · package manager **pnpm** via corepack                                  |
| Containers                   | Docker outside of Docker                                                    |
| GitHub                       | `gh` CLI available                                                          |
| Forwarded ports              | `3000` (frontends) · `8000` (API) · `5678` (n8n)                            |

`postCreateCommand` only installs dependencies **if** a root `package.json` / `pyproject.toml` exists. Neither exists yet.

### Application stack

| Layer                   | Decision                                                                                   | Status      |
| ----------------------- | ------------------------------------------------------------------------------------------ | ----------- |
| Backend API             | **One centralized FastAPI app** under `services/` with one router per domain               | Decided     |
| Shared types            | TypeScript package `@repo/shared-types` in `packages/shared/`                              | Exists      |
| Automations             | n8n (port 5678) — exports in `workflows/`                                                  | Decided     |
| Local orchestration     | `docker-compose.yml` at the **repo root** (not inside `infra/`)                            | Decided     |
| Frontend framework      | Not chosen yet (`uis/website`, `uis/backoffice`)                                           | **Pending** |
| Database                | Not chosen yet                                                                             | **Pending** |
| Authentication          | Not chosen yet (backoffice must be internal-only)                                          | **Pending** |
| Hosting / CI            | Not chosen yet (configs go to `infra/`)                                                    | **Pending** |
| Lint / test tooling     | Not configured yet — no root lint/test commands exist                                      | **Pending** |

> Agents must **not** pick a pending technology on their own. Propose options and wait for developer confirmation, then record the decision below.

## Monorepo map

The folders already exist in the template. **Never create a parallel tree** (no `apps/`, `frontend/`, `backend/`, `api/` at the root, etc.). Read the folder's `README.md` before adding anything.

| Path                     | Purpose                                                                                        |
| ------------------------ | ---------------------------------------------------------------------------------------------- |
| `uis/website/`           | Public corporate website — home route `/`, brand and copy aligned with `BRIEFING.md`           |
| `uis/backoffice/`        | Internal company app — own layout, separate from the website, entry view on `/`                |
| `uis/<other>/`           | Other UIs (dashboards, Streamlit/Gradio tools) — one subfolder per concern                     |
| `services/<service>/`    | Backend services. The central FastAPI app lives in one subfolder (planned: `services/api/`)    |
| `data/raw/`              | Untouched source data (synthetic/anonymised only)                                              |
| `data/pipelines/`        | ETL/ELT jobs                                                                                   |
| `data/process/`          | Pipeline outputs                                                                               |
| `data/eval/`             | Evaluation datasets and metrics                                                                |
| `agents/<agent>/`        | Company AI agents (product code), start from `agents/_template/`                               |
| `skills/<skill>/`        | Company/product agent skills (product code), start from `skills/_template/`                    |
| `mcps/<server>/`         | MCP servers                                                                                    |
| `workflows/`             | n8n / automation exports                                                                       |
| `packages/<pkg>/`        | Versionable shared libraries (`packages/shared` = `@repo/shared-types`)                        |
| `shared/`                | Schemas, templates, static assets                                                              |
| `docs/`                  | Cross-cutting architecture docs and ADRs                                                       |
| `infra/`                 | Dockerfiles, deploy, CI/CD                                                                     |
| `scripts/`               | Single-file helper scripts                                                                     |
| `internal/`              | Internal CLIs with their own package/tests                                                     |
| `memory-bank/`           | Persistent context for coding agents (this folder)                                             |
| `.agents/rules/`         | Development rules for coding agents                                                            |
| `.agents/skills/`        | Development skills for coding agents                                                           |

⚠️ `.agents/` (coding-agent configuration: how we develop) ≠ `agents/` and `skills/` (Brasaland product code).

## Architectural decisions

| ID      | Date       | Decision                                                                                                 | Status   |
| ------- | ---------- | -------------------------------------------------------------------------------------------------------- | -------- |
| ADR-001 | 2026-11-16 | Single monorepo; application code only in the template folders (`uis/website`, `uis/backoffice`, `services/`) | Accepted |
| ADR-002 | 2026-11-16 | One centralized FastAPI backend in `services/`; extract workers only when strictly needed                | Accepted |
| ADR-003 | 2026-11-16 | `BRIEFING.md` (root) is the business source of truth; `memory-bank/` is the agent working context        | Accepted |
| ADR-004 | 2026-11-16 | Coding-agent protocol lives in `AGENTS.md` + `.agents/rules/` + `.agents/skills/`                        | Accepted |
| ADR-005 | 2026-11-16 | Domain data conventions (currency, country, timezone, language) defined in `.agents/rules/brasaland-domain-conventions.md` | Accepted |

## Technical constraints

- **Money:** never `float`. Use decimal types and always store an ISO 4217 code (`COP` or `USD`) next to the amount. Conversions are explicit and record the rate and date.
- **Countries:** ISO 3166-1 alpha-2 codes `CO` and `US`; every location record has a country.
- **Time:** store timestamps in UTC (ISO 8601); render in the location's timezone (`America/Bogota` for Colombia, `America/New_York` for Florida unless a location says otherwise).
- **Languages:** locales `es-CO` and `en-US`; no hard-coded user-facing copy in only one language without a plan for the other.
- **Data privacy:** no real PII, payroll, supplier prices or master recipes in the repo. Use synthetic data in `data/raw/`.
- **Secrets:** only via environment variables; `.env*` files are never committed (provide `.env.example`).
- **Shared contracts:** a type used by both `uis/` and `services/` goes into `packages/shared/` — never duplicated.
- **No root workspace runner yet:** adding a root `package.json`/`pyproject.toml` changes devcontainer behaviour and requires developer confirmation.
