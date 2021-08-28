module Images = {
  @module("./tam.png") external tam: string = "default"
  @module("./bdau.png") external bdau: string = "default"
  @module("./bgua.png") external bgua: string = "default"
  @module("./bio.png") external bio: string = "default"
  @module("./bkauk.png") external bkauk: string = "default"
  @module("./bkaun.png") external bkaun: string = "default"
  @module("./bkua.png") external bkua: string = "default"
  @module("./bmaun.png") external bmaun: string = "default"
  @module("./bnuak.png") external bnuak: string = "default"
  @module("./btuk.png") external btuk: string = "default"
  @module("./buai.png") external buai: string = "default"
  @module("./rdau.png") external rdau: string = "default"
  @module("./rgua.png") external rgua: string = "default"
  @module("./rio.png") external rio: string = "default"
  @module("./rkauk.png") external rkauk: string = "default"
  @module("./rkaun.png") external rkaun: string = "default"
  @module("./rkua.png") external rkua: string = "default"
  @module("./rmaun.png") external rmaun: string = "default"
  @module("./rmun.png") external rmun: string = "default"
  @module("./rnuak.png") external rnuak: string = "default"
  @module("./rtuk.png") external rtuk: string = "default"
  @module("./ruai.png") external ruai: string = "default"
}

let toImagePath = piece => {
  switch piece {
  | CerkeEntities.Piece.Tam2 => Images.tam
  | CerkeEntities.Piece.NonTam2Piece(nonTam2Piece) =>
    switch nonTam2Piece {
    | {color: Huok2, prof: Dau2} => Images.bdau
    | {color: Kok1, prof: Dau2} => Images.rdau
    | {color: Huok2, prof: Gua2} => Images.bgua
    | {color: Kok1, prof: Gua2} => Images.rgua
    | {color: Huok2, prof: Io} => Images.bio
    | {color: Kok1, prof: Io} => Images.rio
    | {color: Huok2, prof: Kauk2} => Images.bkauk
    | {color: Kok1, prof: Kauk2} => Images.rkauk
    | {color: Huok2, prof: Kaun1} => Images.bkaun
    | {color: Kok1, prof: Kaun1} => Images.rkaun
    | {color: Huok2, prof: Kua2} => Images.bkua
    | {color: Kok1, prof: Kua2} => Images.rkua
    | {color: Huok2, prof: Nuak1} => Images.bnuak
    | {color: Kok1, prof: Nuak1} => Images.rnuak
    | {color: Huok2, prof: Tuk2} => Images.btuk
    | {color: Kok1, prof: Tuk2} => Images.rtuk
    | {color: Huok2, prof: Uai1} => Images.buai
    | {color: Kok1, prof: Uai1} => Images.ruai
    | {color: Huok2, prof: Maun1} => Images.bmaun
    | {color: Kok1, prof: Maun1} => Images.bmaun
    }
  }
}
