
void setup() {
  Serial.begin(9600);
  // put your setup code here, to run once:
  pinMode(3, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  // LOW = activate
  
  while (Serial.available() > 0) {
    digitalWrite(3, LOW);
    char c = Serial.read();
    if (c == 'y') {
      digitalWrite(3, HIGH);
      delay(3000); //stay unlocked for how long?
    }
    
    //digitalWrite(3, LOW);
  }
}
