@genType
type t

@genType
let toInt: t => int

@genType
let fromInt: int => option<t>

@genType
let revScore: t => t
