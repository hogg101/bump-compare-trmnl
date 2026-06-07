#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUBY_VERSION="${RUBY_VERSION:-4.0.4}"
RUBY_SERIES="${RUBY_VERSION%.*}"
TRMNLP_VERSION="${TRMNLP_VERSION:-0.8.7}"
DEV_DIR="$ROOT/.trmnl-dev"
RUBY_PREFIX="$DEV_DIR/ruby"
GEM_HOME_DIR="$DEV_DIR/gems"
SRC_DIR="$DEV_DIR/src"
RUBY_TARBALL="$SRC_DIR/ruby-$RUBY_VERSION.tar.xz"
RUBY_SRC="$SRC_DIR/ruby-$RUBY_VERSION"

mkdir -p "$SRC_DIR" "$GEM_HOME_DIR"

if [[ ! -x "$RUBY_PREFIX/bin/ruby" ]]; then
  if [[ ! -f "$RUBY_TARBALL" ]]; then
    curl -fL "https://cache.ruby-lang.org/pub/ruby/$RUBY_SERIES/ruby-$RUBY_VERSION.tar.xz" -o "$RUBY_TARBALL"
  fi

  if [[ ! -d "$RUBY_SRC" ]]; then
    tar -xJf "$RUBY_TARBALL" -C "$SRC_DIR"
  fi

  configure_args=(
    "--prefix=$RUBY_PREFIX"
    "--disable-install-doc"
    "--enable-shared"
  )

  if command -v brew >/dev/null 2>&1; then
    for dep in openssl@3 readline libyaml gmp libffi; do
      dep_prefix="$(brew --prefix "$dep" 2>/dev/null || true)"
      if [[ -n "$dep_prefix" ]]; then
        case "$dep" in
          openssl@3) configure_args+=("--with-openssl-dir=$dep_prefix") ;;
          readline) configure_args+=("--with-readline-dir=$dep_prefix") ;;
          libyaml) configure_args+=("--with-libyaml-dir=$dep_prefix") ;;
          gmp) configure_args+=("--with-gmp-dir=$dep_prefix") ;;
          libffi) configure_args+=("--with-libffi-dir=$dep_prefix") ;;
        esac
      fi
    done
  fi

  (
    cd "$RUBY_SRC"
    ./configure "${configure_args[@]}"
    make -j"$(sysctl -n hw.ncpu 2>/dev/null || echo 2)"
    make install
  )
fi

export GEM_HOME="$GEM_HOME_DIR"
export GEM_PATH="$GEM_HOME"
export PATH="$GEM_HOME_DIR/bin:$RUBY_PREFIX/bin:$PATH"

gem install trmnl_preview -v "$TRMNLP_VERSION" --no-document

echo "Installed trmnlp $TRMNLP_VERSION in $DEV_DIR"
echo "Run ./bin/trmnlp serve to preview at http://localhost:4567"
