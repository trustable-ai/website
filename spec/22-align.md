# Spec 22 — Align the look with the official Nuvolaris site

The look of this website is different from the look of the "official" site in
the folder `trusite`. Align it:

- use the same CSS style and colour
- use the same logos where they differ

## What `trusite` is

`trusite` is the Nuvolaris corporate site — React + Vite + Tailwind v4 +
shadcn, generated on Lovable. Its design system lives in one file,
[trusite/src/styles.css](trusite/src/styles.css), and its own comment states
the intent:

> Ink + paper, one restrained accent. Brand palette derived from Nuvolaris
> guidelines: blue `#1DA1CE`, ink `#231f20`, mute `#58595b`, paper `#ffffff`,
> with reserved orange `#ff7113`. Type: Work Sans (body + display),
> JetBrains Mono (code).

This site is a different animal — Python/Jinja generator emitting static HTML
with the CSS inline in [templates/base.html](templates/base.html) and
[templates/landing.html](templates/landing.html). **We are not porting
Tailwind or React.** We port the *design decisions* — tokens, type scale,
geometry, component shapes — into the existing hand-written CSS.

## The gap

| | `trusite` (official) | this site (now) |
|---|---|---|
| Page ground | `--paper` warm off-white `#fafaf7` | `--bg` cool blue-grey `#f5f7fb` |
| Text | `--ink` `#231f20` near-black | `--navy` `#0b1b3a` deep navy |
| Muted text | `--mute` `#58595b` neutral grey | `--muted` `#55637d` blue-grey |
| Accent | `--brand` `#1DA1CE`, one, restrained | `--blue #1e63d0` + `--cyan` + `--logo-blue`, three |
| Hairline | `--rule` `#e9e9ea` | `--hairline` `#dde3ee` (blue-tinted) |
| Radius | `0.25rem` — near-square | `999px` pills, `12px` cards |
| Primary button | ink block, uppercase `0.18em`, offset brand border on hover | blue pill, uppercase `0.14em` |
| Display type | Work Sans **Light 300**, `tracking-tight`, big | Work Sans **Bold 700** + Montserrat |
| Section labels | JetBrains Mono `11px` uppercase `0.14em` ("eyebrow") | none |
| Cards | borderless cells on a `gap-px` hairline grid | white rounded cards with shadow |
| Footer | paper, hairline top rule, 5 link columns | solid navy block |
| Section rhythm | `py-28 / lg:py-36`, full-bleed hairline dividers | `2.5rem 0 3rem` panels |

Net effect: `trusite` reads as editorial ink-on-paper; this site reads as a
blue-tinted SaaS card deck.

## Plan

### 1. Palette — retoken `:root` in `templates/base.html`

Replace the current five colours with the `trusite` token set, keeping the
**old names as aliases** so no rule in `base.html`, `landing.html`, `docs.html`,
`section.html` or `starter-cards.html` has to change in this step:

```css
:root {
  /* Nuvolaris brand — see trusite/src/styles.css */
  --ink:   #231f20;
  --paper: #fafaf7;
  --mute:  #58595b;
  --rule:  #e9e9ea;
  --brand: #1da1ce;
  --brand-soft: #a0d8ea;
  --signal: #ff7113;   /* reserved, not used for decoration */

  /* legacy aliases — old rules keep working, new colours come through */
  --navy: var(--ink);
  --blue: var(--brand);
  --cyan: var(--brand-soft);
  --logo-blue: var(--brand);
  --bg: var(--paper);
  --card: #ffffff;
  --hairline: var(--rule);
  --muted: var(--mute);
  --radius: 0.25rem;
  --fade: 400ms;
}
```

Then sweep the hardcoded blues that bypass the tokens: `#e6ecf8` (nav/step
hover), `#23324f`, `#e9edf6` (inline code), `#a9b7d2` (footer text) →
`color-mix(in srgb, var(--brand) 8%, transparent)` and `--mute`/`--rule`
equivalents. Files: `base.html`, `landing.html`, `docs.html`.

### 2. Geometry — pills → near-square

`trusite` has `--radius: 0.25rem` and uses square blocks for buttons. Change:

- `.cta`, `.cta-quiet`, `.step-link`, `.sitenav a` — `border-radius: 999px` →
  `2px`.
- `.cta`: `background: var(--brand)` → `var(--ink)`, `color: var(--paper)`,
  `letter-spacing: 0.14em` → `0.18em`, `font-weight: 600`; hover
  `background: var(--brand)` (matches `Nav.tsx`'s "Contact sales").
- `.cta-quiet`: keep the 1px inset rule, but ink not blue —
  `color: var(--ink)`, `box-shadow: inset 0 0 0 1px var(--rule)`,
  hover fills ink.
- Cards in `docs.html` / `starter-cards.html`: `border-radius: 12px` → `2px`,
  drop the shadow, use `border: 1px solid var(--rule)`.

### 3. Type — Light display, add the eyebrow

- Drop **Montserrat** from the Google Fonts link in `base.html`; `trusite`
  uses Work Sans alone for display. Add weight `300` to the Work Sans request:
  `family=Work+Sans:wght@300;400;500;600;700`.
- `.hero-title` — remove `font-family: Montserrat`, set `font-weight: 300`,
  `letter-spacing: -0.02em` (from `tracking-tight`).
- `h2` — `font-weight: 700` → `300`, `line-height: 1.05`.
- New `.eyebrow` class matching `trusite`'s `<Eyebrow>`: JetBrains Mono,
  `11px`, `uppercase`, `letter-spacing: 0.14em`, `color: var(--mute)`. Apply
  above each landing section heading and each docs page title.

### 4. Surfaces — cards → hairline cell grids

`trusite` builds feature grids as borderless cells separated by hairlines
(`gap-px border-l border-t` + `border-b border-r` per cell). Port that to
`.trio` (already close — it uses `border-left` rules) and to
`.gallery-grid` / `starter-cards.html`, which currently use white rounded
cards on the page ground. Result: one continuous hairline lattice, no
floating cards.

Also add `trusite`'s `grid-paper` backdrop as an optional utility for the
hero — the 64px hairline grid at 6% ink — since the landing hero is the one
place both sites want texture.

### 5. Header and footer

- **Header** (`base.html`): keep sticky, change ground to
  `rgba(250,250,247,0.85)` + `backdrop-filter: blur(12px)`, bottom rule
  `1px solid color-mix(in srgb, var(--ink) 10%, transparent)`, height `4rem`.
  Nav links: `13px`, `font-weight: 500`, `--mute` → `--ink` on hover, no pill
  background (matches `Nav.tsx`). The `Nuvolaris` link becomes the ink "Contact
  sales"-style block on the right.
- **Footer** (`base.html`): the navy block is the single biggest visual
  divergence. Replace with `trusite`'s `Footer.tsx` shape — paper ground,
  `border-top: 1px solid var(--rule)`, the Trustable mark + one-line
  positioning statement on the left, link columns with JetBrains Mono `11px`
  uppercase headings, then a hairline-separated bottom bar with the copyright
  and the social links. Keep our existing link set (Documentation, Apps,
  Architecture, Demo, Contact) rather than inventing `trusite`'s five columns.
  Drop `filter: brightness(0) invert(1)` on the logo — on paper it stays black.

### 6. Logos

Copy the higher-resolution official assets from `trusite` into `static/`:

| ours (now) | official | action |
|---|---|---|
| `static/logo-trustable.png` 376×109 | `trusite/src/assets/trustable-logo.png` 1235×353 | **replace** — same mark, 3.3× the resolution |
| `static/logo-nuvolaris.png` 624×114 PNG | `trusite/src/assets/nuvolaris-logo.svg` | **replace with the SVG**; ours is a raster of the same wordmark. Header/footer use it at small sizes, so `brightness(0)` as `Nav.tsx` does, or the light-blue variant on the paper footer |
| `static/logo-nuvolaria.png` 690×230 | — | keep; `trusite` has no NuvolarIA wordmark asset |
| `static/trustable-logo.svg` (favicon, the hexagon mark) | `trusite/public/pittogramma.png` | keep ours — it is the same mark and vector beats raster for a favicon |

Update the two references in `base.html` and the two in `landing.html`.

### 7. Verify

`./build.sh`, then eyeball `docs/index.html` next to the `trusite` home and
`/trustable` pages at desktop and mobile widths. Check specifically: no
blue-grey ground left anywhere, no pill buttons, no navy footer, no Montserrat,
and the Trustable mark crisp on a retina screen.

## Out of scope

- Porting Tailwind, React or shadcn into the generator.
- Dark mode. `trusite` ships a `.dark` block; this site has no toggle and
  adding one is a separate spec.
- Copy changes. This is a visual alignment; the words stay as they are.
- `--signal` orange. `trusite` reserves it and never uses it; so do we.

## Implementation notes

Implemented on branch `spec-22`. What the plan did not anticipate:

### A second `:root` in `landing.html`

`templates/landing.html` carried its own copy of the palette, the box-sizing
reset, the `body`/`img` defaults and `.wrap`. Because it renders inside
`base.html`'s `{% block style %}` — which sits *after* base's own `:root` — that
copy won, and retokening base alone left the home page on the old colours
entirely. The duplicate block is removed; landing.html now holds only rules
specific to the landing page.

This is why step 1's aliasing strategy looked like it had failed on first
build: the tokens were right, the page just never saw them.

### `.prose a` captured the Apps gallery

`docs.html` loads after `base.html`, so `.prose a` and `.gallery-card a` have
equal specificity with prose winning. Once `.prose a` became `--brand`, every
tile name in the Apps gallery turned bold accent-blue with a prose underline —
the loudest thing on the page, in a system whose whole premise is one restrained
accent. `.gallery-card a` and `.gallery-title a` are now also written as
`.prose .gallery-card a` / `.prose .gallery-title a` to win that cascade.

### Artwork matted to the old ground

`static/trustable-machines.png` has no alpha channel at all, and the landing
animation is composited the same way: both were flattened against the old
`#f5f7fb`. On the warm paper they each sat in a visibly cooler rectangle. Added
a `--legacy-plate` token holding that colour and applied it to `.anim-video` and
`.machines`, which turns a mismatched block into a deliberate full-width plate.

**This is a stopgap.** The real fix is re-exporting those two files with
transparency, after which `--legacy-plate` and its two uses should be deleted.
Worth its own spec.

### The hero lockup keeps Bold

Step 3 said to drop Montserrat, which is done. But `.hero-title` sets "IT is
Trustable" directly against the TRUSTABLE wordmark — a wide, bold geometric
grotesque — and Light 300 there reads as a caption beside the mark rather than
as part of it. That one rule stays at Work Sans 700; everything else went Light.

### Logos

- `static/logo-trustable.png` — replaced, 376×109 → 1235×353.
- `static/logo-nuvolaris.png` — **deleted**, replaced by
  `static/logo-nuvolaris.svg` from the corporate site. Note the "SVG" is a
  base64 PNG in an `<image>` wrapper, not real vector paths, but its embedded
  raster is 1455×179 against our 624×114, so it is still the better asset.
- The footer restructure moved the Nuvolaris wordmark from the top of the
  footer into the bottom bar beside the copyright, dropped to ink at 55%
  opacity — Trustable is the product this site is about, Nuvolaris is the
  parent it belongs to.

### Out of scope, found while verifying

The docs layout **overflows horizontally at 390px** — the sidebar box and prose
run past the right edge and the page scrolls sideways. Verified against
`main`'s built output: this predates spec 22 and is not caused by the
alignment. Left alone; worth its own spec.

The header's own narrow-width behaviour *was* made worse by the new CTA block
(`space-between` stranded it past the edge), so that much is fixed here: the bar
stacks and centres below 640px.

### Verified

`./build.sh build --fast` → 30 pages. No `#0b1b3a`, `#1e63d0`, `#22c1e8`,
`#198cb3`, `#dde3ee`, `#55637d`, `#e6ecf8`, `#23324f`, `#e9edf6` or `#a9b7d2`
anywhere in `docs/`; no `border-radius: 999px` anywhere; no Montserrat.
Home, Documentation and Apps pages checked visually at 1440px, Documentation
also at 390px.
