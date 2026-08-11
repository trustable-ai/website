# Site structure

The website is a [Zola](https://www.getzola.org) static site. `./build.sh`
renders `content/` + `templates/` into `docs/`, which GitHub Pages serves;
`./build.sh serve` previews on <http://127.0.0.1:1111> without writing `docs/`.

## Routes

The landing page is the site root. The three documentation sections sit at the
top level and are reachable from both the header and the footer nav.

```
/                              landing page (content/_index.md, landing.html)
/manual/                       Trustable Documentation
/manual/provider/
/manual/applications/
/architecture/                 Nuvolaris Architecture
/architecture/introducing-nuvolaris/
/architecture/serverless-engine/
/architecture/components/
/architecture/integrated-services/
/architecture/supported-clouds/
/tutorial/                     MastroGPT Tutorial
/tutorial/lesson0/ … lesson7/
```

## Content rules

- Front matter is **TOML** (`+++`). Zola rejects YAML `---` blocks.
- Cross-page links use `@/`-prefixed internal links resolved from `content/`,
  e.g. `@/manual/provider.md`. A broken one **fails the build**, which is the
  point — never write a bare relative or absolute path between pages.
- Images are **co-located** with the markdown that uses them and referenced by
  bare filename (`image-4.png`, `_page_2_Figure_3.jpeg`). Zola copies page
  assets next to the rendered page.
- Code fences must name a language syntect knows. `text` and `ops` are **not**
  valid and emit a build warning; use `txt` and `bash`.
- Section order comes from `weight` (`sort_by = "weight"`): manual 10,
  architecture 20, tutorial 30.
- A section whose title is too long for the nav strips sets
  `extra.nav_title` (e.g. "Trustable Documentation" → "Manual").

## Templates

| Template | Role |
|---|---|
| `base.html` | Shell: palette, header nav, footer nav. Everything extends it. |
| `landing.html` | The root page only — cycling four-step platform pitch. |
| `docs.html` | Shared docs layout: section sidebar + prose column. |
| `section.html` / `page.html` | Thin wrappers over `docs.html`. |

The header and footer navs are built with `get_section` over an explicit list
of the three section paths, so a renamed or deleted section breaks the build
instead of leaving a dead link. `permalink` must be piped through `| safe` or
Zola HTML-escapes the slashes.

`docs.html` builds its sidebar from **the section the reader is currently in**,
resolved via `ancestors` — not from a single site-wide index. Tutorial lessons
are subsections rather than pages, so the sidebar iterates both
`index.pages` and `index.subsections`.

## Architecture section

The section is a PDF extraction of the Nuvolaris architecture paper, split by
its top-level headings into one page each. The full-page scan images and the
page-number table of contents were dropped; only the four real diagrams remain
(Figures 1–4). Provider logos on the "Supported Clouds" page were dropped too —
they extracted as clipped fragments, and the prose names every provider.
