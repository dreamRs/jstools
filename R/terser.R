
#' @title Terser - JavaScript compressor
#'
#' @description JavaScript parser, mangler and compressor toolkit for ES6+.
#'
#' @param input Path to one or more JavaScript files.
#' @param options Options for terser, see \url{https://terser.org/docs/api-reference}
#' and \url{https://terser.org/docs/cli-usage}.
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
      # save source map
      if (length(result$map) > 0) {
        writeLines(text = result$map, con = paste0(output, ".map"))
      }
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

#' @param ... Other options to use, see \url{https://terser.org/docs/api-reference}
#' and \url{https://terser.org/docs/cli-usage} for details.
#' Source maps are crucial to the debugging process, thereby making it possible to reconstruct the original
#' JS code starting from a minified script. To correctly generate source map, pass the \code{sourceMap} option
#' (see example). \code{includeSources = TRUE} is mandatory so that files may be retrieved by the web browser developer tools.
#' The folder will have the provided \code{root} as name so it's important to name it consistently!
#'
#' @rdname terser
#'
#' @export
terser_options <- function(...) {
  list(...)
}