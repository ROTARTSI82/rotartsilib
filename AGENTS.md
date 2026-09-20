# Agent Documentation: Rotartsilib Monorepo

## Overview
This repository serves as a unified monorepo for math and Lean-related projects. It leverages Lean 4 (via `lake`), `latexmk` for LaTeX, and `typst` for Typst typesetting.

## Directory Structure

* **`lakefile.toml`**: The Lake package manifest. We deliberately keep this minimal:
  * Only **one** `lean_lib` (`Rotartsilib`) representing pure, reusable library code.
  * Various `lean_exe` targets (`app1`, `app2`, `build_slides`) representing artifacts to be built (binaries, static sites).
* **`Rotartsilib/`**: The core, reusable Lean codebase, acting as the foundation of the project. Imported by executables and slides.
* **`Executables/`**: Subdirectories for distinct Lean programs (e.g., `App1`, `App2`). Each has its own entry point (e.g., `Executables.App1.Main`).
* **`VersoContent/`**: Contains code for Verso slides. The main entry point is `VersoContent.SlidesMain`, which gets compiled into the `build_slides` executable artifact.
* **`tex/`**: Contains all `.tex` documents (like psets and beamer slides).
* **`typst/`**: Contains all `.typ` documents.
* **`outputs/`**: A fully git-ignored isolated folder. All non-Lean build artifacts (e.g., `.pdf`s) generated from `tex` or `typst` are compiled here dynamically by the `Makefile`.
* **`Makefile`**: A central orchestrator for building non-Lean outputs and invoking `lake`. 
  * `make lean` (runs `lake build`)
  * `make docs` (runs `doc-gen4` via `lake build Rotartsilib:docs`)
  * `make tex` (compiles all `tex/` files to `outputs/tex/`)
  * `make typst` (compiles all `typst/` files to `outputs/typst/`)
  * `make clean` (wipes Lean caches and the `outputs/` folder)

## Agent Guidelines for modifying this repo
1. **Adding a new Lean program**: Create a new folder in `Executables/`, write the `Main.lean`, and add a corresponding `[[lean_exe]]` to `lakefile.toml`.
2. **Adding a Verso presentation**: 
   - **For Slideshows**: We maintain multiple slideshows cleanly in the `VersoContent/Slides/` directory. To add a new slideshow, create your Lean file there (e.g. `VersoContent/Slides/MySlideshow.lean`), and update `VersoContent/SlidesMain.lean` to build it to its own directory (e.g. `outputDir := "_slides/MySlideshow"`). Then run `make verso` which copies everything to `outputs/verso/slides/`.
3. **Modifying Math Code**: All pure math or shared utilities belong in `Rotartsilib/`. Do not pollute `Executables/` with library code.
4. **Docs**: To render the mathlib-style docs for `Rotartsilib`, use `make docs`.

## Ergonomics and Editor Configuration
When configuring or debugging tools for this repository, you must maintain the clean separation of source and outputs:
- Do not let LaTeX or Typst LSPs dump their outputs into the `tex/` or `typst/` folders.
- VSCode is already configured via `.vscode/settings.json` to place LaTeX Workshop and Tinymist outputs precisely into `outputs/tex/` and `outputs/typst/`.
- If modifying these settings or adding configuration for other editors (like Helix/Neovim), ensure the isolated `outputs/` folder continues to be utilized.
