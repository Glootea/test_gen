#import "state_monad.typ": bind, next-seed, pure, with-seed

#let map-m(items, action-m) = {
  // Начинаем с пустой монады, возвращающей пустой массив
  let initial-monad = pure(())

  items.fold(initial-monad, (acc-monad, item) => {
    bind(acc-monad, accumulated-values => {
      bind(action-m(item), current-value => {
        // Добавляем новое значение в массив результатов и передаем дальше
        pure(accumulated-values + (current-value,))
      })
    })
  })
}
