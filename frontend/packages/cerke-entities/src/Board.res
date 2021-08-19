type t = array<array<option<Piece.t>>>

let get = (board: t, coord: Coord.t) => board[RowIndex.toInt(coord.row)][ColIndex.toInt(coord.col)]

let update = (board: t, coord: Coord.t, value: option<Piece.t>) => {
  let result = Array.copy(board)
  result[RowIndex.toInt(coord.row)] = Array.copy(result[RowIndex.toInt(coord.row)])
  result[RowIndex.toInt(coord.row)][ColIndex.toInt(coord.col)] = value
  result
}
