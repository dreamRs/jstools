
terser("function add(first, second) { return first + second; }")


path <- system.file("testfiles/htmlwidgets.js", package = "jstools")
terser_file(input = path)

