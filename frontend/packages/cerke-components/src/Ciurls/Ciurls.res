open ReludeRandom
open CerkeExt
open Belt

module Ciurl = {
  type t = {
    isHead: bool,
    dX: float,
    dY: float,
    dRotate: float,
  }

  let gen = (flag: bool) =>
    %GeneratorExt({
      let dX = GeneratorExt.normalDist(~mean=0., ~var=100.)
      %GeneratorExt({
        let dY = GeneratorExt.normalDist(~mean=0., ~var=500.)
        %GeneratorExt({
          let dRotate = GeneratorExt.normalDist(~mean=0., ~var=0.1)

          Generator.pure({
            isHead: flag,
            dX: dX,
            dY: dY,
            dRotate: dRotate,
          })
        })
      })
    })

  let ciurlsGen = count =>
    Array.range(0, 4)
    |> TraversableExt.ArrayGenerator.traverse(x => gen(x < count))
    |> Generator.flatMap(ArrayExt.shuffle)
}

module Images = {
  @module("./ciurl_true.png") external ciurlTrue: string = "default"
  @module("./ciurl_false.png") external ciurlFalse: string = "default"
}

@genType.as("Ciurls") @react.component
let make = (~count, ~seed, ~x, ~y, ~zIndex=?) => {
  let ciurlWidth = 150.
  let ciurlHeight = 15.

  let width = 200.
  let height = 200.
  let (ciurls, _) = Generator.run(Ciurl.ciurlsGen(count), Seed.fromInt(seed))

  <SpriteGroup width={width} height={height} x={x} y={y} zIndex=?{zIndex}>
    {React.array(
      ciurls->Array.mapWithIndex((i, ciurl) =>
        <ImageSprite
          src={if ciurl.isHead {
            Images.ciurlTrue
          } else {
            Images.ciurlFalse
          }}
          width=ciurlWidth
          height=ciurlHeight
          x={ciurl.dX +. width /. 2. -. ciurlWidth /. 2.}
          y={ciurl.dY +. height /. 2. -. ciurlHeight /. 2.}
          rotate={ciurl.dRotate +. Js.Math._PI}
          key={string_of_int(i)}
          zIndex={i}
        />
      ),
    )}
  </SpriteGroup>
}
