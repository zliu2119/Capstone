#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "${ROOT_DIR}"

# Filter one known macOS IMK noise line only; keep all other stderr/stdout.
if ! /bin/bash "${ROOT_DIR}/run_gui.sh" 2>&1 | sed '/IMKCFRunLoopWakeUpReliable/d'; then
  echo
  echo "Launch failed. Press Enter to close this window."
  read -r _
fi
