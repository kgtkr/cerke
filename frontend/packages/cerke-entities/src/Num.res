module Place = {
  type t = N10 | N100

  let fromLog10 = r => {
    switch r {
    | 1 => Some(N10)
    | 2 => Some(N100)
    | _ => None
    }
  }
}

module Digit = {
  type t = N0 | N1 | N2 | N3 | N4 | N5 | N6 | N7 | N8 | N9

  let fromInt = n => {
    switch n {
    | 0 => Some(N0)
    | 1 => Some(N1)
    | 2 => Some(N2)
    | 3 => Some(N3)
    | 4 => Some(N4)
    | 5 => Some(N5)
    | 6 => Some(N6)
    | 7 => Some(N7)
    | 8 => Some(N8)
    | 9 => Some(N9)
    | _ => None
    }
  }
}

type t =
  | Place(Place.t)
  | Digit(Digit.t)
  | Neg

// 100の前後に続く1～99の数字
let intToSubNums = n => {
  if n <= 0 || 100 <= n {
    None
  } else if n == 10 {
    Some([Place(Place.N10)])
  } else if mod(n, 10) === 0 {
    Some([Digit(Digit.fromInt(n / 10)->Belt.Option.getExn), Place(Place.N10)])
  } else {
    let lastDigit = Digit.fromInt(mod(n, 10))->Belt.Option.getExn
    if n >= 20 {
      Some([Digit(Digit.fromInt(n / 10)->Belt.Option.getExn), Digit(lastDigit)])
    } else if n >= 10 {
      Some([Place(Place.N10), Digit(lastDigit)])
    } else {
      Some([Digit(lastDigit)])
    }
  }
}

let rec intToNums = n => {
  if n < 0 {
    intToNums(-n)->Belt.Option.map(nums => Array.concat(list{[Neg], nums}))
  } else if n == 0 {
    Some([Digit(Digit.N0)])
  } else if n < 100 {
    let rest = mod(n, 10) === 0 ? [] : [Digit(Digit.fromInt(mod(n, 10))->Belt.Option.getExn)]

    Some(
      if n < 10 {
        rest
      } else if n < 20 {
        Array.concat(list{[Place(Place.N10)], rest})
      } else {
        Array.concat(list{intToSubNums(n / 10)->Belt.Option.getExn, [Place(Place.N10)], rest})
      },
    )
  } else if n < 10000 {
    let rest = mod(n, 100) === 0 ? [] : intToSubNums(mod(n, 100))->Belt.Option.getExn

    Some(
      if n < 200 {
        Array.concat(list{[Place(Place.N100)], rest})
      } else {
        Array.concat(list{intToSubNums(n / 100)->Belt.Option.getExn, [Place(Place.N100)], rest})
      },
    )
  } else {
    None
  }
}
