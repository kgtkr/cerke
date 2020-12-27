open Belt

let keyframes = arr =>
  Css.keyframes(
    arr
    ->List.fromArray
    ->List.map(((t, style)) => (
      t,
      style->List.fromArray->List.map(((key, value)) => Css.unsafe(key, value)),
    )),
  )

let style = arr =>
  Css.style(arr->List.fromArray->List.map(((key, value)) => Css.unsafe(key, value)))

let media = (query, arr) =>
  Css.media(query, arr->List.fromArray->List.map(((key, value)) => Css.unsafe(key, value)))
