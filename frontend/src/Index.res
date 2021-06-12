@val external document: {..} = "document"

ReactExt.createRoot(document["getElementById"]("root"))->ReactExt.render(
  <div> {React.string("Hello!")} </div>,
)
