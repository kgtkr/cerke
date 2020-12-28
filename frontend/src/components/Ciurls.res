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

type styles = {
    container: string,
    ciurl: string
}
@bs.module("@styles/components/Ciurls.scss") external styles : styles = "default";

@react.component
let make = (~count, ~seed) => {
  let ciurlStates = {
    let gen = RandomSeed.create(seed)
    let array = Array.make(5, 0) |> Array.mapi((i, _) => makeCiurlState(i < count, gen))
    ArrayExt.shuffle(array, gen)
    array
  }

  <div className=styles.container> {React.array(ciurlStates |> Array.mapi((i, ciurlState) =>
        <img
          className=styles.ciurl
          draggable=false
          src={if ciurlState.flag {
            "ciurl_true.png"
          } else {
            "ciurl_false.png"
          }}
          width="150"
          height="15"
          style=ReactDOM.Style.make(
            ~transform=String.concat(" ", list{
              "translateX(" ++ Js.Float.toString(ciurlState.x) ++ "px)",
              "translateY(" ++ Js.Float.toString(ciurlState.y) ++ "px)",
              "rotate(" ++ Js.Float.toString(ciurlState.rotate) ++ "rad)"
            }),
            (),
          )
          key=string_of_int(i)
        />
      ))} </div>
}