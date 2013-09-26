
#include <Stepper.h>

const int steps = 2000;  // change this to fit the number of steps per revolution
                                     // for your motor

Stepper myStepper(steps, 12,11, 13,3);

int powIn;                                
int total;
char dir;
void setup()
{
  Serial.begin(9600);

  myStepper.setSpeed(100);

  Serial.println("hi");
}

void loop()
{
  while(!Serial.available()){}
  char readIn = Serial.read();
  if(readIn == 'l'){
    dir = readIn;
    for(int i = 0; i < 150; i++){
      myStepper.step(1);
      delay(10);
    }
    myStepper.step(-1);
  }
  else if( readIn == 'r'){
    for(int i = 0; i < 150; i++){
      myStepper.step(-1);
      delay(10);
    }
    myStepper.step(-1);
  }
  else {
    myStepper.step(-1);
  }
//  delay(10);
}
