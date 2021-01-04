type styles = {
    animationContainer: string,
    image: string
}
@bs.module("@styles/components/WaterEntry.scss") external styles : styles = "default";


@react.component
let make = (~className=?, ~onHidden=?) => {
  let (show, setShow) = React.useState(() => true);

  let handleAnimationEnd = React.useCallback1((_) => {
      setShow((_) => false)
      switch onHidden {
        | Some(onHidden) => onHidden()
        | None => ()
      }
    }, [onHidden]);

  <div className=?className>
    {
      if show {
        <div className=styles.animationContainer onAnimationEnd={handleAnimationEnd}>
          <img src="images/water_entry.png" className=styles.image width="500"/>
        </div>
      } else { 
        React.null
      }
    }
  </div>
}
