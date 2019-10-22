# Merge two rules
csso(".foo { color: #ff0000; }\n.bar { color: rgba(255, 0, 0, 1); }")

# With a file
path <- system.file("testfiles/example.css", package = "jstools")
csso_file(input = path)

