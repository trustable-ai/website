# Spec 24 — Hero title: "Build Apps with Local AI"

## Goal

Replace the splash hero title "Lovable-like experience / for Private AI" with
"Build Apps with Local AI".

## Plan

1. In `index.html` (the splash/app landing page), change the `h1.hero__title`:
   - `hero__main` → `Build Apps with`
   - `hero__accent` → `Local AI`
   This keeps the existing two-tone styling (white main line, accent line).
2. No other files touched. Site-wide taglines in `config.toml`, `content/**`
   and `templates/landing.html` are out of scope for this spec.
3. Rebuild the site when the user asks (`zola build`), then PR/merge/push.

## Status

Implemented in step 1.
