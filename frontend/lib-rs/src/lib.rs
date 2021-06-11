use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub struct Hoge {
    x: usize,
    y: usize,
}

#[wasm_bindgen]
pub fn func(a: usize, hoge: Hoge) -> usize {
    a + hoge.x + hoge.y
}

mod component;
mod context;
mod web_context;
