# Minimize and update rules
crass("b { font-weight: bold; }")

# With a file
path <- system.file("testfiles/example.css", package = "jstools")
crass_file(input = path)

# You can concatenate several files together
#> crass_file(input = c("file1.css", "file2.css"), output = "file.min.css")
