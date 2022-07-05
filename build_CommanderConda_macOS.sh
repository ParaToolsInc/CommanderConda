#!/usr/bin/env bash

# set -o verbose
set -o errexit
set -o pipefail
set -o nounset

echo "Installing Miniforge3."
chmod +x "${MINIFORGE_FILE}"

echo "Shell: ${SHELL}"
echo "Shell arch info:"

lipo -info "${SHELL}"
file "${SHELL}"

echo "Working directory:"
pwd

ls -la
ls -la build
ls -la build/miniforge

echo "\$MINIFORGE_FILE = ${MINIFORGE_FILE}"

set +o errexit
set +o nounset
# set +o verbose

lipo -info "$(which bash)"
file "$(which bash)"

arch -"$(uname -m)" bash "${MINIFORGE_FILE}" -b -p ~/conda

echo "Configuring conda."
#shellcheck disable=SC1090
source ~/conda/bin/activate root
# set -o verbose
set -o nounset
set -o errexit

CONSTRUCT_ROOT="$(pwd)"
export CONSTRUCT_ROOT

echo "============= Create build directory ============="
mkdir -p build/ || true
chmod 777 build/

echo "============= Build the installer ============="
./scripts/build.sh

echo "============= Test the installer ============="
./scripts/test.sh
