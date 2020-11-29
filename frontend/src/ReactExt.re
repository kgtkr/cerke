type reactRoot;

[@bs.module "react-dom"]
external createRoot: (Dom.element) => reactRoot = "unstable_createRoot";

[@bs.send]
external render: (reactRoot, React.element) => unit = "render"

module Spread = {
    [@react.component]
    let make = (~props, ~children) => React.cloneElement(children, props);
};