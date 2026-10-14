#import "parse_blocks.typ": parseBlocks
#import "generate_variant.typ": generateVariant
#import "state_monad.typ": bind, next-seed, pure, with-seed
#import "loop_with_seed_monad.typ": map-m


#let _questionCounter = counter("questionCounter")

#let _variantHeader(variantNumber) = [
  #_questionCounter.update(c => 0)
  #(variantNumber + 1)Вар  Класс #h(5em) ФИО
  #linebreak()
]

#let generate_test(
  jsonBytes,
  variantCount: 15,
  showAnswer: false,
  showLink: false,
  initialSeed: 0,
  isMultipage: false,
  readPath,
) = {
  set page(
    margin: (
      top: 0.2cm,
      left: 0.5cm,
    ),
  )

  let jsonContent = json(jsonBytes)
  let blocks = parseBlocks(jsonContent)
  map-m(range(variantCount), i => with-seed(seed => [
    #block(
      [
        #_variantHeader(i)
        #generateVariant(blocks, showAnswer, showLink, seed, readPath)
        // #linebreak()
      ],
      breakable: isMultipage,
    )
    #if isMultipage [
      #pagebreak()
    ]
  ]))(initialSeed)
    .at(0)
    .join()
}
