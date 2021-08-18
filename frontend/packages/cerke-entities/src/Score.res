type t = int

let toInt = x => x

let fromInt = x => 
    if 0 <= x && x <= 40 { Some(x) } else { None }

let revScore = x => 40 - x
