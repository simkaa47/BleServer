import 'dart:io';

import 'package:idensity_ble_client/config.dart';
import 'package:path_provider/path_provider.dart';

Future<Directory> getLocalApplicationDocumentsDirectory() async {
  if (kDE == "embedded" && Platform.isLinux) {
    return Directory("/home/Documents/");
  } else {
    return getApplicationDocumentsDirectory();
  }
}
