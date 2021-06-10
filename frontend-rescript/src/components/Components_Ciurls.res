type ciurlState = {
  flag: bool,
  x: float,
  y: float,
  rotate: float,
}

let makeCiurlState = (flag: bool, generator) => {
  flag: flag,
  x: generator->RandomSeed.random() *. 5.,
  y: generator->RandomSeed.random() *. 100.,
  rotate: (generator->RandomSeed.random() -. 0.5) *. Js.Math._PI *. 0.3,
}

type styles = {container: string}
@module("@styles/components/Ciurls.scss") external styles: styles = "default"

@react.component
let make = (~count, ~seed) => {
  let ciurlStates = {
    let gen = RandomSeed.create(seed)
    let array = Array.make(5, 0) |> Array.mapi((i, _) => makeCiurlState(i < count, gen))
    ArrayExt.shuffle(array, gen)
    array
  }

  <div className=styles.container>
    {React.array(
      ciurlStates |> Array.mapi((i, ciurlState) =>
        <Components_ImageSprite
          src={if ciurlState.flag {
            "images/ciurl_true.png"
          } else {
            "images/ciurl_false.png"
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
