# 17 — Link the repository directly in _index.md

## Problem

`parse_applications` in `generator.py` derives an application's repository from
the *filename* of the link:

```
- [Tetris](tetris.md)   ->  https://github.com/trustable-ai/tetris
```

The link target names a markdown file; the repository is then guessed by
convention (`REPO_BASE.format(org=ORG, template=...)`). Two consequences:

1. An application can only ever live in `trustable-ai/<template>`. There is no
   way to point at a repository whose name differs from the link filename, or
   one in another owner.
2. `APPLICATION_LINE` only matches links ending in `.md`. The templates
   repositories have already moved to full URLs — `trudemo-templates`,
   `trureact-templates`, `trutil-templates` list nothing else, and
   `truchat-templates` mixes both. Every URL line is currently **silently
   dropped**, so those applications are missing from the catalog.

## Plan

Make the link target the repository itself, and keep the old form working.

1. Widen `APPLICATION_LINE` so the link target is any non-space text, not just
   `<file>.md`.
2. Add `parse_repo(target)` resolving a link target to `owner/name`:
   - `https://github.com/<owner>/<name>` (optional trailing `/` or `.git`) —
     used directly, so the repository is whatever the line links to.
   - `<owner>/<name>` — a bare slug, used as is.
   - `<file>.md` or a bare `<name>` — the legacy convention, resolved against
     `ORG` as today, so existing `_index.md` files keep working.
   - Anything else (a relative path with directories, an off-GitHub URL,
     a segment failing `REPO_SEGMENT`) yields `None`: the line is skipped and
     a warning is printed naming the file and the target.
3. `name` becomes the repository name (the last segment), which is what it
   already was for every conventional entry — it stays the page filename and
   the sort key. `repo` becomes `https://github.com/<owner>/<name>` and `icon`
   the screenshot of that same `<owner>/<name>`.
4. Pass the source repository into `parse_applications` so the skip warning can
   say which `_index.md` the bad line came from.
5. Delete `REPO_BASE`, replaced by the resolution above.

Nothing downstream changes: `app_repo()` already recovers `<owner>/<name>` from
`repo`, and cloning, image download and page generation all go through it.

## Verification

- `./generator.py --offline` regenerates without error.
- The applications linked by URL in `trudemo/trureact/trutil-templates` appear
  in `static/index.json`, each with the `repo` its line links to.
- `truchat-templates`, which mixes `.md` links and one URL, yields all four.
