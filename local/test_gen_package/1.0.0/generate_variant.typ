#import "random.typ": pick
#import "cartesian_product.typ": cartesian_product
#import "state_monad.typ": bind, next-seed, pure, with-seed
#import "generate_content_for_question.typ": getContentForQuestion
#import "loop_with_seed_monad.typ": map-m

#let _questionCounter = counter("questionCounter")

#let generateVariant(blocks, showAnswer, seed, readPath) = {
  let content = []
  map-m(range(blocks.len()), i => with-seed(seed => {
    let block = blocks.at(i)
    let count = block.at(0)
    let questions = block.at(1)

    let images = block.at(2)
    let imagesContent = images.at("content", default: none)
    let relativeWidths = images.at("relativeWidths")
    // why default does not work???
    if relativeWidths == none {
      relativeWidths = (1,) * imagesContent.len()
    }

    let cartesianProduct = cartesian_product(questions, imagesContent)
    let selectedQuestions = pick(count, cartesianProduct, seed)

    for questionWithImage in selectedQuestions {
      let contentForQuestion = getContentForQuestion(
        questionWithImage,
        relativeWidths,
        _questionCounter,
        showAnswer,
        readPath,
      )
      contentForQuestion
    }
  }))(seed)
    .at(0)
    .join()
}
