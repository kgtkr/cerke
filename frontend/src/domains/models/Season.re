type t = Spring | Summer | Autumn | Winter

let toInt = x => switch x {
    | Spring => 0
    | Summer => 1
    | Autumn => 2
    | Winter => 3
  }

let fromInt = x => switch x {
  | 0 => Some(Spring)
  | 1 => Some(Summer)
  | 2 => Some(Autumn)
  | 3 => Some(Winter)
  | _ => None
}
