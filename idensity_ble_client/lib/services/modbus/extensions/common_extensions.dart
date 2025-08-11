import 'dart:typed_data';

extension FloatModbusExtensions on List<int> {
  double getFloat(int startIndex, {Endian endian = Endian.little}) {
    final buffer = Uint8List(4).buffer;
    final byteData = ByteData.view(buffer);
    byteData.setUint16(0, this[startIndex], endian);
    byteData.setUint16(2, this[startIndex + 1], endian);
    return byteData.getFloat32(0, endian);
  }
}
