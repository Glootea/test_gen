
#let next-seed(seed) = seed + 1973541

#let pure(value) = seed => (value, seed)

// Chain two stateful computations.
#let bind(computation, continuation) = seed => {
  let (value, updated-seed) = computation(seed)
  let next = continuation(value)
  next(updated-seed)
}

// Lift an action: advance the seed, then pass it to the action.
#let with-seed(action) = seed => {
  let updated-seed = next-seed(seed)
  (action(updated-seed), updated-seed)
}