# NuvolarIA Splash Page — Spec

Generate `index.html` in this directory (`web/splash/`) from this spec.
This is the **home page**.
All image paths below are relative to this directory and must be used as-is.

## Goal

A single-page, self-contained landing page for:

**NuvolarIA — The Open Platform for Private AI**

The page tells one story in four steps, in this order:

    Start NOW  →  Build with AI  →  Deploy Anywhere  →  Scale Everywhere

The four steps are shown as a persistent nav at the top, and the page cycles
through them on its own until the visitor takes control. See
[Section cycling behavior](#section-cycling-behavior).

## Global requirements

- Single static `index.html`. No build step, no framework, no external JS.
- Fonts: `Work Sans` (headings and body) and `JetBrains Mono` (eyebrow/labels),
  loaded from Google Fonts, matching the main site (`web/index.html`).
- Brand palette taken from the logo and product renders:
  - deep navy `#0B1B3A` (headings, dark sections)
  - brand blue `#1E63D0` (primary accent, arrows, buttons)
  - cyan `#22C1E8` (highlights)
  - logo blue `#198CB3` — the "Private AI" words in the `<h1>` match the
    Nuvolaris wordmark. The mark itself is `#1DA1CE`, which is only 2.78:1 on
    the page background; use this one-step-darker value on the same hue so the
    heading clears 3:1 for large text.
  - light background `#F5F7FB`, white cards, hairline borders
- Responsive: three-column bands collapse to a single column under ~900px.
  Images use `max-width: 100%`; the page body never scrolls horizontally.
- Every `<img>` needs a meaningful `alt`. Section headings are real `<h2>`.
- `layout-*.png` files are **composition references only** — reproduce their
  structure in HTML/CSS. Do not embed them in the page.

## Header

- Logo: `![Nuvolaris](./logo-nuvolaris.png)` — centered at the top of the page,
  ~250px wide. This is the company mark and stays on every section, since the
  masthead sits outside the cycling slot.
- Tagline as the page `<h1>`: **The Open Platform for Private AI**
- Directly under the header, a horizontal step nav showing the four steps
  separated by arrows, each linking to its section anchor:

      Start NOW  →  Build with AI  →  Deploy Anywhere  →  Scale Everywhere

  Style it as a pill/breadcrumb strip: mono uppercase labels, blue arrows,
  the same visual rhythm used inside the Scale band.

- The nav stays visible while the page cycles (`position: sticky; top: 0`) so
  the current step is always readable. It doubles as the manual control
  described below.

## Section cycling behavior

The four sections are shown **one at a time**, in the same slot, and the page
advances through them automatically on a loop. The nav marks which one is
showing, and clicking the nav hands control to the visitor.

### Auto-play

- Only one section is visible at a time. The others are hidden, not merely
  scrolled past.
- The page advances `Start → Build → Deploy → Scale` and then wraps back to
  `Start`, looping indefinitely.
- Each section holds for **7 seconds** before advancing.
- Transitions are a cross-fade: the outgoing section fades out and the incoming
  one fades in over ~400ms. No horizontal movement, no layout jump — reserve
  the slot height so the nav and footer stay put between steps. Keep the fade
  well under the hold so each section is fully settled before it advances.
- Auto-play starts on load, beginning with `Start`.

### Manual control

- Clicking any nav step immediately shows that section and **stops the
  auto-play loop permanently** for the rest of the visit. It does not resume
  after a delay.
- Once stopped, the nav is the only thing that changes sections; clicking
  between steps stays instant and still cross-fades.
- The active step is visually distinct in the nav — filled blue pill, white
  label — in both auto and manual mode. Inactive steps are navy on light.
- Nav steps are real focusable controls (`<button>`, or `<a href="#start">`
  with the click intercepted) so keyboard and screen-reader users can select a
  section. Mark the active one with `aria-current="step"`.

### Accessibility and fallbacks

- Honor `prefers-reduced-motion: reduce`: do not auto-advance, and drop the
  cross-fade to an instant swap. Show `Start` and let the nav do the rest.
- Without JavaScript the page must still be fully readable: render every
  section stacked and visible, and let the nav work as plain anchor links.
  Hide the non-active sections from JS, not from the base CSS.
- Pause the loop while the tab is hidden (`visibilitychange`) so a
  backgrounded tab does not race through the steps.

---

# Start NOW

> **Start immediately with ready-to-use Private AI applications.**

Show `![NuvolarIA](./logo-nuvolaria.png)` below the heading/lede, centered,
above the three product columns — this is the product mark, so it belongs to
the Start section rather than the page masthead.

Layout reference: `./layout-ai-applications.png` — three equal columns
separated by thin vertical rules, each column a title above a product image.

Three cards, in this order. Each title sits on **one line** — do not wrap them:

| Title                     | Image                       |
| ------------------------- | --------------------------- |
| Private AI for Documents  | `./private-document.png`    |
| Private AI for Email      | `./priave-email.png`        |
| Private AI for Databases  | `./private-database.png`    |

The email screenshot is drawn visually larger than the other two; cap its
height well below theirs so the three product shots read at a consistent
optical size.

Note: `priave-email.png` is misspelled on disk — reference it exactly as
written above, do not rename it.

---

# Build with AI

> **Customize and build your AI application with AI coding with Trustable.**

Single centered column. The video is the whole section — no two-column band,
no logo lockup, no body paragraph.

- `./anim/trustable-anim.mp4` — centered, **80%** of the content width, with
  the caption **"Describe what you want"** directly below it.
- The source is 1200×520 (H.264, 9s). Give the element an explicit
  `width`/`height` or `aspect-ratio` so no layout shift occurs while it loads.
- Autoplay, loop, muted, `playsinline`. `muted` is mandatory — browsers block
  autoplay with sound, and a landing page must never start audio unasked. The
  file carries an audio track, so this matters.
- `preload="auto"`: the section is only on screen for 5 seconds at a time, so
  the video must be ready before its turn comes around.
- Caption below the video in the same muted style as the other section
  captions, centered.

Note the video runs 9s while the section holds for 7s, so a visitor watching
the auto-loop sees most of it before the page advances. Clicking the nav stops
the cycling and lets the video play through and loop.

The old two-column band (Trustable logo, laptop shot `./mac+spark.png`, the
"powered by Nuvolaris" badge and body copy) is replaced by this. `mac+spark.png`
is no longer referenced by the page.

---

# Deploy Anywhere

> **Deploy in your private server with a complete stack for AI.**

Two-column band:

- `![NuvolarIA appliance](./local-ai.png)` — the hardware you deploy on.
- `![Complete AI stack](./nuvolaris-stack.png)` — the full stack diagram.

Body copy for this band, verbatim:

> Frontend, APIs, database and storage, hosting, compute, FAAS, security, rate
> limiting, caching, load balancing, logging and recovery — Kubernetes, S3,
> PostgreSQL, Redis, Prometheus and Velero, ready to use, integrated and
> running on your infrastructure.

Render this band on the light background like every other section. All four
sections share the same light treatment — only one is on screen at a time, so
there is nothing for a contrasting band to separate.

Because the stack diagram is a light-background PNG, give it a white card with
a hairline border and rounded corners so it reads as a distinct object.

---

# Scale Everywhere

> **Scale from your Local AI to an organization Private AI and to a Sovereign
> AI provider.**

Layout reference: `./layout-scale.png` — three columns, each an image above a
bold uppercase caption, joined by two large blue arrows pointing right.
Reproduce the arrows in HTML/CSS; on narrow screens rotate them to point down.

This is the section that carries the platform's argument, so do not leave the
three tiers as bare captions. Each column gets a caption, a one-line scope
label, and a short descriptive sentence — same platform, same applications,
same tooling at every tier; only the hardware underneath changes. That
continuity is the point: you are never migrating, only growing.

| Caption      | Scope             | Image                | Describes                                    |
| ------------ | ----------------- | -------------------- | -------------------------------------------- |
| LOCAL AI     | One desk          | `./local-ai.png`     | The NuvolarIA appliance on your own desk. Your models and data never leave the machine. |
| PRIVATE AI   | One organization  | `./private-ai.png`   | A GPU server in your own rack, serving whole teams behind your firewall. |
| SOVEREIGN AI | One country       | `./sovereign-ai.png` | A full data centre run as an AI provider, under your own jurisdiction and control. |

Set the scope label in mono uppercase above the caption, so the three columns
read as an escalating series (one desk → one organization → one country).

---

## Footer

Small footer on the dark navy background: the `./logo-nuvolaris.png` mark,
a copyright line for Nuvolaris, and a link back to the main site.
