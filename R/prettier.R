
#' @title Prettier
#'
#' @description Prettier is an opinionated code formatter.
#'
#' @param input Path to JavaScript file(s).
#' @param options Options for terser, see \url{https://prettier.io/docs/en/options.html }.
#' @param output Path where to write optimized code.
#'
#' @return a \code{character}.
#' @export
#'
#' @name prettier
#'
#' @example examples/ex-prettier.R
prettier_file <- function(input, options = prettier_options(), output = NULL) {
  input <- normalizePath(path = input, mustWork = TRUE)
  input <- readLines(con = input)
  result <- prettier(code = input, options = options)
  if (!is.null(output)) {
    writeLines(text = result, con = output)
  } else {
    cat(result)
  }
  return(invisible(result))
}

#' @param code Character vector where each element represent a line of JavaScript code.
#'
#' @rdname prettier
#'
#' @export
#'
#' @importFrom V8 v8
prettier <- function(code, options = prettier_options()) {
  ctx <- v8()
  ctx$source(file = system.file("assets/prettier/standalone.js", package = "jstools"))
  ctx$source(file = system.file("assets/prettier/parser-babylon.js", package = "jstools"))
  ctx$assign("code", paste(code, collapse = "\n"))
  ctx$eval('prettier.format(code, { parser: "babel", plugins: prettierPlugins });')
}

#' @param ... Other options to use, see \url{https://prettier.io/docs/en/options.html} for details.
#'
#' @rdname prettier
#'
#' @export
prettier_options <- function(...) {
  list(...)
}
