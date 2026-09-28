#!/bin/sh
# Better Deepin: download every crate pinned by Cargo.lock for the
# (quilt-patched) tree into ./vendor, using `cargo vendor`.
#
# debian/rules runs this once at configure time.  It is the only
# deliberately networked step of the build (the Better-Deepin OBS builder
# permits it); the subsequent `cargo build` itself resolves fully offline
# against ./vendor via debian/cargo-config.toml (source replacement +
# [net] offline = true).  deepin's packaged librust-*-dev crates are far
# too old for netavark, hence crates come from crates.io, not from
# Debian packages.
set -eu

[ -f Cargo.lock ] || {
	echo "error: run ./debian/fetch-vendor.sh in the unpacked source tree" >&2
	exit 1
}

rm -rf vendor
cargo vendor --versioned-dirs vendor >/dev/null
echo "I: vendored $(ls vendor | wc -l) crate directories into ./vendor"
