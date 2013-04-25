
#include <Stepper.h>

const int steps = 4000;  // change this to fit the number of steps per revolution
                                     // for your motor

Stepper myStepper(steps, 12,11, 13,3);

int powIn;                                
int total;
void setup()
{
  Serial.begin(9600);

  myStepper.setSpeed(100);

  Serial.println("hi");
}

void loop()
{
  while(!Serial.available()){}
  char dir = Serial.read();
  if(dir == 'l'){
    for(int i = 0; i < 150; i++){
      myStepper.step(1);
      delay(10);
    }
  }
  else if( dir == 'r'){
    for(int i = 0; i < 150; i++){
      myStepper.step(-1);
      delay(10);
    }
  }
//  delay(10);
}
