#!/bin/bash
set -e

usage() {
    echo "Usage: $0 cross" >&2
    echo "  cross - build with a DJGPP cross compiler" >&2
    exit 1
}

[ $# -eq 0 ] && usage

target=$1

ensure_djgpp_cross() {
    if [ -x "djgpp-cross/bin/i586-pc-msdosdjgpp-gcc" ]; then
        export PATH="$PWD/djgpp-cross/bin:$PATH"
        return
    fi
    if command -v i586-pc-msdosdjgpp-gcc >/dev/null 2>&1; then
        return
    fi
    echo "DJGPP cross tools not found. Downloading prebuilt toolchain..." >&2
    tmpdir=$(mktemp -d)
    url=$(curl -s https://api.github.com/repos/andrewwutw/build-djgpp/releases/latest \
        | grep linux64 | grep browser_download_url | cut -d '"' -f4 | head -n1)
    if [ -z "$url" ]; then
        echo "Failed to determine DJGPP toolchain URL" >&2
        exit 1
    fi
    mkdir -p djgpp-cross
    curl -L "$url" -o "$tmpdir/djgpp.tar.bz2"
    tar -xjf "$tmpdir/djgpp.tar.bz2" -C djgpp-cross --strip-components=1
    rm -rf "$tmpdir"
    if ! ldconfig -p | grep -q libfl.so.2; then
        sudo apt-get update && sudo apt-get install -y libfl2
    fi
    export PATH="$PWD/djgpp-cross/bin:$PATH"
}

case "$target" in
    cross)
        if ! command -v make >/dev/null 2>&1; then
            echo "make not found." >&2
            exit 1
        fi
        ensure_djgpp_cross
        make
        ;;
    *)
        usage
        ;;
esac
