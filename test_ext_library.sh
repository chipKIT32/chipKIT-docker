# Using arduino-cli through our container
docker compose run --rm arduino-cli lib install "DHT sensor library"

# Verify installation
docker compose run --rm arduino-cli lib list

# Test sketch using installed library
mkdir -p sketches/DHTTest
cat > sketches/DHTTest/DHTTest.ino << 'EOF'
#include <DHT.h>

#define DHTPIN 2
#define DHTTYPE DHT22

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  dht.begin();
}

void loop() {
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  
  Serial.print("Humidity: ");
  Serial.println(h);
  Serial.print("Temperature: ");
  Serial.println(t);
  delay(2000);
}
EOF

# Build test
./scripts/build-sketch.sh sketches/DHTTest/DHTTest.ino
