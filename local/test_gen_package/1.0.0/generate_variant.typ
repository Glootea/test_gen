#import "random.typ": pick
#import "cartesian_product.typ": cartesian_product
#import "state_monad.typ": bind, next-seed, pure, with-seed
#import "generate_content_for_question.typ": getContentForQuestion
#import "loop_with_seed_monad.typ": map-m

#let _questionCounter = counter("questionCounter")

#let generateVariant(variantNumber, blocks, showAnswer, showLink, seed, readPath) = {
  let result = map-m(range(blocks.len()), i => with-seed(seed => {
    let block = blocks.at(i)
    let count = block.at("count")
    let questions = block.at("questions")

    let images = block.at("images")
    let imagesContent = images.at("content", default: none)
    let relativeWidths = images.at("relativeWidths")
    // why default does not work???
    if relativeWidths == none {
      relativeWidths = (1,) * imagesContent.len()
    }

    let cartesianProduct = cartesian_product(questions, imagesContent)
    let selectedQuestions = pick(count, cartesianProduct, seed)
    let questionsContent = ()
    for questionWithImage in selectedQuestions {
      let contentForQuestion = getContentForQuestion(
        questionWithImage,
        relativeWidths,
        _questionCounter,
        showAnswer,
        showLink,
        readPath,
      )
      questionsContent = questionsContent + (contentForQuestion,)
    }
    return questionsContent
  }))(seed)
    .at(0)
    .join()

  for i in range(result.len()) {
    let r = result.at(i)
    let contentForQuestion = r.at("content")
    let answerContent = r.at("answer")
    let linkContent = r.at("link")

    contentForQuestion
    linebreak()

    if showLink and linkContent != none {
      text("Ссылка: " + linkContent, blue)
      linebreak()
    }
  }

  if showAnswer {
    linebreak()
    context text("Ответы на вариант " + str(variantNumber), size: text.size * 1.5, red)
    let data = result
      .enumerate()
      .map(r => {
        let index = r.at(0) + 1
        let answer = r.at(1).at("answer")
        ([#index], [#answer])
      })
      .join()

    table(
      ..data,
      columns: (auto, 5fr),
      fill: (x, y) => if calc.rem(y, 2) == 0 { gray.transparentize(70%) },
    )
  }
}


