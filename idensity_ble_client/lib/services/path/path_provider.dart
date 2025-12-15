import 'dart:developer';
import 'dart:io';

import 'package:idensity_ble_client/config.dart';
import 'package:path_provider/path_provider.dart';

Future<Directory> getLocalApplicationDocumentsDirectory() async {
  log("DE = $kDE");
  await Future.delayed(const Duration(seconds: 1));
  if (kDE == "embedded" && Platform.isLinux) {
    return Directory("/home/Documents/");
  } else {
    return getApplicationDocumentsDirectory();
  }
}
