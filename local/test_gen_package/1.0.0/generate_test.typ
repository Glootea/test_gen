#import "parse_blocks.typ": parseBlocks
#import "generate_variant.typ": generateVariant
#import "state_monad.typ": bind, next-seed, pure, with-seed
#import "loop_with_seed_monad.typ": map-m


#let _questionCounter = counter("questionCounter")



#let generate_test(jsonBytes, variantCount: 15, showAnswer: false, showLink: false, initialSeed: 0, readPath) = {
  set text(
    size: 12pt,
  )
  set page(
    margin: (
      top: 0.5cm,
      left: 0.5cm,
    ),
  )

  let jsonContent = json(jsonBytes)
  let blocks = parseBlocks(jsonContent)
  map-m(range(variantCount), i => with-seed(seed => {
    let result = block(
      [
        #_questionCounter.update(c => 0)
        #(i + 1)Вар  Класс #h(5em) ФИО
        #linebreak()
        #let p = generateVariant(blocks, showAnswer, showLink, seed, readPath)
        #p
        #linebreak()
      ],
      breakable: false,
    )

    return result
  }))(initialSeed)
    .at(0)
    .join()
}
