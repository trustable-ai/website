#!/bin/bash
# Publish the Trustable site — see spec/7-publish.md.
#
# Pushes the starter catalog in support/ first, then the site that was built
# from it, so the published site never points at a catalog nobody can fetch
# yet. Builds nothing: run `./build.sh build` first.
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"

# Committing on a detached HEAD leaves the commit unreachable from any branch,
# and there is no branch to push it to either.
require_branch() {
  if ! git -C "$1" symbolic-ref --quiet HEAD >/dev/null 2>&1; then
    echo "error: $2 is on a detached HEAD, refusing to publish" >&2
    exit 1
  fi
}

# --- the catalog -----------------------------------------------------------
# support/ is a submodule of trustable-ai/.github, where index.json is
# published for Trustable itself to read over raw.githubusercontent.com.

if [ ! -e support/index.json ]; then
  echo "error: support/index.json not found — the support submodule is not" >&2
  echo "       checked out. Run: git submodule update --init support" >&2
  exit 1
fi

require_branch support "support"

if [ -n "$(git -C support status --porcelain -- index.json)" ]; then
  echo ">> publishing the starter index to trustable-ai/.github"
  git -C support add -- index.json
  git -C support commit --quiet -m "Update application starter index"
  git -C support push --quiet
  echo ">> pushed $(git -C support rev-parse --short HEAD) to .github"
else
  echo ">> starter index unchanged"
fi

# --- the site --------------------------------------------------------------
# `git add support` records the submodule pointer moved above, so the site
# commit names the exact catalog it was generated from.

require_branch . "the website repo"

git add -- support

if [ -n "$(git diff --cached --name-only)" ]; then
  git commit --quiet -m "Publish the site" \
    -m "Point support/ at the current starter index. Committed by publish.sh."
  echo ">> committed $(git rev-parse --short HEAD)"
fi

BRANCH="$(git rev-parse --abbrev-ref HEAD)"

# Push this branch's commits — the one just made, plus the build's own from
# ./build.sh build. A branch with no upstream yet has nothing to compare
# against, so it is always pushed, setting the upstream as it goes.
if git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' >/dev/null 2>&1; then
  if [ -z "$(git log '@{upstream}..HEAD' --max-count=1 --format=%H)" ]; then
    echo ">> nothing to push, the site is up to date"
    exit 0
  fi
  git push --quiet
else
  git push --quiet --set-upstream origin "$BRANCH"
fi
echo ">> pushed $BRANCH to origin"
