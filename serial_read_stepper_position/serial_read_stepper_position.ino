#include <AccelStepper.h>

AccelStepper one(1, 7, 6);
AccelStepper two(1, 5, 4);
AccelStepper three(1, 3, 2);

int pos = 0;

void setup() {
  one.setMaxSpeed(200);
  one.setAcceleration(50);
  
  two.setMaxSpeed(200);
  two.setAcceleration(50);
  
  three.setMaxSpeed(200);
  three.setAcceleration(50);
  

  Serial.begin(9600);
}

void loop() {


if (Serial.available()){
  pos = Serial.parseInt();
  one.moveTo(pos);
  Serial.read();
}

  one.run();
  two.run();
  three.run();
}

