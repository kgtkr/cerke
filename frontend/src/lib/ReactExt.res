type reactRoot

@module("react-dom")
external createRoot: Webapi.Dom.Element.t => reactRoot = "createRoot"

@send
external render: (reactRoot, React.element) => unit = "render"
