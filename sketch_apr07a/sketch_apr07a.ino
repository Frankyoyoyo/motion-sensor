int analogPin = 5;                              
int val = 0;           

void setup()
{
  Serial.begin(9600);
}

void loop()
{
  val = analogRead(analogPin);
  Serial.println("\\");
/*  Serial.print("\[");
  Serial.print("1");
  Serial.print("\,");
  Serial.print("2");
  Serial.print("\,");
  Serial.print("5");
  Serial.println("\]");*/
  Serial.println("2");
  Serial.println("3");
  Serial.println("2");
  Serial.println("8");
  Serial.println("5");
  Serial.println("4");
  Serial.println("5");
  Serial.println("3");
}
