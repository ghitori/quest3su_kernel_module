#!/usr/bin/env bash
# Prepare DDK local mode so that ddk/scripts/ddk can build the kernel module
# against the kernel build tree produced by this workflow.
#
# Usage:
#   setup-ddk-local.sh <kernel-out-dir> <clang-dir> <ddk-repo-dir>
#
# Env:
#   DDK_ROOT       - DDK install root (default: /opt/ddk)
#   TARGET         - DDK target name (default: android13-5.10)
#   CLANG_VERSION  - clang version dir name (default: clang-r450784e)
set -euo pipefail

OUT_DIR=${1:?usage: setup-ddk-local.sh <kernel-out-dir> <clang-dir> <ddk-repo-dir>}
CLANG_DIR=${2:?missing clang dir}
DDK_REPO=${3:?missing ddk repo dir}

DDK_ROOT=${DDK_ROOT:-/opt/ddk}
TARGET=${TARGET:-android13-5.10}
CLANG_VERSION=${CLANG_VERSION:-clang-r450784e}

if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

$SUDO mkdir -p "$DDK_ROOT/kdir" "$DDK_ROOT/clang"
$SUDO ln -sfn "$OUT_DIR" "$DDK_ROOT/kdir/$TARGET"
$SUDO ln -sfn "$CLANG_DIR" "$DDK_ROOT/clang/$CLANG_VERSION"

mkdir -p "$HOME/.ddk"
cp -f "$DDK_REPO/mapping.json" "$HOME/.ddk/mapping.json"
printf 'local\n' > "$HOME/.ddk/mode"
printf 'github\n' > "$HOME/.ddk/source"

echo "DDK local mode ready:"
echo "  KDIR=$DDK_ROOT/kdir/$TARGET"
echo "  CLANG_PATH=$DDK_ROOT/clang/$CLANG_VERSION/bin"
