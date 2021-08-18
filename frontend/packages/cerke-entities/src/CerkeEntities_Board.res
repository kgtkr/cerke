type t = array<array<option<CerkeEntities_Piece.t>>>

let get = (board: t, coord: CerkeEntities_Coord.t) =>
  board[CerkeEntities_RowIndex.toInt(coord.row)][CerkeEntities_ColIndex.toInt(coord.col)]

let update = (board: t, coord: CerkeEntities_Coord.t, value: option<CerkeEntities_Piece.t>) => {
  let result = Array.copy(board)
  result[
    CerkeEntities_RowIndex.toInt(coord.row)
  ] = Array.copy(result[CerkeEntities_RowIndex.toInt(coord.row)])
  result[CerkeEntities_RowIndex.toInt(coord.row)][CerkeEntities_ColIndex.toInt(coord.col)] = value
  result
}
