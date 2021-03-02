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

// TODO: 全体のタイムアウトがほしい
// A→B→Cの順で表示したいとき、 B <= t < C の時 nonEmptyList {B, C}
// リストの要素数が1ならアニメーションが終わっている
let useListTransitioning = (
  ~elRef: React.ref<Js.Nullable.t<Webapi.Dom.Element.t>>,
  ~scheduledProps: NonEmptyList.t<'a>,
  ~changeScheduledProps: NonEmptyList.t<'a> => unit,
  ~timeoutMs: int=1000,
  _: unit,
): 'a => {
  let transitioningRef = React.useRef(false)

  let (currentProps, propsList) = scheduledProps

  let handleChangeTransitioning = React.useCallback3(transitioning => {
    let prevTransitioning = transitioningRef.current
    transitioningRef.current = transitioning

    let startTransition = !prevTransitioning && transitioning
    let endTransition = prevTransitioning && !transitioning

    if startTransition {
      ()
    } else if endTransition {
      let _ = NonEmptyList.fromList(propsList)->OptionExt.forEach(newValue => {
        changeScheduledProps(newValue)
      })
    }

    ()
  }, (currentProps, propsList, changeScheduledProps))

  let scheduledPropsRef = React.useRef(scheduledProps)
  React.useEffect1(() => {
    scheduledPropsRef.current = scheduledProps
    let _ = Js.Global.setTimeout(_ => {
      if scheduledPropsRef.current == scheduledProps {
        // リストに同じスタイルになるpropsが連続して入っていてtransitionが発生しなかった場合の処理
        // このhooksを使う側はそのようなことが起きないようにtransitionが発生しない連続したpropsを渡してはいけない
        // しかしアニメーションの都合でUIが固まってしまっては困るのでタイムアウトを設けて画面が固まらないようにする
        // これはバグである可能性が高いのでコンソールにメッセージを出力する
        let _ = NonEmptyList.fromList(propsList)->OptionExt.forEach(newValue => {
          Js.Console.warn("[warn]useListTransitioning timeout")
          changeScheduledProps(newValue)
          ()
        })
      }
      ()
    }, timeoutMs)
    None
  }, [scheduledProps])

  useTransitioning(~elRef, ~onChangeTransitioning=handleChangeTransitioning)

  let (firstRun, setFirstRun) = React.useState(_ => true)
  React.useEffect0(() => {
    setFirstRun(_ => false)

    None
  })

  if firstRun {
    currentProps
  } else {
    List.head(propsList)->Option.getWithDefault(currentProps)
  }
}
