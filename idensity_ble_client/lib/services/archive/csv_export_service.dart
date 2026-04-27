import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:idensity_ble_client/models/charts/chart_line.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CsvExportService {
  static final _dtFile = DateFormat('yyyyMMdd_HHmmss');
  static final _dtDate = DateFormat('dd.MM.yyyy');
  static final _dtTime = DateFormat('HH:mm:ss');

  /// Returns saved file path on desktop, null on mobile (share sheet used).
  /// Returns null and does nothing if the user cancelled the save dialog.
  static Future<String?> export({
    required List<ChartLine> lines,
    required DateTime from,
    required DateTime to,
  }) async {
    final fileName = 'trend_${_dtFile.format(from)}_${_dtFile.format(to)}.csv';
    final content = _buildCsv(lines);

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final path = await FilePicker.platform.saveFile(
        dialogTitle: 'Сохранить тренд',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (path == null) return null;
      await File(path).writeAsString(content, encoding: utf8);
      return path;
    } else {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(content);
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'text/csv')],
        subject: fileName,
      );
      return null;
    }
  }

  static String _buildCsv(List<ChartLine> lines) {
    final buffer = StringBuffer();
    buffer.write('﻿'); // UTF-8 BOM — required for Excel to detect encoding
    buffer.writeln('Дата;Время;Устройство;Параметр;Значение');

    final rows = [
      for (final line in lines)
        for (final point in line.points)
          (
            dt: point.x,
            date: _dtDate.format(point.x),
            time: _dtTime.format(point.x),
            device: line.deviceName,
            param: getByIndexFromList(line.chartType.index, chartNames),
            value: point.y,
          ),
    ]..sort((a, b) => a.dt.compareTo(b.dt));

    for (final r in rows) {
      buffer.writeln('${r.date};${r.time};${r.device};${r.param};${r.value}');
    }
    return buffer.toString();
  }
}
