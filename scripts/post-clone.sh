#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

# 1) Init ONLY the submodule you want as pointers (skip LFS there)
git -c filter.lfs.smudge="git-lfs smudge --skip -- %f" \
    -c filter.lfs.process="git-lfs filter-process --skip" \
    submodule update --init submodules/mydotbins

# 2) Run your arch/path-specific skipper inside that submodule
( cd submodules/mydotbins && ./configure-lfs-skip-smudge.py )

# 3) Init the rest of the submodules normally (LFS behaves as usual)
git submodule update --init --recursive --jobs 8

# 4) (Optional) Populate top-level LFS content now
git lfs pull && git lfs checkout
