# Spec 18 — Remove the home page auto-advance

## Problem

On the landing page the "Build / Start / Deploy / Scale" flow panels rotate on
their own every 7 seconds. Visitors reading a panel get pulled to the next one
mid-sentence. The steps should change only when the visitor asks for them.

## Plan

In `templates/landing.html`, in the flow-panel script:

1. Delete the `HOLD` constant, the `timer` variable, the `advance()`, `play()`
   and `pause()` functions and the `visibilitychange` listener that only existed
   to pause/resume the timer.
2. Keep the panel/link wiring: `show()`, the nav click handlers, and the initial
   `show(ORDER[0])`.
3. Drop the `stopped` flag and the `prefers-reduced-motion` check — with no
   auto-rotation there is no motion to reduce, and nav clicks no longer need to
   "stop the loop for good" (keep `event.preventDefault()` and `show(name)`).
4. Update the surrounding comments so they no longer describe a loop.

Nothing else changes: markup, CSS, the no-JS fallback and the motto typing
animation are untouched.
