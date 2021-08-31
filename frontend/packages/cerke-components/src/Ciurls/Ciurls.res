open ReludeRandom
open CerkeExt
open Belt

module Ciurl = {
  type t = {
    isHead: bool,
    x: float,
    y: float,
    rotate: float,
  }

  let gen = (flag: bool) =>
    %GeneratorExt({
      let x = Generator.float(~min=0., ~max=5.)
      %GeneratorExt({
        let y = Generator.float(~min=30., ~max=120.)
        %GeneratorExt({
          let rotate = Generator.float(~min=-.Js.Math._PI *. 0.15, ~max=Js.Math._PI *. 0.15)

          Generator.pure({
            isHead: flag,
            x: x,
            y: y,
            rotate: rotate,
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
  let (ciurls, _) = Generator.run(Ciurl.ciurlsGen(count), Seed.fromInt(seed))

  <SpriteGroup width={160.} height={170.} x={x} y={y} zIndex=?{zIndex}>
    {React.array(
      ciurls->Array.mapWithIndex((i, ciurl) =>
        <ImageSprite
          src={if ciurl.isHead {
            Images.ciurlTrue
          } else {
            Images.ciurlFalse
          }}
          width=150.
          height=15.
          x=ciurl.x
          y=ciurl.y
          rotate=ciurl.rotate
          key={string_of_int(i)}
          zIndex={i}
        />
      ),
    )}
  </SpriteGroup>
}
