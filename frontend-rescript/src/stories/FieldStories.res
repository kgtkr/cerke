open Components
open Belt

let default = StorybookExt.make((props: {
  "type": string,
  "row": int,
  "col": int,
  "index": int,
  "color": string,
  "prof": string,
  "side": string,
}) =>
  <Field
    state={Field.MyTurnInit}
    pieces={Map.String.fromArray([
      (
        "key",
        {
          let row = Option.getExn(Entities.RowIndex.fromInt(props["row"]))
          let col = Option.getExn(Entities.ColIndex.fromInt(props["col"]))
          let color = Option.getExn(Entities.Color.fromString(props["color"]))
          let prof = Entities.Profession.fromString(props["prof"])
          let side = Option.getExn(Entities.Side.fromString(props["side"]))
          let piece = prof->Option.map(prof => {
            Entities.NonTam2Piece.color: color,
            prof: prof,
            side: side,
          })

          switch props["type"] {
          | "OnBoard" =>
            Components.Field.FieldPiece.OnBoard({
              piece: piece
              ->Option.map(piece => Entities.Piece.NonTam2Piece(piece))
              ->Option.getWithDefault(Entities.Piece.Tam2),
              coord: {
                row: row,
                col: col,
              },
            })
          | "Captured" =>
            Components.Field.FieldPiece.Captured({
              piece: piece->Option.getWithDefault({
                Entities.NonTam2Piece.color: color,
                prof: Entities.Profession.Nuak1,
                side: side,
              }),
              index: props["index"],
            })
          | _ => Js.Exn.raiseError("unreachable")
          }
        },
      ),
    ])}
  />
, {
  "title": "Field",
  "argTypes": {
    "type": {
      "control": {
        "type": "select",
        "options": ["OnBoard", "Captured"],
      },
    },
    "row": {"control": {"type": "range", "min": 0, "max": 8}},
    "col": {"control": {"type": "range", "min": 0, "max": 8}},
    "index": {"control": {"type": "range", "min": 0, "max": 15}},
    "color": {
      "control": {
        "type": "select",
        "options": [Entities.Color.Kok1, Entities.Color.Huok2]->Array.map(Entities.Color.toString),
      },
    },
    "prof": {
      "control": {
        "type": "select",
        "options": Array.concat(
          ["Tam2"],
          [
            Entities.Profession.Nuak1,
            Entities.Profession.Kauk2,
            Entities.Profession.Gua2,
            Entities.Profession.Kaun1,
            Entities.Profession.Dau2,
            Entities.Profession.Maun1,
            Entities.Profession.Kua2,
            Entities.Profession.Tuk2,
            Entities.Profession.Uai1,
            Entities.Profession.Io,
          ]->Array.map(Entities.Profession.toString),
        ),
      },
    },
    "side": {
      "control": {
        "type": "select",
        "options": [Entities.Side.Upward, Entities.Side.Downward]->Array.map(
          Entities.Side.toString,
        ),
      },
    },
  },
  "args": {
    "type": "OnBoard",
    "row": 0,
    "col": 0,
    "index": 0,
    "color": "Kok1",
    "prof": "Tam2",
    "side": "Upward",
  },
})
