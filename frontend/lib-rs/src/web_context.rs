use crate::context::Context;
use async_trait::async_trait;
use js_sys::Promise;
use wasm_bindgen::{JsCast, JsValue};
use wasm_bindgen_futures::JsFuture;
use web_sys::{CanvasRenderingContext2d, HtmlAudioElement, HtmlImageElement};

pub struct WebContext {
    canvas_ctx: CanvasRenderingContext2d,
}

#[async_trait(?Send)]
impl Context for WebContext {
    type Image = HtmlImageElement;
    type Audio = HtmlAudioElement;
    type Error = JsValue;

    async fn load_audio(&mut self, src: &str) -> Result<Self::Audio, Self::Error> {
        let result = HtmlAudioElement::new().unwrap();
        let promise = Promise::new(&mut |resolve, reject| {
            result
                .add_event_listener_with_callback("loadeddata", &resolve)
                .unwrap();
            result
                .add_event_listener_with_callback("error", &reject)
                .unwrap();
        });
        result.set_src(src);
        JsFuture::from(promise).await?;
        Ok(result)
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
        let _ = audio
            .clone_node()
            .unwrap()
            .dyn_into::<HtmlAudioElement>()
            .unwrap()
            .play()
            .unwrap();
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
