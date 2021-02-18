open Components
open Belt

let default = StorybookExt.make(
  (props: {.}) => <Field state={Field.MyTurnInit} pieces={HashMap.String.make(~hintSize=10)} />,
  {
    "title": "Field",
  },
)
