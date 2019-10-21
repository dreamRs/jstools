
# Check code from a character vector
jshint(c("var a = 2;", "var foo = 1;", "b = 3", "a + c"))


# From a file (can be several)
path <- system.file("testfiles/example.js", package = "jstools")
jshint_file(input = path)
