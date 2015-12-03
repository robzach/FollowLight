#include <AccelStepper.h>

AccelStepper one(1, 7, 6);
AccelStepper two(1, 5, 4);
AccelStepper three(1, 3, 2);

// initialize delta motor coordinates at center top
float tri[3] = {1, 1, 1};

float t = 0;
float r = 1;

int microMultiplier = 8; // # microsteps/step. 1 if not microstepping.

long amotor = 800 * microMultiplier;
long bmotor = 800 * microMultiplier;
long cmotor = 800 * microMultiplier;

long timer;

float x, y, z;

void setup() {
  Serial.begin(9600);

  one.setMaxSpeed(200 * microMultiplier);
  one.setAcceleration(10000);
  two.setMaxSpeed(200 * microMultiplier);
  two.setAcceleration(10000);
  three.setMaxSpeed(200 * microMultiplier);
  three.setAcceleration(10000);

  one.setCurrentPosition(amotor);
  two.setCurrentPosition(amotor);
  three.setCurrentPosition(amotor);
}

void loop() {

  // to run motors according to serial input

  if (Serial.available() > 0) {

    if (Serial.peek() == 'h') {

      x = Serial.parseFloat();
      y = Serial.parseFloat();
      z = Serial.parseFloat();

      //    descartesToTriangle(x, y);
      threespaceToTriangle(x, y, z);
      amotor = triangleToSteps(tri[0]);
      bmotor = triangleToSteps(tri[1]);
      cmotor = triangleToSteps(tri[2]);
      
      one.moveTo(amotor);
      two.moveTo(bmotor);
      three.moveTo(cmotor);

      // r = t*d <-- MATH IS WRONG! r = d/t, not d*t, dummy
      // set time = 0.5 seconds
      one.setMaxSpeed(one.distanceToGo() / 0.5);
      two.setMaxSpeed(two.distanceToGo() / 0.5);
      three.setMaxSpeed(three.distanceToGo() / 0.5);
    }

    Serial.read(); // in case anything not starting with 'h' came through, clear it out

  }
  /*
        Serial.print("read x, y, z\t");
        Serial.print(x);
        Serial.print('\t');
        Serial.print(y);
        Serial.print('\t');
        Serial.println(z);
        Serial.print("triangle a, b, c = ");
        Serial.print(tri[0]);
        Serial.print('\t');
        Serial.print(tri[1]);
        Serial.print('\t');
        Serial.println(tri[2]);
        Serial.print("amotor, bmotor, cmotor: \t\t");
        Serial.print(amotor);
        Serial.print('\t');
        Serial.print(bmotor);
        Serial.print('\t');
        Serial.println(cmotor);
  */


  /*
    // to make circles?
    if (millis() - timer > 150) {
      timer = millis();
      x = 0.3 * cos(t);
      y = 0.3 * sin(t);
      t += 0.05;
    }

    descartesToTriangle(x, y);
    amotor = triangleToSteps(tri[0]);
    bmotor = triangleToSteps(tri[1]);
    cmotor = triangleToSteps(tri[2]);

    one.moveTo(amotor);
    two.moveTo(bmotor);
    three.moveTo(cmotor);
  */

  one.run();
  two.run();
  three.run();
}

// have to just modify the global tri[] array, a function cannot return an array in C
void descartesToTriangle(float x, float y) {
  tri[0] = sqrt( sq(x) + sq(y - 1) );
  tri[1] = sqrt( sq( (-(sqrt(3)) / 2) - x) + sq(-0.5 - y) );
  tri[2] = sqrt( sq( (sqrt(3) / 2) - x) + sq(-0.5 - y) );
}

void threespaceToTriangle(float x, float y, float z) {
  tri[0] = sqrt( sq(x) + sq(y - 1) + sq(z) );
  tri[1] = sqrt( sq( (-(sqrt(3)) / 2) - x) + sq(-0.5 - y) + sq(z) );
  tri[2] = sqrt( sq( (sqrt(3) / 2) - x) + sq(-0.5 - y) + sq(z) );
}


// MOTOR STEP FUNCTION BELOW NEEDS WORK
// modeled on the map() math from Arduino reference page for that function
// return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;

long triangleToSteps(float x) {
  return x * 800 * microMultiplier;
  //  return (x - 0) * (800 - 0) / (sqrt(3) - 0) + 0;
}

