
#' @title JSHint
#'
#' @description JSHint is a tool that helps to detect
#'  errors and potential problems in your JavaScript code.
#'
#' @param file Path to a JavaScript file.
#' @param options Options for JSHint, see \url{https://jshint.com/docs/options}.
#'
#' @return a \code{list} with the diagnosis of the JavaScript code
#' @export
#'
#' @name JSHint
#'
jshint_file <- function(file, options = jshint_options()) {
  file <- readLines(con = file)
  jshint(code = file, options = options)
}

#' @param code Character vector where each element represent a line of JavaScript code.
#'
#' @rdname JSHint
#'
#' @export
#'
#' @importFrom V8 v8
jshint <- function(code, options = jshint_options()) {
  ctx <- v8()
  ctx$source(
    file = system.file("assets/jshint/jshint.js", package = "jstools")
  )
  ctx$assign("code", code)
  ctx$assign("options", options)
  ctx$eval("JSHINT(code, options);")
  output <- ctx$get("JSHINT.data()")
  class(output) <- c(class(output), "jshint")
  return(output)
}

#' @param undef This option prohibits the use of explicitly undeclared variables.
#'  This option is very useful for spotting leaking and mistyped variables.
#' @param unused This option warns when you define and never use your variables.
#'  It is very useful for general code cleanup, especially when used in addition to undef.
#' @param browser This option defines globals exposed by modern browsers: all the way from
#'  good old document and navigator to the HTML5 FileReader and other new developments
#'  in the browser world.
#' @param jquery This option defines globals exposed by the jQuery JavaScript library.
#' @param devel This option defines globals that are usually used for logging poor-man's
#'  debugging: console, alert, etc. It is usually a good idea to not ship them in production
#'  because, for example, console.log breaks in legacy versions of Internet Explorer.
#' @param ... Other options to use, see \url{https://jshint.com/docs/options} for details.
#'
#' @rdname JSHint
#'
#' @export
jshint_options <- function(undef = TRUE, unused = "vars",
                           browser = TRUE, jquery = FALSE,
                           devel = FALSE, ...) {
  list(
    undef = undef,
    unused = unused,
    browser = browser,
    jquery = jquery,
    devel = devel,
    ...
  )
}

