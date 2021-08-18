@genType
type t

@genType
let get: (t, CerkeEntities_Coord.t) => option<CerkeEntities_Piece.t>

@genType
let update: (t, CerkeEntities_Coord.t, option<CerkeEntities_Piece.t>) => t
