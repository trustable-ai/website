# 11 — Build with AI panel

## Goal

The landing page's **Build with AI** panel currently shows the animation, the
machine band and a documentation link. Grow it to tell the whole build story:
the headline becomes concrete about *where* the AI runs, the machine band gets
the caption it never had, and a new templates walkthrough shows that building
does not have to start from an empty prompt.

The content to show, in order:

- **Build Apps with Local AI on your PC** (the panel heading)
- Lede: Customize and build full stack applications with prompts, using Local,
  Private or Sovereign AI.
- `trustable-anim.mp4` — with the existing caption: *Describe what you want and
  Trustable writes it — frontend, backend actions and data wiring. It is
  Nuvolaris technology inside the platform, not a third-party tool: what it
  builds runs on your own stack, on your own hardware.*
- `trustable-machines.png` — captioned *Use your Local AI workstation. No code
  or data leaves your infrastructure.*
- `trustable-templates.png` — captioned *Use templates to build applications from
  a starter with predefined prompts.*

## Current state

Everything lives in `templates/landing.html`; there is no new page and no new
nav entry.

- The panel is `#build` at `templates/landing.html:698-744`: a `.panel-head`
  (`h2` + `.lede`), the `.anim` figure holding the video and its caption, the
  bare `.machines` image, and a `.cta-row`.
- `.anim`, `.anim-video` and `.machines` are styled at lines 440-478. The
  `.machines` image is an `<img>` with no figure or caption around it.
- `static/trustable-templates.png` is present and untracked (635x564).

## Plan

### 1. Heading and lede

`h2` becomes "Build with Private AI on your PC". The lede becomes "Customize and
build full stack applications with prompts, using Local, Private or Sovereign
AI", replacing "Customize and build your AI application with AI coding with
Trustable". `.lede` caps at `46ch`, which the new sentence exceeds, so it wraps
to three lines at desktop — acceptable and consistent with the other panels.

### 2. Caption the machine band

Wrap `.machines` in a `<figure>` so it carries the "Use your Local AI
workstation. No code or data leaves your infrastructure." caption, reusing the
`.anim-caption` styling the video's caption already uses rather than inventing a
second caption style. The image keeps its width/height and `loading="lazy"`, so
the reserved box is unchanged.

### 3. Templates shot

A `<figure>` below the machine band: the `trustable-templates.png` shot with its
caption underneath — "Use templates to build applications from a starter with
predefined prompts."

- Layout: single centred column, shot then caption, matching how the animation
  and machine band already read. The shot is 635x564 and is sized on width,
  never upscaled past its natural size, so it needs no breakpoint of its own.
- The caption keeps `.templates-lead`'s muted, centred type at `68ch`.

### 4. Panel height

The panels share one grid cell (`.js .panel { grid-area: 1 / 1 }`), so the slot
is as tall as the *tallest* panel and this addition lengthens the page for every
step, not just Build. Build is already the tallest, so the growth is real but
bounded — accepted rather than worked around, since capping the shot's height to
preserve the current slot height would make it unreadable.

### 5. Step nav label

The step nav entry stays "Build with AI" (`templates/landing.html:672`). It
labels the step in a four-item strip where the longer headline would not fit;
the panel heading carries the fuller phrasing.

### 6. Start panel lede

The Start panel's `.panel-head` held only the NuvolarIA mark and no words. Add a
`.lede` under the logo: "No need to start from scratch. Pick one of our
ready-to-use application you can readily customise to your needs with the AI."

The logo stands in for the `<h2>` the other panels have, so `.product-logo`
gives up its `2rem` bottom margin and the `.lede` below supplies the gap —
the same heading-then-lede rhythm as every other panel, without stacking two
margins.

## Files touched

- `templates/landing.html` — panel markup, machine-band figure, templates figure
  and its styles; Start panel lede.
- `static/trustable-templates.png` — committed (currently untracked).

## Verification

`./build.sh` and check the Build panel at desktop and mobile widths: the heading
reads "Build with Private AI on your PC", all three images carry their captions,
the templates caption sits under its shot, and switching between the four steps
does not reflow the panels below.
