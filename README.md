# Rotartsilib Monorepo

This is a unified monorepo for math, Lean 4, LaTeX, and Typst projects. It is designed to keep all projects organized, modular, and coherent, with clean isolated build artifacts.

## Quickstart

- **Lean**:
  - Run `make lean` to build the pure Lean library and executables.
  - Run `make docs` to generate Mathlib-style documentation (powered by `doc-gen4`) in the `.lake/build/doc` directory.
- **LaTeX**:
  - Run `make tex` to compile all `.tex` files inside the `tex/` directory. All outputs, including PDFs and auxiliary logs, will be cleanly isolated into `outputs/tex/` mirroring the directory structure.
- **Typst**:
  - Run `make typst` to compile all `.typ` files in `typst/`. The PDFs are similarly isolated in `outputs/typst/`.
- **Clean**:
  - Run `make clean` to wipe Lean caches and delete the entire `outputs/` folder.

## Ergonomics & Editors

- **VSCode**: 
  - The repository includes a `.vscode/settings.json` which configures LaTeX Workshop and Tinymist (Typst) to output compiled PDFs and auxiliary files seamlessly into the `outputs/` folder. This means you can just hit save in VSCode and your PDFs will appear in the correct output directory without polluting your source tree.
- **Other LSPs (Helix, Neovim)**: 
  - Ensure you configure your LaTeX LSP (e.g., `texlab`) and Typst LSP (`tinymist` or `typst-lsp`) to use the `Makefile` or pass the correct `--root` and `-output-directory` flags, otherwise your source folders may get polluted with build artifacts.

## Directory Structure

* **`Rotartsilib/`**: The core, reusable pure Lean codebase.
* **`Executables/`**: Lean programs and scripts (each with their own `Main.lean`).
* **`Verso/`**: Verso slides, books, and blogs.
* **`tex/`**: All LaTeX documents.
* **`typst/`**: All Typst documents.
* **`outputs/`**: Generated non-Lean build artifacts (e.g. PDFs). This folder is completely git-ignored.