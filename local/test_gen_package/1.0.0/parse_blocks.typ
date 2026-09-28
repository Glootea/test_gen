#let _processImages(imagesRaw) = {
  if imagesRaw == none {
    return (relativeWidths: none, content: ())
  }

  let relativeWidths = imagesRaw.at("relativeWidths", default: none)

  if type(imagesRaw) == dictionary {
    let pattern = imagesRaw.at("pattern")
    let imageCount = imagesRaw.at("imageCount")
    let answers = imagesRaw.at("answers", default: ())
    let images = range(imageCount).map(i => {
      let qNum = str(i + 1)
      let answer = answers.at(qNum, default: none)
      return (pattern.map(p => p.replace("%d", qNum)), answer)
    })
    return (relativeWidths: relativeWidths, content: images)
  } else if type(imagesRaw) == array {
    //
    if type(imagesRaw.at(0)) == string {
      let content = imagesRaw.map(i => (i, none))
      return (relativeWidths: relativeWidths, content: content)
    } else if type(imagesRaw.at(0)) == dictionary {
      let content = imagesRaw.map(img => {
        let i = img.at("i")
        let a = img.at("a", default: none)
        return (i, a)
      })
      return (
        relativeWidths: relativeWidths,
        content: content,
      )
    } else {
      assert(false, message: "Invalid imagesRaw format: " + type(imagesRaw.at(0)).toString())
    }
  }
}

#let parseBlocks(jsonContent) = {
  let result = ()
  let blocks = jsonContent.at("blocks")
  for (index, block) in blocks.enumerate() {
    let count = block.at("count")
    let questions = block.at("questions")
    let imagesRaw = block.at("images", default: none)
    let images = _processImages(imagesRaw)
    result.insert(index, (count, questions, images))
  }
  return result
}


