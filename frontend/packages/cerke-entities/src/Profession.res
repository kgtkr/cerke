@genType
type t =
  | Nuak1
  | Kauk2
  | Gua2
  | Kaun1
  | Dau2
  | Maun1
  | Kua2
  | Tuk2
  | Uai1
  | Io

@genType
let toString = x =>
  switch x {
  | Nuak1 => "Nuak1"
  | Kauk2 => "Kauk2"
  | Gua2 => "Gua2"
  | Kaun1 => "Kaun1"
  | Dau2 => "Dau2"
  | Maun1 => "Maun1"
  | Kua2 => "Kua2"
  | Tuk2 => "Tuk2"
  | Uai1 => "Uai1"
  | Io => "Io"
  }

@genType
let fromString = s =>
  switch s {
  | "Nuak1" => Some(Nuak1)
  | "Kauk2" => Some(Kauk2)
  | "Gua2" => Some(Gua2)
  | "Kaun1" => Some(Kaun1)
  | "Dau2" => Some(Dau2)
  | "Maun1" => Some(Maun1)
  | "Kua2" => Some(Kua2)
  | "Tuk2" => Some(Tuk2)
  | "Uai1" => Some(Uai1)
  | "Io" => Some(Io)
  | _ => None
  }
