use crate::context::Context;

pub trait Component {
    type Ctx: Context;

    fn update(&mut self, ctx: &mut Self::Ctx);
    fn draw(&mut self, ctx: &mut Self::Ctx);
}
