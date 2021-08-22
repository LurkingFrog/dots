# Some global values that may be used for installing/updating

export CARGO=( \
  cargo-edit \
  cargo-expand \
  wasm-bindgen-cli \
  cargo-watch \
  "diesel_cli --no-default-features --features postgres --verbose" \
)

export RUSTUP=(clippy rls rust-analysis rust-src)