#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ "$(uname -s)" != Darwin || "$(uname -m)" != x86_64 ]]; then
  echo "Execute este script no Mac Intel." >&2; exit 1
fi
for tool in brew cmake ninja python3 git; do
  command -v "$tool" >/dev/null || { echo "Ferramenta ausente: $tool" >&2; exit 1; }
done
qt_prefix="$(brew --prefix qt)"
brew_prefix="$(brew --prefix)"
./third_party/build-skia.sh mac-x64
cmake -S . -B build-heinteira-intel -G Ninja \
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_ARCHITECTURES=x86_64 \
  -DCMAKE_PREFIX_PATH="$qt_prefix;$(brew --prefix openssl@3);$brew_prefix" \
  -DDRIFT_BUNDLE_ONNXRUNTIME=OFF -DDRIFT_UPDATE_FEED_URL=
cmake --build build-heinteira-intel --target drift --parallel 2
open "build-heinteira-intel/Heinteira Frame.app"
