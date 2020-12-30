type styles = {
    container: string,
    season: string,
    score: string,
    rate: string,
}
@bs.module("@styles/components/Scoreboard.scss") external styles : styles = "default";

@react.component
let make = (~season, ~score, ~log2Rate) => {
  let iSeason = Season.toInt(season)
  let iScore = Score.toInt(score)
  let iLog2Rate = Log2Rate.toInt(log2Rate)

  <div className=styles.container>
    <img
      className=styles.season
      draggable=false
      src="images/piece/rtam.png"
      width="48" 
      style=ReactDOM.Style.make(
        ~transform="translateY(" ++ Js.Float.toString(-51. *. Js.Int.toFloat(iSeason)) ++ "px)",
        (),
      )
    />
    <img
      className=styles.score
      draggable=false
      src="images/wood_side.png"
      width="48"
      style=ReactDOM.Style.make(
        ~transform="translateY(" ++ Js.Float.toString(21.83333333333333 *. (20. -. Js.Int.toFloat(iScore))) ++ "px)",
        (),
      )
    />
    {if iLog2Rate != 0 {
      <img
        className=styles.rate
        draggable=false
        src="images/wood_side2.png"
        width="48"
        style=ReactDOM.Style.make(
          ~transform="translateY(" ++ Js.Float.toString(-96.66666666666667 *. (Js.Int.toFloat(iLog2Rate) -. 1.)) ++ "px)",
          (),
        )
      />
    } else {
      React.null
    }}
  </div>
}
