@genType
type t

@genType
let get: (t, Coord.t) => option<Piece.t>

@genType
let update: (t, Coord.t, option<Piece.t>) => t
