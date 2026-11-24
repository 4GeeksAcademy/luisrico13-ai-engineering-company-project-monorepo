---
name: brasaland-domain-conventions
description: Domain data conventions (money, countries, time, language, confidential data) for Brasaland product code and data.
scope: file-pattern
alwaysApply: false
globs:
  - "uis/**"
  - "services/**"
  - "packages/**"
  - "shared/**"
  - "data/**"
  - "agents/**"
  - "mcps/**"
  - "workflows/**"
---

# Rule: Brasaland domain conventions

**Scope:** `file-pattern` — applies whenever you create or edit files matching the `globs` above
(product code, shared contracts, data and automations). It does not apply to docs-only changes in `docs/`,
`memory-bank/` or `.agents/`.

## Why

Brasaland operates 14 locations in **two countries, two currencies and two languages**
(see `BRIEFING.md`). Mixing COP and USD, losing a timezone or leaking a supplier price breaks the CEO's
dashboards and the company's trust. These conventions keep every app, API and pipeline consistent.

## Rules

### Money

- Never use binary floats for money. Use `Decimal` (Python) or a decimal string / integer minor units (TypeScript).
- Every amount travels with its ISO 4217 currency: `{ "amount": "45000.00", "currency": "COP" }`. Allowed: `COP`, `USD`.
- Never add COP and USD together. Chain totals are reported **per currency**, or converted explicitly with the exchange rate and its date stored alongside.

### Countries, locations and time

- Country codes are ISO 3166-1 alpha-2: `CO`, `US`. Every location has a `country` and a `timezone`.
- Timezones: `America/Bogota` (Colombia), `America/New_York` (Florida) unless the location record states otherwise.
- Store timestamps in UTC, ISO 8601. Convert to local time only for display and for "opening hours" logic.
- Reports and KPIs (sales, HR, purchasing) must be segmentable by country and by location.
- Do not invent location names, addresses or counts beyond "14 locations in Colombia and Florida". Ask.

### Language

- Supported locales: `es-CO`, `en-US`. User-facing copy goes through a translation mechanism or a clearly marked single base language with the other planned.
- Code identifiers, API fields and commit messages are in English.

### Naming

- API resources and DB tables in plural English `snake_case` (`locations`, `menu_items`, `sales`, `suppliers`).
- JSON fields `snake_case` in the API; TypeScript types in `packages/shared` use `PascalCase` names.

### Confidential data — never in code, fixtures, prompts or logs

- Master recipes / exact proprietary formulas.
- Supplier contract terms and negotiated prices.
- Payroll, salaries and performance reviews.
- Customer (Brasa Points) personal data.

Use clearly synthetic data (e.g. `Demo Location 01`, `supplier_demo_a`) in `data/raw/`, tests and seeds.

## How to verify

- `grep -rnE "float\(|: *float|parseFloat" <changed money code>` returns no money-related usage.
- Every money field in new schemas has a sibling `currency` field.
- No file under the globs contains real personal names of customers/employees, real prices or recipe quantities.
