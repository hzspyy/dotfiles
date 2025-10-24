#!/usr/bin/env bash
# post-clone.sh — Initialize submodules with targeted LFS behavior.
#
# Usage (from a fresh clone *without* --recurse-submodules):
#   git clone git@github.com:basnijholt/dotfiles.git
#   cd dotfiles
#   ./scripts/post-clone.sh
#
# What this does:
#   1) Initializes only submodules/mydotbins with LFS skipping (pointers only).
#   2) Runs its arch/path-specific skipper (sets fine-grained skip rules).
#   3) Initializes all other submodules normally (LFS behaves as usual).
#   4) Optionally materializes top-level LFS objects.

set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

echo "[post-clone] Init mydotbins with LFS skip..."
git -c filter.lfs.smudge="git-lfs smudge --skip -- %f" \
    -c filter.lfs.process="git-lfs filter-process --skip" \
    submodule update --init submodules/mydotbins

echo "[post-clone] Run mydotbins LFS skipper..."
(
  cd submodules/mydotbins
  ./configure-lfs-skip-smudge.py || python3 ./configure-lfs-skip-smudge.py
)

echo "[post-clone] Init remaining submodules normally..."
git submodule update --init --recursive --jobs 8

echo "[post-clone] (optional) Populate top-level LFS objects..."
git lfs pull && git lfs checkout || true

echo "[post-clone] Done."
