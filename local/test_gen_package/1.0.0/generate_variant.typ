#import "random.typ": pick
#import "cartesian_product.typ": cartesian_product
#import "state_monad.typ": bind, next-seed, pure, with-seed
#import "generate_content_for_question.typ": getContentForQuestion

#let _questionCounter = counter("questionCounter")

#let generateVariant(blocks, showAnswer, seed, readPath) = {
  let content = []
  let localSeed = seed
  for (index, block) in blocks.enumerate() {
    let count = block.at(0)
    let questions = block.at(1)

    let images = block.at(2, default: ())
    let cartesianProduct = cartesian_product(questions, images)
    let selectedQuestions = pick(count, cartesianProduct, localSeed)

    for questionWithImage in selectedQuestions {
      _questionCounter.step()
      let contentForQuestion = getContentForQuestion(
        questionWithImage,
        _questionCounter,
        showAnswer,
        readPath,
      )
      content += contentForQuestion
    }
  }
  return content
}
