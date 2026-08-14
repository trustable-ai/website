# 9 — Rename AIpps to Apps

The gallery is called "AIpps" everywhere: in the prose, in the nav menu, in the
`content/aipps/` and `static/aipps/` directories, and so in the public URL
`/aipps/`. Rename it to "Apps" throughout — display text and paths both.

## Two kinds of occurrence

- **Display text** — "AIpps" becomes "Apps". This is the nav entry, the landing
  page's "Customize AIpps" call to action, the section title and description,
  and the prose in specs and template comments. The **singular** "AIpp" occurs
  too and becomes "App": the landing page's "Browse every AIpp" button, the
  gallery's `AIpp groups` ARIA label, and two template comments. A search for
  `aipps` misses all four, so match `aipp`.
- **Paths and URLs** — `aipps` becomes `apps`: the `content/aipps/` and
  `static/aipps/` directories, the `/aipps/` URLs the templates build, and the
  `@/aipps/_index.md` internal links.

## The URL changes

`https://trustable.it/aipps/` becomes `https://trustable.it/apps/`, and every
application page moves with it. Existing external links and bookmarks to the old
path will 404 — zola generates no redirects and GitHub Pages serves the built
tree as-is. Accepted as the point of the rename; noted here because no later
edit can undo it for a link someone else already holds.

The stale `docs/aipps/` tree must be deleted by hand. Zola only clears what it
regenerates, so the old output would otherwise stay published alongside the new.

## Plan

1. **Directories.** `git mv content/aipps content/apps` and
   `git mv static/aipps static/apps`. The files under `content/apps/` are
   generated, but move them so the rename is one reviewable commit rather than
   a deletion and an unexplained reappearance.
2. **`generator.py`.** `CONTENT`/`STATIC` point at the new directories, and the
   icon URLs it writes become `/apps/<name>.png`. Comments and the docstring
   follow.
3. **Templates.** `base.html` (nav, twice), `starter-cards.html`
   (`get_section` path), `section.html` (the `/aipps/` path tests),
   `landing.html` ("Customize AIpps", the `@/aipps/_index.md` link),
   `docs.html` (comments).
4. **`content/apps/_index.md`.** Title and description become "Apps" — but this
   file is generated, so the real fix is whatever writes it. It is written by
   hand today, so it is edited here and left alone.
5. **`build.sh`.** `BUILD_PATHS` and the two progress messages.
6. **Specs.** 4-generate and 7-publish carry the old name in prose and paths.
   **6-starter is not renamed**: it records the earlier Starters → AIpps
   rename, and rewriting it would claim that rename produced "Apps", which it
   did not. It gets a note pointing here instead, so nobody reads its
   `content/aipps/` paths as current.
7. **Delete `docs/aipps/`** and rebuild, so the published tree holds only
   `/apps/`.

## Out of scope

The group names inside the gallery (Chat, Demo, Examples, Utilities) and the
application names are untouched. The catalog in `support/index.json` does not
carry the word.
