module TransitioningTest = {
  @react.component
  let make = () => {
    let elRef = React.useRef(Js.Nullable.null)
    let (value, setValue) = React.useState(_ => (0, list{2, 1, 1, 3}))

    let current = Transitioning.useScheduledTransitioning(
      ~elRef,
      ~scheduledProps=value,
      ~changeScheduledProps=newValue => setValue(_ => newValue),
      (),
    )

    <div ref={ReactDOM.Ref.domRef(elRef)}>
      <div
        style={ReactDOM.Style.make(
          ~transform=String.concat(
            " ",
            list{"translateX(" ++ Js.Int.toString(current * 100) ++ "px)"},
          ),
          ~transition="transform 1s",
          ~backgroundColor="black",
          ~width="100px",
          ~height="100px",
          (),
        )}
      />
    </div>
  }
}

let default = StorybookExt.make((props: {.}) => <TransitioningTest />, {
  "title": "Transitioning",
})
