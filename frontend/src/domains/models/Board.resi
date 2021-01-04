type t

let get: (t, Coord.t)  => option<Piece.t>

let update: (t, Coord.t, option<Piece.t>) => t
