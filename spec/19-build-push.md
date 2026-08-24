# Spec 19 — `./build.sh push`

## Problem

Publishing the site today is a manual sequence: switch to `main`, run
`./build.sh build`, then `git push`. `build.sh` deliberately never pushes
(spec/13-generate.md), which is right for `build`, but it leaves the last —
and most error-prone — step to be remembered by hand. The failure worth
guarding against is publishing from the wrong branch: a build committed on a
feature branch never reaches the site, and the working tree looks identical
either way.

## Plan

Add a third mode to `build.sh`, alongside `serve` and `build`:

    ./build.sh push          ensure main, build everything, commit docs, push

`push` is `build` plus a precondition and a follow-up. It reuses the existing
generation, `zola build --output-dir docs` and commit steps unchanged — no
duplicated logic.

### 1. Argument parsing

Accept `push` in the `MODE` case alongside `serve|build`, and update the usage
line to `usage: $0 [serve|build|push] [--fast]`. `--fast` composes with it the
same way it does with `build`.

### 2. Precondition: must be on `main`

Checked *before* any generation work, so a wrong-branch run fails in a second
rather than after a full GitHub catalog fetch:

- The current branch must be `main`. On any other branch — or a detached HEAD —
  exit non-zero with a message naming the branch found and telling the user to
  `git checkout main` first. `build.sh` does not switch branches itself:
  a checkout can fail on a dirty tree and is the user's call.
- `NO_COMMIT=1` is incompatible with `push` — there would be nothing to push.
  Exit non-zero saying so.

Everything else about the working tree is left alone: `push` commits the same
`BUILD_PATHS` as `build` and an unrelated edit sitting in the tree stays
uncommitted and unpushed, exactly as today.

### 3. Build and commit

Unchanged. `push` falls through the same generation, `zola build` and
`git commit --only -- "${BUILD_PATHS[@]}"` path as `build`, including the
"no changes to commit" case — which is not an error: the site may already be
up to date and there can still be earlier local commits to push.

### 4. Push

After the commit step, only when `MODE = push`:

- Push `main` to `origin`.
- If `origin/main` has moved ahead, the push is rejected by git; report the
  failure and stop rather than force-pushing or auto-rebasing. Resolving a
  divergence is the user's call.
- Print the pushed head so the run ends with what was published.

Because the docs commit is already made by then, a successful push publishes
the rebuilt `docs/` — which is what GitHub Pages serves.

### 5. Documentation

- Update the usage comment at the top of `build.sh` with the new mode, and
  amend the "Never pushes" note to say that only `push` does.
- Note the new mode in `spec/13-generate.md` §4, which describes `build.sh`'s
  modes, and in `spec/7-publish.md`, which describes the publishing process.
- CLAUDE.md's process (wait for the user to ask, PR, merge, push) is unchanged:
  `push` is the mechanism for that final step, not permission to skip it.

## Verification

- `./build.sh push` on a non-`main` branch exits non-zero, names the branch and
  does no generation.
- `NO_COMMIT=1 ./build.sh push` exits non-zero.
- `./build.sh push --fast` on `main` with a change under `BUILD_PATHS` builds,
  commits and pushes; `git status` afterwards is clean of build paths and
  `origin/main` matches local `main`.
- `./build.sh push` on `main` with nothing to commit still pushes any pending
  local commits and does not error.
- `./build.sh serve` and `./build.sh build` behave exactly as before.
