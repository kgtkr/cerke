type styles = {
    animationContainer: string,
    image: string
}
@bs.module("@styles/components/WaterEntry.scss") external styles : styles = "default";


@react.component
let make = (~className=?, ~onAnimationEnd=?) => {
  <div className=?className>
    <div className=styles.animationContainer onAnimationEnd=?onAnimationEnd>
      <img src="water_entry.png" className=styles.image width="500"/>
    </div>
  </div>
}
