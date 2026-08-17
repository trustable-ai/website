# 7 — Preview build and publish

> **Largely superseded by spec/13-generate.md.** `generator.py` has absorbed
> `support/index.py`: it fetches the catalog from the GitHub API itself and
> writes it to `static/index.json`, so `build.sh` no longer runs `index.py`
> (step 1), the generator no longer reads `support/index.json` (step 2), and
> the "push the catalog before the site" ordering constraint (step 3) is gone
> — there is no submodule commit for the site to get ahead of. The `build.sh`
> serve/build split described below still holds.

Split what the build does into two deliberate steps: `build.sh` regenerates
everything from the live GitHub catalog and previews it locally, and publishing
pushes the result out — first the catalog in `support/`, then the site itself.

> **Superseded in part.** This was first implemented as a `publish.sh` script.
> That script has since been removed: publishing is the PR-and-merge process in
> CLAUDE.md, done by hand. Everything below about `build.sh`, `generator.py` and
> the catalog still holds; only the publishing *mechanism* changed. The
> ordering constraint it existed to enforce did not go away — see
> "Publishing by hand" at the end.

Today `build.sh` conflates the two: it fetches the published `index.json` over
HTTP, generates the gallery, writes `docs/`, and commits. The catalog it reads
is whatever `trustable-ai/.github` published earlier, so a catalog change has to
be pushed from elsewhere before the site can see it. After this change the
catalog is regenerated locally from the GitHub API by `support/index.py`, the
site is generated from that fresh file, and both are published together.

## Notes on the current code

- `support/` is a submodule of `trustable-ai/.github`, checked out on `main`
  tracking `origin/main`. `support/index.py` writes `index.json` next to itself.
  It used to carry a `--push` flag that committed and pushed the file; that is
  now the single publishing process's job, so the flag was removed rather than
  left as a second, divergent way to publish. See spec/8-index.md.
- `support/index.py` is a plain `#!/usr/bin/env python3` script with no PEP 723
  block. It uses only the standard library plus the `gh` CLI.
- `generator.py` fetches `INDEX_URL` over HTTP, caches the response in
  `index.json` at the repo root, and has an `--offline` flag that reads that
  cache instead.

## Plan

### 1. `build.sh` — regenerate, then preview

Replace the current single path with the pipeline below. The zola bootstrap
(`install_zola` and the PATH probing) is unchanged.

1. **Regenerate the catalog.** Run `uv run --no-project support/index.py`, which
   leaves the refreshed `index.json` in `support/`. `uv` supplies the
   interpreter; `--no-project` keeps it from trying to resolve this repo as a
   Python project. No `--push` here — regenerating is not publishing. Fail the
   build if the script fails, so the site is never generated from a stale
   catalog.
2. **Generate the gallery.** Run `./generator.py`, now reading
   `support/index.json` (see step 2 below).
3. **Preview.** Exec `zola serve --port 1111`, which is incremental and
   live-reloading. This is the default: `./build.sh` with no argument ends in a
   preview server on http://127.0.0.1:1111 and does not write `docs/`.

`./build.sh build` keeps the publishing path: same steps 1 and 2, then
`zola build --output-dir docs --force`, then the existing confined commit of
`content/apps index.json docs` (`static/apps` was dropped by
spec/12-readme.md). `NO_COMMIT=1` and the detached
HEAD guard keep working as they do now. The committed path list drops the root
`index.json` and gains nothing — `support/index.json` belongs to the submodule
and is committed and pushed there separately.

`./build.sh serve` stays as an explicit alias for the default preview.

### 2. `generator.py` — read the local catalog

- Point `CACHE` at `support/index.json` and read it directly; drop `INDEX_URL`,
  the `requests.get` of the index, and the write-back of the fetched copy.
- Drop the `--offline` flag: with no fetch there is nothing to be offline from.
  `generator.py` still uses `requests` for READMEs, so the dependency block
  stays. (Superseded by spec/12-readme.md: READMEs are now read from the
  clones, and the `requests` dependency is gone.)
- Error clearly if `support/index.json` is missing, naming the submodule — that
  means `support/` was never checked out (`git submodule update --init`).
- Delete the root `index.json`; it was only the HTTP cache.

Two icon bugs surfaced once the generator started reading a freshly regenerated
catalog. The stale cache had been hiding both, and the site cannot be generated
correctly from the live catalog without fixing them. (Both fixes are since
superseded by spec/12-readme.md, which stopped copying icons altogether: the
screenshot is linked at its raw GitHub URL, so there is no local copy to find
or to prune.)

- **`copy_icon` found nothing.** It looks for `<name>.png` in the checkout
  derived from the icon URL. The catalog now points icons at each application's
  own repo, where the file is published as `screenshot.png`, so all 13
  applications lost their icon. Accept `screenshot.png` too — but only from the
  application's own checkout, since unlike `<name>.png` it is not
  self-identifying and any other clone's screenshot belongs to something else.
  Publish either as `/apps/<name>.png` so the page URL does not depend on
  which layout the icon came from.
- **Stale icons were never pruned.** `clean_generated()` clears content
  directories but nothing cleans `static/apps/`, so an application that leaves
  the catalog keeps its icon published forever (`securitycheck.png` and
  `solarsystem.png` were still there). Add `clean_icons()`, run after
  generation, deleting any `*.png` not named by a current application.

### 3. Publishing by hand

Originally a `publish.sh` script; now the process in CLAUDE.md — build, PR,
merge, then push. The script is gone, but the constraint that shaped it
remains, because nothing enforces it automatically any more:

**Push the catalog before the site.** `support/` is a submodule of
`trustable-ai/.github`, and Trustable reads its `index.json` over
raw.githubusercontent.com. If the site is published while the catalog commit
sits unpushed, the submodule pointer in `main` names a commit GitHub does not
have, and the published site describes applications the catalog cannot confirm.
So, in order:

1. In `support/`: commit `index.json` and **push** it to `trustable-ai/.github`.
2. In the website repo: `git add support` to record the moved pointer, commit
   it with whatever the build left, and push.

`./build.sh build` deliberately never pushes; it only commits what it owns.

## Out of scope

Nothing here changes the generated content, the templates, or the GitHub Pages
configuration.
