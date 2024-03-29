type t = int

let toInt = x => x

let fromInt = x => 
    if 0 <= x && x <= 6 { Some(x) } else { None }

let exp2 = x => Js.Math.unsafe_ceil_int(Js.Math.pow_float(~base=2., ~exp=Js.Int.toFloat(x)))
