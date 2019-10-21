
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
  if (length(input) == 1) {
    inputs <- readLines(con = input, encoding = "UTF-8")
  } else {
    inputs <- lapply(input, readLines, encoding = "UTF-8")
    names(inputs) <- basename(input)
  }
  result <- terser(code = inputs, options = options)
  if (!is.null(result$error)) {
    message(result$error$name, result$error$message)
    return(invisible(result))
  } else {
    if (!is.null(output)) {
      writeLines(text = result$code, con = output)
      return(invisible(result))
    } else {
      return(result)
    }
  }
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
  if (is.list(code)) {
    code <- lapply(code, paste, collapse = "\n")
  } else {
    code <- paste(code, collapse = "\n")
  }
  ctx$assign("code", code)
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
