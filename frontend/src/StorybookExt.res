type t

@bs.val external unsafeAssign: ('a, 'b) => 'c = "Object.assign"

let make = (story, meta) => unsafeAssign(story, meta)
