#!/bin/bash
#
# Exports the LedMirror Processing sketch as a Linux binary

PROCESSING_JAVA=/usr/local/bin/processing-java

BASE_DIR=/home/pi/led-mirror/
SKETCH_DIR="${BASE_DIR}Processing/"
SKETCH_NAME=LedMirror

SKETCH_FULL=$SKETCH_DIR$SKETCH_NAME

BIN_DIR=application.linux-armv6hf/

BIN_FULL="${SKETCH_FULL}/$BIN_DIR$SKETCH_NAME"

COMMAND="$PROCESSING_JAVA --sketch=$SKETCH_FULL --export --platform=linux"

echo "Exporting LED Mirror application to:"
echo $BIN_FULL
echo ""

$COMMAND

echo "Done."
echo ""