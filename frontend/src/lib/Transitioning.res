open Belt

let useTransitioning = (
  ~elRef: React.ref<Js.Nullable.t<Webapi.Dom.Element.t>>,
  ~onChangeTransitioning: bool => unit,
) => {
  let handleTransitionRun = React.useCallback1(_ => {
    onChangeTransitioning(true)
  }, [onChangeTransitioning])
  let handleTransitionCancel = React.useCallback1(_ => {
    onChangeTransitioning(false)
  }, [onChangeTransitioning])
  let handleTransitionEnd = React.useCallback1(_ => {
    onChangeTransitioning(false)
  }, [onChangeTransitioning])

  ReactExt.useEventListener(elRef, "transitionrun", handleTransitionRun)
  ReactExt.useEventListener(elRef, "transitioncancel", handleTransitionCancel)
  ReactExt.useEventListener(elRef, "transitionend", handleTransitionEnd)

  ()
}

// A→B→Cの順で表示したいとき、 B <= t < C の時 nonEmptyList {B, C}
// リストの要素数が1ならアニメーションが終わっている
let useListTransitioning = (
  ~elRef: React.ref<Js.Nullable.t<Webapi.Dom.Element.t>>,
  ~scheduledProps: NonEmptyList.t<'a>,
  ~changeScheduledProps: NonEmptyList.t<'a> => unit,
): 'a => {
  let transitioningRef = React.useRef(false)

  let modifiedRef = React.useRef(false)

  let (currentProps, propsList) = scheduledProps

  let handleChangeTransitioning = React.useCallback3(transitioning => {
    let prevTransitioning = transitioningRef.current
    transitioningRef.current = transitioning

    let startTransition = !prevTransitioning && transitioning
    let endTransition = prevTransitioning && !transitioning

    if startTransition {
      modifiedRef.current = true
      ()
    } else if endTransition {
      let _ = NonEmptyList.fromList(propsList)->OptionExt.forEach(newValue => {
        modifiedRef.current = false
        changeScheduledProps(newValue)
      })
    }

    ()
  }, (currentProps, propsList, changeScheduledProps))

  React.useEffect(() => {
    if !modifiedRef.current {
      // リストに同じスタイルになるpropsが連続して入っていてtransitionが発生しなかった場合
      let _ = NonEmptyList.fromList(propsList)->OptionExt.forEach(newValue => {
        changeScheduledProps(newValue)
      })
    }
    None
  })

  useTransitioning(~elRef, ~onChangeTransitioning=handleChangeTransitioning)

  let firstRunRef = React.useRef(true)
  React.useEffect0(() => {
    firstRunRef.current = false

    None
  })

  if firstRunRef.current {
    currentProps
  } else {
    List.head(propsList)->Option.getWithDefault(currentProps)
  }
}
