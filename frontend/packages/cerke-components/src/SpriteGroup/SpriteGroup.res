open Belt

type styles = {container: string}
@module("./SpriteGroup.scss") external styles: styles = "default"

@react.component
let make = (
  ~height,
  ~width,
  ~x,
  ~y,
  ~className=?,
  ~transitionDuration=?,
  ~rotate=?,
  ~children=?,
  ~zIndex=?,
) => {
  <div
    className={list{Some(styles.container), className}->Belt.List.keepMap(Relude.Function.id)
      |> String.concat(" ")}
    style={ReactDOM.Style.make(
      ~transform=list{
        Some(`translateX(${Float.toString(x)}px)`),
        Some(`translateY(${Float.toString(y)}px)`),
        rotate->Option.map(x => `rotate(${Float.toString(x)}rad)`),
      }->List.keepMap(Relude.Function.id) |> String.concat(""),
      ~transition=?transitionDuration->Option.map(x => `transform ${Float.toString(x)}s`),
      ~width=`${Float.toString(width)}px`,
      ~height=`${Float.toString(height)}px`,
      ~zIndex=?zIndex->Option.map(Int.toString),
      (),
    )}>
    {children->Option.getWithDefault(React.null)}
  </div>
}
