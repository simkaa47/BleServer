import 'package:idensity_ble_client/models/settings/device_mode.dart';

class MeasUnit{
  int id;
  String name = "";
  double coeff = 0;
  double offset = 0;
  DeviceMode deviceMode = DeviceMode.density;
  int measMode = 0;
  bool userCantDelete = false;

  MeasUnit({
   
    required this.id,
    required this.name,
    required this.coeff,
    required this.offset,
    required this.deviceMode,
    required this.measMode,
    required this.userCantDelete,
  });

  static bool compare(MeasUnit? first, MeasUnit? second){
    if(first == null || second == null){
      return false;
    }
    return first.coeff == second.coeff && first.offset == second.offset;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'coeff': coeff,
      'offset': offset,
      'deviceMode': deviceMode,
      'measMode': measMode,
      'userCantDelete': userCantDelete,
    };
  }

  static MeasUnit fromMap(Map<String, dynamic> map) {
    return MeasUnit(
      id: map['id'],
      name: map['name'],
      coeff: map['coeff'],
      offset: map['offset'],
      deviceMode: map['deviceMode'],
      measMode: map['measMode'],
      userCantDelete: map['userCantDelete'],
    );
  }
}