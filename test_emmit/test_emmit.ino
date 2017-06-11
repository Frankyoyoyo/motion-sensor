#include <SPI.h>
#include <Mirf.h>
#include <nRF24L01.h>
#include <MirfHardwareSpiDriver.h>
#include <Wire.h>
#include <FaBo9Axis_MPU9250.h>
FaBo9Axis fabo_9axis;
int k;
int i=0;
float value[7] = {0};
float A[3][20]={0};
float G[3][20]={0};
double pi=3.1415926;

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

void loop()
{
    value[0] = 0.0f;
    value[1] = 1.0f;
    value[2] = 2.0f;
    value[3] = 3.0f;
    value[4] = 4.0f;
    value[5] = 5.0f;
    value[6] = 6.0f;
    for (k=0;k<7; k++) {
      Mirf.send((byte *)&value[k]);
      while (Mirf.isSending()) ;
      delay(30);
    }
}
