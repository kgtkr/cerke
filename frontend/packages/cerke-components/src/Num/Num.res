module Images = {
  @module("./neg.png") external neg: string = "default"
  @module("./num00.png") external num00: string = "default"
  @module("./num01.png") external num01: string = "default"
  @module("./num02.png") external num02: string = "default"
  @module("./num03.png") external num03: string = "default"
  @module("./num04.png") external num04: string = "default"
  @module("./num05.png") external num05: string = "default"
  @module("./num06.png") external num06: string = "default"
  @module("./num07.png") external num07: string = "default"
  @module("./num08.png") external num08: string = "default"
  @module("./num09.png") external num09: string = "default"
  @module("./num10.png") external num10: string = "default"
  @module("./num100.png") external num100: string = "default"
}

// 0<=n<=9
let digitToImagePath = n =>
  switch n {
  | 0 => Images.num00
  | 1 => Images.num01
  | 2 => Images.num02
  | 3 => Images.num03
  | 4 => Images.num04
  | 5 => Images.num05
  | 6 => Images.num06
  | 7 => Images.num07
  | 8 => Images.num08
  | 9 => Images.num09
  | _ => Js.Exn.raiseError("Invalid parameter")
  }

// 10^rを返す。r>=1
let logScaleToImagePath = r => {
  if r < 1 {
    Js.Exn.raiseError("Invalid parameter")
  } else {
    switch r {
    | 1 => Images.num10
    | 2 => Images.num100
    | _ => {
        Js.Console.warn("10^" ++ Js.Int.toString(r) ++ " is not supported. Returns 10^2 instead.")
        Images.num100
      }
    }
  }
}

// 0の時[]を返す
let rec naturalNumToImagePaths = n => {
  if n < 0 {
    Js.Exn.raiseError("Invalid parameter")
  } else if n == 0 {
    []
  } else {
    let logScale = Belt.Int.fromFloat(Js.Math.log10(Belt.Int.toFloat(n)))
    if logScale == 0 {
      [digitToImagePath(n)]
    } else {
      let scale = Belt.Int.fromFloat(Js.Math.pow_float(~base=10., ~exp=Belt.Int.toFloat(logScale)))
      let firstDigit = n / scale
      Array.concat(list{
        if firstDigit == 1 {
          [logScaleToImagePath(logScale)]
        } else {
          [digitToImagePath(firstDigit), logScaleToImagePath(logScale)]
        },
        naturalNumToImagePaths(mod(n, scale)),
      })
    }
  }
}

let numToImagePaths = n => {
  if n == 0 {
    [Images.num00]
  } else if n < 0 {
    Array.concat(list{[Images.neg], naturalNumToImagePaths(n)})
  } else {
    naturalNumToImagePaths(n)
  }
}
