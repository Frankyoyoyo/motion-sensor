void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  long int i;
  for(i=0;i<500;i++){
    Serial.print(i);
    Serial.print("+");
    Serial.print(i*i);
    Serial.println("*i");
  }
}
