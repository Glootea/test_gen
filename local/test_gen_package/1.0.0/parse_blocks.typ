#let parseBlocks(jsonContent) = {
  let result = ()
  let blocks = jsonContent.at("blocks")
  for (index, block) in blocks.enumerate() {
    let count = block.at("count")
    let questions = block.at("questions")
    let images = block.at("images", default: ())
    result.insert(index, (count, questions, images))
  }
  return result
}
