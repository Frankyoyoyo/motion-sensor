/*
  connection:
  VCC-3.3V
  GND-GND
  SDA-A4
  SCL-A5
 */

#include <string.h>
#include <Wire.h>
#include <FaBo9Axis_MPU9250.h>
#define T=0.008f
#define N=500
#define pi=3.1415926

FaBo9Axis fabo_9axis;

void setup() {
  Serial.begin(9600);
  fabo_9axis.begin();
  int i=0;
  float q0,q1,q2,q3;
  float G0[3][N]
}

void loop() {
  float ax,ay,az;
  float gx,gy,gz;
  fabo_9axis.readAccelXYZ(&ax,&ay,&az);
  fabo_9axis.readGyroXYZ(&gx,&gy,&gz);
  float A[3]={ax,ay,az}

  gx=gx*pi/180;
  gy=gy*pi/180;
  gz=gz*pi/180;                    //弧度值角速度

  double C={{(q0^2+q1^2-q2^2-q3^2),2*(q1*q2-q0*q3),2*(q1*q3+q0*q2)},
            {2*(q1*q2+q0*q3),(q0^2-q1^2+q2^2-q3^2),2*(q2*q3-q0*q1)},
            {2*(q1*q3-q0*q2),2*(q2*q3+q0*q1),(q0^2-q1^2-q2^2+q3^2)}};
  double Acc=C*A'*g;
}





