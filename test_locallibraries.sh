# Create a test library
mkdir -p arduino_data/libraries/MyTestLib/src
cat > arduino_data/libraries/MyTestLib/src/MyTestLib.h << 'EOF'
#ifndef MyTestLib_h
#define MyTestLib_h

#include "Arduino.h"

class MyTestLib {
  public:
    MyTestLib();
    void begin();
    int getValue();
};

#endif
EOF

cat > arduino_data/libraries/MyTestLib/src/MyTestLib.cpp << 'EOF'
#include "MyTestLib.h"

MyTestLib::MyTestLib() {
}

void MyTestLib::begin() {
}

int MyTestLib::getValue() {
  return 42;
}
EOF

# Create test sketch using local library
mkdir -p sketches/LocalLibTest
cat > sketches/LocalLibTest/LocalLibTest.ino << 'EOF'
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
EOF

# Build test
./scripts/build-sketch.sh sketches/LocalLibTest/LocalLibTest.ino
