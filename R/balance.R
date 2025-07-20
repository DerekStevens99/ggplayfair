#' Compute a simple balance
#'
#' @param exports Numeric vector of export values.
#' @param imports Numeric vector of import values.
#' @return Numeric vector of exports minus imports.
#' @export
balance <- function(exports, imports) {
  exports - imports
}
