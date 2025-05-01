#' Quietly Check Packages
#'
#' Creates a wrapper around `devtools::check()` to execute package checking quietly.
#' This function captures and returns the output and errors without printing them directly to the console.
#'
#' @param ... Arguments passed to purrr::quietly
#' @return A function that when executed will return a list containing elements `result`, `output`, `warnings`, and `messages`.
#' @seealso `purrr::quietly()` for details on the structure of the returned list.
#' @examples
#' \dontrun{
#' result <- check_quietly("myPackage")
#' }
#' @export
#' @importFrom purrr quietly
#' @importFrom devtools check install
#'


check_quietly <- purrr::quietly(devtools::check)

#' Quietly Install Packages
#'
#' Creates a wrapper around `devtools::install()` to execute package installation quietly.
#' This function captures and returns the output and errors without printing them directly to the console.
#' @param ... Arguments passed to purrr::quietly
#' @return A function that when executed will return a list containing elements `result`, `output`, `warnings`, and `messages`.
#' @seealso `purrr::quietly()` for details on the structure of the returned list.
#' @examples
#' \dontrun{
#' result <- install_quietly("myPackage")
#' }
#' @export
install_quietly <- purrr::quietly(devtools::install)

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

install_if_missing <- function(package, host = "CRAN") {
  if (host == "GitHub") {
    install_github_if_missing(repo = package)
  } else if (host == "R-Forge") {
    install_rforge_if_missing(package = package)
  } else if (host == "Bioconductor") {
    install_bioc_if_missing(package = package)
  } else if (host == "CRAN") {
    if (!require(package, character.only = TRUE)) {
      # Check if the package is available on CRAN
      if (!package %in% rownames(available.packages())) {
        stop(paste("Package", package, "is not available on CRAN."))
      }
      # Install the package from CRAN
      install.packages(package)
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
  }
}
#' Install R-Forge Package if Missing
#'
#' This function checks if a package is installed from R-Forge and installs it if not.
#' It uses the `install.packages` function to install the package from the specified R-Forge repository.
#' @param package The name of the package to check and install.
#' @param repo The R-Forge repository URL. Default is "http://R-Forge.R-project.org".
#' @return NULL

install_rforge_if_missing <- function(package, repo = "http://R-Forge.R-project.org") {
  if (!require(package, character.only = TRUE)) {
    install.packages(package, repos = repo)
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
