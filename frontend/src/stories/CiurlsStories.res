let default = {
  "title": "Ciurls",
  "argTypes": {
    "count": {"control": {"type": "range", "max": 5, "min": 0}},
    "seed": {"control": {"type": "text"}},
  },
  "args": {
    "count": 0,
    "seed": "",
  },
}

let ciurls = (props: {"count": int, "seed": string}) =>
  <Ciurls count={props["count"]} seed={props["seed"]} />
