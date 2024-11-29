#include <MyTestLib.h>

MyTestLib myLib;

void setup() {
  Serial.begin(9600);
  myLib.begin();
}

void loop() {
  Serial.println(myLib.getValue());
  delay(1000);
}
