type t = int

let toInt = x => x

let fromInt = x => 
    0 <= x && x <= 40 ? Some(x) : None

let revScore = x => 40 - x
