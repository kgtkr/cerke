ReactExt.createRoot(
  Webapi.Dom.document |> Webapi.Dom.Document.getElementById("root") |> Belt.Option.getExn,
)->ReactExt.render(<div> {React.string("Hello!")} </div>)
