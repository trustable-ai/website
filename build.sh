#!/bin/bash
# Regenerate the Trustable site and preview it — see spec/7-publish.md.
# Installs zola into ~/.local/bin when it is not already on PATH.
#
#   ./build.sh          regenerate the catalog and gallery, then serve a preview
#   ./build.sh serve    the same, said explicitly
#   ./build.sh build    regenerate, write docs/, and commit the result
#
# Every path starts by regenerating the catalog from the live GitHub API into
# support/index.json, so the site can never be generated from a stale one.
# Publishing what `./build.sh build` commits is ./publish.sh's job.
# NO_COMMIT=1 builds without committing.
set -e

ZOLA_VERSION="v0.19.2"
BIN_DIR="$HOME/.local/bin"
HERE="$(cd "$(dirname "$0")" && pwd)"

install_zola() {
  case "$(uname -s)" in
  Darwin) os="apple-darwin" ;;
  Linux) os="unknown-linux-gnu" ;;
  *)
    echo "unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
  esac

  case "$(uname -m)" in
  arm64 | aarch64) arch="aarch64" ;;
  x86_64 | amd64) arch="x86_64" ;;
  *)
    echo "unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
  esac

  # zola ships no aarch64 linux build; that host uses the x86_64 tarball.
  if [ "$os" = "unknown-linux-gnu" ] && [ "$arch" = "aarch64" ]; then
    arch="x86_64"
  fi

  tarball="zola-${ZOLA_VERSION}-${arch}-${os}.tar.gz"
  url="https://github.com/getzola/zola/releases/download/${ZOLA_VERSION}/${tarball}"

  echo ">> installing zola ${ZOLA_VERSION} into ${BIN_DIR}"
  mkdir -p "$BIN_DIR"
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  curl -fsSL "$url" -o "$tmp/$tarball"
  tar -xzf "$tmp/$tarball" -C "$tmp"
  mv "$tmp/zola" "$BIN_DIR/zola"
  chmod +x "$BIN_DIR/zola"
}

ZOLA="$(command -v zola || true)"
if [ -z "$ZOLA" ]; then
  if [ -x "$BIN_DIR/zola" ]; then
    ZOLA="$BIN_DIR/zola"
  else
    install_zola
    ZOLA="$BIN_DIR/zola"
  fi
fi

echo ">> using $("$ZOLA" --version) at $ZOLA"

cd "$HERE"

MODE="${1:-serve}"
case "$MODE" in
serve | build) ;;
*)
  echo "usage: $0 [serve|build]" >&2
  exit 1
  ;;
esac

# The catalog is rebuilt from the GitHub API on every run, so the site cannot
# drift from what the trustable-ai organization looks like today. index.py needs
# the `gh` CLI and only the standard library, so uv just supplies the
# interpreter; --no-project stops it treating this repo as a Python project.
# A failure here stops the build rather than falling back to a stale catalog.
echo ">> regenerating the starter index"
uv run --no-project support/index.py

# The gallery is generated from the support/index.json written just above.
echo ">> generating the Apps gallery"
./generator.py

# `serve` previews on http://127.0.0.1:1111 with live reload and incremental
# rebuilds, and does NOT write docs/. The port is pinned so the URL is
# predictable; zola would otherwise drift to a free one.
if [ "$MODE" = "serve" ]; then
  echo ">> preview on http://127.0.0.1:1111 (ctrl-c to stop)"
  exec "$ZOLA" serve --port 1111
fi

# Zola wipes its output dir, so CNAME and .nojekyll are re-published from
# static/ on every build rather than being kept in docs/ by hand.
"$ZOLA" build --output-dir docs --force

echo ">> built $(find docs -name '*.html' | wc -l | tr -d ' ') pages into docs/"

# Commit what the build owns. Confined to these paths so an unrelated edit
# sitting in the working tree is never swept into the build's commit, and
# skipped entirely when they come back unchanged. Never pushes: publishing
# stays a separate, deliberate step.
if [ -n "${NO_COMMIT:-}" ]; then
  echo ">> NO_COMMIT set, leaving changes in the working tree"
  exit 0
fi

# A commit on a detached HEAD is unreachable from any branch, so don't make one.
if ! git symbolic-ref --quiet HEAD >/dev/null 2>&1; then
  echo ">> detached HEAD, leaving changes in the working tree"
  exit 0
fi

# The catalog itself is not here: it belongs to the support submodule and is
# committed there by publish.sh.
BUILD_PATHS=(content/apps static/apps docs)

# --porcelain over these paths alone reports both tracked edits and untracked
# new files (a newly added application page or icon) without touching the
# index, so a caller who had something else staged still has it staged if
# there turns out to be nothing to do.
if [ -z "$(git status --porcelain -- "${BUILD_PATHS[@]}")" ]; then
  echo ">> no changes to commit"
  exit 0
fi

# `commit --only <paths>` commits exactly these paths and leaves anything else
# staged untouched, but it will not pick up untracked files, so add first.
# The -m flags must precede `--`; everything after it is taken as a pathspec.
git add -- "${BUILD_PATHS[@]}"
git commit --quiet --only \
  -m "Rebuild the site" \
  -m "Regenerated the Apps gallery from support/index.json and rebuilt docs/ with zola. Committed by build.sh; publish with ./publish.sh." \
  -- "${BUILD_PATHS[@]}"
echo ">> committed $(git rev-parse --short HEAD)"
