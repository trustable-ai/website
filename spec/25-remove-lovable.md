# Spec 25: Remove every "Lovable" reference

## Goal

Eliminate all references to "Lovable" from site text, metadata and titles.
Replace with the phrase **"Build Apps with Local AI on your PC"** (adapted
grammatically to each sentence).

## Occurrences to change

| File | Line | Current |
|---|---|---|
| `config.toml` | 3 | site `description` — "A Lovable-like experience for Private AI. …" |
| `content/_index.md` | 2 | `title` — "Trustable — A Lovable-like Experience for Private AI" |
| `content/documentation/_index.md` | 3, 10 | description + body "a Lovable-like experience for building…" |
| `content/architecture/introducing-nuvolaris/index.md` | 40 | "It is a Lovable-like experience for Private AI: …" |
| `content/architecture/components/index.md` | 34 | "a Lovable-like experience where you describe…" |
| `templates/landing.html` | 3, 5 | `title` and `description` blocks |

## Plan

1. Branch `spec-25`.
2. Rewrite each occurrence so the "Lovable-like experience" wording becomes
   "Build Apps with Local AI on your PC" (or "build apps with local AI on your
   PC" inside a sentence), keeping the rest of the sentence intact.
3. Verify no `lovable` (case-insensitive) remains in `config.toml`, `content/`,
   `templates/`, `static/`.
4. Rebuild (`./build.sh`) so `docs/` is regenerated — on user request.
