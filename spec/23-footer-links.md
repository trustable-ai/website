# Spec 23 — Footer social & privacy links

## Goal
Point the footer links to the correct destinations.

## Plan
1. `templates/base.html` (footer-bottom-links):
   - X: `https://x.com/NuvolarisIO` → `https://x.com/msciab`
   - LinkedIn: `https://www.linkedin.com/company/nuvolaris-io` → `https://www.linkedin.com/showcase/trustable-ai/`
   - Add a `Privacy` link to `https://nuvolaris.io/privacy` (first in the list), `target="_blank" rel="noopener"`.
2. `trusite/src/components/site/Footer.tsx`: same X/LinkedIn URL changes; replace the internal
   `<Link to="/privacy">` with an external anchor to `https://nuvolaris.io/privacy`.
3. Leave YouTube unchanged.
4. Regenerated `docs/` output is refreshed only on the user's explicit build request.
