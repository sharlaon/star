#include <Ethernet.h>
#include <EthernetUdp.h>
#include <PWM.h>

#define DATA_PIN 9

//byte mac[] = { 0x49, 0xDA, 0xF3, 0x6A, 0x65, 0xA1 };
byte mac[] = { 0x2E, 0x0D, 0xD4, 0xB5, 0xFD, 0x66 };
//IPAddress ip(10, 0, 1, 110);                          // local IP address
IPAddress ip(10, 0, 1, 111);                          // local IP address
IPAddress Dns(8, 8, 8, 8);
IPAddress gateway(10, 0, 1, 1);
IPAddress netmask(255, 0, 0, 0);
unsigned int localPort = 6038;                        // local port to listen on
EthernetUDP Udp;

void setup() {
  Serial.begin(9600);
  InitTimersSafe();
  int i;
  for (i = 0; i < 6; ++i) {
    mac[i] = (byte) random(256);
  }
  Ethernet.begin(mac, ip, Dns, gateway, netmask);
  Udp.begin(localPort);
}

void loop() {
  int packetSize = Udp.parsePacket();
  if (packetSize)
  {
    unsigned char incoming[2];
    Udp.read((char*)&incoming, sizeof(incoming));
    uint16_t reassembled = ((unsigned int) incoming[0] << 8) | ((unsigned int) incoming[1]);
    Serial.println(reassembled);
    pwmWriteHR(DATA_PIN, reassembled);
  }
}

