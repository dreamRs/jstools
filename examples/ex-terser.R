
terser("function add(first, second) { return first + second; }")

# Mimic several files
terser(list(
  "file1.js" = "function add(first, second) { return first + second; }",
  "file2.js" = "add(1 + 2, 3 + 4);"
))
# equivalent to:
# > terser_file(c("file1.js", "file2.js"))

# With a file
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