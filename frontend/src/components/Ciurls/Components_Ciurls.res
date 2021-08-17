open ReludeRandom

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
      let y = Generator.float(~min=0., ~max=100.)
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

type styles = {container: string}
@module("./Ciurls.scss") external styles: styles = "default"

module Images = {
  @module("./ciurl_true.png") external ciurlTrue: string = "default"
  @module("./ciurl_false.png") external ciurlFalse: string = "default"
}

@react.component
let make = (~count, ~seed) => {
  let (ciurlStates, _) = Generator.run(makeCiurlStates(count), Seed.fromInt(seed))

  <div className=styles.container>
    {React.array(
      ciurlStates |> Array.mapi((i, ciurlState) =>
        <Components_ImageSprite
          src={if ciurlState.flag {
            Images.ciurlTrue
          } else {
            Images.ciurlFalse
          }}
          width=150.
          height=15.
          translateX=ciurlState.x
          translateY=ciurlState.y
          rotate=ciurlState.rotate
          key={string_of_int(i)}
        />
      ),
    )}
  </div>
}
