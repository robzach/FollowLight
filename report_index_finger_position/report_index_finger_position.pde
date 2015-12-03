import processing.serial.*;
Serial myPort;

import de.voidplus.leapmotion.*;

LeapMotion leap;

long timer;

float sendXmin = -0.4;
float sendXmax = 0.4;
float sendYmin = -0.4;
float sendYmax = 0.4;
float sendZmin = 0.0;
float sendZmax = 1.3;

float[] indexXYZ;

void setup() {
  size(800, 500, OPENGL);
  background(255);

  String portName = Serial.list()[5]; // bluetooth module on my laptop is 2
  myPort = new Serial(this, portName, 9600);
  delay(2000);

  // ...

  leap = new LeapMotion(this);

  timer = millis();
}

void draw() {
  background(255);
  // ...
  int fps = leap.getFrameRate();


  // ========= HANDS =========

  for (Hand hand : leap.getHands ()) {


    // ----- BASICS -----

    int     hand_id          = hand.getId();
    PVector hand_position    = hand.getPosition();
    PVector hand_stabilized  = hand.getStabilizedPosition();
    PVector hand_direction   = hand.getDirection();
    PVector hand_dynamics    = hand.getDynamics();
    float   hand_roll        = hand.getRoll();
    float   hand_pitch       = hand.getPitch();
    float   hand_yaw         = hand.getYaw();
    boolean hand_is_left     = hand.isLeft();
    boolean hand_is_right    = hand.isRight();
    float   hand_grab        = hand.getGrabStrength();
    float   hand_pinch       = hand.getPinchStrength();
    float   hand_time        = hand.getTimeVisible();
    PVector sphere_position  = hand.getSpherePosition();
    float   sphere_radius    = hand.getSphereRadius();


    // ----- SPECIFIC FINGER -----

    Finger  finger_thumb     = hand.getThumb();
    // or                      hand.getFinger("thumb");
    // or                      hand.getFinger(0);

    Finger  finger_index     = hand.getIndexFinger();
    // or                      hand.getFinger("index");
    // or                      hand.getFinger(1);

    Finger  finger_middle    = hand.getMiddleFinger();
    // or                      hand.getFinger("middle");
    // or                      hand.getFinger(2);

    Finger  finger_ring      = hand.getRingFinger();
    // or                      hand.getFinger("ring");
    // or                      hand.getFinger(3);

    Finger  finger_pink      = hand.getPinkyFinger();
    // or                      hand.getFinger("pinky");
    // or                      hand.getFinger(4);        


    // ----- DRAWING -----

    hand.draw();
    // hand.drawSphere();


    // ========= ARM =========

    if (hand.hasArm()) {
      Arm     arm               = hand.getArm();
      float   arm_width         = arm.getWidth();
      PVector arm_wrist_pos     = arm.getWristPosition();
      PVector arm_elbow_pos     = arm.getElbowPosition();
    }


    // ========= FINGERS =========

    for (Finger finger : hand.getFingers()) {
      // Alternatives:
      // hand.getOutstrechtedFingers();
      // hand.getOutstrechtedFingersByAngle();

      // ----- BASICS -----

      int     finger_id         = finger.getId();
      PVector finger_position   = finger.getPosition();
      PVector finger_stabilized = finger.getStabilizedPosition();
      PVector finger_velocity   = finger.getVelocity();
      PVector finger_direction  = finger.getDirection();
      float   finger_time       = finger.getTimeVisible();


      // ----- SPECIFIC FINGER -----

      switch(finger.getType()) {
      case 0:
        // System.out.println("thumb");
        break;
      case 1:
        // System.out.println("index");
        indexXYZ = finger_position.array();
        // automatically send updates 4 times/second
        if (millis() - timer > 250) {
          timer = millis();
          sendXYZ(indexXYZ[0], indexXYZ[2], indexXYZ[1]);
        }
        //println(indexXYZ);
        // x range: 140 (left) to 770 (right), represented by [0]
        // y range: 20 (close to me) to 85 (poking towards computer monitor) represented by [2]
        // z range: 70 (higher up) to 430 (closer to sensor), represented by [1]
        break;
      case 2:
        // System.out.println("middle");
        break;
      case 3:
        // System.out.println("ring");
        break;
      case 4:
        // System.out.println("pinky");
        break;
      }


      // ----- SPECIFIC BONE -----

      Bone    bone_distal       = finger.getDistalBone();
      // or                       finger.get("distal");
      // or                       finger.getBone(0);

      Bone    bone_intermediate = finger.getIntermediateBone();
      // or                       finger.get("intermediate");
      // or                       finger.getBone(1);

      Bone    bone_proximal     = finger.getProximalBone();
      // or                       finger.get("proximal");
      // or                       finger.getBone(2);

      Bone    bone_metacarpal   = finger.getMetacarpalBone();
      // or                       finger.get("metacarpal");
      // or                       finger.getBone(3);


      // ----- DRAWING -----

      // finger.draw(); // = drawLines()+drawJoints()
      // finger.drawLines();
      // finger.drawJoints();


      // ----- TOUCH EMULATION -----

      int     touch_zone        = finger.getTouchZone();
      float   touch_distance    = finger.getTouchDistance();

      switch(touch_zone) {
      case -1: // None
        break;
      case 0: // Hovering
        // println("Hovering (#"+finger_id+"): "+touch_distance);
        break;
      case 1: // Touching
        // println("Touching (#"+finger_id+")");
        break;
      }
    }


    // ========= TOOLS =========

    for (Tool tool : hand.getTools ()) {


      // ----- BASICS -----

      int     tool_id           = tool.getId();
      PVector tool_position     = tool.getPosition();
      PVector tool_stabilized   = tool.getStabilizedPosition();
      PVector tool_velocity     = tool.getVelocity();
      PVector tool_direction    = tool.getDirection();
      float   tool_time         = tool.getTimeVisible();


      // ----- DRAWING -----

      // tool.draw();


      // ----- TOUCH EMULATION -----

      int     touch_zone        = tool.getTouchZone();
      float   touch_distance    = tool.getTouchDistance();

      switch(touch_zone) {
      case -1: // None
        break;
      case 0: // Hovering
        // println("Hovering (#"+tool_id+"): "+touch_distance);
        break;
      case 1: // Touching
        // println("Touching (#"+tool_id+")");
        break;
      }
    }
  }


  // ========= DEVICES =========

  for (Device device : leap.getDevices ()) {
    float device_horizontal_view_angle = device.getHorizontalViewAngle();
    float device_verical_view_angle = device.getVerticalViewAngle();
    float device_range = device.getRange();
  }
}

// ========= CALLBACKS =========

void leapOnInit() {
  // println("Leap Motion Init");
}
void leapOnConnect() {
  // println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
  // println("Leap Motion Disconnect");
}
void leapOnExit() {
  // println("Leap Motion Exit");
}

///////////////////////////

// x range: 140 (left) to 770 (right), represented by [0]
// y range: 20 (close to me) to 85 (poking towards computer monitor) represented by [2]
// z range: 70 (higher up) to 430 (closer to sensor), represented by [1]

void keyPressed() {
  //if (key == ' ') {
  //  sendXYZ();
  //}

  if (key == '0') {
    myPort.write("h 0 0 0  \n");
    println("transmitted 0 0 0 ");
  }
}

void sendXYZ(float x, float y, float z) {
  float sendX = constrain(map(x, 140, 770, sendXmin, sendXmax), sendXmin, sendXmax);
  float sendY = constrain(map(y, 20, 85, sendYmin, sendYmax), sendYmin, sendYmax);
  float sendZ = constrain(map(z, 70, 430, sendZmin, sendZmax), sendZmin, sendZmax);

  myPort.write("h" + sendX + " " + sendY + " " + sendZ + "\n");
  println("transmitted X, Y, Z: " + sendX + "\t" + sendY + "\t" + sendZ);
}