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

let numToImagePath = num =>
  switch num {
  | CerkeEntities.Num.Digit(CerkeEntities.Num.Digit.N0) => Images.num00
  | CerkeEntities.Num.Digit(CerkeEntities.Num.Digit.N1) => Images.num01
  | CerkeEntities.Num.Digit(CerkeEntities.Num.Digit.N2) => Images.num02
  | CerkeEntities.Num.Digit(CerkeEntities.Num.Digit.N3) => Images.num03
  | CerkeEntities.Num.Digit(CerkeEntities.Num.Digit.N4) => Images.num04
  | CerkeEntities.Num.Digit(CerkeEntities.Num.Digit.N5) => Images.num05
  | CerkeEntities.Num.Digit(CerkeEntities.Num.Digit.N6) => Images.num06
  | CerkeEntities.Num.Digit(CerkeEntities.Num.Digit.N7) => Images.num07
  | CerkeEntities.Num.Digit(CerkeEntities.Num.Digit.N8) => Images.num08
  | CerkeEntities.Num.Digit(CerkeEntities.Num.Digit.N9) => Images.num09
  | CerkeEntities.Num.Place(CerkeEntities.Num.Place.N10) => Images.num10
  | CerkeEntities.Num.Place(CerkeEntities.Num.Place.N100) => Images.num100
  | CerkeEntities.Num.Neg => Images.neg
  }

@react.component
let make = (~n: int, ~fontSize: float) => {
  <div>
    {CerkeEntities.Num.intToNums(n)
    ->Belt.Option.map(nums =>
      nums
      ->Belt.Array.mapWithIndex((i, num) =>
        <ImageSprite
          src={numToImagePath(num)}
          width={fontSize}
          height={fontSize}
          x={0.}
          y={(1. -. 0.06) *. fontSize *. Belt.Int.toFloat(i)}
        />
      )
      ->React.array
    )
    ->Belt.Option.getWithDefault(<div> {React.int(n)} </div>)}
  </div>
}
