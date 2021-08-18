type t

let get: (t, CerkeEntities_Coord.t) => option<CerkeEntities_Piece.t>

let update: (t, CerkeEntities_Coord.t, option<CerkeEntities_Piece.t>) => t
