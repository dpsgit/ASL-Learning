/* --------------------------------------------------------------------------
 * SimpleOpenNI User3d Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect 2 library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / Zhdk / http://iad.zhdk.ch/
 * date:  12/12/2012 (m/d/y)
 * ----------------------------------------------------------------------------
 */
 
import SimpleOpenNI.*;
import java.awt.Frame;

SimpleOpenNI context;

// ----------- Image Capture Stuff ------------------------

PrintWriter timingOutput;
PrintWriter skeletonOutput;

boolean isWriting = false;
int startTime = 0;
int timingOffset = 0;

String primaryPath = "/Users/dsakaguchi/CS229/ASL Data/Data1";

//----------- Skeleton View Stuff -------------------------
float zoomF = 0.5f;
float rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
                                   // the data from openni comes upside down
float rotY = radians(0);
boolean autoCalib = true;
                                 
color[] userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };  

String skeletonDataName = "/skeletonData.txt";
String depthDataName = "/DepthImages/depthImage";
String rgbDataName = "/RGBImages/rbgImage";
String timeLogName = "/timeLog.txt";

int counter = 0;

void setup() {
  size(640,480,P3D);  // strange, get drawing error in the cameraFrustum if i use P3D, in opengl there is no problem
  context = new SimpleOpenNI(this);
  if(context.isInit() == false) {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }

  context.setMirror(false); // disable mirror
  context.enableDepth(); // enable depthMap generation 
  context.enableUser(); // enable skeleton generation for all joints
  context.enableRGB(); // enables rgb
  
  // Setup jankiness for logging
  frame.setTitle("Skeleton Window");
  
  timingOffset = millis(); 
  
  stroke(255,255,255);
  smooth();  
  perspective(radians(45),
  float(width)/float(height),
  10,150000);
}
  
public void draw() {
  
  // update the cam
  context.update();
 
  int millisSinceStart = millis(); 
 
  if (isWriting) {
    timingOutput.println(str(millisSinceStart - startTime));
    context.rgbImage().save(primaryPath + rgbDataName + counter + ".tiff");
    context.depthImage().save(primaryPath + depthDataName + counter + ".tiff");
      
    counter++;
  }
  
  background(0,0,0);
  
  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);
  
  translate(0,0,-1000);  // set the rotation center of the scene 1000 infront of the camera
  
  // log skeleton data
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i])) {
      drawSkeleton(userList[i]);
      drawAllJoints(userList[i]);
      
      if (isWriting)
        saveSkeleton(userList[i]);
    }
  } 
  
  int[]   depthMap = context.depthMap();
  int[]   userMap = context.userMap();
  int     steps   = 3;  // to speed up the drawing, draw every third point
  int     index;
  PVector realWorldPoint;
   
  // draw the pointcloud
  beginShape(POINTS);
  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      if(depthMap[index] > 0)
      { 
        // draw the projected point
        realWorldPoint = context.depthMapRealWorld()[index];
        if(userMap[index] == 0)
          stroke(100); 
        else
          stroke(userClr[ (userMap[index] - 1) % userClr.length ]);        
        
        point(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);
      }
    } 
  } 
  endShape();   
   
  // draw the kinect cam
  context.drawCamFrustum();
} 
  
  void saveSkeleton(int userId) {
    skeletonOutput.println(millis() + " " + userId);
    for (int i = 0; i < 15; i++) 
      logJoint(userId, i); 
  }
  
  // draw the skeleton with the selected joints
  void drawSkeleton(int userId) {
    // to get the 3d joint data
    drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  
    drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  
    drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  
    drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  
    drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
    drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
    drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  
    drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
   
  }
  
  void drawAllJoints(int userId) {
    for (int i = 0; i < 15; i++)
      drawJoint(userId, i); 
  }
  
  void drawJoint(int userId, int jointType) {
    PVector jointPos = new PVector();
    float confidence = context.getJointPositionSkeleton(userId,jointType,jointPos);
    
    println("ID: " + userId + "X: " + jointPos.x + "Y: " + jointPos.y + "Z: " + jointPos.z + "\n");
    println("Confidence: " + confidence + "\n");
    pushMatrix();
      translate(jointPos.x, jointPos.y, jointPos.z);
      stroke(255,255,0);
      sphere(30 * confidence);
    popMatrix();
  }
  
  void drawLimb(int userId,int jointType1,int jointType2) {
    PVector jointPos1 = new PVector();
    PVector jointPos2 = new PVector();
    float  confidence;
    
    // draw the joint position
    confidence = context.getJointPositionSkeleton(userId,jointType1,jointPos1);
    confidence = context.getJointPositionSkeleton(userId,jointType2,jointPos2);
  
    stroke(255,0,0,100);
    strokeWeight(4);
    line(jointPos1.x,jointPos1.y,jointPos1.z,
         jointPos2.x,jointPos2.y,jointPos2.z);
  }
  
  void logJoint(int userId,int jointType)
  {
    PVector jointPos = new PVector();
  
    float posConfidence = context.getJointPositionSkeleton(userId,jointType,jointPos);
    println("Confidence: " + posConfidence);
    skeletonOutput.println(jointType + " " + jointPos.x + " " + jointPos.y + " " + jointPos.z + " " + posConfidence);
  }

// -----------------------------------------------------------------
// SimpleOpenNI user events

void onNewUser(SimpleOpenNI curContext,int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  context.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext,int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext,int userId)
{
  //println("onVisibleUser - userId: " + userId);
}

void mouseMoved() {
  //rotY = (2 * 3.14) * (mouseX - 512) / 512.0;
  //rotX = (2 * 3.14) * (mouseY - 384) / 384.0;
}
// -----------------------------------------------------------------
// Keyboard events

void keyPressed()
{
  switch(keyCode)
  {
    case 65: // a
      startTime = millis();
      println(str(millis()));
      
      timingOutput = createWriter(primaryPath + timeLogName);
      skeletonOutput = createWriter(primaryPath + skeletonDataName);
      isWriting = true;
      break;
    case 83: // s
      timingOutput.flush();
      timingOutput.close();
 
      skeletonOutput.flush();
      skeletonOutput.close();
      exit();
      break;
  }
}
