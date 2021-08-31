open ReludeRandom

let let_ = (a, b) => Generator.flatMap(b, a)

// ボックス＝ミュラー法
let normalDist = (~mean, ~var) =>
  Generator.float(~max=1., ~min=0.) |> Generator.flatMap(x =>
    Generator.float(~max=1., ~min=0.) |> Generator.map(y =>
      Js.Math.sqrt(-2. *. Js.Math.log(x)) *.
      Js.Math.cos(2. *. Js.Math._PI *. y) /.
      Js.Math.sqrt(var) +. mean
    )
  )
