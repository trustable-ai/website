# 6 — Rename "Starters" to "AIpps"

> **Superseded by spec/9-apps.md.** "AIpps" was later renamed again to "Apps",
> so `content/aipps/`, `static/aipps/` and the `/aipps/` URLs described below
> are now `apps`. This spec is kept as the record of the Starters → AIpps
> rename; read it for that history, not for current paths.

The starter gallery is rebranded as **AIpps**. This renames the content tree,
the icon directory, and every user-visible occurrence of the old wording.

## Original request

- rename the folder `content/starter` to `content/aipps`
- change the menu entries `Starter` to `AIpps`
- in the home page rename "starters and templates" with "Customize AIpps"

## Decisions

The rename changes public URLs from `/starter/...` to `/aipps/...`.

- **No redirects.** The old paths simply stop existing; `/starter/` and its
  application pages return 404. A clean break, not an aliased one.
- **Icons move too.** `static/starter/` becomes `static/aipps/`, so icons are
  served from `/aipps/<icon>.png` and the word "starter" survives nowhere in
  the published site.
- **All user-visible text is updated**, not only the two strings named above.

## Changes

### Generated content — `generator.py`

`content/starter/` is entirely generator output, so the rename belongs in the
generator, not in a one-off `git mv` that the next build would undo.

- `CONTENT` → `HERE / "content" / "aipps"`
- `STATIC` → `HERE / "static" / "aipps"`
- the icon URL it emits → `/aipps/{icon.name}`
- module docstring and the comment guarding the delete-and-rewrite step

Run it to regenerate the tree, and delete the now-orphaned `content/starter/`
and `static/starter/`.

### Section front matter — `content/aipps/_index.md`

Written by the generator: `title = "AIpps"`, description and body reworded off
"Starter projects for Trustable."

### Templates

| File | Change |
|---|---|
| `base.html` | nav loops: `starter/_index.md` → `aipps/_index.md` (two places) |
| `landing.html` | step label `Starters &amp; Templates` → `Customize AIpps`; CTA `@/starter/_index.md` → `@/aipps/_index.md`; button text → `Browse every AIpp` |
| `section.html` | path tests `/starter/` → `/aipps/` (two places) |
| `starter-cards.html` | `get_section(path="starter/_index.md")` → `aipps/_index.md`; tab-list label `Starter groups` → `AIpp groups` |

The partial keeps its filename `starter-cards.html` — it is an internal include
name, never visible to a visitor, and renaming it is churn without benefit.
Prose comments in the templates are updated where they name the old paths.

### `build.sh`

`BUILD_PATHS` → `content/aipps static/aipps index.json docs`, plus the comments
and the commit message that call it "the starter gallery".

## Out of scope

`trustable-ai` remains the GitHub organisation name and is untouched, as
established in `spec/5-domain.md`. The upstream catalog `index.json` keeps its
own vocabulary — this rename is the website's presentation, not the catalog's.

## Verification

- `grep -rni 'starter' content/ static/` returns nothing.
- No user-visible "Starter" remains in `docs/`; the only hits are the internal
  include name `starter-cards.html` and template comments.
- `/aipps/` renders the gallery; the four group indexes and every application
  page render under `/aipps/<group>/<app>/`.
- Icons resolve from `/aipps/<icon>.png`.
- Zola's internal-link check passes, so no `@/starter/...` reference survives.
- `docs/sitemap.xml` lists `/aipps/*` and no `/starter/*`.
