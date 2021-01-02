@react.component
let make = (~onChangeTransitioning=?, ~children) => {
  let elRef = React.useRef(Js.Nullable.null)

  let handleTransitionRun = React.useCallback1((_) => {
    let _ = onChangeTransitioning
      -> OptionExt.forEach(f => f(true))
  }, [onChangeTransitioning])
  let handleTransitionCancel = React.useCallback1((_) => {
    let _ = onChangeTransitioning
      -> OptionExt.forEach(f => f(false))
  }, [onChangeTransitioning])
  let handleTransitionEnd = React.useCallback1((_) => {
    let _ = onChangeTransitioning
      -> OptionExt.forEach(f => f(false))
  }, [onChangeTransitioning])

  ReactExt.useEventListener(elRef, "transitionrun", handleTransitionRun)
  ReactExt.useEventListener(elRef, "transitioncancel", handleTransitionCancel)
  ReactExt.useEventListener(elRef, "transitionend", handleTransitionEnd)

  <ReactExt.Spread props={
    "ref": ReactDOM.Ref.domRef(elRef)
  }>
    {children}
  </ReactExt.Spread>
}