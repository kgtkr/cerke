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

type styles = {container: string, piece: string}
@bs.module("@styles/components/Field.scss") external styles: styles = "default"

module FieldPiece = {
  type t =
    | OnBoard({piece: Entities.Piece.t, coord: Entities.Coord.t})
    | Captured({piece: Entities.NonTam2Piece.t, index: int})

  let _BOARD_SIZE = 631.
  let _CAPTURED_HEIGHT = 140.
  let _COL_MAX = 9
  let _PIECE_SIZE = 60.
  let _PIECE_PAD = 5.0555
  let _SQUARE_SIZE = _PIECE_SIZE +. 2. *. _PIECE_PAD

  let toPiece = piece =>
    switch piece {
    | OnBoard({piece}) => piece
    | Captured({piece}) => Entities.Piece.NonTam2Piece(piece)
    }

  let toX = piece =>
    switch piece {
    | OnBoard({coord}) =>
      _SQUARE_SIZE *. Int.toFloat(Entities.ColIndex.toInt(coord.col)) +. _PIECE_PAD
    | Captured({index, piece: {side}}) => {
        let x = _SQUARE_SIZE *. Int.toFloat(mod(index, _COL_MAX)) +. _PIECE_PAD
        switch side {
        | Upward => x
        | Downward => _BOARD_SIZE -. x -. _PIECE_SIZE
        }
      }
    }
  let toY = piece =>
    switch piece {
    | OnBoard({coord}) =>
      _CAPTURED_HEIGHT +.
      _SQUARE_SIZE *. Int.toFloat(Entities.RowIndex.toInt(coord.row)) +.
      _PIECE_PAD
    | Captured({index, piece: {side}}) => {
        let y = _SQUARE_SIZE *. Int.toFloat(index / _COL_MAX) +. _PIECE_PAD
        switch side {
        | Upward => _CAPTURED_HEIGHT +. _BOARD_SIZE +. y
        | Downward => _CAPTURED_HEIGHT -. y -. _PIECE_SIZE
        }
      }
    }
  let toRotate = piece =>
    switch toPiece(piece) {
    | Tam2 => 0.
    | NonTam2Piece({side}) =>
      if side == Upward {
        0.
      } else {
        Js.Math._PI
      }
    }
}

type key = string

type state =
  | OpponentTurn
  | MyTurnInit
  | MoveSelection({target: key, movable: list<Entities.Coord.t>})
  | StepOverMoveSelection({
      target: key,
      waypoint: Entities.Coord.t,
      movable: list<Entities.Coord.t>,
    })

let toPath = piece => {
  "images/piece/" ++
  switch piece {
  | Entities.Piece.NonTam2Piece(nonTam2Piece) =>
    switch nonTam2Piece.color {
    | Entities.Color.Huok2 => "b"
    | Entities.Color.Kok1 => "r"
    } ++
    switch nonTam2Piece.prof {
    | Entities.Profession.Dau2 => "dau"
    | Entities.Profession.Gua2 => "gua"
    | Entities.Profession.Io => "io"
    | Entities.Profession.Kauk2 => "kauk"
    | Entities.Profession.Kaun1 => "kaun"
    | Entities.Profession.Kua2 => "kua"
    | Entities.Profession.Maun1 => "maun"
    | Entities.Profession.Nuak1 => "nuak"
    | Entities.Profession.Tuk2 => "tuk"
    | Entities.Profession.Uai1 => "uai"
    }
  | Entities.Piece.Tam2 => "tam"
  } ++ ".png"
}

@react.component
let make = (~pieces: HashMap.String.t<FieldPiece.t>, ~state: state) => {
  <div className=styles.container>
    {pieces
    ->HashMap.String.toArray
    ->Array.map(((key, fieldPiece)) =>
      <img
        key={key}
        className={styles.piece}
        src={toPath(FieldPiece.toPiece(fieldPiece))}
        width="256"
        height="256"
        draggable=false
        style={ReactDOM.Style.make(
          ~transform=String.concat(
            " ",
            list{
              "translateX(" ++ Js.Float.toString(FieldPiece.toX(fieldPiece)) ++ "px)",
              "translateY(" ++ Js.Float.toString(FieldPiece.toY(fieldPiece)) ++ "px)",
              "rotate(" ++ Js.Float.toString(FieldPiece.toRotate(fieldPiece)) ++ "rad)",
            },
          ),
          (),
        )}
      />
    )
    ->React.array}
    {switch state {
    | OpponentTurn => <> </>
    | MyTurnInit => <> </>
    | MoveSelection(_) => <> </>
    | StepOverMoveSelection(_) => <> </>
    }}
  </div>
}
