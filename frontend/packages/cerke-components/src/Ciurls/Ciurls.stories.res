let default = StorybookExt.make(
  (props: {"count": int, "seed": int}) => <Ciurls count={props["count"]} seed={props["seed"]} />,
  {
    "title": "Ciurls",
    "argTypes": {
      "count": {"control": {"type": "range", "max": 5, "min": 0}},
      "seed": {"control": {"type": "range", "max": 100, "min": 0}},
    },
    "args": {
      "count": 0,
      "seed": 0,
    },
  },
)
