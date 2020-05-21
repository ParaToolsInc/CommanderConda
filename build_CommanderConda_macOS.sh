#!/usr/bin/env bash

set -o verbose
set -o errexit
set -o pipefail
set -o nounset

echo "Installing Miniforge3."
chmod +x "build/miniforge/${MINIFORGE_FILE}"
./build/miniforge/"${MINIFORGE_FILE}" -b

echo "Configuring conda."

set +o nounset
set +o verbose
#shellcheck disable=SC1090
source ~/miniforge3/bin/activate root
set -o verbose
set -o nounset

CONSTRUCT_ROOT="$(pwd)"
export CONSTRUCT_ROOT

echo "============= Create build directory ============="
mkdir -p build/ || true
chmod 777 build/

echo "============= Build the installer ============="
./scripts/build.sh

# Make output match correct name for macOS
mv build/"${COMMANDERCONDA_NAME}"-*-MacOSX-"${ARCH}".sh build/"${COMMANDERCONDA_NAME}"-*-macOS-"${ARCH}".sh || true
mv build/"${COMMANDERCONDA_NAME}"-*-MacOSX-"${ARCH}".sh.sha256 build/"${COMMANDERCONDA_NAME}"-*-macOS-"${ARCH}".sh.sha256 || true

echo "============= Test the installer ============="
./scripts/test.sh
