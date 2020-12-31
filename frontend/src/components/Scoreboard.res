open Belt

type styles = {
    container: string,
    season: string,
    score: string,
    rate: string,
}
@bs.module("@styles/components/Scoreboard.scss") external styles : styles = "default";

@react.component
let make = (~season, ~score, ~log2Rate, ~onChangeModifying=?) => {
  let iSeason = Season.toInt(season)
  let iScore = Score.toInt(score)
  let iLog2Rate = Log2Rate.toInt(log2Rate)

  let modifying = React.useRef(false);
  let modifyingSeason = React.useRef(false);
  let modifyingScore = React.useRef(false);
  let modifyingRate = React.useRef(false);

  let changeModifying = React.useCallback1(() => {
    let newModifying = modifyingSeason.current || modifyingScore.current || modifyingRate.current
    if modifying.current != newModifying {
      modifying.current = newModifying
      onChangeModifying
          -> OptionExt.forEach(f => f(newModifying))
          -> Option.getWithDefault()
    }
    ()
  }, [onChangeModifying])

  let seasonElRef = ReactExt.useTransition(modifyingSeason, changeModifying)
  let scoreElRef = ReactExt.useTransition(modifyingScore, changeModifying)
  let rateElRef = ReactExt.useTransition(modifyingRate, changeModifying)

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
      ref=ReactDOM.Ref.domRef(seasonElRef)
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
      ref=ReactDOM.Ref.domRef(scoreElRef)
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
        ref=ReactDOM.Ref.domRef(rateElRef)
      />
    } else {
      React.null
    }}
  </div>
}
