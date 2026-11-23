# Progress

Last updated: 2026-11-23

## Current state

- **Milestone:** Public website — first Brasaland customer-facing site.
- **Branch:** `feature/brasaland-public-website` (created from the current repository state; the pre-existing local change to `memory-bank/projectbrief.md` remains untouched).
- **Application code:** initial static website in `uis/website/`: Spanish landing page, contact form, browser-side validation, and folder documentation.
- **Agent infrastructure:**
  - `BRIEFING.md` — official Brasaland company briefing at the repo root.
  - `memory-bank/` — `projectbrief.md` (business), `techContext.md` (technical), `progress.md` (this file).
  - `AGENTS.md` — session start protocol, mandatory pre-commit workflow, protected paths.
  - `.agents/rules/` — `monorepo-structure.md` (always), `brasaland-domain-conventions.md` (file-pattern), `git-and-pr-conventions.md` (agent-requested).
  - `.agents/skills/update-memory-bank/` — skill + verification script.

## Next steps

1. Review the website in a browser at mobile, tablet and desktop widths; refine any visual issues.
2. Exercise the contact form with valid and invalid values, including keyboard-only navigation and screen-reader announcements.
3. Run the required checks, update/verify memory-bank records, and request developer approval before the first website commit.
4. After this website milestone, continue with the next platform priorities: central FastAPI API, local orchestration, quality tooling and shared domain types.

## Known issues / open questions

- The list of the 14 locations (names, cities) is not in `BRIEFING.md` — do not invent it; ask the developer.
- Website form is a client-side demonstration only; submissions are not sent or persisted.
- English localization, database, auth and hosting remain future decisions.
- No automated lint/test commands exist yet; the pre-commit workflow runs only the memory-bank verification and `git diff --check` until they do.

## Changelog

### 2026-11-23

- Started the public website milestone on `feature/brasaland-public-website` without modifying the pre-existing local change in `memory-bank/projectbrief.md`.
- Added a responsive Spanish landing page, Schema.org restaurant metadata, and a contact form with client-side validation in `uis/website/`.
- Recorded the static HTML + Tailwind CDN implementation in `techContext.md`.

### 2026-11-16

- Added `BRIEFING.md` (Brasaland general briefing) and pointed `CONTEXT.md` to it.
- Created memory bank (`projectbrief.md`, `techContext.md`, `progress.md`).
- Replaced the empty `AGENTS.md/` directory with the `AGENTS.md` protocol file.
- Added `.agents/rules/` (3 rules, one per scope type) and the `update-memory-bank` skill with `verify_memory_bank.sh`.
