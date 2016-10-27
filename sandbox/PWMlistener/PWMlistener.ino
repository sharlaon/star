#include <Ethernet.h>
#include <EthernetUdp.h>
#include <PWM.h>

#define DATA_PIN 9

byte mac[6];                   // random() below ensures no clash
IPAddress ip(10, 0, 1, 110);   // local IP address; last byte should be 110 or 111
unsigned int localPort = 6038; // local port to listen on
EthernetUDP Udp;

unsigned char state;
long lastTime;

void setup() {
  InitTimersSafe();
  randomSeed(millis());
  int i;
  for (i = 0; i < 6; ++i) {
    mac[i] = (byte) random(256);
  }
  Ethernet.begin(mac, ip);
  Udp.begin(localPort);
  lastTime = millis();
}

void loop() {
  int packetSize = Udp.parsePacket();
  if (packetSize)
  {
    unsigned char incoming[2];
    Udp.read((char*)&incoming, sizeof(incoming));
    uint16_t reassembled = ((unsigned int) incoming[0] << 8) | ((unsigned int) incoming[1]);
    pwmWriteHR(DATA_PIN, reassembled);
  }
  while (millis() - lastTime < 10) {};
  lastTime = millis();
  pwmWriteHR(DATA_PIN, state++ << 8);
}

