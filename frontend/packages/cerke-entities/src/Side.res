@genType
type t = Upward | Downward

@genType
let toString = x =>
  switch x {
  | Upward => "Upward"
  | Downward => "Downward"
  }

@genType
let fromString = s =>
  switch s {
  | "Upward" => Some(Upward)
  | "Downward" => Some(Downward)
  | _ => None
  }
