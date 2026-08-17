# 12 — Generate app pages from the GitHub README

> **Section 2 superseded by spec/13-generate.md.** "Absolute screenshot URL, no
> local copy" is reversed: every image is downloaded into `static/images/` and
> referenced at a site-absolute `/images/<owner>-<repo>.png`, so the published
> site reaches only its own origin. Section 1 — the README, not the templates
> repo, as the source of page copy — still holds, as does the rule that the
> screenshot must appear once and the hero is the copy that stays.

`generator.py` takes the page copy from the `*-templates` repositories, and
copies each application's screenshot into `static/apps/`. Both are now wrong:

- the copy in the templates repos is the **prompt** used to build the
  application ("Step 1 — Create the Mini CRM Foundation"), not a description of
  it. Every application repo now carries a real README describing what the
  application does; that is what the gallery should show.
- the icon is copied locally, so the catalog's `icon` URL is downloaded, saved
  under `static/apps/<name>.png` and served from there. Meanwhile every README
  illustrates itself with a **relative** `![Title](screenshot.png)`, which
  resolves to nothing once the markdown is rendered under `/apps/<group>/<name>/`.

## Plan

### 1. Read the README, not the templates

Drop `*-templates` from the generator entirely.

- `body_for()` returns the application repo's `README.md` and nothing else. The
  `<templates>/<name>.md` lookup and the search across sibling checkouts go.
- The clone step follows: only the repos named by an application's `repo` field
  are cloned, one per application. `templates_repo()` is removed — it existed
  only to associate an application with the templates repo its icon came from.
- The README is read from the clone (`.templates/<name>/README.md`), so a build
  reads every file from disk and `--offline` keeps working. `fetch_readme()` and
  the `requests` dependency are no longer needed and go with it.

The stub fallback stays: a README that is only `# Trustable Workspace` still
falls back to the catalog description, as does an empty or missing one — but it
now prints a warning naming the repo, since with the README as the only source
of copy a silent fallback leaves a one-line page with no indication why.

### 2. Absolute screenshot URL, no local copy

The screenshot is referenced at its raw GitHub URL everywhere and never copied
into the site.

- `copy_icon()` is replaced by using the catalog's own `icon` field — already an
  absolute `https://raw.githubusercontent.com/<owner>/<name>/refs/heads/main/screenshot.png`
  — as `extra.icon` verbatim. `static/apps/` and `clean_icons()` go; the
  directory is deleted from the repo.
- Relative image links in the README body are rewritten to that same raw base:
  `![Mini CRM](screenshot.png)` becomes
  `![Mini CRM](https://raw.githubusercontent.com/trustable-ai/minicrm/refs/heads/main/screenshot.png)`.
  The rewrite applies to every relative markdown image in the body, not only
  `screenshot.png` — a README may illustrate a second view — and leaves
  absolute (`http:`, `https:`, `//`, `/`) sources alone.
- **The screenshot must appear once, not twice.** After the rewrite the
  README's own illustration is the same URL as `extra.icon`, which `page.html`
  already renders as the page hero, so each application page showed its
  screenshot twice. `drop_icon_image()` removes from the body any image alone
  on its line whose source equals the icon, and collapses the blank run left
  behind. The hero is the copy that stays: the gallery tile is built from the
  same `extra.icon`, so tile and page cannot drift apart. A README image that
  is not the icon is untouched.
- `build.sh`'s `BUILD_PATHS` drops `static/apps`.

`templates/page.html` and `templates/starter-cards.html` need no change: both
already emit `extra.icon` into `src` through `| safe`, so an absolute URL works
as it stands.

This reverses the "downloaded into the site rather than hotlinked" decision in
spec/4-generate.md: the published pages now do reach
raw.githubusercontent.com for every screenshot. The trade is deliberate — one
source of truth for a screenshot, no copies to keep in sync or expire out of
`static/apps/`.

### 3. Update spec/4-generate.md

Rewrite its "Copy taken locally" and "Detail page" sections to describe the
README-and-raw-URL model, and drop `static/apps/<name>.png` from the output
listing.

## Result

```
content/apps/<group>/<name>.md   body = the application repo's README.md
                                 extra.icon = the catalog's raw.githubusercontent.com URL
static/apps/                     removed
```
