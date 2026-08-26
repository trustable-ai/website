# Trustable — Investor Pitch Deck

A [Marp](https://marp.app) deck. The source of truth is `pitch.md`; no HTML or
PDF is committed, and nothing needs to be installed to work on it.

See `spec/20-presentation.md` for the plan behind it.

## Preview

Install the **Marp for VS Code** extension (`marp-team.marp-vscode`), open
`pitch.md`, and click the preview icon in the editor title bar.

## Export

With the extension installed, run **Marp: Export Slide Deck…** from the command
palette to write a PDF, PPTX or HTML alongside the markdown. Exports are
deliberately not committed.

## Images

`images/` holds this deck's own copies of the site images, so the deck previews
and exports standalone without the site being served. They came from `static/`:
if one of those is redesigned, re-copy it here — nothing syncs them
automatically. One was renamed on the way in: `static/mac+spark.png` is
`images/mac-spark.png` here, because a `+` in a markdown image path is a
portability hazard across Marp exporters.

## Before sending

The deck carries four highlighted `TODO` blocks — traction, team, business
model and the ask. They hold no invented figures and must be filled in with real
numbers before the deck goes to an investor.

## Not part of the website build

`presentation/` sits outside `content/`, so zola never reads it and `build.sh`
never publishes it. This deck is sent, not served.
