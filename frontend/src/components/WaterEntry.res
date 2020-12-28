/*module Styles = {
  open Css

  let imageAnimetion = keyframes(list{
    (0, list{unsafe("", "")}),
    (33, list{left(px(100))}),
    (66, list{left(px(100))}),
    (100, list{left(px(-500))}),
  })

  let container = style(list{zIndex(1), position(absolute)})

  let image = style(list{
    zIndex(1),
    position(absolute),
    animation(imageAnimetion),
    unsafe("animation-duration", "0.8"),
    unsafe("transform-origin", "center"),
  })
}

@react.component
let make = () => {
  <div className=Styles.container> <img src="water_entry.png" className=Styles.image /> </div>
}

img.water_entry {
  z-index: 500;
  position: absolute;
  top: 190px + $hop1zuo1_height;
  left: -500px;
  animation: water1 1 * $stususn ease;
}

@keyframes water1 {
  0% {
    left: 700px;
  }
  33% {
    left: 100px;
  }
  66% {
    left: 100px;
  }
  100% {
    left: -500px;
  }
}
*/
