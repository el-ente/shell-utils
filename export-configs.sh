#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIGS_DIR="$SCRIPT_DIR/configs"

mkdir -p "$CONFIGS_DIR"

echo "Exporting Maccy config..."
defaults export org.p0deje.Maccy "$CONFIGS_DIR/maccy.plist"

echo "Exporting Shottr config..."
defaults export cc.ffitch.shottr "$CONFIGS_DIR/shottr.plist"

echo "Done. Configs saved to $CONFIGS_DIR"
