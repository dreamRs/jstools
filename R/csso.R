
#' @title CSSO - CSS optimizer
#'
#' @description CSSO (CSS Optimizer) is a CSS minifier. It performs three sort
#'  of transformations: cleaning (removing redundant), compression (replacement
#'  for shorter form) and restructuring (merge of declarations, rulesets and so
#'  on). As a result your CSS becomes much smaller.
#'
#' @param input Path to CSS file.
#' @param options Options for CSSO, see \url{https://github.com/css/csso}.
#' @param output Path where to write minified code.
#'
#' @return a \code{character}.
#' @export
#'
#' @name csso
#'
#' @example examples/ex-csso.R
csso_file <- function(input, options = csso_options(), output = NULL) {
  input <- normalizePath(path = input, mustWork = TRUE)
  input <- readLines(con = input, encoding = "UTF-8")
  result <- csso(code = input, options = options)
  if (!is.null(output)) {
    writeLines(text = result, con = output)
  }
  return(invisible(result))
}

#' @param code Character vector where each element represent a line of CSS code.
#'
#' @rdname csso
#'
#' @export
#'
#' @importFrom V8 v8
csso <- function(code, options = csso_options()) {
  ctx <- v8()
  ctx$source(file = system.file("assets/csso/csso-browser.js", package = "jstools"))
  ctx$assign("code", paste(code, collapse = "\n"))
  ctx$assign("options", options)
  ctx$eval("var output = csso.minify(code, options);")
  ctx$get("output.css")
}

#' @param restructure Restructure code or not.
#' @param ... Other options to use, see \url{https://github.com/css/csso} for details.
#'
#' @rdname csso
#'
#' @export
csso_options <- function(restructure = TRUE, ...) {
  list(
    restructure = restructure,
    ...
  )
}
