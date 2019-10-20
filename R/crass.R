
#' @title crass
#'
#' A CSS minification, pretty printing, and general utility library written in JS.
#'
#' @param input Path to a CSS file.
#' @param pretty Pretty print result? Otherwise result is minified.
#' @param output Path where to write optimized code.
#'
#' @return a \code{character}.
#' @export
#'
#' @name crass
#'
#' @example
crass_file <- function(input, pretty = FALSE, output = NULL) {
  input <- normalizePath(path = input, mustWork = TRUE)
  input <- readLines(con = input, encoding = "UTF-8")
  result <- crass(code = input, pretty = pretty)
  if (!is.null(output)) {
    writeLines(text = result, con = output)
  } else {
    cat(result)
  }
  return(invisible(result))
}

#' @param code Character vector where each element represent a line of CSS code.
#'
#' @rdname crass
#'
#' @export
#'
#' @importFrom V8 v8
crass <- function(code, pretty = FALSE) {
  ctx <- v8()
  ctx$source(file = system.file("assets/crass/crass.js", package = "jstools"))
  ctx$assign("code", paste(code, collapse = "\n"))
  ctx$eval("var parsed = crass.parse(code);")
  ctx$eval("var optimized = parsed.optimize();")
  if (isTRUE(pretty)) {
    ctx$eval("parsed.pretty();")
  } else {
    ctx$eval("parsed.toString();")
  }
}

