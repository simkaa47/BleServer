#include <BLEDevice.h>
#include <BLE2901.h>
#include "modbus.h"
#include "adc_module.h"

/**Defines*/
#define DEVICE_NAME "Idensity_BLE"
#define SERVICE_1_UUID "d973f2e0-b19e-11e2-9e96-0800200c9a66"
#define CHARACTERISTIC_1_UUID "d973f2e2-b19e-11e2-9e96-0800200c9a66"
#define CHARACTERISTIC_2_UUID "d973f2e1-b19e-11e2-9e96-0800200c9a66"

extern uint8_t modbus_response_buffer[250];
extern TMeas_Proc_Data_Struct meas_proc_data_ready_strct[2];

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

class MyCharacteristicsCallbacksRw : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    // Получаем длину этих данных
    size_t receivedLength = pCharacteristic->getLength();
    uint8_t *receivedData = pCharacteristic->getData();
    // Проверяем, что данные не пустые
    if (receivedData != nullptr && receivedLength > 0) {
      Serial.print("Received data of length: ");
      Serial.println(receivedLength);
      // Вы можете распечатать данные для отладки
      Serial.print("Received bytes: ");
      for (int i = 0; i < receivedLength; i++) {
        Serial.print(receivedData[i], HEX);
        Serial.print(" ");
      }
      Serial.println();
      int result = modBusRTUincomingPacketParse(receivedData, receivedLength);
      if(result>=0){
        result = modBusRTUoutgoingPacketProcess(result);
        Serial.print("Modbus result: ");
        Serial.print(result);
        Serial.println(" bytes");
        pCharacteristic->setValue(modbus_response_buffer, result);
      }
      

      // Устанавливаем полученные данные в качестве ответа
      

      // Отправляем уведомление
      pCharacteristic->notify();
    } else {
      Serial.println("Received empty data.");
    }
  }


  void onRead(BLECharacteristic *pCharacteristic) {
    uint32_t currentMilis = millis() / 1000;
    pCharacteristic->setValue(currentMilis);
    Serial.println(currentMilis);
  }
};
BLECharacteristic *pCharacteristic;


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

  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->addServiceUUID(BLEUUID(SERVICE_1_UUID));

  //Services
  BLEService *pService = pServer->createService(SERVICE_1_UUID);

  //Characteristics
  BLECharacteristic *pCharacteristicRead = pService->createCharacteristic(
    CHARACTERISTIC_2_UUID,
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE | BLECharacteristic::PROPERTY_NOTIFY);

  BLECharacteristic *pCharacteristicWrite = pService->createCharacteristic(
    CHARACTERISTIC_1_UUID,
    BLECharacteristic::PROPERTY_WRITE);

  pCharacteristic = pCharacteristicRead;

  pCharacteristicRead->setCallbacks(new MyCharacteristicsCallbacksRw());

  // Descriptors
  BLE2901 *descriptor_2901 = new BLE2901();
  descriptor_2901->setDescription("Time");
  pCharacteristicRead->addDescriptor(descriptor_2901);


  pService->start();

  //Start advertising
  pAdvertising->start();
}
uint32_t currentMilis1 = 0;

void loop() {
  delay(100);
  currentMilis1 = millis() / 1000;
  meas_proc_data_ready_strct[0].counter = 23748.7 + currentMilis1%12 + (float(currentMilis1%7)/10);
}
