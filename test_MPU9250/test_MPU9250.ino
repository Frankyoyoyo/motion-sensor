/**
 @file read9axis.ino
 @brief This is an Example for the FaBo 9Axis I2C Brick.

   http://fabo.io/202.html

   Released under APACHE LICENSE, VERSION 2.0

   http://www.apache.org/licenses/

 @author FaBo<info@fabo.io>
*/

#include <Wire.h>
#include <FaBo9Axis_MPU9250.h>

FaBo9Axis fabo_9axis;


//设计滤波算法！！！！！！！！！！！！！！！！！！！！！！！！！！！！


void setup() {
  Serial.begin(9600);
/*  Serial.println("RESET");
  Serial.println();

  Serial.println("configuring device.");

  if (fabo_9axis.begin()) {
    Serial.println("configured FaBo 9Axis I2C Brick");
  } else {
    Serial.println("device error");
    while(1);
  }*/
}

void loop() {
  //Serial.println("loop");
  
  float ax,ay,az;
  float gx,gy,gz;
  float mx,my,mz;
  float temp;

  fabo_9axis.readAccelXYZ(&ax,&ay,&az);
  fabo_9axis.readGyroXYZ(&gx,&gy,&gz);
  fabo_9axis.readMagnetXYZ(&mx,&my,&mz);
//  fabo_9axis.readTemperature(&temp);


  double normM = sqrt(mx*mx + my*my + mz*mz);
  Serial.println("0");
//  Serial.print("[ ");
  Serial.println(ax);
//  Serial.print("; ");
  Serial.println(ay);
//  Serial.print("; ");
  Serial.println(az);
//  Serial.print(" ]   ");

//  Serial.print("[ ");
  Serial.println(gx);
//  Serial.print("; ");
  Serial.println(gy);
//  Serial.print("; ");
  Serial.println(gz);
//  Serial.print(" ]   ");

//  Serial.print("[ ");
  Serial.println(mx/normM);
//  Serial.print("; ");
  Serial.println(my/normM);
//  Serial.print("; ");
  Serial.println(mz/normM);
//  Serial.print(" ]    ");
//  Serial.println(normM);

 /* Serial.print("temp: ");
  Serial.println(temp);

  delay(1000);*/
}
