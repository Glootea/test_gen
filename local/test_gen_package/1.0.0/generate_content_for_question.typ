
#let _showAnswerInText(showAnswer, imageContent) = {
  if showAnswer == false {
    return false
  }
  return imageContent == none
}

#let _showAnswerInImage(showAnswer) = showAnswer

#let _getQuestionTextForQuestion(questionContent) = {
  if type(questionContent) == str {
    if questionContent != "" {
      text(questionContent)
    } else {
      v(-1em)
    }
  }

  if type(questionContent) == dictionary {
    if questionContent.q != "" {
      text(questionContent.q)
    }
  }
}


#let _getImageForQuestion(imageContent, relativeWidths, readPath) = {
  if imageContent == none {
    return none
  }

  let imageContent = imageContent.at("image")
  if type(imageContent) == str {
    image(readPath(imageContent))
    linebreak()
  } else if type(imageContent) == array {
    let pageWidthWithMargins = page.width - page.margin.left
    let widths = relativeWidths.map(w => w * 100% * pageWidthWithMargins)

    let currentLine = ()
    let currentLineWidth = ()
    let accWidth = 0%
    for (i, img) in imageContent.enumerate() {
      let width = widths.at(i)

      if accWidth + width >= pageWidthWithMargins {
        grid(
          columns: currentLineWidth,
          ..currentLine
        )
        accWidth = 0%
        linebreak()
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
      grid(
        columns: currentLineWidth,
        ..currentLine
      )
    }
  } else {
    assert(false, message: "Unknown image content type: " + str(type(imageContent)))
  }
}

#let _getAnswerForQuestion(questionWithImage) = {
  let (questionContent, imageContent) = questionWithImage
  if type(imageContent) == dictionary {
    return imageContent.at("answer", default: "no answer provided")
    let answerContent = imageContent.at(1)
    if type(answerContent) == dictionary {
      return answerContent.a
    } else {
      return answerContent
    }
  }
  if type(questionContent) == dictionary {
    return questionContent.a
  }

  return none
}

#let _getLinkForQuestion(questionWithImage) = {
  let (questionContent, imageContent) = questionWithImage
  if type(questionContent) == dictionary {
    return questionContent.at("l", default: none)
  }
  if type(imageContent) == dictionary {
    return imageContent.at("l", default: none)
  }
  return none
}



#let getContentForQuestion(questionWithImage, relativeWidths, questionCount, showAnswer, showLink, readPath) = {
  let (questionContent, imageContent) = questionWithImage

  let content = context [
    #questionCount.step()
    #context questionCount.display():
    #_getQuestionTextForQuestion(questionContent)
    #_getImageForQuestion(imageContent, relativeWidths, readPath)
  ]

  let answer = _getAnswerForQuestion(questionWithImage)
  let link = _getLinkForQuestion(questionWithImage)

  return ("content": content, "answer": answer, "link": link)
}


