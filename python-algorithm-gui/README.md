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
  - `scikit-learn`
- GNU Octave (`octave-cli` recommended)
- Optional for Algorithm 7: a Python interpreter with `tensorflow` + `sklearn`
  (set `ALGO_GUI_TF_PYTHON` if it differs from GUI runtime)

Base dependency file:

- `python-algorithm-gui/requirements.txt`
- `python-algorithm-gui/requirements-windows.txt` (Windows)

Locked reproducible set:

- `requirements-lock.txt`

## Install

Example (venv):

```bash
python3 -m venv .venv
.venv/bin/python -m pip install --upgrade pip setuptools wheel
.venv/bin/python -m pip install -r python-algorithm-gui/requirements.txt
```

Windows (PowerShell):

```powershell
py -3.11 -m venv .venv
.\.venv\Scripts\python -m pip install --upgrade pip setuptools wheel
.\.venv\Scripts\python -m pip install -r python-algorithm-gui\requirements-windows.txt
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

Windows manual run:

```powershell
.\.venv\Scripts\python main.py
```

## Operational Notes

- `run_gui.command` filters one known macOS input-method noise line only:
  `IMKCFRunLoopWakeUpReliable`.
- Octave is started with headless-safe flags via wrapper and
  `OCTAVE_CLI_OPTIONS=--no-site-file --no-window-system`.
- Algorithm execution is threaded in the UI to keep the window responsive.
- ANN Example 1 and ANN Example 2 use Python-first implementations in the
  current codebase; Octave remains required for Octave-backed modules.
