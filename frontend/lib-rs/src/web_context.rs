use crate::context::Context;
use async_trait::async_trait;
use js_sys::{ArrayBuffer, Promise};
use wasm_bindgen::{JsCast, JsValue};
use wasm_bindgen_futures::JsFuture;
use web_sys::{
    AudioBuffer, AudioContext, CanvasRenderingContext2d, HtmlAudioElement, HtmlImageElement,
    Response,
};

pub struct WebContext {
    canvas_ctx: CanvasRenderingContext2d,
    audio_ctx: AudioContext,
}

#[async_trait(?Send)]
impl Context for WebContext {
    type Image = HtmlImageElement;
    type Audio = AudioBuffer;
    type Error = JsValue;

    async fn load_audio(&mut self, src: &str) -> Result<Self::Audio, Self::Error> {
        let window = web_sys::window().unwrap();
        let res = JsFuture::from(window.fetch_with_str(src))
            .await?
            .dyn_into::<Response>()
            .unwrap();
        let buffer = JsFuture::from(res.array_buffer().unwrap())
            .await?
            .dyn_into::<ArrayBuffer>()
            .unwrap();
        let audio_buffer = JsFuture::from(self.audio_ctx.decode_audio_data(&buffer).unwrap())
            .await?
            .dyn_into::<AudioBuffer>()
            .unwrap();

        Ok(audio_buffer)
    }

    async fn load_image(&mut self, src: &str) -> Result<Self::Image, Self::Error> {
        let result = HtmlImageElement::new().unwrap();
        let promise = Promise::new(&mut |resolve, reject| {
            result
                .add_event_listener_with_callback("load", &resolve)
                .unwrap();
            result
                .add_event_listener_with_callback("error", &reject)
                .unwrap();
        });
        result.set_src(src);
        JsFuture::from(promise).await?;
        Ok(result)
    }

    fn audio_play(&mut self, audio: &mut Self::Audio) {
        let source = self.audio_ctx.create_buffer_source().unwrap();
        source.set_buffer(Some(audio));
        source
            .connect_with_audio_node(&self.audio_ctx.destination())
            .unwrap();
        source.start().unwrap();
    }

    fn draw_image(&mut self, image: &mut Self::Image, x: f64, y: f64, w: f64, h: f64) {
        self.canvas_ctx
            .draw_image_with_html_image_element_and_dw_and_dh(image, x, y, w, h)
            .unwrap();
    }

    fn scope<R, F: FnOnce(&mut Self) -> R>(&mut self, f: F) -> R {
        self.canvas_ctx.save();
        let x = f(self);
        self.canvas_ctx.restore();
        x
    }

    fn translate(&mut self, x: f64, y: f64) {
        self.canvas_ctx.translate(x, y).unwrap();
    }
    fn rotate(&mut self, angle: f64) {
        self.canvas_ctx.rotate(angle).unwrap();
    }
    fn scale(&mut self, x: f64, y: f64) {
        self.canvas_ctx.scale(x, y).unwrap();
    }
}
