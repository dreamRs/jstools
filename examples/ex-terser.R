
terser("function add(first, second) { return first + second; }")

# Mimic several files
terser(list(
  "file1.js" = "function add(first, second) { return first + second; }",
  "file2.js" = "add(1 + 2, 3 + 4);"
))
# equivalent to:
#> terser_file(c("file1.js", "file2.js"))

# With a file
path <- system.file("testfiles/htmlwidgets.js", package = "jstools")
terser_file(input = path)

