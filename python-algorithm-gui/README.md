# Python Algorithm GUI

This project is a PySide6 desktop GUI that runs algorithm demos through
Python wrappers and Octave `.m` models.

## Current Runtime Layout

Current executable runtime is at repository root:

- `main.py`
- `ui/`
- `algorithms/`

There is also a legacy mirror under `python-algorithm-gui/src/`.

## Requirements

- Python 3.10 (recommended for this repo)
- GNU Octave
- Python packages in `python-algorithm-gui/requirements.txt`

Install packages:

```bash
python3.10 -m venv .venv
.venv/bin/python -m pip install --upgrade pip setuptools wheel
.venv/bin/python -m pip install -r python-algorithm-gui/requirements.txt
```

## Run (Recommended)

Use the launcher script (no `activate` required):

```bash
bash run_gui.sh
```

On macOS you can also double-click:

- `run_gui.command`

Both launchers use `.venv/bin/python` directly and clear common conflicting
Qt/Conda env vars before startup.

## Run (Manual)

```bash
.venv/bin/python main.py
```

## Notes

- Fuzzy brake model is now vectorized/cached to reduce Octave call overhead.
- Algorithm execution in UI runs in a background thread to keep the window responsive.
