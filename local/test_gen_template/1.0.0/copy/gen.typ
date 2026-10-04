#import "@local/test_gen_package:1.0.0": generate_test

#let readPath(pathStr) = path(pathStr)

#generate_test(
  read("test.json", encoding: none),
  variantCount: 20,
  showAnswer: false,
  showLink: false,
  readPath,
)


