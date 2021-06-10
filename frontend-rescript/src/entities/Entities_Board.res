type t = array<array<option<Entities_Piece.t>>>

let get = (board: t, coord: Entities_Coord.t) =>
  board[Entities_RowIndex.toInt(coord.row)][Entities_ColIndex.toInt(coord.col)]

let update = (board: t, coord: Entities_Coord.t, value: option<Entities_Piece.t>) => {
  let result = Array.copy(board)
  result[
    Entities_RowIndex.toInt(coord.row)
  ] = Array.copy(result[Entities_RowIndex.toInt(coord.row)])
  result[Entities_RowIndex.toInt(coord.row)][Entities_ColIndex.toInt(coord.col)] = value
  result
}
