type t

let get: (t, Entities_Coord.t)  => option<Entities_Piece.t>

let update: (t, Entities_Coord.t, option<Entities_Piece.t>) => t
