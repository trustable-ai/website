# Spec 21 — Consistent calls to action

Give every landing-page section the same call-to-action row, and add a Demo
entry to the footer menu.

## The three destinations

Every CTA on the page points at one of three places:

| Label | Destination | Opens |
|-------|-------------|-------|
| Register for a Demo | `https://n7s.co/nuvolaria-suite` | new tab |
| Contact us | `https://nuvolaris.io/#/contact` | new tab |
| section link | Documentation / Apps / Architecture | same tab |

"Contact us" keeps the existing external Nuvolaris contact form rather than
gaining an on-page form: a form needs a submission backend the static site
does not have, and the Nuvolaris form is already the site's contact route
(it is what the footer and the Scale section link to today).

`n7s.co/nuvolaria-suite` is the NuvolarIA suite demo registration — the
spelling follows the NuvolarIA product name, matching `logo-nuvolaria.png`
shown in the Customize Apps section.

## Footer menu

In `templates/base.html`'s `.footer-nav`: add **Demo**, and remove
**Download**. Demo joins the group of links that leave the site, so it takes
the same `target="_blank" rel="noopener"`.

Removing Download here drops the last link to `download.trustable.it` from the
site — the Build section's Download button goes in the same change, so the
download host is no longer reachable from any page.

## Section CTA rows

All four panels in `templates/landing.html` end up with a row whose last two
buttons are Register for a Demo and Contact us. Each row keeps at most one
primary `.cta`; the rest are `.cta-quiet`, so a section still has a single
visual lead.

| Section | Row after this change |
|---------|----------------------|
| Build with Local AI | Documentation · Register for a Demo · Contact us |
| Customize Apps | Browse Apps · Register for a Demo · Contact us |
| Deploy Anywhere | Architecture · Register for a Demo · Contact us |
| Scale Everywhere | Register for a Demo · Contact us |

Renames and moves:

- **Build** — drop the **Download** button; the section leads with
  Documentation instead, so the row is exactly the three buttons above.
- **Customize Apps** — rename *Browse every App* → **Browse Apps**, and move
  the row up so it sits immediately under the lede, above the app tab strip.
  The tabs stay a tab strip (`starter-cards.html` with `tabbed`), not buttons:
  they switch content in place and are not calls to action.
- **Deploy Anywhere** — rename *Read the architecture* → **Architecture**.
- **Scale Everywhere** — keep Contact Us, add Register for a Demo before it.

## Not changing

- The header `.sitenav` — the spec asks only for the bottom menu.
- `starter-cards.html` — the app tabs already behave as the spec describes.
- The panel copy, images, video and step nav.

## Tab strip look

With a real button row now directly above it, the app tab strip must not read
as a second row of buttons. The pills become a conventional underlined tab
bar in `templates/base.html`:

- `.gallery-tabs` grows a hairline baseline the tabs sit on, and left-aligns
  instead of centring — a tab bar anchors to the content edge, a button row
  centres.
- `.gallery-tab` loses its border, pill radius and card background; it is
  transparent, muted text with a 2px transparent bottom border sitting over
  the baseline.
- The selected tab (`.js-tabs [aria-selected="true"]`) takes the navy text and
  a `--blue` bottom border, so selection is an underline rather than a fill.
- Hover darkens the text and shows a faint underline, not a background.

The markup is already a correct `role="tablist"` and does not change; only the
CSS does. Without JS the strip stays inert as before.

## Fixed along the way

`.cta-quiet` was declared *before* `.cta` in `templates/landing.html`. They
carry the same specificity, so `.cta`'s fill won on every element that had
both and no outlined button ever rendered outlined. Moving `.cta-quiet` after
`.cta` is what makes a row read as one primary button plus two quiet ones.

## Motto

Drop "Enjoy a Lovable-like experience for Private AI" from the rotating hero
motto in `templates/landing.html`, leaving four lines. The site no longer
pitches itself by comparison to another product in the first thing a visitor
reads; the remaining lines say what Trustable does in its own terms.

The phrase still appears in the page title and meta description, in
`config.toml` and across `content/` — those are separate copy, out of scope
here.
