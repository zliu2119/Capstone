# Python Algorithm GUI

PySide6 desktop GUI for algorithm demos backed by Octave `.m` models.

## Runtime Layout

Primary runtime lives at repository root:

- `main.py`
- `ui/`
- `algorithms/`
- `run_gui.sh`
- `run_gui.command`
- `python-algorithm-gui/requirements.txt`
- `python-algorithm-gui/requirements-windows.txt`

Run all commands from the repository root, which is the folder containing
`main.py`.

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

macOS/Linux example (venv):

```bash
python3 -m venv .venv
.venv/bin/python -m pip install --upgrade pip setuptools wheel
.venv/bin/python -m pip install -r python-algorithm-gui/requirements.txt
```

Windows example (PowerShell):

```powershell
py -3.11 -m venv .venv
.\.venv\Scripts\python -m pip install --upgrade pip setuptools wheel
.\.venv\Scripts\python -m pip install -r python-algorithm-gui\requirements-windows.txt
```

If `py -3.11` is not available, install Python 3.11 from python.org or replace
that command with the full path to an installed Python executable.

## Windows Octave Setup

Several algorithms are backed by bundled Octave `.m` files, so Windows machines
need GNU Octave installed before running those modules.

1. Install GNU Octave for Windows.
2. Confirm that `octave-cli.exe` exists. Typical locations look like:

```text
C:\Program Files\GNU Octave\Octave-*\mingw64\bin\octave-cli.exe
```

3. If the GUI cannot find Octave automatically, set `ALGO_GUI_OCTAVE_EXE` in the
   same PowerShell session before launching the GUI:

```powershell
$env:ALGO_GUI_OCTAVE_EXE="C:\Program Files\GNU Octave\Octave-9.2.0\mingw64\bin\octave-cli.exe"
.\.venv\Scripts\python main.py
```

Adjust the Octave version number in the path to match the installed folder on
the target machine.

## Run

Recommended on macOS/Linux:

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

Windows manual run from the repository root:

```powershell
.\.venv\Scripts\python main.py
```

## Algorithm 7 Optional TensorFlow Setup

Algorithm 7 (`Deep Convolutional Module`) requires TensorFlow. This dependency
is intentionally optional because TensorFlow installation is more platform
specific than the core GUI stack.

The first six algorithms can run without TensorFlow. To enable Algorithm 7 on
Windows, install TensorFlow in a separate Python environment and point the GUI to
that interpreter:

```powershell
$env:ALGO_GUI_TF_PYTHON="C:\path\to\tf-env\python.exe"
.\.venv\Scripts\python main.py
```

On Windows CPU-only machines, `tensorflow-cpu` is usually the appropriate
package for that separate environment.

## Operational Notes

- `run_gui.command` filters one known macOS input-method noise line only:
  `IMKCFRunLoopWakeUpReliable`.
- Octave is started with headless-safe flags via wrapper and
  `OCTAVE_CLI_OPTIONS=--no-site-file --no-window-system`.
- On Windows, the GUI uses a native `octave-cli.exe` path. If Octave is not on
  `PATH`, set `ALGO_GUI_OCTAVE_EXE`.
- Algorithm execution is threaded in the UI to keep the window responsive.
- ANN Example 1 and ANN Example 2 use Python-first implementations in the
  current codebase; Octave remains required for Octave-backed modules.

## Troubleshooting

- `No usable Python runtime found`: install the listed Python dependencies in
  `.venv`, then run `.\.venv\Scripts\python main.py` on Windows or
  `.venv/bin/python main.py` on macOS/Linux.
- `Octave error` or Octave not found on Windows: install GNU Octave and set
  `ALGO_GUI_OCTAVE_EXE` to the full `octave-cli.exe` path.
- Algorithm 7 reports that no deep-learning interpreter was found: configure
  `ALGO_GUI_TF_PYTHON`, or skip Algorithm 7 and run Algorithms 1-6.
- Always start the app from the repository root so the GUI can locate `ui/`,
  `algorithms/`, and `algorithms/mfiles/`.
