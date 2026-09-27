
#let _isAnswerWithImage(showAnswer, imageContent) = {
  if showAnswer == false {
    return false
  }
  let ans = imageContent.at("a")
  return ans != none
}


#let _generateText(content, questionContent, showAnswerFromText) = {
  if type(questionContent) == str {
    content += questionContent + ": "
    content += linebreak()
  }

  if type(questionContent) == dictionary {
    content += questionContent.q + ": "
    content += linebreak()
    if showAnswerFromText {
      content += text("Ответ: " + questionContent.a, red)
      content += linebreak()
    }
  }
  return content
}

#let _generateImage(content, imageContent, showAnswerFromText, readPath) = {
  let images = imageContent.i
  if type(images) == str {
    content += image(readPath(images))
    content += linebreak()
  } else if type(images) == array {
    for img in images {
      content += image(readPath(img))
      content += linebreak()
    }
  }

  if showAnswerFromText == false {
    content += text("Ответ: " + imageContent.a, red)
    content += linebreak()
  }

  return content
}

#let getContentForQuestion(questionWithImage, questionCount, showAnswer, readPath) = {
  let content = [
    #questionCount.step()
    #context questionCount.display():
  ]
  let (questionContent, imageContent) = questionWithImage
  let showAnswerFromText = _isAnswerWithImage(showAnswer, imageContent)

  content = _generateText(content, questionContent, showAnswerFromText)
  content = _generateImage(content, imageContent, showAnswerFromText, readPath)

  return content
}


