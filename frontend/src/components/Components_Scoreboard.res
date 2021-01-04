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
  let iSeason = Entities.Season.toInt(season)
  let iScore = Entities.Score.toInt(score)
  let iLog2Rate = Entities.Log2Rate.toInt(log2Rate)

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

  <div className=styles.container>
    <Transitioning onChangeTransitioning={(value)=>{
      modifyingSeason.current = value
      changeModifying()
    }}>
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
    </Transitioning>
    <Transitioning onChangeTransitioning={(value)=>{
      modifyingSeason.current = value
      changeModifying()
    }}>
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
    </Transitioning>
    {if iLog2Rate != 0 {
      <Transitioning onChangeTransitioning={(value)=>{
        modifyingSeason.current = value
        changeModifying()
      }}>
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
      </Transitioning>
    } else {
      React.null
    }}
  </div>
}
