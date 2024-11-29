# Install required libraries
docker compose run --rm arduino-cli lib install "Adafruit SSD1306"

# Create test sketch using multiple libraries
mkdir -p sketches/MultiLibTest
cat > sketches/MultiLibTest/MultiLibTest.ino << 'EOF'
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire);

void setup() {
  Wire.begin();
  display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.println("Hello, World!");
  display.display();
}

void loop() {
  delay(100);
}
EOF

# Build test
./scripts/build-sketch.sh sketches/MultiLibTest/MultiLibTest.ino