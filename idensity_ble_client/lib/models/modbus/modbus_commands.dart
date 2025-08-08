enum ModbusReadCommands {
  readInputRegisters(4),
  readHoldingRegisters(3);

  const ModbusReadCommands(this.code);
  final int code;
}