let default = {
    "title": "Ciurls",
    "argTypes": {"count": { "control": { "type": "range", "max": 5, "min": 0 } }, "seed": { "control": { "type": "text" } } },
    "args": {
        "count": 0,
        "seed": ""
    }
};

type props = {
    count: int,
    seed: string
};

let ciurls = (props: props) => {
    <Ciurls count=props.count seed=props.seed />
};
