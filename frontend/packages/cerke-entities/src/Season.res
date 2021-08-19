@genType
type t = Spring | Summer | Autumn | Winter

@genType
let seasons = [Spring, Summer, Autumn, Winter]

@genType
let toInt = x =>
  switch x {
  | Spring => 0
  | Summer => 1
  | Autumn => 2
  | Winter => 3
  }

@genType
let fromInt = x =>
  switch x {
  | 0 => Some(Spring)
  | 1 => Some(Summer)
  | 2 => Some(Autumn)
  | 3 => Some(Winter)
  | _ => None
  }

@genType
let toString = x =>
  switch x {
  | Spring => "Spring"
  | Summer => "Summer"
  | Autumn => "Autumn"
  | Winter => "Winter"
  }

@genType
let fromString = x =>
  switch x {
  | "Spring" => Some(Spring)
  | "Summer" => Some(Summer)
  | "Autumn" => Some(Autumn)
  | "Winter" => Some(Winter)
  | _ => None
  }
