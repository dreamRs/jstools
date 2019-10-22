
#' @title Prettier - opinionated code formatter.
#'
#' @description Prettier is an opinionated code formatter. It enforces a
#'  consistent style by parsing your code and re-printing it with its own
#'  rules that take the maximum line length into account, wrapping code when necessary.
#'
#' @param input Path to one or more JavaScript files.
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
  file_ext <- gsub(pattern = ".*\\.([0-9a-zA-Z]+)$", replacement = "\\1", x = basename(input))
  file_ext <- tolower(file_ext)
  input <- readLines(con = input, encoding = "UTF-8")
  if (file_ext %in% c("css", "scss", "less")) {
    result <- prettier_css(code = input, options = options)
  } else {
    result <- prettier_js(code = input, options = options)
  }
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
prettier_js <- function(code, options = prettier_options()) {
  ctx <- v8()
  ctx$source(file = system.file("assets/prettier/standalone.min.js", package = "jstools"))
  ctx$source(file = system.file("assets/prettier/parser-babylon.js", package = "jstools"))
  ctx$assign("code", paste(code, collapse = "\n"))
  ctx$eval('prettier.format(code, { parser: "babel", plugins: prettierPlugins });')
}

#' @rdname prettier
#'
#' @export
#'
#' @importFrom V8 v8
prettier_css <- function(code, options = prettier_options()) {
  ctx <- v8()
  ctx$source(file = system.file("assets/prettier/standalone.min.js", package = "jstools"))
  ctx$source(file = system.file("assets/prettier/parser-postcss.min.js", package = "jstools"))
  ctx$assign("code", paste(code, collapse = "\n"))
  ctx$eval('prettier.format(code, { parser: "css", plugins: prettierPlugins });')
}


#' @param ... Other options to use, see \url{https://prettier.io/docs/en/options.html} for details.
#'
#' @rdname prettier
#'
#' @export
prettier_options <- function(...) {
  list(...)
}


prettier_addin <- function() {
  context <- rstudioapi::getSourceEditorContext()
  prettier_file(input = context$path, output = context$path)
}



