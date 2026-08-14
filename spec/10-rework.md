# 9 — Hero rework

## Goal

Rework the landing hero. The lockup reads **It is Trustable**, and under it a
single line composes and changes through four messages instead of the one
static motto.

The four messages, in order:

1. Build Apps with Private AI on your PC
2. Keep your code and data under your control
3. Enjoy a Lovable-like experience for Private AI
4. Deploy in your Server, Data Center or Sovereign Cloud

## Current state

`templates/landing.html` owns the whole landing chrome.

- The hero lockup at `templates/landing.html:575-584` is
  `IT` + `is` + the `logo-trustable.png` wordmark, styled by `.hero-title`,
  `.hero-small` and `.hero-logo` (lines 68-111).
- Under it, `.motto` (line 585) carries the single static string
  "Lovable-like experience for Private AI", styled at lines 113-118.

## Plan

### 1. Lockup case

Change `IT` / `is` to read as **It is** Trustable. `.hero-title` currently
forces `text-transform: uppercase` on the whole lockup with `.hero-small`
overriding back to lowercase for `is`. Drop the uppercasing so the words are
set as written (`It` / `is`), keeping the Montserrat weight, size ramp and the
optical-centre nudge that holds the words against the wordmark. The logo image
itself is unchanged.

### 2. Composing motto

Replace the static `.motto` paragraph with a cycling line that types itself in,
holds, clears, and moves to the next message — "compose and change" rather than
a hard swap.

Markup: the four messages ship in the HTML as a list so they are present
without JavaScript; the script promotes the list into a single animated line.

- No-JS / reduced-motion: all four messages render as a plain static list, so
  the copy is always readable and indexable.
- With JS: one line at a time, character-composed at ~45ms per character,
  holding ~2.2s at full length, then erased faster (~25ms) before the next.
  The cycle loops.

Reserve the line's height (`min-height` on the motto block) so the panel below
does not jump as messages of different lengths compose.

Respect `prefers-reduced-motion`: skip the animation entirely and leave the
static list, matching how the existing panel transitions already opt out at
`templates/landing.html:560-564`.

### 3. Accessibility

The animated line is `aria-hidden`; a visually-hidden copy of the full message
list stays in the DOM for screen readers, so the composing effect is never the
only way to reach the text.

## Files touched

- `templates/landing.html` — hero markup, motto styles, cycling script.

## Verification

Rebuild with `./build.sh` and check the hero at desktop and mobile widths: the
lockup reads "It is Trustable", the line cycles the four messages, nothing
below it shifts, and with JS disabled all four messages are visible.
