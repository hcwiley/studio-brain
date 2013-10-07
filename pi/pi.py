from OSC import OSCClient, OSCMessage, OSCServer
from time import sleep
import serial, os

SERIAL_PORT = os.environ.get("SERIAL_PORT")
if not SERIAL_PORT:
  print "Set the SERIAL_PORT env variable"
  exit(1)
ser = serial.Serial(SERIAL_PORT, 9600)
#ser = serial.Serial("/dev/tty.usbmodem1421", 9600)
client = OSCClient()
client.connect( ("0.0.0.0", 8888) )
server = OSCServer( ("0.0.0.0", 8889) )
server.timeout = 0
run = True

# this method of reporting timeouts only works by convention
# that before calling handle_request() field .timed_out is 
# set to False
def handle_timeout(self):
  self.timed_out = True

# funny python's way to add a method to an instance of a class
import types
server.handle_timeout = types.MethodType(handle_timeout, server)

def quit_callback(path, tags, args, source):
  # don't do this at home (or it'll quit blender)
    global run
    run = False

def handleDoor(path, tags, args, source):
  print "got message %s" % args
  if args[0] == 'lock':
    ser.write('l')
  elif args[0] == 'unlock':
    ser.write('r')

def handleLights(path, tags, args, source):
  print "got message %s" % args
  if args[0] == 'on':
    ser.write('b')
  elif args[0] == 'off':
    ser.write('d')
  elif args[0] == 'far':
    ser.write('f')
  elif args[0] == 'near':
    ser.write('n')


server.addMsgHandler( "/door", handleDoor)
server.addMsgHandler( "/lights", handleLights)

# user script that's called by the game engine every frame
def each_frame():
  msg = OSCMessage( "/active" )
  msg.append("i'm alive")
  client.send( msg )
  # clear timed_out flag
  server.timed_out = False
  # handle all pending requests then return
  while not server.timed_out:
    server.handle_request()

# simulate a "game engine"
while run:
  # do the game stuff:
    sleep(1)
    # call user script
    each_frame()

server.close()

