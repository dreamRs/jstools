
#' @title Terser - JavaScript compressor
#'
#' @description JavaScript parser, mangler and compressor toolkit for ES6+.
#'
#' @param input Path to JavaScript file(s).
#' @param options Options for terser, see \url{https://terser.org/docs/api-reference}.
#' @param output Path where to write optimized code.
#'
#' @return a \code{list}.
#' @export
#'
#' @name terser
#'
#' @example examples/ex-terser.R
terser_file <- function(input, options = terser_options(), output = NULL) {
  input <- normalizePath(path = input, mustWork = TRUE)
  input <- readLines(con = input, encoding = "UTF-8")
  result <- terser(code = input, options = options)
  if (!is.null(result$error)) {
    message(result$error$name, result$error$message)
  } else {
    if (!is.null(output)) {
      writeLines(text = result$code, con = output)
    }
  }
  return(invisible(result))
}

#' @param code Character vector where each element represent a line of JavaScript code,
#'  or a list of character vectors.
#'
#' @rdname terser
#'
#' @export
#'
#' @importFrom V8 v8
terser <- function(code, options = terser_options()) {
  ctx <- v8()
  ctx$source(file = system.file("assets/terser/source-map.min.js", package = "jstools"))
  ctx$source(file = system.file("assets/terser/bundle.min.js", package = "jstools"))
  ctx$assign("code", paste(code, collapse = "\n"))
  ctx$assign("options", options)
  ctx$eval("var result = Terser.minify(code, options);")
  ctx$get("result")
}

#' @param ... Other options to use, see \url{https://terser.org/docs/api-reference} for details.
#'
#' @rdname terser
#'
#' @export
terser_options <- function(...) {
  list(...)
}
