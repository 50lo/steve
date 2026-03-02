#!/bin/sh

set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
INSTALL_DIR="${HOME}/.bin"
BUILD_DIR="${ROOT_DIR}/.build/release"
BIN_NAME="steve"
SOURCE_BIN="${BUILD_DIR}/${BIN_NAME}"
TARGET_BIN="${INSTALL_DIR}/${BIN_NAME}"

mkdir -p "${INSTALL_DIR}"

echo "Building ${BIN_NAME} in release mode..."
swift build -c release --package-path "${ROOT_DIR}"

if [ ! -x "${SOURCE_BIN}" ]; then
  echo "error: built binary not found at ${SOURCE_BIN}" >&2
  exit 1
fi

cp "${SOURCE_BIN}" "${TARGET_BIN}"
chmod 755 "${TARGET_BIN}"

echo "Installed ${BIN_NAME} to ${TARGET_BIN}"
