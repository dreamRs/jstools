
# Format JavaScript code:
prettier_js(
  "foo(reallyLongArg(), omgSoManyParameters(),
   IShouldRefactorThis(), isThereSeriouslyAnotherOne());"
)

# or CSS
prettier_css("b{font-weight: bold;color:red;}")

# With a file
path <- system.file("testfiles/htmlwidgets.js", package = "jstools")
prettier_file(input = path)
