# Spec 20 — Investor pitch deck (Marp)

Generate an investor pitch deck for Trustable as a Marp markdown deck stored in
`presentation/pitch/`, with the images it shows copied in from the rest of the
site.

## Constraints

- **Marp markdown.** One `pitch.md` with `marp: true` front matter and `---`
  slide separators.
- **Install nothing.** No `marp-cli`, no Node toolchain, no additions to
  `build.sh`. The deck is rendered by the Marp for VS Code extension, so the
  source markdown is the deliverable — no committed HTML or PDF.
- **Images copied, not linked.** `presentation/pitch/images/` holds its own
  copies of the site images the deck uses, referenced with relative paths, so
  the deck previews standalone in VS Code without the site being served.
- Deck content is drawn from the live site copy (the landing page sections and
  `content/architecture/`), not invented.

## Why it sits outside the Zola pipeline

`content/` is Zola's input: anything under it becomes a published page. The
pitch deck is a Marp document, not a site page, and a top-level
`presentation/` directory keeps it out of the build — zola never reads it,
`build.sh` never commits it as site output, and it is not published to
trustable.it. That is the intent: an investor deck is sent, not served.

## Layout

```
presentation/pitch/
  pitch.md            the deck
  images/             copies of the site images the deck shows
  README.md           how to preview and export it
```

## Heading artwork

Alongside the deck this spec also lands the site heading artwork:

- `static/heading.png` — the exported heading image served by the site.
- `photoshop/heading.psd` — the editable Photoshop source it is exported from,
  kept in the repo so the heading can be re-cut later. `photoshop/` sits
  outside `content/` and `static/`, so zola never publishes it.

## Slide plan

A standard investor arc, each slide backed by real site copy or a real image.

| # | Slide | Content source |
|---|-------|----------------|
| 1 | Title — "IT is Trustable" | `logo-trustable.png`, site motto |
| 2 | The problem | AI requires sending code and data to third parties |
| 3 | The solution | "A Lovable-like experience for Private AI" |
| 4 | Product: build with Local AI | landing "Build Apps with Local AI on your PC" |
| 5 | Product: start from templates | landing templates section, `trustable-templates.png` |
| 6 | Product: deploy anywhere | landing "Deploy Anywhere", `nuvolaris-stack.png` |
| 7 | The full stack | stack list: Kubernetes, S3, PostgreSQL, Redis, Prometheus, Velero |
| 8 | Market: three tiers | `local-ai.png`, `private-ai.png`, `sovereign-ai.png` |
| 9 | Hardware / appliance | `trustable-machines.png`, NuvolarIA appliance |
| 10 | Use cases | private email, database, documents images |
| 11 | Technology & moat | Nuvolaris serverless engine, owned end to end |
| 12 | Ask / contact | closing call to action |

Slides whose numbers depend on facts we do not have — funding amount, revenue,
team, traction — are written as clearly marked `TODO` placeholders rather than
invented figures. Flagged to the user on delivery.

## Theme

Marp's `default` theme plus a small inline `<style>` using the site palette
(`--navy #0b1b3a`, `--blue #1e63d0`, `--cyan #22c1e8`) so the deck matches
trustable.it. No external font or CSS fetch, so it renders offline.

## Steps

1. Create `presentation/pitch/images/` and copy the site images the deck uses.
2. Write `pitch.md` with the slides above.
3. Write `README.md` with preview/export instructions for the VS Code extension.
4. Verify every image path in the deck resolves to a copied file.

## Revision 1 — visual and message pass

Requested after the first draft. Applied to `pitch.md`; the slide plan above
still holds, the styling and three of the messages change.

### Styling

- **Fancier background.** Lead slides get a navy radial/linear gradient with a
  faint cyan glow instead of flat navy; content slides get a light gradient with
  a cyan accent bar down the left edge, so no slide is a plain colour fill.
- **Fix the unreadable black-on-blue on slide 1.** The title slide's dark text
  on the navy gradient is replaced with explicit white/cyan on the dark ground,
  and the Trustable logo is set on a light plate so it does not vanish into it.
- **An image on every slide.** Slides that were text-only (problem, solution,
  full stack, moat, traction, ask, closing) each get a real site image — no
  slide is a wall of bullets.

### Messages

- **Drop "Lovable-like experience".** Slide 3 and the deck description instead
  say you **build apps with prompts using Local AI on a full stack
  environment** — the differentiator is the stack, not a comparison.
- **NuvolarIA is a set of apps.** The templates slide states plainly that
  NuvolarIA is a suite of ready-to-use applications shipped with the platform,
  not a single product.
- **Better template image.** `trustable-templates.png` is a documentation
  screenshot with annotation arrows; replace it with the App Suite application
  shot (`static/images/trustable-ai-appsuite.png`) plus other app screenshots
  from the catalog, which show what a template actually produces.
- **Deploy Anywhere uses hardware images.** The server (`private-ai.png`) and
  the data centre (`sovereign-ai.png`) images replace the abstract stack
  diagram as the visual for that slide.

### Extra images to copy

`trustable-ai-appsuite.png`, `trustable-ai-minicrm.png`,
`trustable-ai-projectdashboard.png`, `layout-ai-applications.png`,
`logo-nuvolaris.png`, `mac+spark.png`.
