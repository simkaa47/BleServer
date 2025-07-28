#include <BLEDevice.h>

/**Defines*/
#define DEVICE_NAME "Idensity_BLE"
#define SERVICE_1_UUID "d973f2e0-b19e-11e2-9e96-0800200c9a66"

/*Callbacks*/
class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer *pServer) {
    digitalWrite(2, HIGH);
    Serial.println("Client connected");
  }

  void onDisconnect(BLEServer *pServer) {
    digitalWrite(2, LOW);
    Serial.println("Client disconnected");
    BLEDevice::startAdvertising();
  }
};



void setup() {
  pinMode(2, OUTPUT);  
  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial.print("ESP32 BLE Server beginning...");

  //initialize device
  BLEDevice::init(DEVICE_NAME);

  // Create server
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  //Services
  BLEService *pService = pServer->createService(SERVICE_1_UUID);
  pService->start();

  //Start advertising
  BLEDevice::startAdvertising();
}


void loop() {
  // put your main code here, to run repeatedly:
}
