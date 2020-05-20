#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

echo "Installing Miniforge3."
bash "build/miniforge/${MINIFORGE_FILE}" -b

echo "Configuring conda."

#shellcheck disable=SC1090
source ~/miniforge3/bin/activate root

CONSTRUCT_ROOT="$(pwd)"
export CONSTRUCT_ROOT

echo "============= Create build directory ============="
mkdir -p build/ || true
chmod 777 build/

echo "============= Build the installer ============="
bash scripts/build.sh

# echo "============= Test the installer ============="
# bash scripts/test.sh
