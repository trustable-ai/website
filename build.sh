#!/bin/bash
# Build the Trustable site with Zola into docs/ (served by GitHub Pages).
# Installs zola into ~/.local/bin when it is not already on PATH.
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

# `./build.sh serve` previews on http://127.0.0.1:1111 with live reload, and
# does NOT write docs/ — run `./build.sh` with no argument for that. The port is
# pinned so the URL is predictable; zola would otherwise drift to a free one.
if [ "${1:-}" = "serve" ]; then
  echo ">> preview on http://127.0.0.1:1111 (ctrl-c to stop)"
  exec "$ZOLA" serve --port 1111
fi

# Zola wipes its output dir, so CNAME and .nojekyll are re-published from
# static/ on every build rather than being kept in docs/ by hand.
"$ZOLA" build --output-dir docs --force

echo ">> built $(find docs -name '*.html' | wc -l | tr -d ' ') pages into docs/"
