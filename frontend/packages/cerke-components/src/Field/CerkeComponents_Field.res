/*

相手の番 | 自分の番の初期状態 | 選択状態 | 2回目の選択状態

自分の駒は選択できる(カーソルがポインタに)
自分の手ごまも選択できる(カーソルがポインタに)
皇も選択できる
移動対象の駒は青点滅
相手の番の時は全体が禁止カーソルに
二段階移動の一回目の黄色ボタン選択時は元の駒が灰色になったまま、一回目の移動先にも駒が配置され、青点滅
  アニメーションなし
  全体灰色オーバーレイ
  戻るボタン
一段階目の移動の時は元の駒を押すとキャンセル、他の駒を押すと変更可能
*/

open Belt

type styles = {
  container: string,
  opponentTurnContainer: string,
  selection: string,
  guide: string,
  stepOverMoveSelectionTarget: string,
  overlay: string,
}
@module("./Field.scss") external styles: styles = "default"

module Images = {
  @module("./selection.png") external selection: string = "default"
  @module("./ct.png") external ct: string = "default"
  @module("./ct2.png") external ct2: string = "default"
  @module("./ctam.png") external ctam: string = "default"
  @module("../piece/tam.png") external tam: string = "default"
  @module("../piece/bdau.png") external bdau: string = "default"
  @module("../piece/bgua.png") external bgua: string = "default"
  @module("../piece/bio.png") external bio: string = "default"
  @module("../piece/bkauk.png") external bkauk: string = "default"
  @module("../piece/bkaun.png") external bkaun: string = "default"
  @module("../piece/bkua.png") external bkua: string = "default"
  @module("../piece/bmaun.png") external bmaun: string = "default"
  @module("../piece/bmun.png") external bmun: string = "default"
  @module("../piece/bnuak.png") external bnuak: string = "default"
  @module("../piece/btuk.png") external btuk: string = "default"
  @module("../piece/buai.png") external buai: string = "default"
  @module("../piece/rdau.png") external rdau: string = "default"
  @module("../piece/rgua.png") external rgua: string = "default"
  @module("../piece/rio.png") external rio: string = "default"
  @module("../piece/rkauk.png") external rkauk: string = "default"
  @module("../piece/rkaun.png") external rkaun: string = "default"
  @module("../piece/rkua.png") external rkua: string = "default"
  @module("../piece/rmaun.png") external rmaun: string = "default"
  @module("../piece/rmun.png") external rmun: string = "default"
  @module("../piece/rnuak.png") external rnuak: string = "default"
  @module("../piece/rtuk.png") external rtuk: string = "default"
  @module("../piece/ruai.png") external ruai: string = "default"
}

module FieldPiece = {
  type t =
    | OnBoard({piece: CerkeEntities.Piece.t, coord: CerkeEntities.Coord.t})
    | Captured({piece: CerkeEntities.NonTam2Piece.t, index: int})

  let _BOARD_SIZE = 631.
  let _CAPTURED_HEIGHT = 140.
  let _COL_MAX = 9
  let _PIECE_SIZE = 60.
  let _PIECE_PAD = 5.0555
  let _SQUARE_SIZE = _PIECE_SIZE +. 2. *. _PIECE_PAD

  let toPiece = piece =>
    switch piece {
    | OnBoard({piece}) => piece
    | Captured({piece}) => CerkeEntities.Piece.NonTam2Piece(piece)
    }

  let colIndexToX = colIndex =>
    _SQUARE_SIZE *. Int.toFloat(CerkeEntities.ColIndex.toInt(colIndex)) +. _PIECE_PAD

  let toX = piece =>
    switch piece {
    | OnBoard({coord}) => colIndexToX(coord.col)
    | Captured({index, piece: {side}}) => {
        let x = _SQUARE_SIZE *. Int.toFloat(mod(index, _COL_MAX)) +. _PIECE_PAD
        switch side {
        | Upward => x
        | Downward => _BOARD_SIZE -. x -. _PIECE_SIZE
        }
      }
    }

  let rowIndexToY = rowIndex =>
    _CAPTURED_HEIGHT +.
    _SQUARE_SIZE *. Int.toFloat(CerkeEntities.RowIndex.toInt(rowIndex)) +.
    _PIECE_PAD

  let toY = piece =>
    switch piece {
    | OnBoard({coord}) => rowIndexToY(coord.row)
    | Captured({index, piece: {side}}) => {
        let y = _SQUARE_SIZE *. Int.toFloat(index / _COL_MAX) +. _PIECE_PAD
        switch side {
        | Upward => _CAPTURED_HEIGHT +. _BOARD_SIZE +. y
        | Downward => _CAPTURED_HEIGHT -. y -. _PIECE_SIZE
        }
      }
    }
  let notDownwardPiece = piece =>
    switch toPiece(piece) {
    | Tam2 => true
    | NonTam2Piece({side}) =>
      if side == Upward {
        true
      } else {
        false
      }
    }
  let toRotate = piece =>
    if notDownwardPiece(piece) {
      0.
    } else {
      Js.Math._PI
    }

  let toTransformValue = piece =>
    String.concat(
      " ",
      list{
        `translateX(${Js.Float.toString(toX(piece))}px)`,
        `translateY(${Js.Float.toString(toY(piece))}px)`,
        `rotate(${Js.Float.toString(toRotate(piece))}rad)`,
      },
    )
}

module Movable = {
  type kind = Normal | InfAfterStep | Tam
  type t = {
    coord: CerkeEntities.Coord.t,
    kind: kind,
  }
}

type key = string

type state =
  | OpponentTurn
  | MyTurnInit
  | MoveSelection({target: key, movable: list<Movable.t>})
  | StepOverMoveSelection({target: key, waypoint: CerkeEntities.Coord.t, movable: list<Movable.t>})

let toPath = piece => {
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
    }
  }
  /* "images/piece/" ++
  switch piece {
  | CerkeEntities.Piece.NonTam2Piece(nonTam2Piece) =>
    switch nonTam2Piece.color {
    | CerkeEntities.Color.Huok2 => "b"
    | CerkeEntities.Color.Kok1 => "r"
    } ++
    switch nonTam2Piece.prof {
    | CerkeEntities.Profession.Gua2 => "gua"
    | CerkeEntities.Profession.Io => "io"
    | CerkeEntities.Profession.Kauk2 => "kauk"
    | CerkeEntities.Profession.Kaun1 => "kaun"
    | CerkeEntities.Profession.Kua2 => "kua"
    | CerkeEntities.Profession.Maun1 => "maun"
    | CerkeEntities.Profession.Nuak1 => "nuak"
    | CerkeEntities.Profession.Tuk2 => "tuk"
    | CerkeEntities.Profession.Uai1 => "uai"
    }
  } ++ ".png"*/
}

@react.component
let make = (~pieces: Map.String.t<FieldPiece.t>, ~state: state) => {
  <div
    className={String.concat(
      " ",
      list{styles.container, state == OpponentTurn ? styles.opponentTurnContainer : ""},
    )}>
    {pieces
    ->Map.String.toArray
    ->Array.map(((key, fieldPiece)) =>
      <CerkeComponents_ImageSprite
        className={switch state {
        | StepOverMoveSelection({target}) if key == target => styles.stepOverMoveSelectionTarget
        | _ => ""
        }}
        key={key}
        src={toPath(FieldPiece.toPiece(fieldPiece))}
        width=60.
        height=60.
        translateX={FieldPiece.toX(fieldPiece)}
        translateY={FieldPiece.toY(fieldPiece)}
        rotate={FieldPiece.toRotate(fieldPiece)}
        transitionDuration={1.5 *. 0.8093}
        button=?{switch state {
        | MyTurnInit => true
        | MoveSelection(_) => true
        | _ => false
        } &&
        FieldPiece.notDownwardPiece(fieldPiece)
          ? Some(CerkeComponents_ImageSprite.mkButtonProps())
          : None}
      />
    )
    ->React.array}
    {switch state {
    | MoveSelection({target, movable}) => {
        let target = pieces->Map.String.getExn(target)
        <>
          <CerkeComponents_ImageSprite
            src={Images.selection}
            className={styles.selection}
            width=60.
            height=60.
            translateX={FieldPiece.toX(target)}
            translateY={FieldPiece.toY(target)}
            rotate={FieldPiece.toRotate(target)}
            button={CerkeComponents_ImageSprite.mkButtonProps()}
          />
          {movable
          ->List.mapWithIndex((i, movable) =>
            <CerkeComponents_ImageSprite
              key={Int.toString(i)}
              src={switch movable.kind {
              | Normal => Images.ct
              | InfAfterStep => Images.ct2
              | Tam => Images.ctam
              }}
              className={styles.guide}
              width=60.
              height=60.
              translateX={FieldPiece.colIndexToX(movable.coord.col)}
              translateY={FieldPiece.rowIndexToY(movable.coord.row)}
              button={CerkeComponents_ImageSprite.mkButtonProps()}
            />
          )
          ->List.toArray
          ->React.array}
        </>
      }
    | StepOverMoveSelection({target, waypoint, movable}) => {
        let target = pieces->Map.String.getExn(target)
        <>
          <div className={styles.overlay} />
          <CerkeComponents_ImageSprite
            src={toPath(FieldPiece.toPiece(target))}
            width=60.
            height=60.
            translateX={FieldPiece.colIndexToX(waypoint.col) -. FieldPiece._PIECE_PAD}
            translateY={FieldPiece.rowIndexToY(waypoint.row) +. FieldPiece._PIECE_PAD}
          />
          <CerkeComponents_ImageSprite
            src={Images.selection}
            className={styles.selection}
            width=60.
            height=60.
            translateX={FieldPiece.colIndexToX(waypoint.col) -. FieldPiece._PIECE_PAD}
            translateY={FieldPiece.rowIndexToY(waypoint.row) +. FieldPiece._PIECE_PAD}
          />
          {movable
          ->List.mapWithIndex((i, movable) =>
            <CerkeComponents_ImageSprite
              key={Int.toString(i)}
              src={switch movable.kind {
              | Normal => Images.ct
              | InfAfterStep => Images.ct2
              | Tam => Images.ctam
              }}
              className={styles.guide}
              width=60.
              height=60.
              translateX={FieldPiece.colIndexToX(movable.coord.col)}
              translateY={FieldPiece.rowIndexToY(movable.coord.row)}
              button={CerkeComponents_ImageSprite.mkButtonProps()}
            />
          )
          ->List.toArray
          ->React.array}
          <CerkeComponents_ImageSprite
            src={Images.bmun}
            width=80.
            height=80.
            translateX={526.}
            translateY={780.}
            button={CerkeComponents_ImageSprite.mkButtonProps()}
          />
        </>
      }
    | _ => React.null
    }}
  </div>
}
