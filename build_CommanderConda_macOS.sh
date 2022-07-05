#!/usr/bin/env bash

# set -o verbose
set -o errexit
set -o pipefail
set -o nounset

echo "Installing Miniforge3."
chmod +x "build/miniforge/${MINIFORGE_FILE}"
./build/miniforge/"${MINIFORGE_FILE}" -b

echo "Configuring conda."

set +o nounset
# set +o verbose
bash miniconda.sh -b -p ~/conda
#shellcheck disable=SC1090
source ~/conda/bin/activate root
# set -o verbose
set -o nounset

CONSTRUCT_ROOT="$(pwd)"
export CONSTRUCT_ROOT

echo "============= Create build directory ============="
mkdir -p build/ || true
chmod 777 build/

echo "============= Build the installer ============="
./scripts/build.sh

echo "============= Test the installer ============="
./scripts/test.sh
