#!/usr/bin/env bash
set -e

VERSION="1.0.0"
echo "Building RecipeMate release v$VERSION with obfuscation..."

flutter build appbundle --release --obfuscate --split-debug-info=build/symbols/$VERSION
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/symbols/$VERSION

echo "Build complete! Symbols saved to build/symbols/$VERSION"
