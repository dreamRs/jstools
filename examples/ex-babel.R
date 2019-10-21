# Template literals are not supported in ES5
babel("var filename = `${Date.now()}.png`;")

# Arrow function neither
babel("[1, 2, 3].map((n) => n + 1);")

