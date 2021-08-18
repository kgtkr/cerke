open ReludeRandom

let shuffle = array =>
  Belt.Array.range(1, Array.length(array) - 1)->Belt.Array.reverse
  |> TraversableExt.ArrayGenerator.traverse(i => Generator.int(~min=0, ~max=i))
  |> Generator.map(rs => {
    let array = Array.copy(array)
    rs->Belt.Array.forEachWithIndex((i, r) => {
      let tmp = array[i]
      array[i] = array[r]
      array[r] = tmp
    })
    array
  })
