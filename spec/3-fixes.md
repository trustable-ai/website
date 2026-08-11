# Landing page fixes

The landing page (`templates/landing.html`) needs a masthead change plus layout
and call-to-action fixes on two of its panels.

## Masthead

The lockup reads **`IT` is `<trustable wordmark>`.it`** — the domain pun, not
"It is Trustable!". `IT` stays at the full hero size; `is` and `.it` are the
small connective parts at half that size, lowercase against the block's
uppercase, and **vertically centred** on the wordmark's axis rather than sitting
on the baseline of a word twice their height. The `.it` is punctuation on the
mark, so it is pulled back against it (cancelling the flex gap) and set in the
mark's near-black. The old `!` is gone.

## Build with AI

- The video must be **fixed width**, not stretched horizontally. Today
  `.anim-video` is sized with `width: min(80%, …)`, so it grows with the
  viewport and is stretched by the `1200 / 520` aspect ratio. Cap it at its
  natural width (1200px) and keep it shrinking only when the panel is narrower
  than that, so it never renders wider than the source. It is then held **10%
  under** that band — `min(1080px, 90%)` — so it does not run edge to edge.
- The size is set by **horizontal width only**. There must be no viewport-height
  term in the width calculation: a short window would otherwise collapse the
  video to a thumbnail, which is worse than letting the panel scroll.
- Add a **"Read the documentation"** button under the caption, linking to the
  documentation section (`@/documentation/_index.md`).

## Deploy Anywhere

- Fix the layout: the **appliance and the architecture diagram sit side by
  side** (two columns), not appliance-left / text+diagram-right as today.
- The **text goes below** the two images, full width.
- Add a **"Read the architecture"** button under the text, linking to the
  architecture section (`@/architecture/_index.md`).

## Shared button style

Both panels use one `.cta` class defined in the landing page's `style` block:
pill-shaped, `--blue` background, white text, hover/focus states matching the
existing `.step-link` treatment. Centered under the block it belongs to.

Links are written as Zola internal links (`@/…`) via `get_url`, so a renamed or
removed section fails the build instead of leaving a dead link — the same rule
the header and footer navs follow.

## Responsive

Below 900px the Deploy pair stacks into one column, which the existing
`.duo { grid-template-columns: 1fr }` media query already handles.
