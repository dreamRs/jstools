

# Minify prettier files ---------------------------------------------------

terser_file(input = "inst/assets/prettier/standalone.js", output = "inst/assets/prettier/standalone.min.js")
# terser_file(input = "inst/assets/prettier/parser-babylon.js", output = "inst/assets/prettier/parser-babylon.min.js")
terser_file(input = "inst/assets/prettier/parser-postcss.js", output = "inst/assets/prettier/parser-postcss.min.js")
