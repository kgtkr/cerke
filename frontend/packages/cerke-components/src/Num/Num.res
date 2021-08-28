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

// 100の前後に続く1～99の数字
let subNumToImagePaths = n => {
  if n <= 0 || 100 <= n {
    Js.Exn.raiseError("Invalid parameter")
  }

  if n == 10 {
    [Images.num10]
  } else if mod(n, 10) === 0 {
    [digitToImagePath(n / 10), Images.num10]
  } else {
    let lastDigit = digitToImagePath(mod(n, 10))
    if n >= 20 {
      [digitToImagePath(n / 10), lastDigit]
    } else if n >= 10 {
      [Images.num10, lastDigit]
    } else {
      [lastDigit]
    }
  }
}

let rec numToImagePaths = n => {
  if n < 0 {
    Array.concat(list{[Images.neg], numToImagePaths(-n)})
  } else if n == 0 {
    [Images.num00]
  } else if n < 100 {
    let rest = mod(n, 10) === 0 ? [] : [digitToImagePath(mod(n, 10))]

    if n < 10 {
      rest
    } else if n < 20 {
      Array.concat(list{[Images.num10], rest})
    } else {
      Array.concat(list{subNumToImagePaths(n / 10), [Images.num10], rest})
    }
  } else {
    let rest = mod(n, 100) === 0 ? [] : subNumToImagePaths(mod(n, 100))

    if n < 200 {
      Array.concat(list{[Images.num100], rest})
    } else {
      Array.concat(list{subNumToImagePaths(n / 100), [Images.num100], rest})
    }
  }
}
