type styles = {animationContainer: string}
@module("./WaterEntry.scss") external styles: styles = "default"

module Images = {
  @module("./water_entry.png") external waterEntry: string = "default"
}

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
        <ImageSprite src={Images.waterEntry} width=500. height={268.6} x=250. y=134.289 />
      </div>
    } else {
      React.null
    }}
  </div>
}
