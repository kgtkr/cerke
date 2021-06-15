type t = {registerAnimation: ((unit => unit) => unit) => unit}

// durationは呼び出しごとに変わらないことを想定している
let useAnimationValue = (x: 'a, ~duration: int, ~eq: Relude.Eq.eq<'a>, ~manager: t): 'a => {
  let prevX = React.useRef(x)
  let (renderX, setRenderX) = React.useState(() => x)
  React.useEffect1(() => {
    if !eq(x, prevX.current) {
      prevX.current = x
      manager.registerAnimation(end => {
        setRenderX(_ => x)
        let _ = Js.Global.setTimeout(() => {
          end()
        }, duration)
      })
    }
    None
  }, [x])

  renderX
}
