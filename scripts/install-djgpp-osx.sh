#!/usr/bin/env bash
set -e

# Install the prebuilt DJGPP cross-compiler on macOS.
PREFIX=${1:-/opt/djgpp}
VERSION=v3.4
ARCHIVE=djgpp-osx-gcc1220.tar.bz2
SHA256=cf605786efe14166d32aede89c37e41bf1272178ae73a624e7e84761cca38549
URL="https://github.com/andrewwutw/build-djgpp/releases/download/${VERSION}/${ARCHIVE}"

mkdir -p "$PREFIX"

curl -L "$URL" -o /tmp/${ARCHIVE}
echo "${SHA256}  /tmp/${ARCHIVE}" | shasum -a 256 --check
tar -xf /tmp/${ARCHIVE} -C "$PREFIX" --strip-components=1
rm /tmp/${ARCHIVE}

echo "DJGPP cross compiler installed to ${PREFIX}."
echo "Run 'source ${PREFIX}/setenv' to update your PATH."
