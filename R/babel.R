
#' @title Babel
#'
#' @description Babel is a tool that helps you write code in the latest version of
#'  JavaScript. When your supported environments don't support certain features
#'  natively, Babel will help you compile those features down to a supported version.
#'
#' @param input Path to JavaScript file.
#' @param options Options for terser, see \url{https://babeljs.io/docs/en/options}.
#' @param output Path where to write transformed code.
#'
#' @return a \code{list}.
#' @export
#'
#' @name babel
#'
#' @example examples/ex-babel.R
babel_file <- function(input, options = babel_options(), output = NULL) {
  input <- normalizePath(path = input, mustWork = TRUE)
  input <- readLines(con = input, encoding = "UTF-8")
  result <- babel(code = input, options = options)
  if (!is.null(output)) {
    writeLines(text = result$code, con = output)
  }
  return(invisible(result))
}

#' @param code Character vector where each element represent a line of CSS code.
#'
#' @rdname babel
#'
#' @export
#'
#' @importFrom V8 v8
babel <- function(code, options = babel_options()) {
  ctx <- v8()
  ctx$source(file = system.file("assets/babel/babel.min.js", package = "jstools"))
  ctx$assign("code", paste(code, collapse = "\n"))
  ctx$assign("options", options)
  ctx$eval("var output = Babel.transform(code, options);")
  ctx$get("output.code")
}



#' @param presets Preset to use, default to \code{"es2015"}.
#' @param sourceType Default to \code{"script"} : parse the file using the ECMAScript Script grammar.
#' @param ... Other options to use, see \url{https://babeljs.io/docs/en/options} for details.
#'
#' @return a \code{list}.
#' @export
#'
#' @rdname babel
#'
babel_options <- function(presets = list("es2015"), sourceType = "script", ...) {
  list(
    presets = presets,
    sourceType = sourceType,
    ...
  )
}
