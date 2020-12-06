
unsigned long previous_micros = 0;        // will store last time LED was updated
const long sample_t = 33333;           // interval at which to blink (microseconds)


void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
}

void loop() {
  // put your main code here, to run repeatedly:
  unsigned long current_micros = micros();
  if (current_micros - previous_micros >= sample_t) {
    Serial.print(current_micros - previous_micros);Serial.print(",");
    previous_micros = current_micros;
    
    int val1 = analogRead(1);
    int val2 = analogRead(2);
    int val3 = analogRead(3);
    
    Serial.print(val1); Serial.print(',');
    Serial.print(val2); Serial.print(',');
    Serial.println(val3); 
    
  }
  
  

}
