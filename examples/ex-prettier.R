

prettier("foo(reallyLongArg(), omgSoManyParameters(),
         IShouldRefactorThis(), isThereSeriouslyAnotherOne());")

path <- system.file("testfiles/htmlwidgets.js", package = "jstools")
prettier_file(input = path)
