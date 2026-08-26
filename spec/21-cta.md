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

Add **Demo** to `templates/base.html`'s `.footer-nav`, beside Download and
Contact Us — the group of links that leave the site, so it takes the same
`target="_blank" rel="noopener"`.

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

- **Build** — drop the **Download** button. Download stays reachable from the
  footer and remains the site's download route; the section leads with
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
