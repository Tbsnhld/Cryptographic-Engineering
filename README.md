# Cryptographic Engineering

This repository includes my implementations of the Cryptographic Engineering tasks of WiSe 2026-27.

## Repository Structure

The repository is organised by **lecture** (`L1`, `L2`, ...) and, inside each lecture, by **individual task**. Every task is a self-contained project that can be built and run on its own:

```
.
├── L1                          # Lecture 1
│   └── HashFunctions            # Task 1: file hashing tool
│       ├── src/main.rs          #   implementation
│       ├── Cargo.toml           #   dependencies (Rust)
│       └── input_file.txt       #   sample input
├── scripts
│   └── update_algorithm_table.sh  # regenerates the table below
└── README.md
```

## Implemented Algorithms

<!-- ALGORITHMS:START -->
| Lecture | Task | Implemented Algorithm(s) | Location |
| :--- | :--- | :--- | :--- |
| L1 | HashFunctions | SHA3-256 | [`L1/HashFunctions/`](L1/HashFunctions/) |
<!-- ALGORITHMS:END -->

## Keeping the Table Up to Date

The table above is generated automatically and should not be edited by hand. After adding or changing a task, simply run from the repository root:

```bash
./scripts/update_algorithm_table.sh
```

To add a new task:

1. Create a folder following the `L<lecture>/<TaskName>` pattern, e.g. `L2/BlockCiphers/`.
2. To make the **Implemented Algorithm(s)** column meaningful, add a file named `algorithms.txt` inside the task folder and list one algorithm per line, e.g.:

   ```
   SHA3-256
   ```

   If no `algorithms.txt` exists, the task folder name is used as a fallback.
3. Run `./scripts/update_algorithm_table.sh` to refresh the table, then commit `README.md` together with your task.

## Running a Task

Each task is a standalone Rust (Cargo) project. From the task folder run:

```bash
cargo run
```

E.g. for the hash tool: `cd L1/HashFunctions && cargo run`, then type a filename at the prompt to compute its SHA3-256 hash.
