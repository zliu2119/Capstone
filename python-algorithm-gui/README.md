# Python Algorithm GUI

PySide6 desktop GUI for algorithm demos backed by Octave `.m` models.

## Runtime Layout

Primary runtime lives at repository root:

- `main.py`
- `ui/`
- `algorithms/`
- `run_gui.sh`
- `run_gui.command`

## Requirements

- A Python interpreter with:
  - `PySide6`
  - `oct2py`
  - `numpy`
  - `matplotlib`
- GNU Octave (`octave-cli` recommended)

Base dependency file:

- `python-algorithm-gui/requirements.txt`

Locked reproducible set:

- `requirements-lock.txt`

## Install

Example (venv):

```bash
python3 -m venv .venv
.venv/bin/python -m pip install --upgrade pip setuptools wheel
.venv/bin/python -m pip install -r python-algorithm-gui/requirements.txt
```

## Run

Recommended:

```bash
bash run_gui.sh
```

macOS double-click launcher:

- `run_gui.command`

The launcher auto-selects a usable Python runtime by checking candidate
interpreters for required modules. You can force a specific interpreter:

```bash
ALGO_GUI_PYTHON=/absolute/path/to/python bash run_gui.sh
```

Manual run:

```bash
python main.py
```

## Operational Notes

- `run_gui.command` filters one known macOS input-method noise line only:
  `IMKCFRunLoopWakeUpReliable`.
- Octave is started with headless-safe flags via wrapper and
  `OCTAVE_CLI_OPTIONS=--no-site-file --no-window-system`.
- Algorithm execution is threaded in the UI to keep the window responsive.
