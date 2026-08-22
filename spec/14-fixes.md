in the home page add to the set of messagges on the top

"Yoda says: Trustable, (is) it"

Add the buttons:

- "Download" that opens download.trustable.it
- "Documentation" that goes to the Documentation section

before the video

remove tbe button "read documentation"

## Plan

All changes are in `templates/landing.html`.

1. **Yoda message** — append `<li>Yoda says: Trustable, (is) it</li>` to
   `#motto-list`. The typing script reads its messages from that list, so the
   fifth message joins the cycle with no JS change.

2. **Buttons before the video** — a `.cta-row.cta-row-hero` inserted in the
   Build panel between `.panel-head` and `<figure class="anim">`:
   - **Download** → `https://download.trustable.it` (filled `.cta`).
   - **Documentation** → the documentation section (`.cta.cta-quiet`,
     outlined) so Download leads and the pair reads as one choice.

   New styles: `.cta-row-hero` (flex, centred, gap, bottom margin) and
   `.cta-quiet` (transparent with an inset `--blue` border, inverting on
   hover).

3. **Move "Read the architecture"** — in the Deploy panel the CTA moves from
   the foot of the panel to just above the `.duo` block that holds the server
   image, reusing `.cta-row-hero` so it sits the same way as the pair in the
   Build panel.

4. **Remove "Read the documentation"** — the trailing `.cta-row` at the end of
   the Build panel is deleted; the new Documentation button replaces it.

## Status

Implemented. Not yet built into `docs/`.

## Scale panel

The Scale lede becomes "We can help scaling your AI Application built with
Trustable to Local AI, Private organizational AI and Sovereign AI data center."
and a **Contact Us** button (`https://nuvolaris.io`) sits under it in a
`.cta-row-hero`, above the three-tier flow.
