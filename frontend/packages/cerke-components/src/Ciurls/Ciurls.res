open ReludeRandom
open CerkeExt

type ciurlState = {
  flag: bool,
  x: float,
  y: float,
  rotate: float,
}

let makeCiurlState = (flag: bool) =>
  %GeneratorExt({
    let x = Generator.float(~min=0., ~max=5.)
    %GeneratorExt({
      let y = Generator.float(~min=30., ~max=120.)
      %GeneratorExt({
        let rotate = Generator.float(~min=-.Js.Math._PI *. 0.15, ~max=Js.Math._PI *. 0.15)

        Generator.pure({
          flag: flag,
          x: x,
          y: y,
          rotate: rotate,
        })
      })
    })
  })

let makeCiurlStates = count =>
  Belt.Array.range(0, 4)
  |> TraversableExt.ArrayGenerator.traverse(x => makeCiurlState(x < count))
  |> Generator.flatMap(xs => ArrayExt.shuffle(xs))

module Images = {
  @module("./ciurl_true.png") external ciurlTrue: string = "default"
  @module("./ciurl_false.png") external ciurlFalse: string = "default"
}

@genType.as("Ciurls") @react.component
let make = (~count, ~seed, ~x, ~y, ~zIndex=?) => {
  let (ciurlStates, _) = Generator.run(makeCiurlStates(count), Seed.fromInt(seed))

  <SpriteGroup width={160.} height={170.} x={x} y={y} zIndex=?{zIndex}>
    {React.array(
      ciurlStates |> Array.mapi((i, ciurlState) =>
        <ImageSprite
          src={if ciurlState.flag {
            Images.ciurlTrue
          } else {
            Images.ciurlFalse
          }}
          width=150.
          height=15.
          x=ciurlState.x
          y=ciurlState.y
          rotate=ciurlState.rotate
          key={string_of_int(i)}
          zIndex={i}
        />
      ),
    )}
  </SpriteGroup>
}
