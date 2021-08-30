let default = CerkeSb.make(
  (props: {"n": int, "fontSize": int}) =>
    <Num n={props["n"]} fontSize={Belt.Int.toFloat(props["fontSize"])} x={0.} y={0.} />,
  {
    "title": "Num",
    "argTypes": {
      "n": {"control": {"type": "range", "max": 11000, "min": -11000}},
      "fontSize": {"control": {"type": "range", "max": 100, "min": 0}},
    },
    "args": {
      "n": 123,
      "fontSize": 32,
    },
  },
)
