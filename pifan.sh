#!/bin/bash

PIN=26
TEMP_ON=45
TEMP_OFF=40
STATE=0

# Init the GPIO port.
GPIO_PATH="/sys/class/gpio/gpio"$PIN

if [ ! -d $GPIO_PATH ]
then
	echo $PIN > /sys/class/gpio/export
fi

if [ ! -d $GPIO_PATH ]
then
	echo "GPIO interface not found!"
	exit 1
fi

echo out > $GPIO_PATH/direction

while true
do
	TEMP=`vcgencmd measure_temp | cut -d'=' -f2 | cut -d'.' -f1`
	#echo -n "Temp: "
	#echo $TEMP

	if [ $TEMP -ge $TEMP_ON ] && [ $STATE -eq 0 ]
	then
		STATE=1
		echo 1 > $GPIO_PATH/value
		#echo "Turned fan on."
	fi

	if [ $TEMP -le $TEMP_OFF ] && [ $STATE -eq 1 ]
	then
		STATE=0
		echo 0 > $GPIO_PATH/value
		#echo "Turned fan off."
	fi

	sleep 1
done
