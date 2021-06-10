type styles = {animationContainer: string}
@module("@styles/components/WaterEntry.scss") external styles: styles = "default"

@react.component
let make = (~className=?, ~onHidden=?) => {
  let (show, setShow) = React.useState(() => true)

  let handleAnimationEnd = React.useCallback1(_ => {
    setShow(_ => false)
    switch onHidden {
    | Some(onHidden) => onHidden()
    | None => ()
    }
  }, [onHidden])

  <div ?className>
    {if show {
      <div className=styles.animationContainer onAnimationEnd={handleAnimationEnd}>
        <Components_ImageSprite
          src="images/water_entry.png" width=500. translateX=250. translateY=134.289
        />
      </div>
    } else {
      React.null
    }}
  </div>
}
