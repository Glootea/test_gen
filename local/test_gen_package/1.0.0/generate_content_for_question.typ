
#let _showAnswerInText(showAnswer, imageContent) = {
  if showAnswer == false {
    return false
  }
  return imageContent == none
}

#let _showAnswerInImage(showAnswer) = showAnswer

#let _showLinkInText(showLink, questionContent) = {
  if showLink == false {
    return false
  }
  return type(questionContent) == dictionary and questionContent.at("l", default: none) != none
}

#let _showLinkInImage(showLink) = showLink



#let _generateText(content, questionContent, showAnswerFromText, showLinkFromText) = {
  if type(questionContent) == str {
    content += questionContent + ": "
    content += linebreak()
  }

  if type(questionContent) == dictionary {
    content += questionContent.q + ": "
    content += linebreak()
    if showAnswerFromText == false {
      content += linebreak()
    }
    if showAnswerFromText {
      content += text("Ответ: " + questionContent.a, red)
      content += linebreak()
    }
    if showLinkFromText {
      content += text("Ссылка: ", blue)
      content += link(questionContent.l)
      content += linebreak()
    }
  }
  return content
}

#let _generateImage(content, imageContent, relativeWidths, showAnswer, showLink, readPath) = {
  if type(imageContent) == str {
    content += image(readPath(imageContent))
    content += linebreak()
  } else if type(imageContent) == array {
    let pageWidthWithMargins = page.width - page.margin.left
    let images = imageContent.at(0)
    let widths = relativeWidths.map(w => w * 100% * pageWidthWithMargins)

    let currentLine = ()
    let currentLineWidth = ()
    let accWidth = 0%
    for (i, img) in images.enumerate() {
      let width = widths.at(i)

      if accWidth + width >= pageWidthWithMargins {
        content += grid(
          columns: currentLineWidth,
          ..currentLine
        )
        accWidth = 0%
        content += linebreak()
        currentLine = ()
        currentLineWidth = ()
      }
      currentLine.push(grid.cell(
        image(readPath(img), width: width, fit: "stretch"),
      ))
      currentLineWidth.push(width)
      accWidth += width
    }
    if currentLineWidth.len() > 0 {
      content += grid(
        columns: currentLineWidth,
        ..currentLine
      )
    }
  }

  if imageContent != none and showAnswer {
    let answerContent = imageContent.at(1)
    if type(answerContent) == dictionary {
      content += text("Ответ: " + answerContent.a, red)
      if answerContent.at("l") != none and showLink {
        content += linebreak()
        content += text("Ссылка: ", blue)
        content += link(answerContent.at("l"))
      }
    } else {
      content += text("Ответ: " + answerContent, red)
    }
    // content += text("Ответ: " + imageContent.at(1), red)
    content += linebreak()
  }

  return content
}

#let getContentForQuestion(questionWithImage, relativeWidths, questionCount, showAnswer, showLink, readPath) = {
  let content = [
    #questionCount.step()
    #context questionCount.display():
  ]
  let (questionContent, imageContent) = questionWithImage

  content = _generateText(content, questionContent, _showAnswerInText(showAnswer, imageContent), _showLinkInText(
    showLink,
    questionContent,
  ))
  content = context _generateImage(
    content,
    imageContent,
    relativeWidths,
    _showAnswerInImage(showAnswer),
    _showLinkInImage(showLink),
    readPath,
  )

  return content
}


