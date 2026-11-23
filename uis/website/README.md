# Brasaland public website

First public-facing website for Brasaland, aligned with the company briefing. It uses static HTML and the Tailwind CSS CDN; no framework or package installation is required.

## Pages

- `index.html` — Spanish-language landing page and company information.
- `application.html` — contact form for interested customers.
- `validation.js` — client-side validation and form feedback.

## Run locally

From the repository root, serve the workspace with any static HTTP server. For example:

```bash
npx http-server uis/website -p 3000 -a 0.0.0.0
```

Then open `http://localhost:3000` (or the forwarded port in Codespaces). The Tailwind CDN requires an internet connection during development.

## Notes

- The form is a front-end demonstration and does not send or persist submissions.
- Public-facing copy uses Spanish (`es-CO`) as the initial base language; English localization is a future enhancement.
- Do not add unverified location addresses, contact details, customer information, recipes, or supplier data.
