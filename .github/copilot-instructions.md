# Copilot Instructions for UtilsFlowSOMSV

## Purpose & Scope

This file provides guidelines for GitHub Copilot when working with the UtilsFlowSOMSV R package, which provides utility functions for assessing FlowSOM clustering output.

---

## Maintaining These Instructions

When updating copilot instructions, follow GitHub's best practices:

* Keep it concise - Files under 1000 lines (ideally under 250)
* Structure matters - Use headings, bullets, clear sections
* Be direct - Short, imperative rules over long paragraphs
* Show examples - Include code samples (correct and incorrect patterns)
* No external links - Copilot won't follow them; copy info instead
* No vague language - Avoid "be more accurate", "identify all issues", etc.
* Path-specific - Use applyTo frontmatter in topic files

---

## Code Quality

* Make minimal, surgical changes to fix issues
* Maintain backward compatibility when possible
* Follow existing patterns in the codebase
* Add tests for new functionality or bug fixes
* Never leave trailing whitespace at the end of lines or on blank lines
* Always add a blank line between headings (ending with `**`) and bullet points

---

## Before Committing

* Run `devtools::document()` to update documentation
* Run `devtools::test()` with LITE mode for faster iteration
* Run `devtools::check()` to ensure package passes R CMD check
* Update `_pkgdown.yml` if functions are added, removed, or newly imported/exported (see pkgdown section below)

---

## pkgdown Website Maintenance

When modifying exported functions, **always update `_pkgdown.yml`**:

* **Adding a function**: Add the function name to the appropriate `contents` section under `reference`
* **Removing a function**: Remove the function name from the `contents` section
* **Renaming a function**: Update the function name in the `contents` section
* **Adding a new category**: Add a new `- title:` block with `desc:` and `contents:` fields

### Example: Adding a New Function

```yaml
reference:
  - title: Cluster Stability
    desc: Functions for calculating and assessing cluster stability
    contents:
      - calc_cluster_stability
      - new_function_name  # Add new functions here
```

### Validation

* Run `pkgdown::check_pkgdown()` to verify `_pkgdown.yml` is valid
* All exported functions must be listed in `_pkgdown.yml`
* Internal functions (prefixed with `.`) should NOT be listed

---

## Package Structure

* `R/` - Source code (use `.` prefix for internal functions, no prefix for exported functions)
* `tests/testthat/` - Tests (use helper functions from `helper-*.R`)
* `man/` - Auto-generated docs (DO NOT edit directly)

---

## R Coding Standards

### Naming Conventions

* Use snake_case for function and variable names
* Prefix internal functions with `.` (e.g., `.get_flowset_test`)
* Exported functions should be descriptive (e.g., `calc_cluster_stability`)

### Documentation

* Use roxygen2 comments for all functions
* Include `@title`, `@param`, `@return`, and `@export` tags for exported functions
* Document internal functions with `@title`, `@description`, and `@return`

### Code Examples

✅ **Correct:**

```r
#' @title Calculate cluster stability
#' @param fs flowSet object
#' @return A tibble with stability metrics
#' @export
calc_cluster_stability <- function(fs, ...) {
  # implementation
}
```

❌ **Incorrect:**

```r
# Missing roxygen documentation
calcClusterStability <- function(fs, ...) {
  # implementation
}
```

---

## Testing Guidelines

* Place tests in `tests/testthat/`
* Name test files as `test-<function_name>.R`
* Use `skip_if_not_installed()` for optional dependencies
* Test both success and edge cases

### Test Example

```r
test_that("calc_cluster_stability works", {
  skip_if_not_installed("flowWorkspaceData")
  skip_if_not_installed("UtilsCytoRSV")

  fs <- .get_flowset_test()
  # ... test implementation
  expect_identical(ncol(out_tbl), 3L)
})
```

---

## FlowSOM-Specific Guidelines

* This package works with FlowSOM output from the Bioconductor FlowSOM package
* Use `flowCore` for flow cytometry data handling
* Input data (flowSet) should be transformed and compensated before use
* The main output is a tibble with cluster stability metrics (Jaccard coefficients)
