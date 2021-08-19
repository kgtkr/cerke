module AnimationManagerTest = {
  @react.component
  let make = () => {
    let animationManager = AnimationManager.useAnimationManager()

    let duringAnimation = AnimationManager.useDuringAnimation(~manager=animationManager)

    let (value1, setValue1) = React.useState(() => 0)

    let (value2, setValue2) = React.useState(() => 0)

    React.useEffect0(() => {
      let count = ref(0)
      let _ = Js.Global.setInterval(() => {
        if mod(count.contents, 50) < 3 {
          setValue1(_ => 10 + mod(count.contents, 11) * (1 - 2 * mod(count.contents, 2)))
          setValue2(_ => 10 + mod(count.contents, 11) * -(1 - 2 * mod(count.contents, 2)))
        }
        count := count.contents + 1
        ()
      }, 100)
      None
    })

    let renderValue1 = AnimationManager.useAnimationValue(
      value1,
      ~duration=500,
      ~eq=Relude.Int.eq,
      ~manager=animationManager,
    )
    let renderValue2 = AnimationManager.useAnimationValue(
      value2,
      ~duration=500,
      ~eq=Relude.Int.eq,
      ~manager=animationManager,
    )

    <div>
      <div> {React.string(`duringAnimation: ${string_of_bool(duringAnimation)}`)} </div>
      <div
        style={ReactDOM.Style.make(
          ~transform=String.concat(
            " ",
            list{`translateX(${Js.Int.toString(renderValue1 * 50)}px)`},
          ),
          ~transition="transform 0.5s",
          ~backgroundColor="blue",
          ~width="100px",
          ~height="100px",
          (),
        )}>
        {React.string(string_of_int(value1))}
      </div>
      <div
        style={ReactDOM.Style.make(
          ~transform=String.concat(
            " ",
            list{`translateX(${Js.Int.toString(renderValue2 * 50)}px)`},
          ),
          ~transition="transform 0.5s",
          ~backgroundColor="red",
          ~width="100px",
          ~height="100px",
          (),
        )}>
        {React.string(string_of_int(value2))}
      </div>
    </div>
  }
}

let default = CerkeSb.make(
  (_: {.}) => <AnimationManagerTest />,
  {
    "title": "AnimationManager",
    "excludeStories": ["AnimationManagerTest"],
  },
)
