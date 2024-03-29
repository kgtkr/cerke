type styles = {container: string}
@module("./Scoreboard.scss") external styles: styles = "default"

module Images = {
  @module("./wood_side.png") external woodSide: string = "default"
  @module("./wood_side2.png") external woodSide2: string = "default"
  @module("./rtam.png") external rtam: string = "default"
}

@react.component
let make = (~season, ~score, ~log2Rate) => {
  let iSeason = CerkeEntities.Season.toInt(season)
  let iScore = CerkeEntities.Score.toInt(score)
  let iLog2Rate = CerkeEntities.Log2Rate.toInt(log2Rate)

  <div className=styles.container>
    <ImageSprite
      src={Images.rtam}
      width=48.
      height=48.
      x={3.}
      y={512. +. -51. *. Js.Int.toFloat(iSeason)}
      transitionDuration={0.7 *. 0.8093}
    />
    <ImageSprite
      src={Images.woodSide}
      width=48.
      height=48.
      x=64.
      y={444.833333333 +. 21.83333333333333 *. (20. -. Js.Int.toFloat(iScore))}
      transitionDuration=0.8093
    />
    {if iLog2Rate != 0 {
      <ImageSprite
        src={Images.woodSide2}
        width=48.
        height=48.
        x={4.}
        y={870.333333333 +. -96.66666666666667 *. (Js.Int.toFloat(iLog2Rate) -. 1.)}
        transitionDuration={0.8093}
      />
    } else {
      React.null
    }}
  </div>
}
