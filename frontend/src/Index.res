@bs.val external document: {..} = "document"

OfflinePlugin.install()

ReactExt.createRoot(document["getElementById"]("root"))->ReactExt.render(
  <div> {React.string("Hello!")} </div>,
)
