open Belt

let default = CerkeSb.make(
  (
    props: {
      "state": string,
      "type": string,
      "row": int,
      "col": int,
      "index": int,
      "color": string,
      "prof": string,
      "side": string,
    },
  ) =>
    <Field
      state={switch props["state"] {
      | "OpponentTurn" => Field.OpponentTurn
      | "MyTurnInit" => Field.MyTurnInit
      | "MoveSelection(Normal)" =>
        Field.MoveSelection({
          target: "key",
          movable: list{
            {
              coord: {
                row: Option.getExn(CerkeEntities.RowIndex.fromInt(1)),
                col: Option.getExn(CerkeEntities.ColIndex.fromInt(1)),
              },
              kind: Field.Movable.Normal,
            },
          },
        })
      | "MoveSelection(InfAfterStep)" =>
        Field.MoveSelection({
          target: "key",
          movable: list{
            {
              coord: {
                row: Option.getExn(CerkeEntities.RowIndex.fromInt(1)),
                col: Option.getExn(CerkeEntities.ColIndex.fromInt(1)),
              },
              kind: Field.Movable.InfAfterStep,
            },
          },
        })
      | "MoveSelection(Tam)" =>
        Field.MoveSelection({
          target: "key",
          movable: list{
            {
              coord: {
                row: Option.getExn(CerkeEntities.RowIndex.fromInt(1)),
                col: Option.getExn(CerkeEntities.ColIndex.fromInt(1)),
              },
              kind: Field.Movable.Tam,
            },
          },
        })
      | "StepOverMoveSelection" =>
        Field.StepOverMoveSelection({
          target: "key",
          waypoint: {
            row: Option.getExn(CerkeEntities.RowIndex.fromInt(1)),
            col: Option.getExn(CerkeEntities.ColIndex.fromInt(1)),
          },
          movable: list{
            {
              coord: {
                row: Option.getExn(CerkeEntities.RowIndex.fromInt(2)),
                col: Option.getExn(CerkeEntities.ColIndex.fromInt(2)),
              },
              kind: Field.Movable.Normal,
            },
          },
        })
      | _ => Js.Exn.raiseError("unreachable")
      }}
      pieces={Map.String.fromArray([
        (
          "key",
          {
            let row = Option.getExn(CerkeEntities.RowIndex.fromInt(props["row"]))
            let col = Option.getExn(CerkeEntities.ColIndex.fromInt(props["col"]))
            let color = Option.getExn(CerkeEntities.Color.fromString(props["color"]))
            let prof = CerkeEntities.Profession.fromString(props["prof"])
            let side = Option.getExn(CerkeEntities.Side.fromString(props["side"]))
            let piece = prof->Option.map(prof => {
              CerkeEntities.NonTam2Piece.color: color,
              prof: prof,
              side: side,
            })

            switch props["type"] {
            | "OnBoard" =>
              CerkeComponents.Field.FieldPiece.OnBoard({
                piece: piece
                ->Option.map(piece => CerkeEntities.Piece.NonTam2Piece(piece))
                ->Option.getWithDefault(CerkeEntities.Piece.Tam2),
                coord: {
                  row: row,
                  col: col,
                },
              })
            | "Captured" =>
              CerkeComponents.Field.FieldPiece.Captured({
                piece: piece->Option.getWithDefault({
                  CerkeEntities.NonTam2Piece.color: color,
                  prof: CerkeEntities.Profession.Nuak1,
                  side: side,
                }),
                index: props["index"],
              })
            | _ => Js.Exn.raiseError("unreachable")
            }
          },
        ),
      ])}
    />,
  {
    "title": "Field",
    "argTypes": {
      "state": {
        "control": {
          "type": "select",
          "options": [
            "OpponentTurn",
            "MyTurnInit",
            "MoveSelection(Normal)",
            "MoveSelection(InfAfterStep)",
            "MoveSelection(Tam)",
            "StepOverMoveSelection",
          ],
        },
      },
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
          "options": [CerkeEntities.Color.Kok1, CerkeEntities.Color.Huok2]->Array.map(
            CerkeEntities.Color.toString,
          ),
        },
      },
      "prof": {
        "control": {
          "type": "select",
          "options": Array.concat(
            ["Tam2"],
            [
              CerkeEntities.Profession.Nuak1,
              CerkeEntities.Profession.Kauk2,
              CerkeEntities.Profession.Gua2,
              CerkeEntities.Profession.Kaun1,
              CerkeEntities.Profession.Dau2,
              CerkeEntities.Profession.Maun1,
              CerkeEntities.Profession.Kua2,
              CerkeEntities.Profession.Tuk2,
              CerkeEntities.Profession.Uai1,
              CerkeEntities.Profession.Io,
            ]->Array.map(CerkeEntities.Profession.toString),
          ),
        },
      },
      "side": {
        "control": {
          "type": "select",
          "options": [CerkeEntities.Side.Upward, CerkeEntities.Side.Downward]->Array.map(
            CerkeEntities.Side.toString,
          ),
        },
      },
    },
    "args": {
      "state": "MyTurnInit",
      "type": "OnBoard",
      "row": 0,
      "col": 0,
      "index": 0,
      "color": "Kok1",
      "prof": "Nuak1",
      "side": "Upward",
    },
  },
)
