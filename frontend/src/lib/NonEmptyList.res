open Belt

type t<'a> = ('a, List.t<'a>)

let fromList = (list: list<'a>): option<t<'a>> => {
  switch list {
  | list{x, ...xs} => Some((x, xs))
  | _ => None
  }
}
