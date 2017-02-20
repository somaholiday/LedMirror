#!/bin/bash

PROCESSING_JAVA=/usr/local/bin/processing-java

BASE_DIR=/home/pi/led-mirror/
LOG_DIR="${BASE_DIR}logs/"
SKETCH_DIR="${BASE_DIR}Processing/"

SKETCH_NAME=LedMirror

SKETCH_FULL=$SKETCH_DIR$SKETCH_NAME

COMMAND="$PROCESSING_JAVA --sketch=$SKETCH_FULL --run"

echo "Running LED Mirror from:"
echo $SKETCH_FULL
echo ""

while true
do

LOG_FILE=$LOG_DIR$(date -d "today" +"%Y%m%d-%H%M").log

if pgrep $SKETCH_NAME > /dev/null
then
	echo "Sketch already running"
else
	echo "Running..."
	echo $COMMAND
	echo ""

	echo "Logging to:"
	echo $LOG_FILE
	echo ""
	
	$COMMAND > $LOG_FILE
fi

sleep 1

echo ""
echo "xXx"
echo " died."
echo ""
echo "Restarting..."
echo ""

#killall processing-java

sleep 1

done
