#include <stdint.h>
#include <Arduino.h>
#include "modbus.h"
#include "settings.h"
#include "adc_module.h"

TModBusReq_Strct modbus_req_strct;
TSettings settings;
TDevice_State device_state;
TTemp_Module_Telemetry_Struct temp_module_telemetry_strct;
THV_Module_Telemetry_Struct hv_module_telemetry_strct;
TAnalog_Module_Telemetry_Struct analog_module_telemetry_strct[4];
TMeas_Proc_Data_Struct meas_proc_data_ready_strct[2];
uint16_t test_value_for_ao = 0;

const uint8_t counter_start_reg_num = 24;
const uint8_t counter_diap_reg_cnt = 8;
const uint8_t ipaddr_start_reg_num = 48;
const uint8_t analog_outs_setts_start_reg_num = 74;
const uint8_t analog_outs_setts_reg_size = 14;
const uint8_t meas_proc_cnt = 8;
const uint8_t meas_proc_reg_cnt = 180;
const uint8_t meas_proc_start_reg_num = 200;
const uint8_t stand_cnt = 3;
const uint8_t stand_reg_cnt = 12;
const uint8_t stand_start_reg_num = 24;
const uint8_t calibr_curve_reg_cnt = 16;
const uint8_t calibr_curve_start_reg_num = 60;
const uint8_t single_meas_cnt = 10;
const uint8_t single_meas_reg_cnt = 8;
const uint8_t single_meas_start_reg_num = 76;

const static unsigned char auchCRCHi[] = {
  0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
  0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
  0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01,
  0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41,
  0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81,
  0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0,
  0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01,
  0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
  0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
  0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
  0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01,
  0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
  0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
  0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
  0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01,
  0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
  0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
  0x40
};

const static char auchCRCLo[] = {
  0x00, 0xC0, 0xC1, 0x01, 0xC3, 0x03, 0x02, 0xC2, 0xC6, 0x06, 0x07, 0xC7, 0x05, 0xC5, 0xC4,
  0x04, 0xCC, 0x0C, 0x0D, 0xCD, 0x0F, 0xCF, 0xCE, 0x0E, 0x0A, 0xCA, 0xCB, 0x0B, 0xC9, 0x09,
  0x08, 0xC8, 0xD8, 0x18, 0x19, 0xD9, 0x1B, 0xDB, 0xDA, 0x1A, 0x1E, 0xDE, 0xDF, 0x1F, 0xDD,
  0x1D, 0x1C, 0xDC, 0x14, 0xD4, 0xD5, 0x15, 0xD7, 0x17, 0x16, 0xD6, 0xD2, 0x12, 0x13, 0xD3,
  0x11, 0xD1, 0xD0, 0x10, 0xF0, 0x30, 0x31, 0xF1, 0x33, 0xF3, 0xF2, 0x32, 0x36, 0xF6, 0xF7,
  0x37, 0xF5, 0x35, 0x34, 0xF4, 0x3C, 0xFC, 0xFD, 0x3D, 0xFF, 0x3F, 0x3E, 0xFE, 0xFA, 0x3A,
  0x3B, 0xFB, 0x39, 0xF9, 0xF8, 0x38, 0x28, 0xE8, 0xE9, 0x29, 0xEB, 0x2B, 0x2A, 0xEA, 0xEE,
  0x2E, 0x2F, 0xEF, 0x2D, 0xED, 0xEC, 0x2C, 0xE4, 0x24, 0x25, 0xE5, 0x27, 0xE7, 0xE6, 0x26,
  0x22, 0xE2, 0xE3, 0x23, 0xE1, 0x21, 0x20, 0xE0, 0xA0, 0x60, 0x61, 0xA1, 0x63, 0xA3, 0xA2,
  0x62, 0x66, 0xA6, 0xA7, 0x67, 0xA5, 0x65, 0x64, 0xA4, 0x6C, 0xAC, 0xAD, 0x6D, 0xAF, 0x6F,
  0x6E, 0xAE, 0xAA, 0x6A, 0x6B, 0xAB, 0x69, 0xA9, 0xA8, 0x68, 0x78, 0xB8, 0xB9, 0x79, 0xBB,
  0x7B, 0x7A, 0xBA, 0xBE, 0x7E, 0x7F, 0xBF, 0x7D, 0xBD, 0xBC, 0x7C, 0xB4, 0x74, 0x75, 0xB5,
  0x77, 0xB7, 0xB6, 0x76, 0x72, 0xB2, 0xB3, 0x73, 0xB1, 0x71, 0x70, 0xB0, 0x50, 0x90, 0x91,
  0x51, 0x93, 0x53, 0x52, 0x92, 0x96, 0x56, 0x57, 0x97, 0x55, 0x95, 0x94, 0x54, 0x9C, 0x5C,
  0x5D, 0x9D, 0x5F, 0x9F, 0x9E, 0x5E, 0x5A, 0x9A, 0x9B, 0x5B, 0x99, 0x59, 0x58, 0x98, 0x88,
  0x48, 0x49, 0x89, 0x4B, 0x8B, 0x8A, 0x4A, 0x4E, 0x8E, 0x8F, 0x4F, 0x8D, 0x4D, 0x4C, 0x8C,
  0x44, 0x84, 0x85, 0x45, 0x87, 0x47, 0x46, 0x86, 0x82, 0x42, 0x43, 0x83, 0x41, 0x81, 0x80,
  0x40
};

int holdRegsCheck(void) {
  int result = 0;

  return result;
}

uint8_t modbus_response_buffer[250] = { 0 };
uint8_t modbus_request_buffer[250] = { 0 };

int modBusRTUoutgoingPacketProcess(int parameter) {
  uint16_t ndx = 0, i, result = 0;
  uint16_t checksum, reg_addr;

  modbus_response_buffer[ndx++] = 1;

  switch (parameter) {
    case MODBUS_FUNC_RD_HOLD_REG:
      modbus_response_buffer[ndx++] = parameter;
      if (!modbus_req_strct.error) {
        modbus_response_buffer[ndx++] = modbus_req_strct.reg_qty * MODBUS_HOLD_REG_SIZE;
        for (i = 0; i < modbus_req_strct.reg_qty; i++) {
          reg_addr = modbus_req_strct.reg_addr_start + i;
          uint16_t tmp_val = modBusRTUholdRegRead(reg_addr);  //*((uint16_t *) &(modBus_hold_regs[reg_addr]));
          modbus_response_buffer[ndx++] = (tmp_val >> 8) & 0xFF;
          modbus_response_buffer[ndx++] = tmp_val & 0xFF;
        }
      }
      break;

    case MODBUS_FUNC_RD_INP_REG:
      modbus_response_buffer[ndx++] = parameter;
      if (!modbus_req_strct.error) {
        modbus_response_buffer[ndx++] = modbus_req_strct.reg_qty * MODBUS_INP_REG_SIZE;
        for (i = 0; i < modbus_req_strct.reg_qty; i++) {
          reg_addr = modbus_req_strct.reg_addr_start + i;
          uint16_t tmp_val = modBusRTUinpRegRead(reg_addr);
          ;  //*((uint16_t *) &(modBus_input_regs.array[reg_addr]));
          modbus_response_buffer[ndx++] = (tmp_val >> 8) & 0xFF;
          modbus_response_buffer[ndx++] = tmp_val & 0xFF;
        }
      }
      break;

    case MODBUS_FUNC_WR_HOLD_REG:
      modbus_response_buffer[ndx++] = parameter;
      if (!modbus_req_strct.error) {
        modbus_response_buffer[ndx++] = (modbus_req_strct.reg_addr_start >> 8) & 0xFF;
        modbus_response_buffer[ndx++] = modbus_req_strct.reg_addr_start & 0xFF;
        modbus_response_buffer[ndx++] = modbus_request_buffer[4];
        modbus_response_buffer[ndx++] = modbus_request_buffer[5];
      }
      break;

    case MODBUS_FUNC_WR_HOLD_REGS:
      modbus_response_buffer[ndx++] = parameter;
      if (!modbus_req_strct.error) {
        modbus_response_buffer[ndx++] = (modbus_req_strct.reg_addr_start >> 8) & 0xFF;
        modbus_response_buffer[ndx++] = modbus_req_strct.reg_addr_start & 0xFF;
        modbus_response_buffer[ndx++] = (modbus_req_strct.reg_qty >> 8) & 0xFF;
        modbus_response_buffer[ndx++] = modbus_req_strct.reg_qty & 0xFF;
      }
      break;

    default:
      modbus_response_buffer[ndx++] = parameter;
      break;
  }

  if (modbus_req_strct.error) {
    modbus_response_buffer[ndx - 1] |= 0x80;
    modbus_response_buffer[ndx++] = modbus_req_strct.error;
  }
  checksum = checksumModbusCalc(modbus_response_buffer, ndx);
  modbus_response_buffer[ndx++] = checksum & 0xFF;
  modbus_response_buffer[ndx++] = (checksum >> 8) & 0xFF;

  if (!result) {  // Send outgoing packet
    result = ndx;
  } else {
    if (result < 0) {
      result = 0;
    }
  }

  return result;
}

int modBusRTUincomingPacketParse(uint8_t *data, int length) {
  int result = 0, i;
  TModBusRTU_Write_Packet *hold_wr_packet;
  TModBusRTU_Write_Single_Packet *hold_wr_single_packet;
  TModBusRTU_ReadPacket *reg_rd_packet;
  uint16_t checksum;

  modbus_req_strct.error = 0;

  TModBusRTU_ReqPacket_Header *packet = (TModBusRTU_ReqPacket_Header *)data;
  memcpy(modbus_request_buffer, data, length);

  if ((packet->slave_addr != 1) && (packet->slave_addr != 0xFF))
    return -1;

  switch (packet->function) {
    case MODBUS_FUNC_RD_HOLD_REG:
      reg_rd_packet = (TModBusRTU_ReadPacket *)data;
      checksum = checksumModbusCalc((uint8_t *)reg_rd_packet, modBusPacketGetSize(reg_rd_packet->header.function) - 2);
      if (checksum != reg_rd_packet->checksum)
        result = -2;
      else {
        reg_rd_packet->header.start_addr = swap_u16(reg_rd_packet->header.start_addr);
        reg_rd_packet->header.number_of_regs = swap_u16(reg_rd_packet->header.number_of_regs);
        if ((reg_rd_packet->header.start_addr + reg_rd_packet->header.number_of_regs)
            > (MODBUS_HOLD_REG_START_ADDR + MODBUS_HOLD_REG_QTY))
          modbus_req_strct.error = 2;
        else {
          modbus_req_strct.reg_addr_start = reg_rd_packet->header.start_addr;
          modbus_req_strct.reg_qty = reg_rd_packet->header.number_of_regs;
        }
      }
      break;

    case MODBUS_FUNC_RD_INP_REG:
      reg_rd_packet = (TModBusRTU_ReadPacket *)data;
      checksum = checksumModbusCalc((uint8_t *)reg_rd_packet, modBusPacketGetSize(reg_rd_packet->header.function) - 2);
      if (checksum != reg_rd_packet->checksum)
        result = -2;
      else {
        reg_rd_packet->header.start_addr = swap_u16(reg_rd_packet->header.start_addr);
        reg_rd_packet->header.number_of_regs = swap_u16(reg_rd_packet->header.number_of_regs);
        if ((reg_rd_packet->header.start_addr + reg_rd_packet->header.number_of_regs)
            > (MODBUS_INP_REG_START_ADDR + MODBUS_INP_REG_QTY))
          modbus_req_strct.error = 2;
        else {
          modbus_req_strct.reg_addr_start = reg_rd_packet->header.start_addr;
          modbus_req_strct.reg_qty = reg_rd_packet->header.number_of_regs;
        }
      }
      break;

    case MODBUS_FUNC_WR_HOLD_REG:
      hold_wr_single_packet = (TModBusRTU_Write_Single_Packet *)data;
      checksum = checksumModbusCalc((uint8_t *)hold_wr_single_packet, modBusPacketGetSize(hold_wr_single_packet->function) - 2);
      if (checksum != hold_wr_single_packet->checksum)
        result = -2;
      else if (swap_u16(hold_wr_single_packet->start_addr) > (MODBUS_HOLD_REG_START_ADDR + MODBUS_HOLD_REG_QTY + 1))
        modbus_req_strct.error = 2;
      else {
        modbus_req_strct.reg_addr_start = swap_u16(hold_wr_single_packet->start_addr);
        modBusRTUholdRegWrite(modbus_req_strct.reg_addr_start, swap_u16(hold_wr_single_packet->data));  //*((uint16_t *)&modBus_hold_regs[modbus_req_strct.reg_addr_start])
        result = holdRegsCheck();
        if (result)
          modbus_req_strct.error = 3;
      }
      break;
    case MODBUS_FUNC_WR_HOLD_REGS:
      hold_wr_packet = (TModBusRTU_Write_Packet *)data;
      checksum = checksumModbusCalc((uint8_t *)hold_wr_packet, length - 2);
      uint16_t checksum_in_packet = hold_wr_packet->data[length - 2 - 7]
                                    | ((uint16_t)hold_wr_packet->data[length - 1 - 7] << 8);
      if (checksum != checksum_in_packet)
        result = -2;
      else if ((swap_u16(hold_wr_packet->header.start_addr) + hold_wr_packet->byte_count / MODBUS_HOLD_REG_SIZE)
               > (MODBUS_HOLD_REG_START_ADDR + MODBUS_HOLD_REG_QTY + 1))
        modbus_req_strct.error = 2;
      else if (hold_wr_packet->byte_count & 1)
        modbus_req_strct.error = 2;
      else {
        modbus_req_strct.reg_addr_start = swap_u16(hold_wr_packet->header.start_addr);
        modbus_req_strct.reg_qty = swap_u16(hold_wr_packet->header.number_of_regs);
        uint16_t u16_val = 0;
        for (i = 0; i < modbus_req_strct.reg_qty; i++) {
          memcpy(&u16_val, &(hold_wr_packet->data[i * MODBUS_HOLD_REG_SIZE]), sizeof(u16_val));
          //*((uint16_t *)&modBus_hold_regs[modbus_req_strct.reg_addr_start + i]) = swap_u16(u16_val);
          modBusRTUholdRegWrite(modbus_req_strct.reg_addr_start + i, swap_u16(u16_val));
          result = holdRegsCheck();
          if (result) {
            modbus_req_strct.error = 3;
            break;
          }
        }
      }
      break;
  }
  if (result >= 0)
    result = packet->function;
  return result;
}



uint16_t checksumModbusCalc(uint8_t *data, uint8_t size) {
  unsigned char uchCRCHi = 0xFF; /* high byte of CRC initialized */
  unsigned char uchCRCLo = 0xFF; /* low byte of CRC initialized */
  unsigned uIndex;               /* will index into CRC lookup table */
  while (size--)                 /* pass through message buffer */
  {
    uIndex = uchCRCHi ^ *data++; /* calculate the CRC */
    uchCRCHi = uchCRCLo ^ auchCRCHi[uIndex];
    uchCRCLo = auchCRCLo[uIndex];
  }
  return ((uint16_t)uchCRCLo << 8 | uchCRCHi);
}

uint8_t modBusPacketGetSize(uint8_t function) {
  uint8_t result = 0;

  switch (function) {
    case MODBUS_FUNC_RD_HOLD_REG:
      result = 8;
      break;

    case MODBUS_FUNC_RD_INP_REG:
      result = 8;
      break;

    case MODBUS_FUNC_WR_HOLD_REG:
      result = 8;
      break;

    case MODBUS_FUNC_WR_HOLD_REGS:
      result = 255;
      break;

    default:
      result = 0;
      break;
  }

  return result;
}


int modBusRTUholdRegWrite(uint16_t address, uint16_t value) {
  int result = 0;
  uint8_t bank, reg;

  bank = address >> 8;
  reg = address & 0xFF;
  switch (address) {
      //Адрес modbus
    case 0:
      settings.modbus_addr = value;
      break;
    //Режим обработки
    case 1:
      settings.adc_module.proc_mode = (TADC_Module_Proc_Modes)value;
      break;
    //Режим синхронизации
    case 2:
      setSyncMode(value);
      break;
    //Режим работы платы АЦП
    case 3:
      setAdcMode(value);
      break;
      //Уровень синхронизации
    case 4:
      setSyncLevel(value);
      break;
    //Таймер выдачи данных
    case 5:
      settings.timer_max_ms = value;
      break;
      //К-т платы предусиления
    case 6:
      settings.preamp.gain = value;
      break;
    // Адрес получателя данных
    case 7:
    case 8:
    case 9:
    case 10:
      settings.udp_ip_port[address - 7] = value;
      break;
    // udp порт
    case 11:
      settings.udp_port = value;
      break;
    //Уставка HV
    case 12:
      setHvTarget(value);
      break;
    // Очистка спеткра
    case 18:
      rstSpectrum(value);
      break;
    //Запуск-останов платы АЦП
    case 19:
      startStopAdcBoard(value);
      break;
    // Разрешение на передачу данных платы АЦП клиенту
    case 20:
      settings.adc_module.data_send_en = value;
      break;
    case 21:
      startStopHv(value);
      break;
    // Последовательный порт
    case 66:
      memcpy((uint8_t *)&settings.serial_baudrate, &value, 2);
      break;
    case 67:
      memcpy((uint8_t *)&settings.serial_baudrate + 2, &value, 2);
      break;
    case 68:
      settings.serial_select = value == 0 ? 0 : 1;
      break;
    // Вкл-выкл аналоговых входов
    case 70:
    case 71:
      settings.am_in[address - 70].on_off = value == 0 ? 0 : 1;
      setAnalogPwr(address - 70, 1, settings.am_in[address - 70].on_off);
      break;
    // тип прибора
    case 102:
      settings.device_type = (TMeas_Device_Type)(value == 0 ? 0 : 1);
      break;
    // Источник температуры для компенсации
    case 103:
      settings.temperature_src = value;
      break;
    // К-т A для AI0 (получение температуры)
    case 104:
    case 105:
      memcpy((uint8_t *)&settings.am_in[0].temp_coeff_A + (reg & 1), &value, 2);
      break;
    // К-т B для AI0 (получение температуры)
    case 106:
    case 107:
      memcpy((uint8_t *)&settings.am_in[0].temp_coeff_B + (reg & 1), &value, 2);
      break;
    // К-т A для AI1 (получение температуры)
    case 108:
    case 109:
      memcpy((uint8_t *)&settings.am_in[1].temp_coeff_A + (reg & 1), &value, 2);
      break;
    // К-т B для AI1 (получение температуры)
    case 110:
    case 111:
      memcpy((uint8_t *)&settings.am_in[1].temp_coeff_B + (reg & 1), &value, 2);
      break;
    // длина уровнемера
    case 112:
    case 113:
      memcpy((uint8_t *)&settings.levelmeter_length + (reg & 1), &value, 2);
      break;
    // вкл-выкл измерения
    case 114:
      SwitchCycleMeas(value);
      break;
    default:
      // Если счетчики
      if (address >= counter_start_reg_num && address < (counter_start_reg_num + counter_diap_reg_cnt * 3)) {
        setCountersSettings(address, value);
      }
      // Ip адрес
      else if (address >= ipaddr_start_reg_num && address < (ipaddr_start_reg_num + 18)) {
        setEthernetSettings(address, value);
      }
      // Если настройки аналоговых входов
      else if (address >= analog_outs_setts_start_reg_num && address < (analog_outs_setts_start_reg_num + analog_outs_setts_reg_size * 2)) {
        setAnalogSettsRegisters(address, value);
      }
      // изм процессы
      else if (address >= meas_proc_start_reg_num && address < (meas_proc_start_reg_num + meas_proc_reg_cnt * meas_proc_cnt)) {
        setMeasProcess(address, value);
      }
      // rtc
      if (address >= 116 && address <= 122) {
        setRtc(address, value);
      }
      break;
  }

  return result;
}




void setSyncMode(uint8_t mode) {
  settings.adc_module.sync_mode = (TADC_Module_Sync_Modes)mode;
}

void setAdcMode(uint8_t mode) {
  settings.adc_module.mode = (TADC_Module_Work_Modes)mode;
}

void setSyncLevel(uint16_t level) {
  settings.adc_module.sync_level = level;
}

void setHvTarget(uint16_t target) {
  settings.hv_target = target;
}


void rstSpectrum(uint8_t value) {
}

void startStopAdcBoard(uint8_t value) {
}

void setRtc(uint16_t address, uint16_t value) {
}

void startStopHv(uint8_t value) {
}

void setAnalogPwr(uint8_t groupNum, uint8_t moduleNum, uint8_t value) {
}

void SwitchCycleMeas(uint16_t value) {
}

void setEthernetSettings(uint16_t address, uint16_t value) {
  uint8_t offset = address - ipaddr_start_reg_num;
  if (offset < 12)
    settings.tcp_ip[offset] = value;
  else if (offset < 18)
    settings.macAddr[offset - 12] = value;
}

void setCountersSettings(uint16_t address, uint16_t value) {
  uint8_t counter_num = (address - counter_start_reg_num) / counter_diap_reg_cnt;
  if (counter_num >= 0 && counter_num < 3) {
    uint8_t offset = (address - counter_start_reg_num) % counter_diap_reg_cnt;
    switch (offset) {
      case 0:
        settings.adc_module.counters_settings[counter_num].beginning = value;
        break;
      case 1:
        settings.adc_module.counters_settings[counter_num].width = value;
        break;
      case 2:
        settings.adc_module.counters_settings[counter_num].type = value;
        break;
      default:
        break;
    }
  }
}

void setAnalogSettsRegisters(uint16_t address, uint16_t value) {
  uint8_t outNum = (address - analog_outs_setts_start_reg_num) / analog_outs_setts_reg_size;
  if (outNum < 2) {
    uint8_t offset = (address - analog_outs_setts_start_reg_num) % analog_outs_setts_reg_size;
    switch (offset) {
      // Активность
      case 0:
        setAnalogPwr(outNum, 0, value == 0 ? 0 : 1);
        settings.am_out[outNum].on_off = value;
        break;
      // Режим работы
      case 1:
        settings.am_out[outNum].type = value;
        break;
      // Номер изм. Процесса
      case 2:
        settings.am_out[outNum].meas_proc_ndx = value;
        break;
      // Тип измеряемой величины
      case 3:
        settings.am_out[outNum].var_ndx = value;
        break;
      // Мин измеряемая величина
      case 4:
        memcpy((uint8_t *)&settings.am_out[outNum].val_low_thr, &value, 2);
        break;
      case 5:
        memcpy((uint8_t *)&settings.am_out[outNum].val_low_thr + 2, &value, 2);
        break;
      // Макс измеряемая величина
      case 6:
        memcpy((uint8_t *)&settings.am_out[outNum].val_high_thr, &value, 2);
        break;
      case 7:
        memcpy((uint8_t *)&settings.am_out[outNum].val_high_thr + 2, &value, 2);
        break;
      // Мин ток, мкА
      case 8:
        memcpy((uint8_t *)&settings.am_out[outNum].val_low_thr_uA, &value, 2);
        break;
      case 9:
        memcpy((uint8_t *)&settings.am_out[outNum].val_low_thr_uA + 2, &value, 2);
        break;
      // Макс ток, мкА
      case 10:
        memcpy((uint8_t *)&settings.am_out[outNum].val_high_thr_uA, &value, 2);
        break;
      case 11:
        memcpy((uint8_t *)&settings.am_out[outNum].val_high_thr_uA + 2, &value, 2);
        break;
      // Тестовое значение
      case 12:
        test_value_for_ao = value;
        break;
      // Отправить тестовое значение
      case 13:
        if (value == 1) {
          sendAnalogTestValue(outNum, test_value_for_ao);
        }
        break;
      default:
        break;
    }
  }
}

void setMeasProcess(uint16_t address, uint16_t value) {

  uint16_t offset = 0;
  uint8_t meas_proc_num = (address - meas_proc_start_reg_num) / meas_proc_reg_cnt;
  if (meas_proc_num >= meas_proc_cnt) return;
  offset = (address - meas_proc_start_reg_num) % meas_proc_reg_cnt;
  switch (offset) {
    //Длительность измерения
    case 0:
      settings.adc_module.meas_process[meas_proc_num].duration = value;
      break;
      //Кол-во точек измерения для усреднения
    case 1:
      settings.adc_module.meas_process[meas_proc_num].averaging_depth = value;
      break;
    //Диаметр трубы
    case 2:
      settings.adc_module.meas_process[meas_proc_num].pipe_diam = value;
      break;
    //Активность изм процесса
    case 3:
      if (value) {
        settings.adc_module.meas_process_current = settings.adc_module.meas_process_current | (1 << meas_proc_num);
      } else {
        settings.adc_module.meas_process_current = settings.adc_module.meas_process_current & ~(1 << meas_proc_num);
      }
      break;
    // Тип расчета измерения.
    case 4:
      settings.adc_module.meas_process[meas_proc_num].calc_type = (TMeas_Proc_Calc_Type)value;
      break;
    // Тип  измерения.
    case 5:
      settings.adc_module.meas_process[meas_proc_num].meas_type = (TMeas_Proc_Meas_Type)value;
      break;
    //Плотность жидкого
    case 6:
    case 7:
      memcpy((uint8_t *)&settings.adc_module.meas_process[meas_proc_num].density_liquid_d1.phys_value + (offset & 1) * 2, &value, 2);
      break;
    //Плотность твердого
    case 8:
    case 9:
      memcpy((uint8_t *)&settings.adc_module.meas_process[meas_proc_num].density_solid_d2.phys_value + (offset & 1) * 2, &value, 2);
      break;
    // Активность быстрых изменений
    case 10:
      settings.adc_module.meas_process[meas_proc_num].fast_change.active = value;
      break;
    // Порог быстрых изменений
    case 11:
      settings.adc_module.meas_process[meas_proc_num].fast_change.threshold = value;
      break;
    // Время ед измерений
    case 12:
      settings.adc_module.meas_single_time = value;
      break;
    default:
      if (offset >= stand_start_reg_num && offset < (stand_start_reg_num + stand_cnt * stand_reg_cnt)) {
        setStandData(meas_proc_num, offset, value);
      } else if (offset >= calibr_curve_start_reg_num && offset < (calibr_curve_start_reg_num + calibr_curve_reg_cnt)) {
        setCalibrCurveData(meas_proc_num, offset, value);
      } else if (offset >= single_meas_start_reg_num && offset < (single_meas_start_reg_num + single_meas_cnt * single_meas_reg_cnt)) {
        setSingleMeasData(meas_proc_num, offset, value);
      }
      break;
  }
}

void sendAnalogTestValue(uint8_t outNum, uint16_t value) {
}

void setStandData(uint8_t meas_proc_num, uint16_t offset, uint16_t value) {
  uint16_t stand_offset = 0;
  uint8_t stand_num = (offset - stand_start_reg_num) / stand_reg_cnt;
  if (stand_num >= stand_cnt) return;
  stand_offset = (offset - stand_start_reg_num) % stand_reg_cnt;
  switch (stand_offset) {
    case 0:
      settings.adc_module.meas_process[meas_proc_num].standartisation[stand_num].duration = value;
      break;
    case 1:
      settings.adc_module.meas_process[meas_proc_num].standartisation[stand_num].date.Year = value;
      break;
    case 2:
      settings.adc_module.meas_process[meas_proc_num].standartisation[stand_num].date.Month = value;
      break;
    case 3:
      settings.adc_module.meas_process[meas_proc_num].standartisation[stand_num].date.Date = value;
      break;
    // Результат
    case 4:
    case 5:
      memcpy((uint8_t *)&settings.adc_module.meas_process[meas_proc_num].standartisation[stand_num].result + (stand_offset & 1) * 2, &value, 2);
      break;
    // half life
    case 6:
    case 7:
      memcpy((uint8_t *)&settings.adc_module.meas_process[meas_proc_num].standartisation[stand_num].half_life_compensated + (stand_offset & 1) * 2, &value, 2);
      break;
    default:
      break;
  }
}

void setCalibrCurveData(uint8_t meas_proc_num, uint16_t offset, uint16_t value) {

  uint16_t curve_offset = offset - calibr_curve_start_reg_num;
  switch (curve_offset) {
    // Тип калибровки
    case 0:
      settings.adc_module.meas_process[meas_proc_num].calib_curve.d_type = (TMeas_Density_Type)value;
      break;
    default:
      if (curve_offset >= 2 && curve_offset < (calibr_curve_reg_cnt - 2)) {
        uint8_t c_index = (curve_offset - 2) / 2;
        memcpy((uint8_t *)&settings.adc_module.meas_process[meas_proc_num].calib_curve.coeffs[c_index] + (curve_offset & 1) * 2, &value, 2);
      }
  }
}

void setSingleMeasData(uint8_t meas_proc_num, uint16_t offset, uint16_t value) {
  uint16_t single_meas_offset = 0;
  uint8_t single_meas_index = (offset - single_meas_start_reg_num) / single_meas_reg_cnt;
  if (single_meas_index >= single_meas_cnt) return;
  single_meas_offset = (offset - single_meas_start_reg_num) % single_meas_reg_cnt;
  switch (single_meas_offset) {
    case 0:
      settings.adc_module.meas_process[meas_proc_num].calib_src_values[single_meas_index].date.Year = value;
      break;
    case 1:
      settings.adc_module.meas_process[meas_proc_num].calib_src_values[single_meas_index].date.Month = value;
      break;
    case 2:
      settings.adc_module.meas_process[meas_proc_num].calib_src_values[single_meas_index].date.Date = value;
      break;

    case 4:
    case 5:
      memcpy((uint8_t *)&settings.adc_module.meas_process[meas_proc_num].calib_src_values[single_meas_index].attenuation + (single_meas_offset & 1) * 2, &value, 2);
      break;
    // осалбление
    case 6:
    case 7:
      memcpy((uint8_t *)&settings.adc_module.meas_process[meas_proc_num].calib_src_values[single_meas_index].phys_value + (single_meas_offset & 1) * 2, &value, 2);
      break;
    default:
      break;
  }
}

uint16_t modBusRTUholdRegRead(uint16_t address) {
  uint16_t result = 0;
  uint8_t bank, reg;

  bank = address >> 8;
  reg = address & 0xFF;

  switch (address) {
    //mosbus addr
    case 0:
      result = settings.modbus_addr;
      break;
    //Режим обработки
    case 1:
      result = settings.adc_module.proc_mode;
      break;
    case 2:
      result = settings.adc_module.sync_mode;
      break;
    //Режим работы АЦП
    case 3:
      result = settings.adc_module.mode;
      break;
    //Уровень синхронизации
    case 4:
      result = settings.adc_module.sync_level;
      break;

    //Таймер выдачи данных
    case 5:
      result = settings.timer_max_ms;
      break;
    //К-т платы предусиления
    case 6:
      result = settings.preamp.gain;
      break;
    // udp адрес получателя спектра
    case 7:
    case 8:
    case 9:
    case 10:
      result = settings.udp_ip_port[address - 7];
      break;
    //udp порт
    case 11:
      result = settings.udp_port;
      break;
    //уставка hv
    case 12:
      result = settings.hv_target;
      break;
    // Разрешение на передачу данных платы АЦП клиенту
    case 20:
      result = settings.adc_module.data_send_en;
      break;
    // Скорость посл порта
    case 66:
    case 67:
      memcpy(&result, (uint8_t *)&settings.serial_baudrate + (reg & 1) * sizeof result, sizeof result);
      break;
    // Режим работы порта
    case 68:
      result = settings.serial_select;
      break;
    // Аналоговые входы
    case 70:
    case 71:
      result = settings.am_in[address - 70].on_off;
      break;
    // тип прибора
    case 102:
      result = settings.device_type;
      break;
    // Источник температуры для компенсации
    case 103:
      result = settings.temperature_src;
      break;
    // К-т A для AI0 (получение температуры)
    case 104:
    case 105:
      memcpy(&result, (uint8_t *)&settings.am_in[0].temp_coeff_A + (reg & 1) * sizeof result, sizeof result);
      break;
    // К-т B для AI0 (получение температуры)
    case 106:
    case 107:
      memcpy(&result, (uint8_t *)&settings.am_in[0].temp_coeff_B + (reg & 1) * sizeof result, sizeof result);
      break;
    // К-т A для AI1 (получение температуры)
    case 108:
    case 109:
      memcpy(&result, (uint8_t *)&settings.am_in[1].temp_coeff_A + (reg & 1) * sizeof result, sizeof result);
      break;
    // К-т B для AI1 (получение температуры)
    case 110:
    case 111:
      memcpy(&result, (uint8_t *)&settings.am_in[1].temp_coeff_B + (reg & 1) * sizeof result, sizeof result);
      break;
    // Длина уровнемера
    case 112:
    case 113:
      memcpy(&result, (uint8_t *)&settings.levelmeter_length + (reg & 1) * sizeof result, sizeof result);
      break;
    default:
      // Если счетчики
      if (address >= counter_start_reg_num && address < (counter_start_reg_num + counter_diap_reg_cnt * 3)) {
        result = getRegisterFromCounters(address);
      }
      // Ip адрес
      else if (address >= ipaddr_start_reg_num && address < (ipaddr_start_reg_num + 18)) {
        result = getEthernetRegisters(address);
      }
      // аналоги
      else if (address >= analog_outs_setts_start_reg_num && address < (analog_outs_setts_start_reg_num + analog_outs_setts_reg_size * 2)) {
        result = getAnalogSettsRegisters(address);
      }
      // изм процессы
      else if (address >= meas_proc_start_reg_num && address < (meas_proc_start_reg_num + meas_proc_reg_cnt * meas_proc_cnt)) {
        result = GetMeasProcData(address);
      }
      break;
  }


  return result;
}

uint16_t modBusRTUinpRegRead(uint16_t address) {
  uint16_t result = 0;
  uint8_t bank, reg, reg_backup;
  TMeas_Proc_Data_Struct *meas_proc_data = reg < 9 ? &meas_proc_data_ready_strct[0] : &meas_proc_data_ready_strct[1];

  reg = address & 0xFF;

  switch (reg) {
    //Флаг общего измерения
    case 0:
      result = meas_proc_data->meas_in_progress > 0 ? 1 : 0;
      break;
    // Измерение 0 - номер измерительного процесса
    case 1:
      result = meas_proc_data->ndx;
      break;
    // Измерение 0 - счетчик
    case 2:
      meas_proc_data->counter = 123;
    case 3:
      memcpy(&result, (uint8_t *)&meas_proc_data->counter + (reg - 2) * sizeof result, sizeof result);
      break;
    // Измерение 0 - Мгновенная физ. величина
    case 4:
    case 5:
      memcpy(&result, (uint8_t *)&meas_proc_data->phys_vals[0] + (reg - 4) * sizeof result, sizeof result);
      break;
    // Измерение 0 - Усредненная  физ. величина
    case 6:
    case 7:
      memcpy(&result, (uint8_t *)&meas_proc_data->phys_val_complete_aver + (reg - 6) * sizeof result, sizeof result);
      break;
    // Измерение 0 - активность измерения
    case 8:
      result = meas_proc_data->meas_in_progress > 0 ? 1 : 0;
      break;
    // Измерение 1 - номер измерительного процесса
    case 9:
      result = meas_proc_data->ndx;
      break;
    // Измерение 1 - счетчик
    case 10:
    case 11:
      memcpy(&result, (uint8_t *)&meas_proc_data->counter + (reg - 10) * sizeof result, sizeof result);
      break;
    // Измерение 1 - Мгновенная физ. величина
    case 12:
    case 13:
      memcpy(&result, (uint8_t *)&meas_proc_data->phys_vals[0] + (reg - 12) * sizeof result, sizeof result);
      break;
    // Измерение 1 - Усредненная  физ. величина
    case 14:
    case 15:
      memcpy(&result, (uint8_t *)&meas_proc_data->phys_val_complete_aver + (reg - 14) * sizeof result, sizeof result);
      break;
    // Измерение 1 - активность измерения
    case 16:
      result = meas_proc_data->meas_in_progress > 0 ? 1 : 0;
      break;
    case 17:
      memcpy(&result, &device_state.comm_state, 2);
      break;    
    case 24:
    case 25:
      memcpy(&result, (uint8_t *)&temp_module_telemetry_strct.t_int + (reg & 1) * sizeof result, sizeof result);
      break;
    // Внешняя температура
    case 26:
    case 27:
      memcpy(&result, (uint8_t *)&temp_module_telemetry_strct.t_ext + (reg & 1) * sizeof result, sizeof result);
      break;
    // HV - input voltage
    case 28:
    case 29:
      memcpy(&result, (uint8_t *)&hv_module_telemetry_strct.v_in + (reg & 1) * sizeof result, sizeof result);
      break;
    // HV - output voltage
    case 30:
    case 31:
      memcpy(&result, (uint8_t *)&hv_module_telemetry_strct.v_out + (reg & 1) * sizeof result, sizeof result);
      break;
    // Аналоговый выход 0 - Питание на вход
    case 32:
      result = device_state.analog_out_state[0].pwr_0 == 0 ? 1 : 0;
      break;
    // Аналоговый выход 0 - Связь с модулем
    case 33:
      result = device_state.analog_out_state[0].comm_0 == 0 ? 1 : 0;
      break;
    // Аналоговый выход 0 - Значение АЦП
    case 34:
    case 35:
      memcpy(&result, (uint8_t *)&analog_module_telemetry_strct[0].v_test + (reg & 1) * sizeof result, sizeof result);
      break;
    // Аналоговый выход 0 - Напряжение ЦАП
    case 36:
    case 37:
      memcpy(&result, (uint8_t *)&analog_module_telemetry_strct[0].v_dac + (reg & 1) * sizeof result, sizeof result);
      break;
    // Аналоговый выход 1 - Питание на вход
    case 38:
      result = device_state.analog_out_state[1].pwr_0 == 0 ? 1 : 0;
      break;
    // Аналоговый выход 1 - Связь с модулем
    case 39:
      result = device_state.analog_out_state[1].comm_0 == 0 ? 1 : 0;
      break;
    // Аналоговый выход 1 - Значение АЦП
    case 40:
    case 41:
      memcpy(&result, (uint8_t *)&analog_module_telemetry_strct[2].v_test + (reg & 1) * sizeof result, sizeof result);
      break;
    // Аналоговый выход 1 - Напряжение ЦАП
    case 42:
    case 43:
      memcpy(&result, (uint8_t *)&analog_module_telemetry_strct[2].v_dac + (reg & 1) * sizeof result, sizeof result);
      break;
    // Аналоговый вход 0 - Питание на вход
    case 44:
      result = device_state.analog_out_state[0].pwr_1 == 0 ? 1 : 0;
      break;
    // Аналоговый вход 0 - Связь с модулем
    case 45:
      result = device_state.analog_out_state[0].comm_1 == 0 ? 1 : 0;
      break;
    // Аналоговый вход 0 - Значение АЦП
    case 46:
    case 47:
      memcpy(&result, (uint8_t *)&analog_module_telemetry_strct[1].v_rx + (reg & 1) * sizeof result, sizeof result);
      break;
    // Аналоговый вход 1 - Питание на вход
    case 50:
      result = device_state.analog_out_state[1].pwr_1 == 0 ? 1 : 0;
      break;
    // Аналоговый вход 1 - Связь с модулем
    case 51:
      result = device_state.analog_out_state[1].comm_1 == 0 ? 1 : 0;
      break;
    // Аналоговый вход 1 - Значение АЦП
    case 52:
    case 53:
      memcpy(&result, (uint8_t *)&analog_module_telemetry_strct[2].v_rx + (reg & 1) * sizeof result, sizeof result);
      break;
    default: break;
  }

  return result;
}

uint16_t getRegisterFromCounters(uint16_t address)
{
	uint16_t result = 0;
	uint8_t counter_num = (address-counter_start_reg_num)/counter_diap_reg_cnt;
	if(counter_num>=0 && counter_num<3)
	{
		uint8_t offset = (address-counter_start_reg_num)%counter_diap_reg_cnt;
		switch (offset) {
			case 0:
				result = settings.adc_module.counters_settings[counter_num].beginning;
				break;
			case 1:
				result = settings.adc_module.counters_settings[counter_num].width;
				break;
			case 2:
				result = settings.adc_module.counters_settings[counter_num].type;
				break;
			default:
				break;
		}
	}
	return result;
}

uint16_t getEthernetRegisters(uint16_t address)
{
	uint16_t result = 0;
	uint8_t offset = address - ipaddr_start_reg_num;
	if(offset >=0 && offset < 12){
		result = settings.tcp_ip[offset];
	}
	else if(offset< 18 && offset >=0)
		result = settings.macAddr[offset-12];
	return result;
}

uint16_t getAnalogSettsRegisters(uint16_t address)
{
	uint16_t result = 0;
	uint8_t outNum = (address - analog_outs_setts_start_reg_num)/analog_outs_setts_reg_size;
	if(outNum<2){
		uint8_t offset = (address - analog_outs_setts_start_reg_num)%analog_outs_setts_reg_size;
		switch (offset) {
			// Активность
			case 0: result = settings.am_out[outNum].on_off;
				break;
			// Режим работы
			case 1: result = settings.am_out[outNum].type;
				break;
			// Номер изм. Процесса
			case 2: result = settings.am_out[outNum].meas_proc_ndx;
				break;
			// Тип измеряемой величины
			case 3: result = settings.am_out[outNum].var_ndx;
				break;
			// Мин измеряемая величина
			case 4:
			case 5:  memcpy(&result, (uint8_t *) &settings.am_out[outNum].val_low_thr + (offset & 1) * sizeof result, sizeof result);
				break;
			// Макс измеряемая величина
			case 6:
			case 7: memcpy(&result, (uint8_t *) &settings.am_out[outNum].val_high_thr + (offset & 1) * sizeof result, sizeof result);
				break;
			// Мин ток, мкА
			case 8:
			case 9: memcpy(&result, (uint8_t *) &settings.am_out[outNum].val_low_thr_uA + (offset & 1) * sizeof result, sizeof result);
				break;
			// Макс ток, мкА
			case 10:
			case 11: memcpy(&result, (uint8_t *) &settings.am_out[outNum].val_high_thr_uA + (offset & 1) * sizeof result, sizeof result);
				break;
			// Тестовое значение
			case 12: result = test_value_for_ao;
				break;
			default:
				break;
		}
	}
	return result;
}

uint16_t GetMeasProcData(uint16_t address)
{
	uint16_t result = 0;
	uint16_t offset = 0;
	uint8_t meas_proc_num = (address - meas_proc_start_reg_num)/meas_proc_reg_cnt;
	if(meas_proc_num>=meas_proc_cnt)return 0;
	offset = (address - meas_proc_start_reg_num)%meas_proc_reg_cnt;
	switch (offset) {
		//Длительность измерения
		case 0:
			result = settings.adc_module.meas_process[meas_proc_num].duration;
			break;
		//Кол-во точек измерения для усреднения
		case 1:
			result = settings.adc_module.meas_process[meas_proc_num].averaging_depth;
			break;
		//Диаметр трубы
		case 2:
			result = settings.adc_module.meas_process[meas_proc_num].pipe_diam;
			break;
		//Активность изм процесса
		case 3:
			result = settings.adc_module.meas_process_current & (1 << meas_proc_num);
			break;
		// Тип расчета измерения.
		case 4:
			result = settings.adc_module.meas_process[meas_proc_num].calc_type;
			break;
		// Тип  измерения.
		case 5:
			result = settings.adc_module.meas_process[meas_proc_num].meas_type;
			break;
		//Плотность жидкого
		case 6:
		case 7:
			memcpy(&result, (uint8_t *) &settings.adc_module.meas_process[meas_proc_num].density_liquid_d1.phys_value + (offset & 1) * 2, 2);
			break;
		//Плотность твердого
		case 8:
		case 9:
			memcpy(&result, (uint8_t *) &settings.adc_module.meas_process[meas_proc_num].density_solid_d2.phys_value + (offset & 1) * sizeof result, sizeof result);
			break;
		// Активность быстрых изменений
		case 10:
			result = settings.adc_module.meas_process[meas_proc_num].fast_change.active;
			break;
		// Порог быстрых изменений
		case 11:
			result = settings.adc_module.meas_process[meas_proc_num].fast_change.threshold;
			break;
		// Время ед измерений
		case 12:
			if(settings.adc_module.meas_single_time == 0){
				settings.adc_module.meas_single_time = 300;
			}
			result = settings.adc_module.meas_single_time;
			break;
		default:
			if(offset >= stand_start_reg_num && offset < (stand_start_reg_num + stand_cnt * stand_reg_cnt))
			{
				result = getStandData(meas_proc_num, offset);
			}
			else if(offset >= calibr_curve_start_reg_num && offset < (calibr_curve_start_reg_num + calibr_curve_reg_cnt))
			{
				result  = getCalibrCurveData(meas_proc_num, offset);
			}
			else if(offset >= single_meas_start_reg_num && offset < (single_meas_start_reg_num + single_meas_cnt * single_meas_reg_cnt))
			{
				result  = getSingleMeasData(meas_proc_num, offset);
			}
			break;
	}
	return result;
}

uint16_t getStandData(uint8_t meas_proc_num, uint16_t offset)
{
	uint16_t result = 0;
	uint16_t stand_offset = 0;
	uint8_t stand_num = (offset - stand_start_reg_num)/stand_reg_cnt;
	if(stand_num>=stand_cnt) return 0;
	stand_offset = (offset - stand_start_reg_num)%stand_reg_cnt;
	switch (stand_offset) {
		case 0:
			result = settings.adc_module.meas_process[meas_proc_num].standartisation[stand_num].duration;
			break;
		case 1:
			result = settings.adc_module.meas_process[meas_proc_num].standartisation[stand_num].date.Year;
			break;
		case 2:
			result = settings.adc_module.meas_process[meas_proc_num].standartisation[stand_num].date.Month;
			break;
		case 3:
			result = settings.adc_module.meas_process[meas_proc_num].standartisation[stand_num].date.Date;
			break;
		// Результат
		case 4:
		case 5:memcpy(&result, (uint8_t *) &settings.adc_module.meas_process[meas_proc_num].standartisation[stand_num].result + (stand_offset & 1) * sizeof result, sizeof result);
			break;
		// Результат
		case 6:
		case 7:memcpy(&result, (uint8_t *) &settings.adc_module.meas_process[meas_proc_num].standartisation[stand_num].half_life_compensated + (stand_offset & 1) * sizeof result, sizeof result);
			break;
		default:
			break;
	}

	return result;
}

uint16_t getCalibrCurveData(uint8_t meas_proc_num, uint16_t offset)
{
	uint16_t result = 0;
	uint16_t curve_offset = offset  - calibr_curve_start_reg_num;
	switch (curve_offset) {
		// Тип калибровки
		case 0:
			result = settings.adc_module.meas_process[meas_proc_num].calib_curve.d_type;
			break;
		default:
			if(curve_offset>=2 && curve_offset < (calibr_curve_reg_cnt-2)){
				uint8_t c_index = (curve_offset-2)/2;
				memcpy(&result, (uint8_t *) &settings.adc_module.meas_process[meas_proc_num].calib_curve.coeffs[c_index] + (curve_offset & 1) * sizeof result, sizeof result);
			}
	}
	return result;
}

uint16_t getSingleMeasData(uint8_t meas_proc_num, uint16_t offset)
{
	uint16_t result = 0;
	uint16_t single_meas_offset = 0;
	uint8_t single_meas_index = (offset - single_meas_start_reg_num)/single_meas_reg_cnt;
	if(single_meas_index >= single_meas_cnt) return 0;
	single_meas_offset = (offset - single_meas_start_reg_num) % single_meas_reg_cnt;
	switch (single_meas_offset) {
		case 0:
			result = settings.adc_module.meas_process[meas_proc_num].calib_src_values[single_meas_index].date.Year;
			break;
		case 1:
			result = settings.adc_module.meas_process[meas_proc_num].calib_src_values[single_meas_index].date.Month;
			break;
		case 2:
			result = settings.adc_module.meas_process[meas_proc_num].calib_src_values[single_meas_index].date.Date;
			break;
		// осалбление
		case 4:
		case 5:
			memcpy(&result, (uint8_t *) &settings.adc_module.meas_process[meas_proc_num].calib_src_values[single_meas_index].attenuation + (single_meas_offset & 1) * sizeof result, sizeof result);
			break;
		// осалбление
		case 6:
		case 7:
			memcpy(&result, (uint8_t *) &settings.adc_module.meas_process[meas_proc_num].calib_src_values[single_meas_index].phys_value + (single_meas_offset & 1) * sizeof result, sizeof result);
			break;
		default:
			break;
	}
	return result;
}

