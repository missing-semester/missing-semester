---
layout: lecture
title: "ಕೋಡ್ ಗುಣಮಟ್ಟ"
description: >
  formatting, linting, testing, continuous integration ಮತ್ತು ಇನ್ನಷ್ಟು ವಿಷಯಗಳನ್ನು ಕಲಿಯಿರಿ.
thumbnail: /static/assets/thumbnails/2026/lec9.png
date: 2026-01-23
ready: true
video:
  aspect: 56.25
  id: XBiLUNx84CQ
---

ಉನ್ನತ ಗುಣಮಟ್ಟದ code ಬರೆಯಲು developers ಗೆ ನೆರವಾಗುವ ಹಲವು tools ಮತ್ತು ತಂತ್ರಗಳಿವೆ. ಈ ಉಪನ್ಯಾಸದಲ್ಲಿ ನಾವು ಇವುಗಳನ್ನು ನೋಡೋಣ:

- [ಫಾರ್ಮ್ಯಾಟಿಂಗ್](#formatting)
- [ಲಿಂಟಿಂಗ್](#linting)
- [ಟೆಸ್ಟಿಂಗ್](#testing)
- [Pre-commit hooks](#pre-commit-hooks)
- [Continuous integration](#continuous-integration)
- [Command runners](#command-runners)

ಅತಿರಿಕ್ತ ವಿಷಯವಾಗಿ [regular expressions](#regular-expressions) ಕೂಡ ನೋಡೋಣ. ಇದು ಹಲವಾರು ಕ್ಷೇತ್ರಗಳಿಗೆ ಅನ್ವಯಿಸುವ ವಿಷಯ - code quality ಯಲ್ಲಿ (ಉದಾ: pattern ಗೆ ಹೊಂದುವ tests subset ಮಾತ್ರ run ಮಾಡುವುದು) ಹಾಗೆಯೇ IDE ಗಳಲ್ಲಿ (ಉದಾ: search and replace) ಸಹ ಬಳಸಲಾಗುತ್ತದೆ.

ಈ tools ಗಳಲ್ಲಿ ಅನೇಕವು language-specific ಆಗಿರುತ್ತವೆ (ಉದಾ: Python ಗೆ [Ruff](https://docs.astral.sh/ruff/) linter/formatter). ಕೆಲವು tools ಬಹುಭಾಷಾ ಬೆಂಬಲ ಕೊಡುತ್ತವೆ (ಉದಾ: [Prettier](https://prettier.io/) code formatter). ಆದರೆ ಕಲ್ಪನೆಗಳು ಬಹುತೇಕ ವಿಶ್ವವ್ಯಾಪಕ - ಯಾವುದೇ programming language ಗೆ code formatter, linter, testing library ಇತ್ಯಾದಿ ಸಿಗುತ್ತವೆ.

# Formatting

Code auto-formatters ಮೂಲ syntax ನ presentation ಅನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಸುಂದರಗೊಳಿಸುತ್ತವೆ. ಇದರಿಂದ ನೀವು ಗಂಭೀರ ಮತ್ತು ಸವಾಲಿನ ಸಮಸ್ಯೆಗಳಿಗೆ ಗಮನಕೊಡಬಹುದು; meanwhile formatter `'` vs `"` string syntax consistency, binary operators ಸುತ್ತ spaces (`x+y` ಬದಲು `x + y`), `import` statements ಕ್ರಮ, ಮತ್ತು ಅತಿದೀರ್ಘ lines ತಪ್ಪಿಸುವುದು ಮೊದಲಾದ ಸಾಮಾನ್ಯ ವಿವರಗಳನ್ನು ನೋಡಿಕೊಳ್ಳುತ್ತದೆ. Code formatters ನ ಪ್ರಮುಖ ಲಾಭವೆಂದರೆ codebase ಮೇಲೆ ಕೆಲಸ ಮಾಡುವ developers ಎಲ್ಲರಿಗೂ ಏಕಸಮಾನ code style ಒದಗಿಸುವುದು.

Prettier ಮೊದಲಾದ ಕೆಲವು tools [ಹೆಚ್ಚು configurable](https://prettier.io/docs/configuration). Project configuration file ಅನ್ನು [version control](/2026/version-control/) ನಲ್ಲಿ commit ಮಾಡಬೇಕು. [Black](https://github.com/psf/black), [gofmt](https://pkg.go.dev/cmd/gofmt) ಮೊದಲಾದ tools ನಲ್ಲಿ configurability ಕಡಿಮೆ ಅಥವಾ ಇಲ್ಲ - [bikeshedding](https://en.wikipedia.org/wiki/Law_of_triviality) ಕಡಿಮೆ ಮಾಡಲು ಇದು ಉದ್ದೇಶಿತ.

Code formatter ಗೆ [IDE integration](/2026/development-environment/#code-intelligence-and-language-servers) ಸಕ್ರಿಯಗೊಳಿಸಿದರೆ type ಮಾಡುವಾಗ ಅಥವಾ file save ಮಾಡುವಾಗ code auto-format ಆಗುತ್ತದೆ. Project ಗೆ [EditorConfig](https://editorconfig.org/) file ಸೇರಿಸಬಹುದು. ಇದರಿಂದ file type ಪ್ರಕಾರ indent size ಮುಂತಾದ project-level settings IDE ಗೆ ತಿಳಿಯುತ್ತದೆ.

# Linting

Linters static analysis (code run ಮಾಡದೆ code ವಿಶ್ಲೇಷಣೆ) ನಡೆಸಿ antipatterns ಮತ್ತು ಸಾಧ್ಯ ಸಮಸ್ಯೆಗಳನ್ನು ಪತ್ತೆಹಿಡಿಯುತ್ತವೆ. ಈ tools autoformatters ಗಿಂತ ಆಳವಾದ ಮಟ್ಟದಲ್ಲಿ ಕೆಲಸ ಮಾಡುತ್ತವೆ - surface syntax ನಾಚೆಗೆ ಹೋಗಿ ವಿಶ್ಲೇಷಿಸುತ್ತವೆ. Analysis ಆಳವು tool ಪ್ರಕಾರ ಬದಲಾಗುತ್ತದೆ.

Linters ನಲ್ಲಿ _rules_ ಪಟ್ಟಿಗಳು ಮತ್ತು project ಮಟ್ಟದಲ್ಲಿ configure ಮಾಡಬಹುದಾದ presets ಇರುತ್ತವೆ. ಕೆಲವು rules false positives ನೀಡಬಹುದು; ಆಗ ಅವನ್ನು per-file ಅಥವಾ per-line ಆಧಾರದ ಮೇಲೆ disable ಮಾಡಬಹುದು.

ಉತ್ತಮ linters ನಲ್ಲಿ ಪ್ರತಿಯೊಂದು rule ಗಾಗಿ built-in help/documentation ಇರುತ್ತದೆ - rule ಏನು ಹುಡುಕುತ್ತದೆ, ಅದು ಯಾಕೆ ದುರ್ಬಲ pattern, ಉತ್ತಮ ಪರ್ಯಾಯ ಏನು ಎಂಬುದು ಸ್ಪಷ್ಟವಾಗಿರುತ್ತದೆ. ಉದಾಹರಣೆಗೆ Python ನಲ್ಲಿ ಅನಾವಶ್ಯಕ nested `if` statements ಹಿಡಿಯುವ [Ruff](https://docs.astral.sh/ruff/) ನ [SIM102](https://docs.astral.sh/ruff/rules/collapsible-if/) rule documentation ನೋಡಿ.

ಕೆಲವು linters ಸಮಸ್ಯೆಗಳನ್ನು flag ಮಾಡುವುದಷ್ಟೇ ಅಲ್ಲ, ಕೆಲವು ದೋಷಗಳನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಸರಿಪಡಿಸಿಯೂ ಬಿಡುತ್ತವೆ.

Language-specific linters ಹೊರತುಪಡಿಸಿ ಉಪಯುಕ್ತ tool ಆಗಿ [semgrep](https://github.com/semgrep/semgrep) ಅನ್ನು ನೋಡಬಹುದು. ಇದು AST ಮಟ್ಟದಲ್ಲಿ ಕೆಲಸ ಮಾಡುವ "semantic grep" (character ಮಟ್ಟದಲ್ಲಿ grep ಮಾಡುವುದಕ್ಕಿಂತ ಉನ್ನತ) ಮತ್ತು ಅನೇಕ ಭಾಷೆಗಳನ್ನು ಬೆಂಬಲಿಸುತ್ತದೆ. Projects ಗಾಗಿ custom linter rules ಬರೆಯಲು semgrep ಸೂಕ್ತ. ಉದಾ: Python ನಲ್ಲಿ ಅಪಾಯಕಾರಿ `subprocess.Popen(..., shell=True)` ಬಳಕೆಯನ್ನು ತಡೆಯಲು ಈ pattern ಹುಡುಕಬಹುದು:

```bash
semgrep -l python -e "subprocess.Popen(..., shell=True, ...)"
```

# Testing

Software testing ಎಂದರೆ ನಿಮ್ಮ code ಸರಿಯೇ ಎಂಬ ವಿಶ್ವಾಸವನ್ನು ಹೆಚ್ಚಿಸುವ ಮಾನದಂಡ ತಂತ್ರ. ನೀವು code ಬರೆಯುತ್ತೀರಿ; ಬಳಿಕ ಅದೇ code ನ ವರ್ತನೆಯನ್ನು exercise ಮಾಡುವ test code ಬರೆಯುತ್ತೀರಿ. ನಿರೀಕ್ಷಿತಂತೆ ಕೆಲಸ ಮಾಡದಿದ್ದರೆ tests ದೋಷವನ್ನು ಎತ್ತುತ್ತವೆ.

ವಿವಿಧ granularities ನಲ್ಲಿ tests ಬರೆಯಬಹುದು: ಪ್ರತ್ಯೇಕ functions ಗಾಗಿ _unit tests_, modules/services ನಡುವಿನ ಸಂವಹನಕ್ಕೆ _integration tests_, end-to-end ಸಂದರ್ಭಗಳಿಗೆ _functional tests_. ನೀವು _test-driven development_ ಅನುಸರಿಸಬಹುದು - implementation ಮುಂಚೆ tests ಬರೆಯುವುದು. Bug ಸಿಕ್ಕಾಗ _regression tests_ ಸೇರಿಸಿ ಮುಂದೆಯೂ ಅದೇ ಸಮಸ್ಯೆ ಮರಳಿ ಬಾರದಂತೆ ನೋಡಬಹುದು. [QuickCheck](https://hackage.haskell.org/package/QuickCheck) ಮೂಲಕ ಪ್ರಸಿದ್ಧಿಯಾದ _property-based tests_ (Python ನಲ್ಲಿ [Hypothesis](https://hypothesis.readthedocs.io/) ಹಾಗೆ) ಬರೆಯಬಹುದು. ಯಾವ ವಿಧಾನ ಸೂಕ್ತ ಎಂಬುದು project ಅವಲಂಬಿತ; ಬಹುಪಾಲು ಸಂದರ್ಭಗಳಲ್ಲಿ ಮಿಶ್ರ ವಿಧಾನ ಬಳಸಲಾಗುತ್ತದೆ.

ನಿಮ್ಮ program ಗೆ database ಅಥವಾ web API ಮೊದಲಾದ external dependencies ಇದ್ದರೆ, test ಸಮಯದಲ್ಲಿ third-party dependency ಜೊತೆ ನೇರ ಸಂಪರ್ಕ ಮಾಡುವ ಬದಲು ಅವನ್ನು _mock_ ಮಾಡುವುದು ಸಹಾಯಕ.

## Code coverage

Code coverage ಎಂದರೆ tests ಗುಣಮಟ್ಟವನ್ನು ಅಳೆಯುವ metric. Tests run ಆಗುವಾಗ code ನ ಯಾವ lines execute ಆಗುತ್ತವೆ ಎಂದು coverage ನೋಡುತ್ತದೆ; ಇದರಿಂದ ಎಲ್ಲಾ code paths cover ಆಗುತ್ತಿವೆಯೇ ಎಂದು ಖಚಿತಪಡಿಸಬಹುದು. Coverage tools line-by-line ಮಾಹಿತಿ ತೋರಿಸಿ tests ಬರೆಯುವ ದಾರಿಗೆ ಮಾರ್ಗದರ್ಶನ ಕೊಡುತ್ತವೆ. [Codecov](https://app.codecov.io) ಮೊದಲಾದ services project ಇತಿಹಾಸದ coverage ಅನ್ನು track/view ಮಾಡಲು web interfaces ಒದಗಿಸುತ್ತವೆ.

ಯಾವ metric ಆದರೂ code coverage ಪರಿಪೂರ್ಣವಲ್ಲ. Coverage ಸಂಖ್ಯೆಯ ಮೇಲಷ್ಟೇ ಗಮನಕೊಡಬೇಡಿ; ಉನ್ನತ ಗುಣಮಟ್ಟದ tests ಬರೆಯುವುದರ ಮೇಲೆ ಗಮನಹರಿಸಿ.

# Pre-commit hooks

Git pre-commit [hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) - [pre-commit](https://pre-commit.com/) framework ಮೂಲಕ ಸುಲಭವಾಗುವ ವಿಧಾನ - ಪ್ರತಿಯೊಂದು Git commit ಮೊದಲು user-ನಿರ್ಧರಿತ code ಅನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಓಡಿಸುತ್ತವೆ. Projects ಗಳು ಸಾಮಾನ್ಯವಾಗಿ formatters, linters, ಕೆಲವೊಮ್ಮೆ tests ಕೂಡ commit ಮೊದಲು run ಆಗುವಂತೆ pre-commit hooks ಬಳಸುತ್ತವೆ. ಉದ್ದೇಶ: commit ಆಗುವ code project style ಗೆ ಹೊಂದಿಕೆಯಾಗಿರಲಿ ಮತ್ತು ನಿರ್ದಿಷ್ಟ ಸಮಸ್ಯೆಗಳಿಲ್ಲದಿರಲಿ.

# Continuous integration

[GitHub Actions](https://github.com/features/actions) ಮೊದಲಾದ Continuous integration (CI) services, ನೀವು code push ಮಾಡಿದಾಗ (ಅಥವಾ pull request ಗಳಲ್ಲಿ, ಅಥವಾ schedule ಪ್ರಕಾರ) scripts run ಮಾಡಬಹುದು. Developers ಸಾಮಾನ್ಯವಾಗಿ CI ನಲ್ಲಿ formatters, linters, tests ಮುಂತಾದ code quality tools run ಮಾಡುತ್ತಾರೆ. Compiled languages ಗಾಗಿ code compile ಆಗುತ್ತದೆಯೇ ಪರಿಶೀಲಿಸಬಹುದು; statically typed languages ಗಾಗಿ type checking ಖಚಿತಪಡಿಸಬಹುದು. ಹೊಸ commits ಪ್ರತಿ push ಗೆ CI ಓಡಿಸಿದರೆ main branch ಗೆ ಸೇರಿದ ದೋಷಗಳು ಹಿಡಿಯುತ್ತವೆ. Pull requests ಮೇಲೆ run ಮಾಡಿದರೆ contributor submissions ಸಮಸ್ಯೆಗಳು ಪತ್ತೆಯಾಗುತ್ತವೆ. Schedule ಮೇಲೆ run ಮಾಡಿದರೆ external dependency issues ಹಿಡಿಯಬಹುದು (ಉದಾ: ಯಾರಾದರೂ ತಪ್ಪಾಗಿ [semver-compatible](/2026/shipping-code/#releases--versioning) ಆಗಿದೆ ಎಂದು breaking change release ಮಾಡುವುದು).

CI scripts developer machine ನಿಂದ ಪ್ರತ್ಯೇಕವಾಗಿ ನಡೆಯುವುದರಿಂದ, ದೀರ್ಘ ಸಮಯ ತೆಗೆದುಕೊಳ್ಳುವ jobs ಅನ್ನು ಸುಲಭವಾಗಿ ಅಲ್ಲಿ ಓಡಿಸಬಹುದು. ಉದಾ: software ವಿವಿಧ operating systems ಮತ್ತು programming language versions ಗಳಲ್ಲಿ ಸರಿಯಾಗಿ ಕೆಲಸ ಮಾಡುತ್ತದೆಯೇ ಎಂದು ಪರೀಕ್ಷಿಸಲು _matrix_ tests run ಮಾಡಬಹುದು.

ಸಾಮಾನ್ಯವಾಗಿ CI script ನಿಮ್ಮ code ನ್ನೇ ನೇರವಾಗಿ ಬದಲಾಯಿಸುವುದಿಲ್ಲ: "fix" mode ಬದಲು "check-only" mode ನಲ್ಲಿ tools run ಆಗುತ್ತವೆ. ಉದಾ: auto-formatter format ಗೆ ಅನುಗುಣವಾಗದ code ಕಂಡರೆ error ನೀಡುತ್ತದೆ.

Repositories ನಲ್ಲಿ ಸಾಮಾನ್ಯವಾಗಿ README ಯಲ್ಲಿ [status badges](https://docs.github.com/en/actions/how-tos/monitor-workflows/add-a-status-badge) ಇರುತ್ತವೆ - CI status ಮತ್ತು code coverage ಮುಂತಾದ ಮಾಹಿತಿ ತೋರಿಸಲು. ಉದಾಹರಣೆಗೆ ಕೆಳಗೆ Missing Semester ನ build status ಇದೆ.

[![Build Status](https://github.com/missing-semester/missing-semester/actions/workflows/build.yml/badge.svg)](https://github.com/missing-semester/missing-semester/actions/workflows/build.yml) [![Links Status](https://github.com/missing-semester/missing-semester/actions/workflows/links.yml/badge.svg)](https://github.com/missing-semester/missing-semester/actions/workflows/links.yml)

> [links checker](https://github.com/missing-semester/missing-semester/blob/master/.github/workflows/links.yml) (ಇದು [proof-html](https://github.com/anishathalye/proof-html) GitHub Action ಬಳಸುತ್ತದೆ) ಮೂರನೇ ಪಕ್ಷದ websites ಸಮಸ್ಯೆಗಳ ಕಾರಣದಿಂದ ಆಗಾಗ ವಿಫಲವಾಗುತ್ತದೆ. ಆದರೂ, ಇದು ಅನೇಕ broken links ಹಿಡಿದು ಸರಿಪಡಿಸಲು ಸಹಾಯಮಾಡಿದೆ (ಕೆಲವೊಮ್ಮೆ typos, ಹೆಚ್ಚುಸಾರಿ redirects ಇಲ್ಲದೆ website content ಸ್ಥಳಾಂತರಿಸುವುದು ಅಥವಾ websites ಅಳಿದುಹೋಗುವುದು).

CI services, formatters, linters, testing libraries ಮುಂತಾದವುಗಳ ನಿಖರ ಬಳಕೆ ಕಲಿಯಲು ಉತ್ತಮ ವಿಧಾನ ಎಂದರೆ ಉದಾಹರಣೆಗಳಿಂದ ಕಲಿಯುವುದು. GitHub ನಲ್ಲಿ ಉತ್ತಮ open-source projects ಹುಡುಕಿ - programming language, domain, project size/scope ಹೀಗೆ ನಿಮ್ಮ project ಗೆ ಹೆಚ್ಚು ಹತ್ತಿರ ಇರುವುದಾದಷ್ಟು ಉತ್ತಮ - ನಂತರ ಅವುಗಳ `pyproject.toml`, `.github/workflows/`, `DEVELOPMENT.md` ಮತ್ತು ಸಂಬಂಧಿತ files ಅಧ್ಯಯನ ಮಾಡಿ.

## Continuous deployment

Continuous deployment ಎಂದರೆ CI infrastructure ಬಳಸಿ ಬದಲಾವಣೆಗಳನ್ನು ನೇರವಾಗಿ _deploy_ ಮಾಡುವುದು. ಉದಾ: Missing Semester repository GitHub Pages ಗೆ continuous deployment ಬಳಸುತ್ತದೆ. ಹೀಗಾಗಿ lecture notes update ಮಾಡಿ `git push` ಮಾಡಿದಾಗ site ಸ್ವಯಂಚಾಲಿತವಾಗಿ build ಆಗಿ deploy ಆಗುತ್ತದೆ. CI ನಲ್ಲಿ applications ಗಾಗಿ binaries ಅಥವಾ services ಗಾಗಿ Docker images ಮೊದಲಾದ ಬೇರೆ [artifacts](/2026/shipping-code/) ಕೂಡ build ಮಾಡಬಹುದು.

# Command runners

[just](https://github.com/casey/just) ಮೊದಲಾದ command runners project context ನಲ್ಲಿ commands run ಮಾಡುವುದನ್ನು ಸುಲಭಗೊಳಿಸುತ್ತವೆ. Project ಗೆ code quality infrastructure ಹೆಚ್ಚಾದಂತೆ `uv run ruff check --fix` ರೀತಿಯ commands developers ನೆನಪಿಡಬೇಕಾಗದಂತೆ ಮಾಡುವುದು ಮುಖ್ಯ. Command runner ಇದ್ದರೆ ಇದೇ ಕೆಲಸ `just lint` ಆಗಬಹುದು. ಅದೇ ರೀತಿ `just format`, `just typecheck` ಇತ್ಯಾದಿ invocations ರಚಿಸಿ developer ಬೇಕಾದ tools ಎಲ್ಲಕ್ಕೂ ಸರಳ entry point ಕೊಡಬಹುದು.

ಕೆಲವು language-specific project/package managers ನಲ್ಲಿ ಈ functionality built-in ಇರುತ್ತದೆ. ಅಂಥ ಸಂದರ್ಭಗಳಲ್ಲಿ `just` ಹಾಗೆ language-agnostic tool ಬೇಕಾಗುವುದಿಲ್ಲ. ಉದಾ: [npm](https://nodejs.org/en/learn/getting-started/an-introduction-to-the-npm-package-manager) (Node.js) ಯ `package.json` ನಲ್ಲಿ `scripts` ವಿಭಾಗ ಮತ್ತು [Hatch](https://hatch.pypa.io/) (Python) ಯ `pyproject.toml` ನಲ್ಲಿ `tool.hatch.envs.*.scripts` ವಿಭಾಗಗಳು ಈ ಕೆಲಸ ಮಾಡುತ್ತವೆ.

# Regular expressions

_Regular expressions_ (ಸಾಮಾನ್ಯವಾಗಿ "regex") ಎಂದರೆ strings ಸಮೂಹಗಳನ್ನು ಪ್ರತಿನಿಧಿಸುವ ಭಾಷೆ. Regex patterns ಅನ್ನು command-line tools, IDEs ಸೇರಿದಂತೆ ಹಲವು ಸಂದರ್ಭಗಳಲ್ಲಿ pattern matching ಗಾಗಿ ಬಳಸುತ್ತಾರೆ. ಉದಾ: [ag](https://github.com/ggreer/the_silver_searcher) codebase-wide search ಗೆ regex ಬೆಂಬಲಿಸುತ್ತದೆ (`ag "import .* as .*"` Python ನಲ್ಲಿ renamed imports ಎಲ್ಲವನ್ನೂ ಹುಡುಕುತ್ತದೆ), ಮತ್ತು [go test](https://pkg.go.dev/cmd/go#hdr-Test_packages) ನಲ್ಲಿ tests subset ಆಯ್ಕೆ ಮಾಡಲು `-run [regexp]` ಆಯ್ಕೆ ಇದೆ. ಜೊತೆಗೆ programming languages ನಲ್ಲಿ regex matching ಗೆ built-in support ಅಥವಾ third-party libraries ಇರುವುದರಿಂದ pattern matching, validation, parsing ಮುಂತಾದ ಕಾರ್ಯಗಳಲ್ಲಿ regex ಉಪಯೋಗಿಸಬಹುದು.

ಅನುವೈಜ್ಞಾನಿಕ ಗ್ರಹಿಕೆಗೆ ಕೆಲವು regex pattern ಉದಾಹರಣೆಗಳು ಕೆಳಗೆ. ಈ ಉಪನ್ಯಾಸದಲ್ಲಿ [Python regex syntax](https://docs.python.org/3/library/re.html) ಬಳಸುತ್ತೇವೆ. Regex ಗೆ ಹಲವು flavors ಇದ್ದು, ವಿಶೇಷವಾಗಿ advanced features ನಲ್ಲಿ ಸಣ್ಣ ವ್ಯತ್ಯಾಸಗಳಿವೆ. Regex patterns ರಚನೆ/debug ಮಾಡಲು [regex101](https://regex101.com/) ಮೊದಲಾದ online tester ಉಪಯುಕ್ತ.

- `abc` - literal "abc" ಗೆ match ಆಗುತ್ತದೆ.
- `missing|semester` - "missing" ಅಥವಾ "semester" string ಗೆ match ಆಗುತ್ತದೆ.
- `\d{4}-\d{2}-\d{2}` - YYYY-MM-DD ದಿನಾಂಕ ಮಾದರಿಗೆ match (ಉದಾ: "2026-01-14"). ಇದು ರೂಪವಷ್ಟೇ ಪರಿಶೀಲಿಸುತ್ತದೆ; ನಿಜವಾದ ದಿನಾಂಕ ಮಾನ್ಯತೆ ಪರಿಶೀಲಿಸುವುದಿಲ್ಲ. ಆದ್ದರಿಂದ "2026-01-99" ಕೂಡ match ಆಗುತ್ತದೆ.
- `.+@.+` - ಕೆಲವು ಪಠ್ಯ + `@` + ಇನ್ನಷ್ಟು ಪಠ್ಯ ಇರುವ email-like strings ಗೆ match. ಇದು ಅತ್ಯಂತ ಮೂಲ ಪರಿಶೀಲನೆ ಮಾತ್ರ; "nonsense@@@email" ಕೂಡ match ಆಗುತ್ತದೆ. False positives/negatives ಇಲ್ಲದ email regex [ಇದೆ](https://pdw.ex-parrot.com/Mail-RFC822-Address.html), ಆದರೆ ಪ್ರಾಯೋಗಿಕವಾಗಿ ಬಳಸಲು ಕಷ್ಟ.

## Regex syntax

Regex syntax ಗೆ ಸಮಗ್ರ ಮಾರ್ಗದರ್ಶಿ [ಈ documentation](https://docs.python.org/3/library/re.html#regular-expression-syntax) ನಲ್ಲಿ ಸಿಗುತ್ತದೆ (ಆನ್‌ಲೈನಿನಲ್ಲಿ ಇಂತಹ ಹಲವಾರು ಸಂಪನ್ಮೂಲಗಳಿವೆ). ಮೂಲ ಕಟ್ಟುಗಲ್ಲುಗಳು:

- `abc` - characters ಗೆ ವಿಶೇಷ ಅರ್ಥ ಇಲ್ಲದಿದ್ದರೆ literal string ಗೆ match (ಈ ಉದಾಹರಣೆಯಲ್ಲಿ "abc")
- `.` - ಯಾವುದೇ ಒಂದು character ಗೆ match
- `[abc]` - brackets ಒಳಗಿನ ಒಂದೇ character ಗೆ match (ಈ ಉದಾಹರಣೆಯಲ್ಲಿ "a", "b", ಅಥವಾ "c")
- `[^abc]` - brackets ಒಳಗಿನವುಗಳನ್ನು ಹೊರತುಪಡಿಸಿದ ಒಂದೇ character ಗೆ match (ಉದಾ: "d")
- `[a-f]` - ಸೂಚಿಸಿದ range ಒಳಗಿನ ಒಂದೇ character ಗೆ match (ಉದಾ: "c", ಆದರೆ "q" ಅಲ್ಲ)
- `a|b` - ಯಾವುದಾದರೂ pattern ಗೆ match (ಉದಾ: "a" ಅಥವಾ "b")
- `\d` - ಯಾವುದೇ digit character ಗೆ match (ಉದಾ: "3")
- `\w` - ಯಾವುದೇ word character ಗೆ match (ಉದಾ: "x")
- `\b` - word _boundary_ ಗೆ match (ಉದಾ: "missing semester" ನಲ್ಲಿ "m" ಮುಂಚೆ, "g" ನಂತರ, "s" ಮುಂಚೆ, "r" ನಂತರ)
- `(...)` - pattern group ಗೆ match
- `...?` - pattern ನ zero ಅಥವಾ one occurrence ಗೆ match. ಉದಾ: `words?` - "word" ಅಥವಾ "words"
- `...*` - pattern ನ ಯಾವುದೇ ಸಂಖ್ಯೆಯ occurrences ಗೆ match. ಉದಾ: `.*` - ಯಾವುದೇ characters ಯಾವುದೇ ಸಂಖ್ಯೆಯಲ್ಲಿ
- `...+` - pattern ನ one or more occurrences ಗೆ match. ಉದಾ: `\d+` - ಒಂದು ಅಥವಾ ಹೆಚ್ಚು digits
- `...{N}` - pattern ನ ನಿಖರ N occurrences ಗೆ match. ಉದಾ: `\d{4}` - 4 digits
- `\.` - literal `.` ಗೆ match
- `\\` - literal `\` ಗೆ match
- `^` - line ಆರಂಭಕ್ಕೆ match
- `$` - line ಅಂತ್ಯಕ್ಕೆ match

## Capture groups and references

Regex groups `(...)` ಬಳಸಿದಾಗ match ನ ಉಪಭಾಗಗಳನ್ನು extraction ಅಥವಾ search-and-replace ಗಾಗಿ reference ಮಾಡಬಹುದು. ಉದಾ: YYYY-MM-DD ದಿನಾಂಕದಲ್ಲಿ ತಿಂಗಳ ಭಾಗ ಮಾತ್ರ ತೆಗೆಯಲು Python code:

```python
>>> import re
>>> re.match(r"\d{4}-(\d{2})-\d{2}", "2026-01-14").group(1)
'01'
```

Text editor ನಲ್ಲಿ replace patterns ಗೆ capture group references ಬಳಸಬಹುದು. Syntax IDE ಪ್ರಕಾರ ಬದಲಾಗಬಹುದು. ಉದಾ: VS Code ನಲ್ಲಿ `$1`, `$2`, ... ಬಳಸಬಹುದು; Vim ನಲ್ಲಿ `\1`, `\2`, ... ಬಳಸಬಹುದು.

## Limitations

[Regular languages](https://en.wikipedia.org/wiki/Regular_language) ಶಕ್ತಿಶಾಲಿಯಾದರೂ ಮಿತಿಗಳಿವೆ. ಕೆಲವು string classes ಅನ್ನು standard regex ಮೂಲಕ ವ್ಯಕ್ತಪಡಿಸಲಾಗುವುದಿಲ್ಲ (ಉದಾ: {a^n b^n \| n &ge; 0} ಸೆಟ್‌ಗೆ regex ಬರೆಯುವುದು [ಸಾಧ್ಯವಿಲ್ಲ](https://en.wikipedia.org/wiki/Pumping_lemma_for_regular_languages) - ಅಂದರೆ ಕೆಲವು "a"ಗಳ ನಂತರ ಅದೇ ಸಂಖ್ಯೆಯ "b"ಗಳು; ಹಾಗೆಯೇ HTML ಮೊದಲಾದ ಭಾಷೆಗಳು regular languages ಅಲ್ಲ). ಪ್ರಾಯೋಗಿಕವಾಗಿ modern regex engines lookahead, backreferences ಮೊದಲಾದ features ಮೂಲಕ regular languages ಗಿಂತ ಮುಂದೆ ಬೆಂಬಲ ಕೊಡುತ್ತವೆ ಮತ್ತು ಬಹಳ ಉಪಯುಕ್ತ. ಆದರೆ expressive power ಇನ್ನೂ ಮಿತಿಯಲ್ಲಿದೆ ಎಂಬುದನ್ನು ತಿಳಿದುಕೊಳ್ಳುವುದು ಮುಖ್ಯ. ಹೆಚ್ಚು ಸಂಕೀರ್ಣ ಭಾಷೆಗಳಿಗೆ, ಹೆಚ್ಚು ಸಾಮರ್ಥ್ಯವಿರುವ parser ಅಗತ್ಯವಾಗಬಹುದು (ಉದಾ: [pyparsing](https://github.com/pyparsing/pyparsing), ಒಂದು [PEG](https://en.wikipedia.org/wiki/Parsing_expression_grammar) parser).

## Learning regex

ನಮ್ಮ ಶಿಫಾರಸು: ಮೊದಲು ಮೂಲಭುತಗಳು (ಈ ಉಪನ್ಯಾಸದಲ್ಲಿ ನೋಡಿದ ವಿಷಯಗಳು) ಚೆನ್ನಾಗಿ ಕಲಿಯಿರಿ, ನಂತರ ಅಗತ್ಯವಿದ್ದಾಗ regex references ನೋಡುತ್ತಾ ಮುಂದುವರಿಯಿರಿ. ಸಂಪೂರ್ಣ ಭಾಷೆಯನ್ನು ಮನಪಾಠ ಮಾಡಬೇಕಾಗಿಲ್ಲ.

Conversational AI tools regex patterns ರಚಿಸಲು ಸಹಾಯಕ. ಉದಾ: ನಿಮ್ಮ ಇಷ್ಟದ LLM ಗೆ ಈ query ನೀಡಿ:

```
Write a Python-style regex pattern that matches the requested path from log lines from Nginx. Here is an example log line:

169.254.1.1 - - [09/Jan/2026:21:28:51 +0000] "GET /feed.xml HTTP/2.0" 200 2995 "-" "python-requests/2.32.3"
```

# ವ್ಯಾಯಾಮಗಳು

1. ನೀವು ಕೆಲಸ ಮಾಡುತ್ತಿರುವ project ಗೆ formatter, linter, pre-commit hooks configure ಮಾಡಿ. ದೋಷಗಳು ಹೆಚ್ಚು ಇದ್ದರೆ autoformatting ಬಹುಪಾಲು format errors ಸರಿಪಡಿಸುತ್ತದೆ. Linter errors ಗಾಗಿ [AI agent](/2026/agentic-coding/) ಬಳಸಿ ಎಲ್ಲವನ್ನು ಸರಿಪಡಿಸಲು ಪ್ರಯತ್ನಿಸಿ. Agent ಗೆ linter run ಮಾಡಿ ಫಲಿತಾಂಶ ನೋಡುವ ಅವಕಾಶ ಕೊಡಿ, ಆಗ iterative loop ಮೂಲಕ ಎಲ್ಲಾ issues ಸರಿಪಡಿಸಬಹುದು. ಫಲಿತಾಂಶವನ್ನು ಜಾಗ್ರತೆಯಿಂದ ಪರಿಶೀಲಿಸಿ - AI ನಿಮ್ಮ code ಅನ್ನು ಹಾಳು ಮಾಡದಂತೆ ನೋಡಿಕೊಳ್ಳಿ.
1. ನಿಮಗೆ ಪರಿಚಿತ programming language ನಲ್ಲಿ ಒಂದು testing library ಕಲಿತು, ನಿಮ್ಮ project ಗೆ unit test ಬರೆಯಿರಿ. Coverage tool run ಮಾಡಿ HTML-formatted coverage report ರಚಿಸಿ ಫಲಿತಾಂಶ ನೋಡಿ. ಯಾವ lines cover ಆಗಿವೆ ಎಂದು ಕಾಣುತ್ತದೆಯೇ? ಆರಂಭದಲ್ಲಿ coverage ಕಡಿಮೆ ಇರಬಹುದು. ಕೈಯಿಂದ ಕೆಲವು tests ಬರೆಯಿ coverage ಹೆಚ್ಚಿಸಿ. ನಂತರ [AI agent](/2026/agentic-coding/) ಬಳಸಿ coverage ಸುಧಾರಿಸಲು ಪ್ರಯತ್ನಿಸಿ; coding agent ಗೆ coverage ಜೊತೆಗೆ tests run ಮಾಡಲು ಮತ್ತು line-by-line report ರಚಿಸಲು ಅವಕಾಶ ಇರಲಿ. AI ರಚಿಸಿದ tests ನಿಜವಾಗಿಯೂ ಉತ್ತಮವಾಗಿವೆಯೇ?
1. ನೀವು ಕೆಲಸ ಮಾಡುತ್ತಿರುವ project ನಲ್ಲಿ ಪ್ರತಿಯೊಂದು push ಗೆ run ಆಗುವಂತೆ continuous integration ಹೊಂದಿಸಿ. CI ನಲ್ಲಿ formatting, linting, tests run ಆಗಲಿ. ಉದ್ದೇಶಪೂರ್ವಕವಾಗಿ code break ಮಾಡಿ (ಉದಾ: linter violation ಸೇರಿಸಿ) ಮತ್ತು CI ಅದನ್ನು ಹಿಡಿಯುತ್ತದೆಯೇ ದೃಢಪಡಿಸಿ.
1. ಒಂದು [regex pattern](#regular-expressions) ಬರೆಯಿರಿ ಮತ್ತು `grep` [command-line tool](/2026/course-shell/) ಬಳಸಿ ನಿಮ್ಮ code ನಲ್ಲಿ `subprocess.Popen(..., shell=True)` occurrences ಹುಡುಕಿ. ನಂತರ ಆ regex pattern ಅನ್ನು "break" ಮಾಡಲು ಪ್ರಯತ್ನಿಸಿ. ನಿಮ್ಮ grep invocation ತಪ್ಪಿಸುವ ಅಪಾಯಕಾರಿ code ಅನ್ನು [semgrep](#linting) ಇನ್ನೂ ಸರಿಯಾಗಿ ಪತ್ತೆಹಿಡಿಯುತ್ತದೆಯೇ?
1. ನಿಮ್ಮ IDE/text editor ನಲ್ಲಿ regex search-and-replace ಅಭ್ಯಾಸ ಮಾಡಿ: [Markdown bullet markers](https://spec.commonmark.org/0.31.2/#bullet-list-marker) ಆಗಿರುವ `-` ಅನ್ನು `*` ಗೆ ಬದಲಿಸಿ ([ಈ lecture notes](https://raw.githubusercontent.com/missing-semester/missing-semester/refs/heads/master/_2026/code-quality.md) ನಲ್ಲಿ). file ನಲ್ಲಿರುವ ಎಲ್ಲ `-` characters ಬದಲಿಸಿದರೆ ತಪ್ಪು, ಏಕೆಂದರೆ ಅವುಗಳಲ್ಲಿ ಬಹಳವು bullet markers ಅಲ್ಲ.
1. `{"name": "Alyssa P. Hacker", "college": "MIT"}` ರೂಪದ JSON ನಲ್ಲಿ name (`Alyssa P. Hacker`) ಹಿಡಿಯುವ regex ಬರೆಯಿರಿ. ಸೂಚನೆ: ಮೊದಲ ಪ್ರಯತ್ನದಲ್ಲಿ `Alyssa P. Hacker", "college": "MIT` ವರೆಗೂ ಹಿಡಿಯುವ greedy pattern ಬರೆಯುವ ಸಾಧ್ಯತೆ ಇದೆ; ಇದನ್ನು ಸರಿಪಡಿಸಲು [Python regex docs](https://docs.python.org/3/library/re.html) ನಲ್ಲಿ greedy quantifiers ಬಗ್ಗೆ ಓದಿ.
    1. name ಒಳಗೆ `"` (JSON escaped double quotes) ಇದ್ದರೂ ಕೆಲಸ ಮಾಡುವಂತೆ regex pattern ಸುಧಾರಿಸಿ.
    1. ಪ್ರಾಯೋಗಿಕವಾಗಿ sophisticated parsing ಸಮಸ್ಯೆಗಳಿಗೆ regular expressions ಬಳಸುವುದನ್ನು ನಾವು **ಶಿಫಾರಸು ಮಾಡುವುದಿಲ್ಲ**. ಈ ಕೆಲಸಕ್ಕೆ ನಿಮ್ಮ programming language ನ JSON parser ಹೇಗೆ ಬಳಸುವುದು ಎಂದು ಕಂಡುಹಿಡಿಯಿರಿ. ಮೇಲ್ಕಂಡ ರೂಪದ JSON ಅನ್ನು stdin ಮೂಲಕ ಸ್ವೀಕರಿಸಿ, name ಅನ್ನು stdout ಗೆ ಮುದ್ರಿಸುವ command-line program ಬರೆಯಿರಿ. ಇದಕ್ಕೆ ಕೆಲವೇ ಸಾಲುಗಳ code ಸಾಕು. Python ನಲ್ಲಿ `import json` ಹೊರತುಪಡಿಸಿ ಒಂದು ಸಾಲಿನಲ್ಲಿ ಮಾಡಬಹುದು.
