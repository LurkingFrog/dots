# Some global values that may be used for installing/updating

export CARGO=( \
  cargo-edit \
  cargo-expand \
  wasm-bindgen-cli \
  cargo-watch \
  wasm-pack \
  trunk \
  cargo-cache \
  "diesel_cli --no-default-features --features postgres --verbose --version \"^1\"" \
)

export RUSTUP=(clippy rls rust-analysis rust-src)