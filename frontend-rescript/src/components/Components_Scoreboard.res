type styles = {container: string}
@module("@styles/components/Scoreboard.scss") external styles: styles = "default"

@react.component
let make = (~season, ~score, ~log2Rate) => {
  let iSeason = Entities.Season.toInt(season)
  let iScore = Entities.Score.toInt(score)
  let iLog2Rate = Entities.Log2Rate.toInt(log2Rate)

  <div className=styles.container>
    <Components_ImageSprite
      src="images/piece/rtam.png"
      width=48.
      translateX={3.}
      translateY={512. +. -51. *. Js.Int.toFloat(iSeason)}
      transitionDuration={0.7 *. 0.8093}
    />
    <Components_ImageSprite
      src="images/wood_side.png"
      width=48.
      translateX=64.
      translateY={444.833333333 +. 21.83333333333333 *. (20. -. Js.Int.toFloat(iScore))}
      transitionDuration=0.8093
    />
    {if iLog2Rate != 0 {
      <Components_ImageSprite
        src="images/wood_side2.png"
        width=48.
        translateX={4.}
        translateY={870.333333333 +. -96.66666666666667 *. (Js.Int.toFloat(iLog2Rate) -. 1.)}
        transitionDuration={0.8093}
      />
    } else {
      React.null
    }}
  </div>
}
