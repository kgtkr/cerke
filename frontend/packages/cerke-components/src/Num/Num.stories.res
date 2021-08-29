let default = CerkeSb.make(
  (props: {"n": int, "width": int}) =>
    <Num n={props["n"]} width={Belt.Int.toFloat(props["width"])} />,
  {
    "title": "Num",
    "argTypes": {
      "n": {"control": {"type": "range", "max": 11000, "min": -11000}},
      "width": {"control": {"type": "range", "max": 100, "min": 0}},
    },
    "args": {
      "n": 0,
      "width": 16,
    },
  },
)
