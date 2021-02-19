type t = Upward | Downward

let toString = x =>
  switch x {
  | Upward => "Upward"
  | Downward => "Downward"
  }

let fromString = s =>
  switch s {
  | "Upward" => Some(Upward)
  | "Downward" => Some(Downward)
  | _ => None
  }
