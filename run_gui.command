#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "${ROOT_DIR}"

if ! bash "${ROOT_DIR}/run_gui.sh"; then
  echo
  echo "Launch failed. Press Enter to close this window."
  read -r _
fi
