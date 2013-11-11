sysctl vm.overcommit_memory=1
if [ -c /dev/video0 ]; then
  echo "use video0"
  streamer -c /dev/video0 -o public/img/foobar.jpeg &
else 
  if [ -c /dev/video1 ]; then
    echo "use video1"
    streamer -c /dev/video1 -o public/img/foobar.jpeg &
  fi
fi
sleep 0.5
sysctl vm.overcommit_memory=0
PID=$(pidof streamer)
echo $PID
# reset the device if PID
if [ $PID ]; then
  killall streamer
  FULLSTR=$(lsusb | grep cam)
  USBBUS='/dev/bus/usb/'
  USBBUS=$USBBUS$(echo $FULLSTR  | cut -d" " -f 2)'/'
  USBBUS=$USBBUS$(echo $FULLSTR  | cut -d" " -f 4)
  USBBUS=$(echo $USBBUS  | cut -d":" -f 1)
  #echo $USBBUS
  ./resetUSB $USBBUS
fi

