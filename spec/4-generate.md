# 4 — Generate the Apps gallery

`generator.py` is a [uv](https://docs.astral.sh/uv/) script with embedded
dependencies (PEP 723 header, `requests`) that turns the catalog published by
the `trustable-ai/.github` repo into Zola content.

```bash
./generator.py            # regenerate content/apps/, pulling the clones
./generator.py --offline  # reuse the existing clones instead of pulling
```

The catalog is read from `support/index.json`, not fetched — `build.sh`
regenerates that file first with `support/index.py`, so the gallery is built
from the same catalog that is about to be published beside it. See
spec/7-publish.md.

## build.sh runs it

`build.sh` regenerates the catalog and the gallery before every build, so the
published site always matches what the organization looks like today:

1. `support/index.py` — rebuild `support/index.json` from the GitHub API
2. `generator.py` — read that index, pull the templates repos, rewrite
   `content/apps/` and `static/apps/`
3. `zola build --output-dir docs` (only for `./build.sh build`; the default
   serves a preview instead)
4. **commit** the result, if anything changed

The commit is confined to the three paths the build owns — `content/apps/`,
`static/apps/` and `docs/` — so unrelated edits in the working tree are never
swept into it. The catalog is not among them: it belongs to the `support`
submodule and is committed and pushed there separately. Nothing is committed
when those paths come back unchanged, and the commit is never pushed;
publishing is the PR-and-merge process in CLAUDE.md.

Two escape hatches, because a build that always commits is wrong in some
contexts:

- `./build.sh` / `./build.sh serve` — regenerate, then preview on
  http://127.0.0.1:1111. Writes no `docs/` and commits nothing.
- `NO_COMMIT=1 ./build.sh build` — write `docs/` but leave the result in the
  working tree. This is also what a detached HEAD gets automatically, since
  committing there would strand the commit.

Regenerating needs the network and the `gh` CLI on every build. If either step
fails the build stops rather than silently publishing a stale catalog.

## Input

`support/index.json` — the `support` submodule's checkout of
`trustable-ai/.github`, published for Trustable itself to read at
`https://raw.githubusercontent.com/trustable-ai/.github/refs/heads/main/index.json`

```json
{
  "starters":     [ { "name", "repo", "templates", "description" } ],
  "applications": { "<Group>": [ { "name", "title", "repo", "icon", "description" } ] }
}
```

`applications` is a map of **group** → list of applications. Group order in the
JSON is the order the gallery uses.

## Copy taken locally

Every application's prose and icon live in the `*-templates` repository the
`icon` URL points at, not in the application repo — most application READMEs
are the generic `# Trustable Workspace` stub. The generator clones (or pulls)
each templates repo once into `.templates/<repo>/`, a gitignored working
directory, and copies out of it. The clones deliberately sit **outside**
`content/`: zola parses every file below it and a bare repo README carries no
front matter, which fails the build. From each checkout it takes:

- **page body** — `<templates>/<name>.md`, falling back to the application
  repo's `README.md` when that file is absent
- **icon** — copied to `static/apps/<name>.png`. Two source layouts are in
  use: a templates repo names the file after the application, `<name>.png`,
  while an application's own repo publishes it as `screenshot.png` — which is
  what the catalog's `icon` URLs point at today. `screenshot.png` is only
  accepted from the application's own checkout, since unlike `<name>.png` it
  does not identify itself and any other clone's screenshot belongs to a
  different application. Either is published under `<name>.png` so the page URL
  does not depend on where the icon came from. It is the gallery tile *and* the
  illustration at the top of the detail page, so it is downloaded from GitHub
  into the site rather than hotlinked; the published pages never reach
  raw.githubusercontent.com. An application listed under two groups points at
  only one templates repo (`truk8s` is in `Demo` and `Utilities` but the PNG
  lives only in `trutil-templates`), so both the icon and the copy are looked
  up across every checkout before giving up.

Icons of applications that have left the catalog are deleted from
`static/apps/` after generation; otherwise they stay published forever, since
clearing the content directories does not touch them.

## Output

```
content/apps/_index.md          hand-written, untouched
content/apps/<group>/_index.md  generated section, one per group
content/apps/<group>/<name>.md  generated page, one per application
static/apps/<name>.png          copied icon
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
icon = "/apps/minicrm.png"
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

A body that is only the `# Trustable Workspace` stub, or empty, falls back to
the catalog description.

An application listed under two groups (`truk8s` is in both `Demo` and
`Utilities`) gets a page in each group; the icon is shared.

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
than with bare text. The image is the copy under `static/apps/`, never a
GitHub URL. Pages without an icon are unchanged.

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
