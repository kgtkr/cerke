open ReludeRandom

let let_ = (a,b)=>Generator.flatMap(b,a)
