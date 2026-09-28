#import "@local/test_gen_package:1.0.0": generate_test

#let readPath(pathStr) = path(pathStr)

#generate_test(
  read("test.jsonc", encoding: none),
  variantCount: 15,
  showAnswer: true,
  readPath,
)


