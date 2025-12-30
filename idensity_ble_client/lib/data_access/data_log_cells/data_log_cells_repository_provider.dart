import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/data_access/data_log_cells/data_log_cell_repository.dart';
import 'package:idensity_ble_client/data_access/app_database_provider.dart';

final dataLogCellsRepositoryProvider = Provider<DataLogCellRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DataLogCellRepository(db: db);
});