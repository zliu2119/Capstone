# Python Algorithm GUI

This project is a graphical user interface (GUI) for various algorithms, designed to provide an interactive platform for users to explore and utilize different algorithm implementations. The GUI is built using PySide6, allowing for a responsive and user-friendly experience.

## Project Structure

The project is organized as follows:

```
python-algorithm-gui
├── src
│   ├── algorithms
│   │   ├── __init__.py
│   │   └── fuzzy_logic.py
│   ├── ui
│   │   ├── __init__.py
│   │   ├── main_window.py
│   │   └── algo_list_panel.py
│   └── main.py
├── requirements.txt
└── README.md
```

- **src/algorithms/**: Contains algorithm implementations.
  - `__init__.py`: Initializes the algorithms module.
  - `fuzzy_logic.py`: Implements fuzzy logic algorithms.

- **src/ui/**: Contains the user interface components.
  - `__init__.py`: Initializes the UI module.
  - `main_window.py`: Defines the main application window and layout.
  - `algo_list_panel.py`: Displays the list of available algorithms.

- **src/main.py**: The entry point of the application, responsible for launching the GUI.

- **requirements.txt**: Lists the required Python libraries and dependencies.

## Installation

To set up the project, follow these steps:

1. Clone the repository:
   ```
   git clone <repository-url>
   cd python-algorithm-gui
   ```

2. Install the required dependencies:
   ```
   pip install -r requirements.txt
   ```

## Usage

To run the application, execute the following command:

```
python src/main.py
```

This will launch the algorithm GUI, where you can select and interact with various algorithms.

## Contributing

Contributions are welcome! If you have suggestions or improvements, please feel free to submit a pull request.