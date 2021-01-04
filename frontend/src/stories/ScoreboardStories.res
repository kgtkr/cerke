open Belt
open Components

let default = StorybookExt.make(
  (props: {"log2Rate": int, "score": int, "season": string}) =>
    <Scoreboard
      log2Rate={props["log2Rate"] |> Entities.Log2Rate.fromInt |> Option.getExn}
      score={props["score"] |> Entities.Score.fromInt |> Option.getExn}
      season={props["season"] |> Entities.Season.fromString |> Option.getExn}
    />,
  {
    "title": "Scoreboard",
    "argTypes": {
      "log2Rate": {"control": {"type": "range", "max": 6, "min": 0}},
      "score": {"control": {"type": "range", "max": 40, "min": 0}},
      "season": {
        "control": {
          "type": "select",
          "options": Entities.Season.seasons -> Array.map(Entities.Season.toString),
        }
      },
    },
    "args": {
      "log2Rate": 0,
      "score": 20,
      "season": "Spring"
    },
  },
)
