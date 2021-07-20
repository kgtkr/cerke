type reactRoot

@module("react-dom")
external createRoot: Webapi.Dom.Element.t => reactRoot = "createRoot"

@send
external render: (reactRoot, React.element) => unit = "render"

module Spread = {
  @react.component
  let make = (~props, ~children) => React.cloneElement(children, props)
}

let useEventListener = (
  elRef: React.ref<Js.Nullable.t<Webapi.Dom.Element.t>>,
  eventName,
  handler,
) => {
  React.useEffect2(() => {
    elRef.current
    ->Js.Nullable.toOption
    ->OptionExt.forEach(el => {
      el |> Webapi.Dom.Element.addEventListener(eventName, handler)

      () => {
        el |> Webapi.Dom.Element.removeEventListener(eventName, handler)
        ()
      }
    })
  }, (elRef.current, handler))
}
