use crate::context::Context;

pub struct Resources<Ctx: Context> {
    pub test: Ctx::Audio,
}

impl<Ctx: Context> Resources<Ctx> {
    pub async fn load(ctx: &mut Ctx) -> Result<Self, Ctx::Error> {
        let test = ctx.load_audio("test.mp3").await?;
        Ok(Resources { test })
    }
}
