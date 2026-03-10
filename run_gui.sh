#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${ROOT_DIR}"

PY_BIN="${ROOT_DIR}/.venv/bin/python"
if [ ! -x "${PY_BIN}" ]; then
  echo "Missing venv python: ${PY_BIN}"
  echo "Please create venv and install dependencies first."
  exit 1
fi

mkdir -p "${ROOT_DIR}/.cache/matplotlib"

# Avoid inheriting conflicting Qt/Conda runtime variables from current shell.
unset QT_PLUGIN_PATH
unset QT_QPA_PLATFORM_PLUGIN_PATH
unset DYLD_FRAMEWORK_PATH
unset CONDA_PREFIX
unset CONDA_DEFAULT_ENV
unset CONDA_SHLVL

export MPLCONFIGDIR="${ROOT_DIR}/.cache/matplotlib"
if command -v octave-cli >/dev/null 2>&1; then
  export OCTAVE_EXECUTABLE="$(command -v octave-cli) --no-init-file"
fi

exec "${PY_BIN}" "${ROOT_DIR}/main.py"
