open Belt

type t<'a> = ('a, List.t<'a>)

let fromList = (list: list<'a>): option<t<'a>> => {
  switch list {
  | list{x, ...xs} => Some((x, xs))
  | _ => None
  }
}

let head = ((head, _): t<'a>): 'a => {
  head
}

let tail = ((_, tail): t<'a>): List.t<'a> => {
  tail
}

let last = ((head, tail): t<'a>): 'a => {
  tail->List.get(List.length(tail))->Option.getWithDefault(head)
}
