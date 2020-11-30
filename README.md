
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jstools

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/dreamRs/jstools.svg?branch=master)](https://travis-ci.org/dreamRs/jstools)
[![R build
status](https://github.com/dreamRs/jstools/workflows/R-CMD-check/badge.svg)](https://github.com/dreamRs/jstools/actions)
<!-- badges: end -->

> Set of tools to work with JavaScript and CSS (and addins to
> interactively use them in RStudio)

Disclaimer: I use this in my personnal workflow when working with
JavaScript or CSS, some functionnalities are similar to
[{js}](https://github.com/jeroen/js) or
[{reactR}](https://github.com/react-R/reactR).

## Installation

You can install the development version from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("dreamRs/jstools")
```

## Prettier : format code

Via <https://prettier.io/>

`prettier_js()` allow to reformat JavaScript code:

``` r
prettier_js("function add(first, second) { return first + second; }")
```

    function add(first, second) {
      return first + second;
    }

`pettier_css()` does the same thing for CSS:

``` r
prettier_css("b{font-weight: bold;color:red;}")
```

    b {
      font-weight: bold;
      color: red;
    }

You can reformat a file with:

``` r
prettier_file(input = "path/to/file.js", output = "path/to/reformated.js")
```

In Rstudio, you can use addin “Prettier” to reformat the current script
(careful, it will overwrite it).

## Terser : JavaScript compressor

Via <https://terser.org/>

`terser()` can be used to compress JavaScript code :

``` r
terser("function add(first, second) { return first + second; }")
#> $code
#> [1] "function add(n,d){return n+d}"
```

You can compress a file (or several) with:

``` r
terser_file(input = "path/to/file.js", output = "path/to/file.min.js")
terser_file(input = c("path/to/file1.js", "path/to/file2.js"), output = "path/to/file.min.js")
```

Source maps are crucial to the debugging process, thereby making it possible to reconstruct the original
JS code starting from a minified script. To correctly generate a source map, pass the __sourceMap__ option to `terser_options`. 
`includeSources = TRUE` is mandatory so that files may be retrieved by the web browser developer tools.
The folder will have the provided __root__ as name so it is important to name it consistently:

```r
path <- system.file("testfiles/htmlwidgets.js", package = "jstools")
# source maps options
o <- terser_options(
  sourceMap = list(
    root = "../../htmlwidgets-sources",
    filename = "file.min.js",
    url = "file.min.js.map",
    includeSources = TRUE
  )
)
# returns a list containing the minified code an the source map
terser_file(input = path, options = o)
```

## JSHint : code validation

Via <https://jshint.com/>

`jshint()` detect errors in JavaScript code:

``` r
res <- jshint(c("var a = 2;", "var foo = 1;", "b = 3", "a + c"))
res$errors[, c("line", "reason")]
#>   line                                                                 reason
#> 1    3                                                     Missing semicolon.
#> 2    4 Expected an assignment or function call and instead saw an expression.
#> 3    4                                                     Missing semicolon.
#> 4    3                                                    'b' is not defined.
#> 5    4                                                    'c' is not defined.
#> 6    2                                       'foo' is defined but never used.
```

Use with a file :

``` r
path <- system.file("testfiles/example.js", package = "jstools")
jshint_file(input = path)
#> -- Checking example.js --------------------------------------------------------- 
#> 6 errors found. 
#>  - Line 1: Missing semicolon. 
#>  - Line 2: 'foo' is defined but never used. 
#>  - Line 4: 'b' is not defined. 
#>  - Line 6: Expected an assignment or function call and instead saw an expression. 
#>  - Line 6: Missing semicolon. 
#>  - Line 6: 'c' is not defined.
```

To validate a Shiny script, you can add `jQuery` and `Shiny` as global
variables (same for `Htmlwidgets`:

``` r
jshint_file(input = path, options = jshint_options(jquery = TRUE, globals = list("Shiny")))
```

You can check several scripts at once (for example custom Shiny input
bindings in {shinyWidgets}):

``` r
bindings <- list.files(
  path = system.file("assets", package = "shinyWidgets"), 
  pattern = "bindings\\.js$",
  recursive = TRUE, 
  full.names = TRUE
)
jshint_file(input = bindings, options = jshint_options(jquery = TRUE, globals = list("Shiny")))
```

In Rstudio, you can use addin “JSHint” to run code validation on current
script.

## Babel : JavaScript compiler

Via <https://babeljs.io/>

`babel()` can be used to convert ES6+ code to ES5 to make it works in
most browser:

``` r
# Template literals are not supported in ES5
babel("var filename = `${Date.now()}.png`;")
```

    var filename = "".concat(Date.now(), ".png");

``` r
# Arrow function neither
babel("[1, 2, 3].map((n) => n + 1);")
```

    [1, 2, 3].map(function (n) {
      return n + 1;
    });

## Crass : CSS minifier and optimizer

Via <https://github.com/mattbasta/crass>

Minimize and optimize CSS code :

``` r
crass("b { font-weight: bold; }")
#> [1] "b{font-weight:700}"
```

You can concatenate several files together:

``` r
crass_file(
  input = c("path/to/file1.css", "path/to/file2.css"), 
  output = "path/to/file.min.css"
)
```

## CSSO : CSS minifier with structural optimizations

Via <https://github.com/css/csso>

Merge identical rules together:

``` r
csso(".foo { color: #ff0000; }\n.bar { color: rgba(255, 0, 0, 1); }")
#> [1] ".bar,.foo{color:red}"
```

You can also concatenate several files together:

``` r
csso_file(
  input = c("path/to/file1.css", "path/to/file2.css"), 
  output = "path/to/file.min.css"
)
```
