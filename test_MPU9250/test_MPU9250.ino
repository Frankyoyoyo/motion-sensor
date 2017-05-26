/*
  connection:
  VCC-3.3V
  GND-GND
  SDA-A4
  SCL-A5
 */


#include <Wire.h>
#include <FaBo9Axis_MPU9250.h>

FaBo9Axis fabo_9axis;

void setup() {
  Serial.begin(9600);

  fabo_9axis.begin();

}

void loop() {
  float ax,ay,az;
  float gx,gy,gz;
  float mx,my,mz;
  float temp;

  fabo_9axis.readAccelXYZ(&ax,&ay,&az);
  fabo_9axis.readGyroXYZ(&gx,&gy,&gz);
  fabo_9axis.readMagnetXYZ(&mx,&my,&mz);
  fabo_9axis.readTemperature(&temp);

  double pi=3.1415926;
  gx=gx*pi/180;
  gy=gy*pi/180;
  gz=gz*pi/180;

  Serial.println("0");
  Serial.println(ax);
  Serial.println(ay);
  Serial.println(az);
  Serial.println(gx);
  Serial.println(gy);
  Serial.println(gz);
  Serial.println(mx);
  Serial.println(my);
  Serial.println(mz);

// delay(10);
}





