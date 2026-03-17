#!/usr/bin/env bash
set -eo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${ROOT_DIR}"

mkdir -p "${ROOT_DIR}/.cache/matplotlib"
mkdir -p "${ROOT_DIR}/.cache"
export MPLCONFIGDIR="${ROOT_DIR}/.cache/matplotlib"

has_required_modules() {
  local py="$1"
  # Keep the probe minimal and import-only: this avoids GUI startup side effects
  # while still proving the interpreter can satisfy runtime requirements.
  "${py}" -c "import importlib.util,sys;mods=('PySide6','oct2py','numpy','matplotlib');sys.exit(0 if all(importlib.util.find_spec(m) for m in mods) else 1)" >/dev/null 2>&1
}

add_candidate() {
  local py="$1"
  local existing
  [ -n "${py}" ] || return 0
  for existing in "${CANDIDATES[@]}"; do
    [ "${existing}" = "${py}" ] && return
  done
  CANDIDATES+=("${py}")
}

CANDIDATES=()
add_candidate "${ALGO_GUI_PYTHON:-}"
if [ -n "${VIRTUAL_ENV:-}" ]; then
  add_candidate "${VIRTUAL_ENV}/bin/python"
fi
if command -v python >/dev/null 2>&1; then
  add_candidate "$(command -v python)"
fi
if command -v python3 >/dev/null 2>&1; then
  add_candidate "$(command -v python3)"
fi
add_candidate "${ROOT_DIR}/.venv/bin/python"
add_candidate "${ROOT_DIR}/.venv_x86/bin/python"
add_candidate "/opt/anaconda3/envs/tf311/bin/python"
add_candidate "/opt/anaconda3/bin/python"

PY_BIN=""
# Candidate order is intentional: explicit override > active shell env >
# common local interpreters > project fallbacks.
for candidate in "${CANDIDATES[@]}"; do
  if [ -x "${candidate}" ] && has_required_modules "${candidate}"; then
    PY_BIN="${candidate}"
    break
  fi
done

if [ -z "${PY_BIN}" ]; then
  echo "No usable Python runtime found."
  echo "Set ALGO_GUI_PYTHON=/path/to/python and try again."
  exit 1
fi

# Stability guard for TensorFlow-backed algorithm tabs in this GUI process.
# This does not affect other projects or notebook sessions.
export CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:--1}"
export TF_CPP_MIN_LOG_LEVEL="${TF_CPP_MIN_LOG_LEVEL:-2}"
export TF_ENABLE_ONEDNN_OPTS="${TF_ENABLE_ONEDNN_OPTS:-0}"

if command -v octave-cli >/dev/null 2>&1; then
  OCT_WRAPPER="${ROOT_DIR}/.cache/octave-cli-no-init.sh"
  cat > "${OCT_WRAPPER}" <<EOF
#!/usr/bin/env bash
exec "$(command -v octave-cli)" --no-init-file --no-window-system "\$@"
EOF
  chmod +x "${OCT_WRAPPER}"
  export OCTAVE_EXECUTABLE="${OCT_WRAPPER}"
  export OCTAVE_CLI_OPTIONS="--no-site-file --no-window-system"
fi

exec "${PY_BIN}" "${ROOT_DIR}/main.py"
