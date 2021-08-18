@genType
type t = Kok1 | Huok2

@genType
let toString = x =>
  switch x {
  | Kok1 => "Kok1"
  | Huok2 => "Huok2"
  }

@genType
let fromString = s =>
  switch s {
  | "Kok1" => Some(Kok1)
  | "Huok2" => Some(Huok2)
  | _ => None
  }
