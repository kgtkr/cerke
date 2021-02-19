open Components
open Belt

let default = StorybookExt.make((props: {.}) =>
  <Field
    state={Field.MyTurnInit}
    pieces={Map.String.fromArray([
      (
        "a",
        Components.Field.FieldPiece.OnBoard({
          piece: Entities.Piece.Tam2,
          coord: {
            row: Entities.RowIndex.fromInt(4) |> Option.getExn,
            col: Entities.ColIndex.fromInt(4) |> Option.getExn,
          },
        }),
      ),
      (
        "b",
        Components.Field.FieldPiece.Captured({
          piece: {
            color: Entities.Color.Huok2,
            prof: Entities.Profession.Dau2,
            side: Entities.Side.Upward,
          },
          index: 0,
        }),
      ),
      (
        "c",
        Components.Field.FieldPiece.Captured({
          piece: {
            color: Entities.Color.Huok2,
            prof: Entities.Profession.Dau2,
            side: Entities.Side.Upward,
          },
          index: 1,
        }),
      ),
      (
        "d",
        Components.Field.FieldPiece.Captured({
          piece: {
            color: Entities.Color.Huok2,
            prof: Entities.Profession.Dau2,
            side: Entities.Side.Downward,
          },
          index: 0,
        }),
      ),
      (
        "e",
        Components.Field.FieldPiece.Captured({
          piece: {
            color: Entities.Color.Huok2,
            prof: Entities.Profession.Dau2,
            side: Entities.Side.Downward,
          },
          index: 1,
        }),
      ),
    ])}
  />
, {
  "title": "Field",
})
