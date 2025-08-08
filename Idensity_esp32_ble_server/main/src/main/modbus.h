#ifndef MODBUS_H_
#define MODBUS_H_


#define MODBUS_FUNC_RD_HOLD_REG	 3
#define MODBUS_FUNC_RD_INP_REG	4
#define MODBUS_FUNC_WR_HOLD_REG 6
#define MODBUS_FUNC_WR_HOLD_REGS	16


// Holding registers
#define MODBUS_HOLD_REG_QTY			65535
#define MODBUS_HOLD_REG_SIZE		2
#define MODBUS_HOLD_REG_START_ADDR	1

// Input registers
#define MODBUS_INP_REG_QTY			65535
#define MODBUS_INP_REG_SIZE			2
#define MODBUS_INP_REG_START_ADDR	1

#define swap_u16(u16) ((uint16_t)(((uint16_t)(u16) >> 8) | ((uint16_t)(u16) << 8)))

typedef struct
{
  uint8_t slave_addr;
  uint8_t function;
  uint16_t start_addr;
  uint16_t number_of_regs;
} TModBusRTU_ReqPacket_Header;

typedef struct
{
  uint8_t slave_addr;
  uint8_t function;
  uint16_t start_addr;
  uint16_t data;
  uint16_t checksum;
} TModBusRTU_Write_Single_Packet;

typedef struct
{
  TModBusRTU_ReqPacket_Header header;
  uint8_t byte_count;
  uint8_t data[];
} TModBusRTU_Write_Packet;

typedef struct
{
  TModBusRTU_ReqPacket_Header header;
  uint16_t checksum;
} TModBusRTU_ReadPacket;

typedef struct
{
  uint16_t reg_addr_start;
  uint16_t reg_qty;
  union
  {
  uint16_t temp;
  uint16_t filenum;
  };
  int error;
} TModBusReq_Strct;
int modBusRTUoutgoingPacketProcess(int parameter);
int modBusRTUincomingPacketParse(uint8_t *data, int length);
uint16_t checksumModbusCalc(uint8_t *data, uint8_t size);
uint8_t modBusPacketGetSize(uint8_t function);
uint16_t modBusRTUholdRegRead(uint16_t address);
uint16_t modBusRTUinpRegRead(uint16_t address);

void setSyncMode(uint8_t mode);
void setAdcMode(uint8_t mode);
void setSyncLevel(uint16_t level);

void setHvTarget(uint16_t target);
void rstSpectrum(uint8_t value);
void setRtc(uint16_t address, uint16_t value);
void startStopAdcBoard(uint8_t value);
uint16_t getEthernetRegisters(uint16_t address);
uint16_t getAnalogSettsRegisters(uint16_t address);
uint16_t GetMeasProcData(uint16_t address);
uint16_t getStandData(uint8_t meas_proc_num, uint16_t offset);
uint16_t getCalibrCurveData(uint8_t meas_proc_num, uint16_t offset);
uint16_t getSingleMeasData(uint8_t meas_proc_num, uint16_t offset);

void startStopHv(uint8_t value);
uint16_t getRegisterFromCounters(uint16_t address);

void setAnalogPwr(uint8_t groupNum, uint8_t moduleNum, uint8_t value);
void SwitchCycleMeas(uint16_t value);

void setEthernetSettings(uint16_t address, uint16_t value);
void setCountersSettings(uint16_t address, uint16_t value);
void setAnalogSettsRegisters(uint16_t address, uint16_t value);
void setMeasProcess(uint16_t address, uint16_t value);
void sendAnalogTestValue(uint8_t outNum, uint16_t value);

void setStandData(uint8_t meas_proc_num, uint16_t offset, uint16_t value);
void setCalibrCurveData(uint8_t meas_proc_num, uint16_t offset, uint16_t value);
void setSingleMeasData(uint8_t meas_proc_num, uint16_t offset, uint16_t value);

#endif