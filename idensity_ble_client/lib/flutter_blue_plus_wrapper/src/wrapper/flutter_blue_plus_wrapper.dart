import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:idensity_ble_client/flutter_blue_plus_wrapper/src/windows/windows.dart';

class FlutterBluePlusWrapper  {
  static Future<void> startScan({
    List<Guid> withServices = const [],
    List<String> withRemoteIds = const [],
    List<String> withNames = const [],
    List<String> withKeywords = const [],
    List<MsdFilter> withMsd = const [],
    List<ServiceDataFilter> withServiceData = const [],
    Duration? timeout,
    Duration? removeIfGone,
    bool continuousUpdates = false,
    int continuousDivisor = 1,
    bool oneByOne = false,
    bool androidLegacy = false,
    AndroidScanMode androidScanMode = AndroidScanMode.lowLatency,
    bool androidUsesFineLocation = false,
  }) async {
    if (Platform.isWindows) {
      return await FlutterBluePlusWindows.startScan(
        withServices: withServices,
        withRemoteIds: withRemoteIds,
        withNames: withNames,
        withKeywords: withKeywords,
        withMsd: withMsd,
        withServiceData: withServiceData,
        timeout: timeout,
        removeIfGone: removeIfGone,
        continuousUpdates: continuousUpdates,
        continuousDivisor: continuousDivisor,
        oneByOne: oneByOne,
        androidLegacy: androidLegacy,
        androidScanMode: androidScanMode,
        androidUsesFineLocation: androidUsesFineLocation,
      );
    }

    return await FlutterBluePlus.startScan(
      withServices: withServices,
      withRemoteIds: withRemoteIds,
      withNames: withNames,
      withKeywords: withKeywords,
      withMsd: withMsd,
      withServiceData: withServiceData,
      timeout: timeout,
      removeIfGone: removeIfGone,
      continuousUpdates: continuousUpdates,
      continuousDivisor: continuousDivisor,
      oneByOne: oneByOne,
      androidLegacy: androidLegacy,
      androidScanMode: androidScanMode,
      androidUsesFineLocation: androidUsesFineLocation,
    );
  }

  static Stream<BluetoothAdapterState> get adapterState {
    if (Platform.isWindows) return FlutterBluePlusWindows.adapterState;
    return FlutterBluePlus.adapterState;
  }

  static Stream<List<ScanResult>> get scanResults {
    if (Platform.isWindows) return FlutterBluePlusWindows.scanResults;
    return FlutterBluePlus.scanResults;
  }

  static bool get isScanningNow {
    if (Platform.isWindows) return FlutterBluePlusWindows.isScanningNow;
    return FlutterBluePlus.isScanningNow;
  }

  static Stream<bool> get isScanning {
    if (Platform.isWindows) return FlutterBluePlusWindows.isScanning;
    return FlutterBluePlus.isScanning;
  }

  static Future<void> stopScan() async {
    if (Platform.isWindows) return await FlutterBluePlusWindows.stopScan();
    return await FlutterBluePlus.stopScan();
  }

  static Future<void> setLogLevel(LogLevel level, {color = true}) async {
    if (Platform.isWindows) {
      return FlutterBluePlusWindows.setLogLevel(level, color: color);
    }
    return FlutterBluePlus.setLogLevel(level, color: color);
  }
  
  static LogLevel get logLevel => FlutterBluePlus.logLevel;

  static Future<void> setOptions({
    bool restoreState = false,
    bool showPowerAlert = true,
  }) async {
    if (Platform.isWindows) return;
    FlutterBluePlus.setOptions(
      restoreState: restoreState,
      showPowerAlert: showPowerAlert,
    );
  }

  static Future<bool> get isSupported async {
    if (Platform.isWindows) return await FlutterBluePlusWindows.isSupported;
    return await FlutterBluePlus.isSupported;
  }

  static Future<String> get adapterName async {
    if (Platform.isWindows) return await FlutterBluePlusWindows.adapterName;
    return await FlutterBluePlus.adapterName;
  }

  static Future<void> turnOn({int timeout = 60}) async {
    if (Platform.isWindows) {
      return await FlutterBluePlusWindows.turnOn(timeout: timeout);
    }
    return await FlutterBluePlus.turnOn(timeout: timeout);
  }

  static List<BluetoothDevice> get connectedDevices {
    if (Platform.isWindows) return FlutterBluePlusWindows.connectedDevices;
    return FlutterBluePlus.connectedDevices;
  }

  static Future<List<BluetoothDevice>> systemDevices(
    List<Guid> withServices,
  ) async {    
    if (Platform.isWindows) return FlutterBluePlusWindows.connectedDevices;
    return await FlutterBluePlus.systemDevices(withServices);
  }

  static Future<PhySupport> getPhySupport() {
    return FlutterBluePlus.getPhySupport();
  }

  static Future<List<BluetoothDevice>> get bondedDevices async {
    if (Platform.isWindows) return FlutterBluePlusWindows.connectedDevices;
    return await FlutterBluePlus.bondedDevices;
  }

  static void cancelWhenScanComplete(StreamSubscription subscription) {
    if (Platform.isWindows) {
      return FlutterBluePlusWindows.cancelWhenScanComplete(subscription);
    }
    return FlutterBluePlus.cancelWhenScanComplete(subscription);
  }
}
