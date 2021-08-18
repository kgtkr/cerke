open Belt

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
  ~height=?,
  ~width=?,
  ~transitionDuration=?,
  ~translateX=?,
  ~translateY=?,
  ~rotate=?,
  ~button=?,
) => {
  <img
    className={styles.container ++ " " ++ className->Option.getWithDefault("")}
    draggable=false
    src={src}
    height=?{height->Option.map(Float.toString)}
    width=?{width->Option.map(Float.toString)}
    style={ReactDOM.Style.make(
      ~transform=String.concat(
        "",
        list{
          translateX->Option.map(x => `translateX(${Float.toString(x)}px)`),
          translateY->Option.map(x => `translateY(${Float.toString(x)}px)`),
          rotate->Option.map(x => `rotate(${Float.toString(x)}rad)`),
        }->List.keepMap(Relude.Function.id),
      ),
      ~transition=?transitionDuration->Option.map(x => `transform ${Float.toString(x)}s`),
      ~cursor=?button->Option.map(button =>
        if button.disabled {
          "not-allowed"
        } else {
          "pointer"
        }
      ),
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