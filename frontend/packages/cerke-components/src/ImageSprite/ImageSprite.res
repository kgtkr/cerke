open Belt
open CerkeExt

type styles = {container: string}
@module("./ImageSprite.scss") external styles: styles = "default"

type buttonProps = {onClick: unit => unit, disabled: bool}

let mkButtonProps = (~onClick=() => (), ~disabled=false, ()) => {
  onClick: onClick,
  disabled: disabled,
}

@react.component
let make = (
  ~src,
  ~className=?,
  ~height,
  ~width,
  ~transitionDuration=?,
  ~x,
  ~y,
  ~rotate=?,
  ~button=?,
  ~zIndex=?,
) => {
  <img
    className={styles.container ++ " " ++ className->Option.getWithDefault("")}
    draggable=false
    src={src}
    height={Float.toString(height)}
    width={Float.toString(width)}
    style={ReactDOM.Style.make(
      ~transform=list{
        Some(`translateX(${Float.toString(x)}px)`),
        Some(`translateY(${Float.toString(y)}px)`),
        rotate->Option.map(x => `rotate(${Float.toString(x)}rad)`),
      }->List.keepMap(Relude.Function.id) |> String.concat(""),
      ~transition=?transitionDuration->Option.map(x => `transform ${Float.toString(x)}s`),
      ~cursor=?button->Option.map(button =>
        if button.disabled {
          "not-allowed"
        } else {
          "pointer"
        }
      ),
      ~width=`${Float.toString(width)}px`,
      ~height=`${Float.toString(height)}px`,
      ~zIndex=?zIndex->Option.map(Int.toString),
      (),
    )}
    onClick={_ => {
      button->OptionExt.forEach_(button => {
        if !button.disabled {
          button.onClick()
        }
        ()
      })
    }}
  />
}
