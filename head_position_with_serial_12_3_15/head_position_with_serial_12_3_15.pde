/*
Thomas Sanchez Lengeling.
 http://codigogenerativo.com/
 
 KinectPV2, Kinect for Windows v2 library for processing
 
 3D Skeleton.
 Some features a not implemented, such as orientation
 */

import processing.serial.*;
Serial myPort;

import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

long timer;
long wait = 200; // wait between sending data points to Arduino

float sendXmin = -0.4;
float sendXmax = 0.4;
float sendYmin = -0.4;
float sendYmax = 0.4;
float sendZmin = 0.0;
float sendZmax = 1.3;

float kminX = -1.0;
float kmaxX = 1.0;
float kminY = -0.6;
float kmaxY = 0.4;
float kminZ = 1.4;
float kmaxZ = 3.3;

float sendX, sendY, sendZ;

boolean sendValues = false;

float zVal = 300;
float rotX = PI;

float xpos, ypos, zpos;

void setup() {
  size(1024, 768, P3D);

  String portName = "COM4"; // may need to be changed
  myPort = new Serial(this, portName, 9600);

  PFont mono;
  mono = loadFont("LucidaConsole-48.vlw");
  textFont(mono);

  kinect = new KinectPV2(this);

  kinect.enableColorImg(true);

  //enable 3d  with (x,y,z) position
  kinect.enableSkeleton3DMap(true);

  kinect.init();

  timer = millis();
}

void draw() {
  background(0);

  image(kinect.getColorImage(), 0, 0, 320, 240);

  //translate the scene to the center 
  pushMatrix();
  translate(width/2, height/2, 0);
  scale(zVal);
  rotateX(rotX);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      //draw different color for each hand state
      //drawHandState(joints[KinectPV2.JointType_HandRight]);
      //drawHandState(joints[KinectPV2.JointType_HandLeft]);

      //Draw body
      color col  = skeleton.getIndexColor();
      stroke(col);
      drawBody(joints);
    }
  }
  popMatrix();


  fill(255, 0, 0);
  //text(frameRate, 50, 50);
  textSize(90);
  text("x " + xpos, 500, 100);
  text("y " + ypos, 500, 200);
  text("z " + zpos, 500, 300);

  if (sendValues) text("sent " + sendX + "\n" + sendY + "\n" + sendZ, 0, 500);
}


void drawBody(KJoint[] joints) {

  //point(joints[jointType_Head].getX(), joints[jointType_Head].getY(), joints[jointType_Head].getZ());


  //drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  //drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  //drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);

  //drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  //drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  //drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  //drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  //drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  //// Right Arm    
  //drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  //drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  //drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  //drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  //drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  //// Left Arm
  //drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  //drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  //drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  //drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  //drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  //// Right Leg
  //drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  //drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  //drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  //// Left Leg
  //drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  //drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  //drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  //drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  //drawJoint(joints, KinectPV2.JointType_HandTipRight);
  //drawJoint(joints, KinectPV2.JointType_FootLeft);
  //drawJoint(joints, KinectPV2.JointType_FootRight);

  //drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  //drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
  //println(KinectPV2.JointType_Head);
  //String xpos = "x = " + joints[3].getX();
  fill(255);
  //text("x = " + joints[3].getX(), 500, 10);

  xpos = joints[3].getX(); // joints[3] is the head
  ypos = joints[3].getY();
  zpos = joints[3].getZ();

  if (sendValues) {
    if (millis() - timer > wait) {
      sendXYZ(xpos, ypos, zpos);
      timer = millis();
    }
  }
}

void drawJoint(KJoint[] joints, int jointType) {
  strokeWeight(2.0f + joints[jointType].getZ()*8);
  point(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
}

void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  strokeWeight(2.0f + joints[jointType1].getZ()*8);
  point(joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

void drawHandState(KJoint joint) {
  handState(joint.getState());
  strokeWeight(5.0f + joint.getZ()*8);
  point(joint.getX(), joint.getY(), joint.getZ());
}

void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    stroke(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    stroke(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    stroke(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    stroke(100, 100, 100);
    break;
  }
}

void keyPressed() {

  // switch boolean flag to start or stop sending values
  if (key == 'g') sendValues = true;
  if (key == 's') sendValues = false;
}


// function to serial transmit motor to Arduino
// note that Kinect z --> Arduino y and Kinect y --> Arduino z
// owing to a rotation in how the coordinate systems are built
void sendXYZ(float x, float y, float z) {
  sendX = constrain(floatmap(x, kminX, kmaxX, sendXmin, sendXmax), sendXmin, sendXmax);
  // negative sign because this axis is 180deg rotated from Kinect to Arduino
  sendY = -constrain(floatmap(z, kminZ, kmaxZ, sendYmin, sendYmax), sendYmin, sendYmax);
  // note sendZmax and sendZmin order; this is because the Arduino coordinate system is built
  // with z = 0 at maximum height and z increasing towards the floor
  sendZ = constrain(floatmap(y, kminY, kmaxY, sendZmax, sendZmin), sendZmin, sendZmax);

  myPort.write("h" + sendX + " " + sendY + " " + sendZ + "\n");
  println("transmitted X, Y, Z: " + sendX + "\t" + sendY + "\t" + sendZ);
}

float floatmap(float x, float in_min, float in_max, float out_min, float out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}