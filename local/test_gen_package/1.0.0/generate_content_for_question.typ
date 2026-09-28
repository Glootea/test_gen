
#let _showAnswerInText(showAnswer, imageContent) = {
  if showAnswer == false {
    return false
  }
  return imageContent == none
}

#let _showAnswerInImage(showAnswer) = showAnswer


#let _generateText(content, questionContent, showAnswerFromText) = {
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
  }
  return content
}

#let _generateImage(content, imageContent, relativeWidths, showAnswer, readPath) = {
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
        stroke: 0.1pt,
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
    content += text("Ответ: " + imageContent.at(1), red)
    content += linebreak()
  }

  return content
}

#let getContentForQuestion(questionWithImage, relativeWidths, questionCount, showAnswer, readPath) = {
  let content = [
    #questionCount.step()
    #context questionCount.display():
  ]
  let (questionContent, imageContent) = questionWithImage

  content = _generateText(content, questionContent, _showAnswerInText(showAnswer, imageContent))
  content = context _generateImage(content, imageContent, relativeWidths, _showAnswerInImage(showAnswer), readPath)

  return content
}


