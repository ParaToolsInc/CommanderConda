#!/usr/bin/env bash

# set -o verbose
set -o errexit
set -o pipefail
set -o nounset

echo "***** Start: Building CommanderConda installer *****"

CONSTRUCT_ROOT="${CONSTRUCT_ROOT:-/construct}"

cd "$CONSTRUCT_ROOT"

# Constructor should be latest for non-native building
# See https://github.com/conda/constructor
echo "***** Install constructor *****"
conda install -y "constructor>=3.3.1" jinja2 curl libarchive -c conda-forge --override-channels

if [[ "$(uname)" == "Darwin" ]]; then
    conda install -y coreutils -c conda-forge --override-channels
fi

conda list

echo "***** Make temp directory *****"
TEMP_DIR=$(mktemp -d);

echo "***** Copy file for installer construction *****"
cp -R CommanderConda "${TEMP_DIR}/"
cp LICENSE "${TEMP_DIR}/"

ls -al "${TEMP_DIR}"

MICROMAMBA_VERSION=0.23.0
mkdir "${TEMP_DIR}/micromamba"
pushd "${TEMP_DIR}/micromamba"
curl -L -O "https://anaconda.org/conda-forge/micromamba/${MICROMAMBA_VERSION}/download/${TARGET_PLATFORM}/micromamba-${MICROMAMBA_VERSION}-0.tar.bz2"
bsdtar -xf "micromamba-${MICROMAMBA_VERSION}-0.tar.bz2"
MICROMAMBA_FILE="${PWD}/bin/micromamba"
popd
EXTRA_CONSTRUCTOR_ARGS+=(--conda-exe "${MICROMAMBA_FILE}" --platform "${TARGET_PLATFORM}")

echo "***** Construct the installer *****"
constructor "$TEMP_DIR/CommanderConda/" --output-dir "$TEMP_DIR" "${EXTRA_CONSTRUCTOR_ARGS[@]}"

echo "***** Generate installer hash *****"
cd "$TEMP_DIR"
# This line ill break if there is more than one installer in the folder.
INSTALLER_PATH=$(find . -name "CommanderConda*.sh" | head -n 1)
HASH_PATH="$INSTALLER_PATH.sha256"
shasum -a 256 "$INSTALLER_PATH" > "$HASH_PATH"

echo "***** Move installer and hash to build folder *****"
mv "$INSTALLER_PATH" "$CONSTRUCT_ROOT/build/"
mv "$HASH_PATH" "$CONSTRUCT_ROOT/build/"

echo "***** Done: Building CommanderConda installer *****"
