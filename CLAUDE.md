# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

**datascience4psych** is an R package that provides utility functions and datasets to support introductory data science education for psychology students. Maintained by S. Mason Garrison (garrissm@wfu.edu).

## Build & Check Commands

```bash
# Full R CMD check (the primary CI validation)
Rscript -e 'devtools::check()'

# Run tests only
Rscript -e 'devtools::test()'

# Run a single test file
Rscript -e 'testthat::test_file("tests/testthat/test-advdate.R")'

# Regenerate documentation from roxygen2 comments
Rscript -e 'devtools::document()'

# Install the package locally
Rscript -e 'devtools::install()'
```

## Code Style

- Follow the [Tidyverse Style Guide](https://style.tidyverse.org/).
- Use `roxygen2` for all function documentation (current version: 7.3.3).
- Include `@examples` in roxygen blocks where practical.

## Testing

- Framework: `testthat` (edition 3).
- Tests live in `tests/testthat/`.
- All existing tests must pass before submitting changes.
- Add tests for any new functionality.

## Project Structure

- `R/` -- Package source code (schedule helpers, package tools, content embedding, general helpers).
- `tests/testthat/` -- Unit tests.
- `man/` -- Auto-generated documentation (do not edit by hand).
- `data/` -- Exported datasets (`.rda` files).
- `data-raw/` -- Scripts and raw files used to produce datasets.
- `.github/workflows/` -- CI: R-CMD-check (multi-platform), test coverage (codecov), pkgdown site.

## Key Dependencies

- **Imports:** stringr, devtools, webshot, purrr, tweetrmd, knitr
- **Suggests:** testthat (>= 3.0.0)
- **Requires:** R >= 3.5

## Branching Strategy

- `main` -- Stable, CRAN-ready releases.
- `dev_main` -- Staging for the next release.
- `dev` -- Active development (less stable).
- Feature branches are created from `dev_main`.
