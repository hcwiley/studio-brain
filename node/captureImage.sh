#sysctl vm.overcommit_memory=1
SOURCE=""
if [ -c /dev/video0 ]; then
  SOURCE="/dev/video0"
else 
  if [ -c /dev/video1 ]; then
    SOURCE="/dev/video1"
  fi
fi
streamer -j 40 -c $SOURCE -s 320x240 -o public/img/foobar.jpeg &
sleep 0.3
#sysctl vm.overcommit_memory=0
PID=$(pidof streamer)
#echo $PID
# reset the device if PID
if [ $PID ]; then
  killall streamer
  #FULLSTR=$(lsusb | grep cam)
  #USBBUS='/dev/bus/usb/'
  #USBBUS=$USBBUS$(echo $FULLSTR  | cut -d" " -f 2)'/'
  #USBBUS=$USBBUS$(echo $FULLSTR  | cut -d" " -f 4)
  #USBBUS=$(echo $USBBUS  | cut -d":" -f 1)
  #./resetUSB $USBBUS
fi


