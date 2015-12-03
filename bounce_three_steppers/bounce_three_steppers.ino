#include <AccelStepper.h>

AccelStepper one(1, 7, 6);
AccelStepper two(1, 5, 4);
AccelStepper three(1, 3, 2);

void setup() {
  one.setMaxSpeed(200);
  one.setAcceleration(50);
  one.moveTo(2000);
  two.setMaxSpeed(200);
  two.setAcceleration(50);
  two.moveTo(2000);
  three.setMaxSpeed(200);
  three.setAcceleration(50);
  three.moveTo(2000);
}

void loop() {
  // If at the end of travel go to the other end
  if (one.distanceToGo() == 0)
    one.moveTo(-one.currentPosition());
  if (two.distanceToGo() == 0)
    two.moveTo(-two.currentPosition());
  if (three.distanceToGo() == 0)
    three.moveTo(-three.currentPosition());

  one.run();
  two.run();
  three.run();
}

