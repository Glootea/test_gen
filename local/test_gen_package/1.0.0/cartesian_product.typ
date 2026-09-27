#let cartesian_product(array1, array2) = {
  if (array1.len() == 0 or array2.len() == 0) {
    return ()
  }
  if array1.len() == 0 {
    return array2
  }
  if array2.len() == 0 {
    return array1
  }

  let result = ()
  let array2Len = array2.len()
  for (i, item1) in array1.enumerate() {
    for (j, item2) in array2.enumerate() {
      result.insert((i * array2Len) + j, (item1, item2))
    }
  }
  return result
}
