/*
  connection:
  VCC-3.3V
  GND-GND
  SDA-A4
  SCL-A5
 */


#include <Wire.h>
#include <FaBo9Axis_MPU9250.h>
int i=0;
FaBo9Axis fabo_9axis;
float A[3][20]={0};
float G[3][20]={0};
double pi=3.1415926;

void setup() {
  Serial.begin(9600);

  fabo_9axis.begin();
}

void loop() {
  int j;
  i=i+1;
  float ax,ay,az;
  float gx,gy,gz;

  if((i%20)!=0)
  {
    fabo_9axis.readAccelXYZ(&ax,&ay,&az);
    fabo_9axis.readGyroXYZ(&gx,&gy,&gz);
    A[0][(i%20)-1]=ax;
    A[1][(i%20)-1]=ay;
    A[2][(i%20)-1]=az;
    G[0][(i%20)-1]=gx;
    G[1][(i%20)-1]=gy;
    G[2][(i%20)-1]=gz;
  }else{
    fabo_9axis.readAccelXYZ(&ax,&ay,&az);
    fabo_9axis.readGyroXYZ(&gx,&gy,&gz);
    A[0][19]=ax;
    A[1][19]=ay;
    A[2][19]=az;
    G[0][19]=gx;
    G[1][19]=gy;
    G[2][19]=gz;
    ax=ay=az=gx=gy=gz=0.0f;

    for(j=0;j<20;j++){
      ax=ax+A[0][j];
      ay=ay+A[1][j];
      az=az+A[2][j];
      gx=gx+G[0][j];
      gy=gy+G[1][j];
      gz=gz+G[2][j];
    }
    ax=ax/20;
    ay=ay/20;
    az=az/20;
    gx=gx/3600*pi;
    gy=gy/3600*pi;
    gz=gz/3600*pi;
   
    Serial.println("100000");
    Serial.println(ax);
    Serial.println(ay);
    Serial.println(az);
    Serial.println(gx);
    Serial.println(gy);
    Serial.println(gz);
    delay(30);
  }

}





