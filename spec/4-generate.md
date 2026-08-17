# 4 — Generate the Apps gallery

`generator.py` is a [uv](https://docs.astral.sh/uv/) script (PEP 723 header, no
dependencies beyond the standard library and the `gh` CLI). It builds the
catalog of the `trustable-ai` organization, downloads every image the site
shows, and turns both into Zola content. Since spec/13-generate.md it is the
only script the build runs, and the only one that talks to the GitHub API.

```bash
./generator.py            # fetch the catalog, pull the clones, regenerate
./generator.py --offline  # reuse static/index.json and the existing clones
```

The catalog logic — the `Trustable:` marker, `templates=`, the `_index.md`
listing and its grouping — is specified in spec/8-index.md, which
`support/index.py` implements too for Trustable's own discovery. The website no
longer reads that submodule's `index.json`.

## build.sh runs it

`build.sh` regenerates the catalog and the gallery before every build, so the
published site always matches what the organization looks like today:

1. `generator.py` — fetch the catalog from the GitHub API, write
   `static/index.json`, pull the application repos, download their images into
   `static/images/`, rewrite `content/apps/`
2. `zola build --output-dir docs` (only for `./build.sh build`; the default
   serves a preview instead)
3. **commit** the result, if anything changed

The commit is confined to the paths the build owns — `content/apps/`,
`static/index.json`, `static/images/` and `docs/` — so unrelated edits in the
working tree are never swept into it. Nothing is committed when those paths
come back unchanged, and the commit is never pushed; publishing is the
PR-and-merge process in CLAUDE.md.

Two escape hatches, because a build that always commits is wrong in some
contexts:

- `./build.sh` / `./build.sh serve` — regenerate, then preview on
  http://127.0.0.1:1111. Writes no `docs/` and commits nothing.
- `NO_COMMIT=1 ./build.sh build` — write `docs/` but leave the result in the
  working tree. This is also what a detached HEAD gets automatically, since
  committing there would strand the commit.
- `./build.sh [serve|build] --fast` — reuse the catalog and images from the last
  full run (`generator.py --offline`) instead of asking GitHub for them. Pages
  are still regenerated, so template and generator changes show up; only the
  network work is skipped, and neither `gh` nor a connection is needed. For
  iterating locally — a publishing build should be a full one.

Regenerating needs the network and the `gh` CLI on every build. `build.sh`
checks for an authenticated `gh` up front, since the requirement is the
website's own now rather than something inherited from the `support` submodule.
If generation fails the build stops rather than silently publishing a stale
catalog — and the "no starters" guard runs **before** anything is deleted, so an
API hiccup cannot blank an existing gallery.

## Input and output catalog

The input is the `trustable-ai` organization itself, read through `gh`. The
catalog built from it is written to `static/index.json` and published at
`https://trustable.it/index.json`:

```json
{
  "generated":    "2026-08-17T09:00:00Z",
  "starters":     [ { "name", "repo", "templates", "description" } ],
  "applications": { "<Group>": [ { "name", "title", "repo", "icon", "description" } ] }
}
```

`applications` is a map of **group** → list of applications. Group order in the
JSON is the order the gallery uses. Each `icon` is the full
`https://trustable.it/images/<file>` URL of the downloaded copy, since whatever
reads this catalog is not being served from this site; the generated pages keep
the bare `/images/<file>` path instead, which also resolves under a local
preview. An application whose image could not be fetched carries no `icon` at
all. `starters` is written through unchanged — its `repo` and `templates` are
where a user clones from, so they keep naming GitHub.

With `--offline` this file is the **input** instead: the catalog is read back
from it and the images already in `static/images/` are reused, so a rebuild
needs no network at all.

## Copy read from the README

The page body is the application repository's own `README.md` — see
spec/12-readme.md. The generator clones (or pulls) each application repo once
into `.templates/<name>/`, a gitignored working directory, and reads the README
out of it. The clones deliberately sit **outside** `content/`: zola parses every
file below it and a bare repo README carries no front matter, which fails the
build.

The `*-templates` repos are **not** read. Their per-application markdown is the
prompt an application was built from ("Step 1 — Create the Mini CRM
Foundation"), not a description of what it does.

A README that is only the `# Trustable Workspace` stub, or empty, falls back to
the catalog description.

## Screenshots served from trustable.it

Every image the site shows is copied into `static/images/` and referenced at a
site-absolute path, so a published page reaches nothing but its own origin.
This reverses the hotlinking of spec/12-readme.md — see spec/13-generate.md for
the trade.

The name is the repository the image came from:

```
static/images/<owner>-<repo>.png          screenshot.png at the repo root
static/images/<owner>-<repo>-<path>.<ext> any other image in the README
```

So `trustable-ai/minicrm`'s `screenshot.png` is `trustable-ai-minicrm.png`,
served at `https://trustable.it/images/trustable-ai-minicrm.png`. Deriving the
name from owner and repository alone means an application listed under two
groups resolves to one file, copied once. A README's *second* illustration keeps
its path in the name (`docs/ui/detail.png` → `-docs-ui-detail`), so it cannot
collide with the screenshot; the source extension is kept, so a `.jpg` or `.svg`
survives.

The file is normally taken **from the clone** the generator already made for the
README, so a build does no extra network I/O; only an image missing from the
checkout is fetched over HTTP, and with `--offline` an already-downloaded copy
stands in. An image that cannot be had at all leaves the entry with no icon
rather than a link to nothing.

The README illustrates itself with a **relative** `![Title](screenshot.png)`,
which resolves to nothing once rendered under `/apps/<group>/<name>/`. Every
relative markdown image in the body is therefore rewritten to the local copy;
so is one already pointing at `raw.githubusercontent.com`, since that is the
hotlink being removed. An image deliberately hosted anywhere else is left alone.

That rewrite makes the README's own illustration **the same image** as
`extra.icon`, which `page.html` renders as the page hero — so the screenshot
would appear twice on every page. The body's copy is therefore dropped: an
image alone on its line whose source equals the icon is removed, and the blank
run it leaves behind is collapsed. The hero is the one that stays, since the
gallery tile is built from the same field and so cannot drift from the page.
A README image that is *not* the icon is left where it is.

`static/images/` is wholly generator-owned: after generation, any file in it
that no application referenced this run is deleted, so an application leaving
the catalog does not keep its image published forever.

## Output

```
content/apps/_index.md          hand-written, untouched
content/apps/<group>/_index.md  generated section, one per group
content/apps/<group>/<name>.md  generated page, one per application
static/index.json               the catalog, served at trustable.it/index.json
static/images/<owner>-<repo>.png  one image per application, served locally
templates/starter-cards.html       gallery partial, included by landing.html
```

Group directories are slugified (`Examples` → `examples`, `Utilities` → `utilities`).
Every generated file opens with a `<!-- generated by generator.py -->` marker
line inside the TOML frontmatter comment area, and the generator only ever
deletes directories it recognises as generated, so hand-written content under
`content/apps/` survives a regeneration.

Page frontmatter:

```toml
+++
title = "Mini CRM"
description = "Mini Customer Relation Manager"
weight = 20
[extra]
icon = "/images/trustable-ai-minicrm.png"
repo = "https://github.com/trustable-ai/minicrm"
group = "Examples"
+++
```

The page body is the copied markdown with a leading heading stripped when it
only restates the title — `page.html` already renders `page.title` as the
`<h1>`. The match is deliberately loose in one direction: a heading *contained*
in the title counts (`# Database Manager` under "AI Database Manager"), a longer
one does not, because most copy opens with a real step heading
(`# 1 - Application Foundation`) that must survive.

An application listed under two groups (`truk8s` is in both `Demo` and
`Utilities`) gets a page in each group from the one clone of its repo.

## Index pages

Each index level lists exactly one step down, rather than being a bare title:

- **`/apps/`** — the **groups only**, one tile per group. It does not
  descend into the applications: the whole catalog on one page is a wall of
  tiles that buries the structure, and the group tile is the way into it.
- **`/apps/<group>/`** — the applications of that group.

Both render through the same `starter-cards.html` partial the home page uses,
so the surfaces cannot drift apart. Two variables select the level: `only`
narrows to a single group's applications, and `groups_only` lists the groups
themselves. The listing comes from the content tree at build time — the
`_index.md` bodies stay empty and no application or group is ever named in
markdown.

A group tile shows the group name and a count of what is inside it, and uses
the icon of its first application as the preview, so the four tiles read the
same way the application tiles do.

A group index also needs an **in-section sidebar**. `docs.html` derives the
sidebar from the containing section, and for a section it climbed to the
*parent*, so a group page listed its sibling groups rather than its own
applications. A section that has pages of its own now lists those.

## Detail page

`page.html` renders the icon above the prose for any page carrying
`extra.icon`, so each application page opens with its own screenshot rather
than with bare text. The image is the site's own copy under `/images/`. Pages
without an icon are unchanged.

## Gallery on the home page

The "Customize Apps" panel of [landing.html](../templates/landing.html)
drops its three hardcoded columns and includes `starter-cards.html`, which
walks `content/apps/`'s subsections. This is pure Zola templating over the
generated sections — no data duplicated into the template.

On the home page the groups are **tabbed**: a row of tab buttons, one per
group, showing that group's tiles alone. The panel is one slide of a cycling
slot, so stacking every group vertically would run several screens deep;
tabs keep the whole catalog reachable at a fixed height. The tabs are the
group names, and they carry the section heading themselves — the panel's own
`<h2>` and lede are dropped, since the step nav above already names the step.

Tabs are progressive: with no JS every group renders stacked, which is also
what the two index pages want. The first tab is selected on load, and the tab
list is a real `role="tablist"` with arrow-key navigation.

The tiles are a responsive grid rather than a horizontal scroller, sized so a
row is never fuller than the breakpoint allows:

| Viewport | Tiles per row | Tile width |
|---|---|---|
| Desktop (≥ 1000px) | 3 | ≥ 30% |
| Tablet (600–999px) | 2 | 50% |
| Mobile (< 600px) | 1 | 100% |

The grid keeps a **5% inset on both sides at every width**, so the tiles never
run to the panel edge. The gallery breaks out of the `.wrap` container to do
it: `.wrap` caps at 1200px and adds its own margin, which would stack on the
5% and leave the real inset drifting between 3% and 8% across breakpoints.

Tile width is a share of that inset **band** (the 90% between the gutters),
not of the whole viewport — a third of the band is the 30% the desktop row is
specified at. Measured: 32.3% / 48.6% / 100% of the band at 1440 / 800 / 420px.

The columns are equal `1fr` with the gutter as a real `column-gap`, so every
tile in a row is exactly the same width. That uniformity is load-bearing: with
a 3:4 preview slot any width difference becomes a visible height difference,
and tiles in a row stop lining up.

Each tile is a link to the application's generated page. The **title sits above
the box**, not inside it, and the box holds the icon alone.

The preview box is a fixed **3:4 slot** (portrait) at every breakpoint, so its
height follows the column width and every tile in a row is the same size
whatever its icon's own aspect. The source screenshots are all portrait —
between 0.55:1 and 0.97:1 — so they seat in that slot with little waste. The
icon is `object-fit: contain` inside it: a shot is never cropped or stretched,
only letterboxed against the card. The description is
**not** printed under the tile — it appears as a hover popup over the icon
(and on keyboard focus, so it is reachable without a pointer). The description
also stays in the tile's `title`/`aria-label` so it is announced rather than
being purely visual.

The section index (`content/apps/_index.md`) keeps its own listing through
the existing `section.html` sidebar, so every generated page is reachable from
the Apps nav as well as from the home page.
