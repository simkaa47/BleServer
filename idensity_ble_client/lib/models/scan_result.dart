class IdensityScanResult {
  String macAddress = "NOT INFO";
}

class BlueScanResult extends IdensityScanResult{
  String advName = "";  
}

class EthernetScanResult extends IdensityScanResult{
  String ip = "0.0.0.0";
}



