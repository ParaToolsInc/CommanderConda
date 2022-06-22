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

echo "***** Construct the installer *****"
constructor "$TEMP_DIR/CommanderConda/" --output-dir "$TEMP_DIR" # --platform "${TARGET_PLATFORM}"

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
