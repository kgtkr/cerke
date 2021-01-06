
type styles = {
    container: string,
}
@bs.module("@styles/components/Field.scss") external styles : styles = "default";

@react.component
let make = () => {
  <div className=styles.container></div>
}
