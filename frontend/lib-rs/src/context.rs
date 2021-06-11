use async_trait::async_trait;

#[async_trait(?Send)]
pub trait Context {
    type Image;
    type Audio;
    type Error;

    async fn load_audio(&mut self, src: &str) -> Result<Self::Audio, Self::Error>;
    async fn load_image(&mut self, src: &str) -> Result<Self::Image, Self::Error>;
    fn audio_play(&mut self, audio: &mut Self::Audio);
    fn draw_image(&mut self, image: &mut Self::Image, x: f64, y: f64, w: f64, h: f64);
    fn scope<R, F: FnOnce(&mut Self) -> R>(&mut self, f: F) -> R;
    fn translate(&mut self, x: f64, y: f64);
    fn rotate(&mut self, angle: f64);
    fn scale(&mut self, x: f64, y: f64);
}
