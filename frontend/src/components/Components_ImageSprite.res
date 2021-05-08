open Belt

type styles = {container: string}
@module("@styles/components/ImageSprite.scss") external styles: styles = "default"

type buttonProps = {onClick: unit => unit, disabled: bool}

let mkButtonProps = (~onClick=() => (), ~disabled=false, ()) => {
  onClick: onClick,
  disabled: disabled,
}

@react.component
let make = (
  ~src,
  ~height,
  ~width,
  ~transitionDuration=?,
  ~translateX=?,
  ~translateY=?,
  ~rotate=?,
  ~button=?,
) => {
  <img
    className={styles.container}
    draggable=false
    src={src}
    height={Float.toString(height)}
    width={Float.toString(width)}
    style={ReactDOM.Style.make(
      ~transform=String.concat(
        "",
        list{
          translateX->Option.map(x => "translateX(" ++ Float.toString(x) ++ "px)"),
          translateY->Option.map(x => "translateY(" ++ Float.toString(x) ++ "px)"),
          rotate->Option.map(x => "rotate(" ++ Float.toString(x) ++ "rad)"),
        }->List.keepMap(x => x),
      ),
      ~transition=?transitionDuration->Option.map(x => "transform " ++ Float.toString(x) ++ "s"),
      ~cursor=?button->Option.map(button =>
        if button.disabled {
          "pointer"
        } else {
          "not-allowed"
        }
      ),
      (),
    )}
    onClick={_ => {
      let _ = button->OptionExt.forEach(button => {
        if !button.disabled {
          button.onClick()
        }
        ()
      })
    }}
  />
}