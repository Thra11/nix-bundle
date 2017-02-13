#!/usr/bin/env sh

if [ "$#" -lt 1 ]; then
    cat <<EOF

Usage: $0 TARGET

Create a closure from the nixpkgs attribute "TARGET".
EOF

    exit 1
fi

target="$1"

expr="with import <nixpkgs> {}; with import ./. {}; closure { targets = [$target]; }"

out=$(nix-store --no-gc-warning -r $(nix-instantiate --no-gc-warning -E "$expr"))

if [ -z "$out" ]; then
  echo "$0 failed. Exiting."
  exit 1
else
  rm -f result
  ln -sf $out result
  echo "Dir created at result"
fi
