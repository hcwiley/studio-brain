
#include <Stepper.h>
#include <Adafruit_NeoPixel.h>

#define PIN 4
#define LIGHT1 2
#define LIGHT2 7

#define GREEN			0x008000
#define DARKRED			0x8B0000
#define GRAY			0x808080

// Parameter 1 = number of pixels in strip
// Parameter 2 = pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_KHZ800  800 KHz bitstream (most NeoPixel products w/WS2812 LEDs)
//   NEO_KHZ400  400 KHz (classic 'v1' (not v2) FLORA pixels, WS2811 drivers)
//   NEO_GRB     Pixels are wired for GRB bitstream (most NeoPixel products)
//   NEO_RGB     Pixels are wired for RGB bitstream (v1 FLORA pixels, not v2)
Adafruit_NeoPixel led = Adafruit_NeoPixel(1, PIN, NEO_GRB + NEO_KHZ800);


const int steps = 2000;  // change this to fit the number of steps per revolution
                                     // for your motor

Stepper myStepper(steps, 12,11, 13,3);

int powIn;                                
int total;
char dir = 'f';
void setup()
{
  Serial.begin(9600);
  
  pinMode(LIGHT1, OUTPUT);
  pinMode(LIGHT2, OUTPUT);
  
  digitalWrite(LIGHT1, LOW);
  digitalWrite(LIGHT2, LOW);
  
  myStepper.setSpeed(100);
  
  led.begin();
  led.setBrightness(10);
  led.setPixelColor(0, GRAY);
  led.show();

  Serial.println("hi");
}

void loop()
{
  while(!Serial.available()){
  }
  char readIn = Serial.read();
  if(readIn == 'l'){
    dir = readIn;
    for(int i = 0; i < 120; i++){
      myStepper.step(1);
      delay(3);
    }
    myStepper.step(-2);
  }
  else if( readIn == 'r'){
    dir = readIn;
    for(int i = 0; i < 140; i++){
      myStepper.step(-1);
      delay(3);
    }
    myStepper.step(2);
  }
  else if( readIn == 'b' ){
    digitalWrite(LIGHT1, HIGH);
    digitalWrite(LIGHT2, HIGH);
  }
  else if( readIn == 'd' ){
    digitalWrite(LIGHT1, LOW);
    digitalWrite(LIGHT2, LOW);
  }
  if(dir == 'l'){
      led.setPixelColor(0,DARKRED);
    } else if (dir == 'r'){
      led.setPixelColor(0,GREEN);
    } else {
      led.setPixelColor(0,GRAY);
    }
    led.setBrightness(100);
    led.show();
    delay(1);
}
