#let cartesian_product(arr1, arr2) = {
  if (arr1.len() == 0 and arr2.len() == 0) {
    return (none, none)
  }
  if arr1.len() == 0 {
    return arr2.map(item => (none, item))
  }
  if arr2.len() == 0 {
    return arr1.map(item => (item, none))
  }

  let result = ()
  let arr2Len = arr2.len()
  for (i, item1) in arr1.enumerate() {
    for (j, item2) in arr2.enumerate() {
      result.insert((i * arr2Len) + j, (item1, item2))
    }
  }
  return result
}
