#include <SPI.h>
#include <Mirf.h>
#include <nRF24L01.h>
#include <MirfHardwareSpiDriver.h>
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Mirf.spi = &MirfHardwareSpi;
  Mirf.init();
  Mirf.setRADDR((byte*)"serv1");             //设置自己地址
  Mirf.payload = sizeof(float);
  Mirf.channel = 90;
  Mirf.config();                            //设置使用的通道
}

void loop() {
  int i = 0;
  byte data[7][Mirf.payload];
  for (i = 0; i < 7; i++) {
    if (!Mirf.isSending() && Mirf.dataReady())         //当接收到数据，从串口输出该数据
    {
      Mirf.getData(data[i]);
      Mirf.rxFifoEmpty();   //清理24L01缓存
    Serial.println(*(float *)data[i]);
    }
    delay(30);
  }
}
