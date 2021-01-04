type t = int

let fromInt = x => if 0 <= x && x <= 8 { Some(x) } else { None }

let toInt = x => x
