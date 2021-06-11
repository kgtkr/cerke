.PHONY: build
build: build-lib-rs

.PHONY: build-lib-rs
build-lib-rs:
	cd lib-rs && WASM_BINDGEN_WEAKREF=1 wasm-pack build --target web
