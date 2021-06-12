mod component;
mod context;
mod web_context;

use wasm_bindgen::prelude::*;
#[wasm_bindgen]
pub fn f(x: i32) -> i32 {
    x
}
