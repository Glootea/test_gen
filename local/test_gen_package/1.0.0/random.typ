#import "@preview/suiji:0.1.0"

#let pick(num, arr, seed) = {
  assert(type(seed) == int, message: "Seed must be int, type: " + str(type(seed)))
  assert(type(arr) == array, message: "Arr must be array, type: " + str(type(arr)))

  let rng = suiji.gen-rng(seed)
  let shuffled = suiji.shuffle(rng, arr).at(1)
  let r = shuffled.chunks(num).at(0, default: ())
  return r
}