#' Function to handle single or multiple samples
#'
#' This function takes a vector `x` and returns a single random sample from it.
#' If the vector has only one element, it returns that element without attempting to sample.
#' This prevents errors that can occur when trying to sample from a single-element vector.
#' @param x A vector from which to sample.
#' @return A single element from the vector `x`.
sample_no_surprises <- function(x) {
  if (length(x) <= 1) {
    return(x)
  } else {
    return(sample(x, 1))
  }
}
