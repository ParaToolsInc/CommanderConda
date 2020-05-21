#!/usr/bin/env bash

set -o verbose
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
bash "$INSTALLER_PATH" -b -p "$CONDA_PATH"

echo "***** Setup conda *****"
set +o nounset
set +o verbose
#shellcheck disable=SC1090
source "${CONDA_PATH}/bin/activate"
set -o vervose
set -o nounset

echo "***** Print conda info *****"
conda info

echo "***** Run conda update *****"
conda update --all -y

echo "***** Python path *****"
python -c "import sys; print(sys.executable)"
python -c "import sys; assert 'commanderconda' in sys.executable"

echo "***** Print system information from Python *****"
python -c "print('Hello CommanderConda!')"
python -c "import platform; print(platform.architecture())"
python -c "import platform; print(platform.system())"
python -c "import platform; print(platform.machine())"
python -c "import platform; print(platform.release())"

echo "***** Done: Building Testing installer *****"
false
