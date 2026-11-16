# Project Brief — Brasaland Digital Platform

> **Type:** business context · **Source of truth:** [`BRIEFING.md`](../BRIEFING.md)
> If this file and `BRIEFING.md` disagree, `BRIEFING.md` wins — stop and ask the developer before "fixing" either.

## Business description

**Brasaland** is a grilled-food restaurant chain founded in 2008 in Medellín, Colombia.

| Fact                | Value                                                                  |
| ------------------- | ---------------------------------------------------------------------- |
| Locations           | 14 company-owned restaurants                                           |
| Markets             | Colombia and United States (Florida)                                   |
| Headcount           | ~115 people (kitchen, floor, operations, corporate)                    |
| Annual revenue      | ~USD 6M                                                                |
| Headquarters        | Medellín (HQ) · Miami (commercial and operations office for Florida)   |
| Currencies          | COP (Colombia) and USD (Florida)                                       |
| Languages           | Spanish and English                                                    |
| Brand promises      | Same taste in every location · warm, consistent service · fast kitchen |

We are **Brasaland Digital**, the internal team created by the CEO to build the tools, systems and
automations that let Brasaland operate like a modern company without losing its identity.

### Stakeholders

| Area                             | Owner                       | Main need (from the briefing)                                                            |
| -------------------------------- | --------------------------- | ---------------------------------------------------------------------------------------- |
| Executive Direction              | Mariana Restrepo (CEO)      | Executive dashboard (USD + COP), natural-language AI assistant, Monday 7am weekly report |
| Technology                       | Nicolás Park (CTO)          | Central API (locations, menus, sales, customers, suppliers), telemetry, data pipeline    |
| Restaurant Operations            | Felipe Guerrero             | Real-time sales per location, smart ingredient ordering, no-sales alerts                 |
| Procurement and Suppliers        | Lucía Fernández             | Supplier platform with price history/alerts, consolidated purchasing                     |
| Marketing and Digital Experience | Camila Ospina               | Loyalty + ordering app (replace "Brasa Points" stamp cards), CRM, personalisation        |
| People and Culture               | Ashley Turner (Miami)       | HR portal (holidays/absences), automated onboarding, HR KPIs by country                  |
| Training and Quality Standards   | Jake Morrison (Miami)       | Searchable recipe catalogue, onboarding path, simultaneous recipe updates (es/en)        |

## Problem it solves

Brasaland runs a two-country, 14-location operation with tools built for a single local restaurant:

- **No central visibility** — each location operates in isolation; leadership relies on phone calls and Tuesday PDF reports.
- **No data** — ingredient orders via WhatsApp/phone, purchasing in email/Excel, loyalty on physical stamp cards (60% of customers don't use them).
- **Fragmented tech** — 2019 static website with no online orders, an app rated 2.8, a different POS per country with no integration, spreadsheets as management systems, no API and no telemetry.
- **Manual people processes** — HR and onboarding by email/Excel across two labour markets with high kitchen turnover.
- **Hard-to-maintain standards** — training material in an unnavigable shared drive; recipe changes take days to reach all locations in two languages.

Competitors with digital ordering, data-driven marketing and operational dashboards are gaining ground.

## Project objectives

Build, inside this single monorepo, Brasaland's digital platform from near-zero, milestone by milestone:

1. **Public website** (`uis/website`) — modern brand presence, aligned with the briefing.
2. **Internal backoffice** (`uis/backoffice`) — one internal app hosting operations, HR, procurement, training and executive views.
3. **Central company API** (`services/`) — single FastAPI backend: locations, menus, sales, customers, suppliers.
4. **Data and telemetry** (`data/`) — pipelines that consolidate sales/operations data from both countries into dashboards.
5. **AI capabilities** (`agents/`, `skills/`, `mcps/`) — e.g. natural-language assistant for the CEO, manager support agent, demand forecasting.
6. **Automations** (`workflows/`) — e.g. the Monday 7am executive weekly report, no-sales alerts.

### Objective of the current milestone (AI-driven Engineering)

Give the repository persistent, agent-readable context and a delivery protocol **before** any application code
is written: memory bank, `AGENTS.md`, `.agents/rules/` and at least one verifiable `.agents/skills/` skill.
No application code is created in this milestone.

## Business constraints the product must respect

- **Two currencies:** every monetary value is COP or USD and must say which. Chain totals are shown in both.
- **Two languages:** Spanish and English. Pick one base language per feature and design for the other.
- **Two countries:** labour rules, timezones and suppliers differ between Colombia and Florida — reports are segmented by country.
- **Consistency is the brand:** the same recipe/standard must reach every location at the same time.
- **Confidential data** — must never be exposed publicly or committed to the repo:
  - master recipes / exact proprietary formulas,
  - supplier contract terms and negotiated prices,
  - payroll data and performance reviews,
  - customer (Brasa Points) personal data.
- **Users are non-technical** (managers with high turnover, executives): UIs must be simple and self-explanatory.

## Out of scope (for now)

- Replacing the POS systems themselves (we integrate with their data, we don't rebuild them).
- Any real customer, employee or supplier data in the repository — use synthetic data only.
