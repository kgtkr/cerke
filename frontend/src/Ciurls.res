type ciurlState = {
  flag: bool,
  left: float,
  top: float,
  rotate: float,
}

let makeCiurlState = (flag: bool, generator) => {
  flag: flag,
  top: (generator->RandomSeed.random() -. 0.5) *. 150. *. 0.8 +. 70.,
  left: (generator->RandomSeed.random() -. 0.5) *. 150. *. 0.2,
  rotate: (generator->RandomSeed.random() -. 0.5) *. Js.Math._PI *. 0.3,
}

module Styles = {
  open Css

  let container = style(list{position(relative), width(px(150)), height(px(140))})

  let ciurl = style(list{position(absolute)})
}

@react.component
let make = (~count, ~seed) => {
  let ciurlStates = {
    let gen = RandomSeed.create(seed)
    let array = Array.make(5, 0) |> Array.mapi((i, _) => makeCiurlState(i < count, gen))
    ArrayExt.shuffle(array, gen)
    array
  }

  <div className=Styles.container> {React.array(ciurlStates |> Array.map(ciurlState =>
        <img
          className=Styles.ciurl
          draggable=false
          src={if ciurlState.flag {
            "ciurl_true.png"
          } else {
            "ciurl_false.png"
          }}
          width="150"
          height="15"
          style={ReactDOM.Style.make(
            ~top=Js.Float.toString(ciurlState.top) ++ "px",
            ~left=Js.Float.toString(ciurlState.left) ++ "px",
            ~transform="rotate(" ++ (Js.Float.toString(ciurlState.rotate) ++ "rad)"),
            (),
          )}
        />
      ))} </div>
}
