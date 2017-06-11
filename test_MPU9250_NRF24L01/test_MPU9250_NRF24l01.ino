#include <SPI.h>
#include <Mirf.h>
#include <nRF24L01.h>
#include <MirfHardwareSpiDriver.h>
#include <Wire.h>
#include <FaBo9Axis_MPU9250.h>
FaBo9Axis fabo_9axis;
int k;
float value[7] = {0};
double pi = 3.1415926;

void setup()
{
  fabo_9axis.begin();
  Mirf.spi = &MirfHardwareSpi;
  Mirf.init();
  Mirf.setTADDR((byte *)"serv1"); //设置自己的地址（发送端地址），使用5个字符
  Mirf.payload = sizeof(float);
  Mirf.channel = 90;
  Mirf.config();//设置所用信道
  Serial.begin(9600);
}
float a;
float b;
float a0, a1, a2, g0, g1, g2;
void loop()
{
//  a = millis();
  int j;
  float ax, ay, az;
  float gx, gy, gz;
  a0 = a1 = a2 = g0 = g1 = g2 = 0;
  for (j = 0; j < 10; j++)
  {
    fabo_9axis.readAccelXYZ(&ax, &ay, &az);
    fabo_9axis.readGyroXYZ(&gx, &gy, &gz);

    a0 = a0 + ax;
    a1 = a1 + ay;
    a2 = a2 + az;
    g0 = g0 + gx;
    g1 = g1 + gy;
    g2 = g2 + gz;
  }

  ax = a0 / 10;
  ay = a1 / 10;
  az = a2 / 10;
  gx = g0 / 1800 * pi;
  gy = g1 / 1800 * pi;
  gz = g2 / 1800 * pi;

  value[0] = 100;
  value[1] = ax;
  value[2] = ay;
  value[3] = az;
  value[4] = gx;
  value[5] = gy;
  value[6] = gz;

  //  b = millis(); //    20ms

  for (k = 0; k < 7; k++) {
    Mirf.send((byte *)&value[k]);
    while (Mirf.isSending()) {};
    delay(20);
  }                                     //9ms without delay
  
//  b = millis();
//  b = b - a;
//  Serial.println(b);
}
