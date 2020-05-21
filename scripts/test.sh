#!/usr/bin/env bash

# set -o verbose
set -o errexit
set -o pipefail
set -o nounset

echo "***** Start: Testing CommanderConda installer *****"

export CONDA_PATH="$HOME/taucmdr/conda"

CONSTRUCT_ROOT="${CONSTRUCT_ROOT:-/construct}"

cd "${CONSTRUCT_ROOT}"

echo "***** Get the installer *****"
INSTALLER_PATH=$(find build/ -name "CommanderConda*$ARCH.sh" | head -n 1)

echo "***** Run the installer *****"
chmod +x "$INSTALLER_PATH"

if ! [[ "${GITHUB_REF:-}" =~ ^refs/tags/ ]]; then
    echo "***** Performing install and self-tests *****"
    "$INSTALLER_PATH" -b -u -t -p "$CONDA_PATH"
else
    "$INSTALLER_PATH" -b -u -p "$CONDA_PATH"
fi

echo "***** Setup conda *****"
set +o nounset
# set +o verbose
#shellcheck disable=SC1090
source "${CONDA_PATH}/bin/activate"
# set -o verbose
set -o nounset

echo "***** Print conda info *****"
conda info

echo "***** Print conda list *****"
conda list

echo "***** Run conda update *****"
conda update --all -y

echo "***** Python path *****"
python -c "import sys; print(sys.executable)"
python -c "import sys; assert 'taucmdr' in sys.executable"

echo "***** Print system information from Python *****"
python -c "print('Hello CommanderConda!')"
python -c "import platform; print(platform.architecture())"
python -c "import platform; print(platform.system())"
THIS_OS="$(uname)"
export THIS_OS
python -c "import platform; import os; assert platform.system() in os.environ.get('THIS_OS')"
python -c "import platform; print(platform.machine())"
python -c "import platform; import os; assert platform.machine() in os.environ.get('ARCH')"
python -c "import platform; print(platform.release())"

echo "***** Done: Building Testing installer *****"
