type generator;

[@bs.module "random-seed"]
external create: (string) => generator = "create";

[@bs.send]
external random: (generator, unit) => float = "random"
