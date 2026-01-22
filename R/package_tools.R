#' Quietly check a package with devtools
#'
#' A thin wrapper around [devtools::check()] executed via [purrr::quietly()].
#' This captures output, warnings, and messages instead of printing them.
#'
#' This is primarily useful for instructors and package maintainers. If you ship
#' this to students, keep in mind it requires the suggested packages `devtools`
#' and `purrr`.
#'
#' @param ... Arguments forwarded to [devtools::check()].
#' @param quiet Logical; if `TRUE`, suppress printed output (default `TRUE`).
#'
#' @return A list with elements `result`, `output`, `warnings`, and `messages`
#'   in the format returned by [purrr::quietly()].
#'
#' @seealso [purrr::quietly()], [devtools::check()]
#'
#' @examples
#' \dontrun{
#' out <- check_quietly(pkg = ".")
#' str(out)
#' }
#'
#' @export

check_quietly <- function(..., quiet = TRUE) {
  if (!requireNamespace("purrr", quietly = TRUE)) {
    stop("Package 'purrr' is required for check_quietly(). Install it first.")
  }
  if (!requireNamespace("devtools", quietly = TRUE)) {
    stop("Package 'devtools' is required for check_quietly(). Install it first.")
  }

  f <- purrr::quietly(devtools::check, quiet = quiet)
  f(...)
}

#' Quietly Install Packages
#'
#' A thin wrapper around [devtools::install()] executed via [purrr::quietly()].
#' This captures output, warnings, and messages instead of printing them.
#'
#' This is primarily useful for instructors and package maintainers. If you ship
#' this to students, keep in mind it requires the suggested packages `devtools`
#' and `purrr`.
#'
#' @param ... Arguments forwarded to [devtools::install()].
#' @param quiet Logical; if `TRUE`, suppress printed output (default `TRUE`).
#'
#' @return A list with elements `result`, `output`, `warnings`, and `messages`
#'   in the format returned by [purrr::quietly()].
#'
#' @seealso [purrr::quietly()], [devtools::install()]
#'
#' @examples
#' \dontrun{
#' out <- install_quietly(pkg = ".")
#' str(out)
#' }
#'
#' @export
install_quietly <- function(..., quiet = TRUE) {
  if (!requireNamespace("purrr", quietly = TRUE)) {
    stop("Package 'purrr' is required for install_quietly(). Install it first.")
  }
  if (!requireNamespace("devtools", quietly = TRUE)) {
    stop("Package 'devtools' is required for install_quietly(). Install it first.")
  }

  f <- purrr::quietly(devtools::install, quiet = quiet)
  f(...)
}
#' Check and Install Packages Quietly
#'
#' Executes the check or install commands quietly, using purrr's quietly wrapper.
#' @param ... Arguments passed to devtools::check or devtools::install.
#' @param quiet Logical indicating whether to suppress output (default is TRUE for shhh_check).
#' @return Returns a list of the function results.
#' @examples
#' \dontrun{
#' result <- shhh_check("myPackage")
#' install_results <- pretty_install("myPackage")
#' }
#' @export
shhh_check <- function(..., quiet = TRUE) {
  out <- check_quietly(..., quiet = quiet)
  out$result
}

#' Pretty Install
#'
#' Performs a quiet installation and cleans up the output, only displaying relevant information.
#' @param ... Arguments passed to install_quietly.
#' @return Returns a cleaned list of output and messages.
#' @examples
#' \dontrun{
#' install_results <- pretty_install("myPackage")
#' }
#' @export
pretty_install <- function(...) {
  out <- install_quietly(...)
  output <- strsplit(out$output, split = "\n")[[1]]
  output <- grep("^(\\s*|[-|])$", output, value = TRUE, invert = TRUE)
  c(output, out$messages)
}

#' Conditionally Install Packages
#'
#' This function checks if a package is installed and installs it if not.
#' It also provides options for installing from GitHub, R-Forge, or Bioconductor.
#'
#' @param package The name of the package to check and install.
#' @param host The host from which to install the package. Options are "CRAN", "GitHub", "R-Forge", or "Bioconductor".
#' @param repo The GitHub repository in the format "username/repo" (for GitHub installations).

install_if_missing <- function(package, host = "CRAN", repo = NULL) {
  if (host == "GitHub") {
    if (is.null(repo)) {
      install_github_if_missing(repo = package)
    } else {
      install_github_if_missing(repo = repo)
    }
  } else if (host == "R-Forge") {
    install_rforge_if_missing(package = package)
  } else if (host == "Bioconductor") {
    install_bioc_if_missing(package = package)
  } else if (host == "CRAN") {
    if (!require(package, character.only = TRUE)) {
      # Check if the package is available on CRAN
      if (!package %in% rownames(utils::available.packages())) {
        stop(paste("Package", package, "is not available on CRAN."))
      }
      # Install the package from CRAN
      utils::install.packages(package)
    }
  } else {
    stop("Invalid host specified. Use 'CRAN', 'GitHub', 'R-Forge', or 'Bioconductor'.")
  }
}


#' Install GitHub Package if Missing
#'
#' This function checks if a package is installed from GitHub and installs it if not.
#' It uses the `devtools` package to install the package from a specified GitHub repository.
#' @param repo The GitHub repository in the format "username/repo".
#' @return NULL
#' @importFrom devtools install_github

install_github_if_missing <- function(repo) {
  package <- unlist(strsplit(repo, "/"))[2]
  if (!require(package, character.only = TRUE)) {
    devtools::install_github(repo)
  } else {
    message(paste("Package", package, "is already installed."))
  }
}
#' Install R-Forge Package if Missing
#'
#' This function checks if a package is installed from R-Forge and installs it if not.
#' It uses the `install.packages` function to install the package from the specified R-Forge repository.
#' @param package The name of the package to check and install.
#' @param repo The R-Forge repository URL. Default is "http://R-Forge.R-project.org".
#' @return NULL

install_rforge_if_missing <- function(package,
                                      repo = "http://R-Forge.R-project.org") {
  if (!require(package, character.only = TRUE)) {
    utils::install.packages(package, repos = repo)
  }
}

#' Install Bioconductor Package if Missing
#'
#' This function checks if a package is installed from Bioconductor and installs it if not.
#' It uses the `BiocManager` package to install the package from the specified Bioconductor repository.
#' @param package The name of the package to check and install.
#' @return NULL


install_bioc_if_missing <- function(package) {
  if (!requireNamespace(package, quietly = TRUE)) {
    devtools::install(package)
  }
}
