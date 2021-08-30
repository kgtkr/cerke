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
  @module("./bmun.png") external bmun: string = "default"
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
      <ImageSprite
        className={switch state {
        | StepOverMoveSelection({target}) if key == target => styles.stepOverMoveSelectionTarget
        | _ => ""
        }}
        key={key}
        src={Piece.toImagePath(FieldPiece.toPiece(fieldPiece))}
        width=60.
        height=60.
        x={FieldPiece.toX(fieldPiece)}
        y={FieldPiece.toY(fieldPiece)}
        rotate={FieldPiece.toRotate(fieldPiece)}
        transitionDuration={1.5 *. 0.8093}
        button=?{switch state {
        | MyTurnInit => true
        | MoveSelection(_) => true
        | _ => false
        } &&
        FieldPiece.notDownwardPiece(fieldPiece)
          ? Some(ImageSprite.mkButtonProps())
          : None}
      />
    )
    ->React.array}
    {switch state {
    | MoveSelection({target, movable}) => {
        let target = pieces->Map.String.getExn(target)
        <>
          <ImageSprite
            src={Images.selection}
            className={styles.selection}
            width=60.
            height=60.
            x={FieldPiece.toX(target)}
            y={FieldPiece.toY(target)}
            rotate={FieldPiece.toRotate(target)}
            button={ImageSprite.mkButtonProps()}
          />
          {movable
          ->List.mapWithIndex((i, movable) =>
            <ImageSprite
              key={Int.toString(i)}
              src={switch movable.kind {
              | Normal => Images.ct
              | InfAfterStep => Images.ct2
              | Tam => Images.ctam
              }}
              className={styles.guide}
              width=60.
              height=60.
              x={FieldPiece.colIndexToX(movable.coord.col)}
              y={FieldPiece.rowIndexToY(movable.coord.row)}
              button={ImageSprite.mkButtonProps()}
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
          <ImageSprite
            src={Piece.toImagePath(FieldPiece.toPiece(target))}
            width=60.
            height=60.
            x={FieldPiece.colIndexToX(waypoint.col) -. FieldPiece._PIECE_PAD}
            y={FieldPiece.rowIndexToY(waypoint.row) +. FieldPiece._PIECE_PAD}
          />
          <ImageSprite
            src={Images.selection}
            className={styles.selection}
            width=60.
            height=60.
            x={FieldPiece.colIndexToX(waypoint.col) -. FieldPiece._PIECE_PAD}
            y={FieldPiece.rowIndexToY(waypoint.row) +. FieldPiece._PIECE_PAD}
          />
          {movable
          ->List.mapWithIndex((i, movable) =>
            <ImageSprite
              key={Int.toString(i)}
              src={switch movable.kind {
              | Normal => Images.ct
              | InfAfterStep => Images.ct2
              | Tam => Images.ctam
              }}
              className={styles.guide}
              width=60.
              height=60.
              x={FieldPiece.colIndexToX(movable.coord.col)}
              y={FieldPiece.rowIndexToY(movable.coord.row)}
              button={ImageSprite.mkButtonProps()}
            />
          )
          ->List.toArray
          ->React.array}
          <ImageSprite
            src={Images.bmun}
            width=80.
            height=80.
            x={526.}
            y={780.}
            button={ImageSprite.mkButtonProps()}
          />
        </>
      }
    | _ => React.null
    }}
  </div>
}
