#include <SPI.h>
#include <Mirf.h>
#include <nRF24L01.h>
#include <MirfHardwareSpiDriver.h>
#include <Wire.h>
#include <FaBo9Axis_MPU9250.h>
FaBo9Axis fabo_9axis;
int i = 0;
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

void loop()
{
  int j;
  float ax, ay, az;
  float gx, gy, gz;
  value[0] = 100;
  Mirf.send((byte *)&value[0]);
  while (Mirf.isSending()) {};
  delay(8);

  a = millis();

  for (j = 0; j < 8; j++) {
    fabo_9axis.readAccelXYZ(&ax, &ay , &az);
    value[1] = value[1] + ax;
  }
  value[1] = value[1] / 8;
  Mirf.send((byte *)&value[1]);
  while (Mirf.isSending()) {};

  b = millis();

  for (j = 0; j < 8; j++) {
    fabo_9axis.readAccelXYZ(&ax, &ay , &az);
    value[2] = value[2] + ay;
  }
  value[2] = value[2] / 8;
  Mirf.send((byte *)&value[2]);
  while (Mirf.isSending()) {};

  for (j = 0; j < 8; j++) {
    fabo_9axis.readAccelXYZ(&ax, &ay , &az);
    value[3] = value[3] + az;
  }
  value[3] = value[3] / 8;
  Mirf.send((byte *)&value[3]);
  while (Mirf.isSending()) {};

  for (j = 0; j < 8; j++) {
    fabo_9axis.readGyroXYZ(&gx, &gy , &gz);
    value[4] = value[4] + gx;
  }
  value[4] = value[4] / 1440 * pi;
  Mirf.send((byte *)&value[4]);
  while (Mirf.isSending()) {};

  for (j = 0; j < 8; j++) {
    fabo_9axis.readGyroXYZ(&gx, &gy , &gz);
    value[5] = value[5] + gy;
  }
  value[5] = value[5] / 1440 * pi;
  Mirf.send((byte *)&value[5]);
  while (Mirf.isSending()) {};

  for (j = 0; j < 8; j++) {
    fabo_9axis.readGyroXYZ(&gx, &gy , &gz);
    value[6] = value[6] + gz;
  }
  value[6] = value[6] / 1440 * pi;
  Mirf.send((byte *)&value[6]);
  while (Mirf.isSending()) {};

  Serial.println(b - a);
}
