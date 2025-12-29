// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DataLogCellsTable extends DataLogCells
    with TableInfo<$DataLogCellsTable, DataLogCell> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DataLogCellsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _deviceNameMeta = const VerificationMeta(
    'deviceName',
  );
  @override
  late final GeneratedColumn<String> deviceName = GeneratedColumn<String>(
    'device_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chartTypeMeta = const VerificationMeta(
    'chartType',
  );
  @override
  late final GeneratedColumn<int> chartType = GeneratedColumn<int>(
    'chart_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dtMeta = const VerificationMeta('dt');
  @override
  late final GeneratedColumn<DateTime> dt = GeneratedColumn<DateTime>(
    'dt',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, deviceName, chartType, dt, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'data_log_cells';
  @override
  VerificationContext validateIntegrity(
    Insertable<DataLogCell> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_name')) {
      context.handle(
        _deviceNameMeta,
        deviceName.isAcceptableOrUnknown(data['device_name']!, _deviceNameMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceNameMeta);
    }
    if (data.containsKey('chart_type')) {
      context.handle(
        _chartTypeMeta,
        chartType.isAcceptableOrUnknown(data['chart_type']!, _chartTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_chartTypeMeta);
    }
    if (data.containsKey('dt')) {
      context.handle(_dtMeta, dt.isAcceptableOrUnknown(data['dt']!, _dtMeta));
    } else if (isInserting) {
      context.missing(_dtMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DataLogCell map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DataLogCell(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      deviceName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}device_name'],
          )!,
      chartType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}chart_type'],
          )!,
      dt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}dt'],
          )!,
      value:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}value'],
          )!,
    );
  }

  @override
  $DataLogCellsTable createAlias(String alias) {
    return $DataLogCellsTable(attachedDatabase, alias);
  }
}

class DataLogCell extends DataClass implements Insertable<DataLogCell> {
  final int id;
  final String deviceName;
  final int chartType;
  final DateTime dt;
  final double value;
  const DataLogCell({
    required this.id,
    required this.deviceName,
    required this.chartType,
    required this.dt,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_name'] = Variable<String>(deviceName);
    map['chart_type'] = Variable<int>(chartType);
    map['dt'] = Variable<DateTime>(dt);
    map['value'] = Variable<double>(value);
    return map;
  }

  DataLogCellsCompanion toCompanion(bool nullToAbsent) {
    return DataLogCellsCompanion(
      id: Value(id),
      deviceName: Value(deviceName),
      chartType: Value(chartType),
      dt: Value(dt),
      value: Value(value),
    );
  }

  factory DataLogCell.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DataLogCell(
      id: serializer.fromJson<int>(json['id']),
      deviceName: serializer.fromJson<String>(json['deviceName']),
      chartType: serializer.fromJson<int>(json['chartType']),
      dt: serializer.fromJson<DateTime>(json['dt']),
      value: serializer.fromJson<double>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceName': serializer.toJson<String>(deviceName),
      'chartType': serializer.toJson<int>(chartType),
      'dt': serializer.toJson<DateTime>(dt),
      'value': serializer.toJson<double>(value),
    };
  }

  DataLogCell copyWith({
    int? id,
    String? deviceName,
    int? chartType,
    DateTime? dt,
    double? value,
  }) => DataLogCell(
    id: id ?? this.id,
    deviceName: deviceName ?? this.deviceName,
    chartType: chartType ?? this.chartType,
    dt: dt ?? this.dt,
    value: value ?? this.value,
  );
  DataLogCell copyWithCompanion(DataLogCellsCompanion data) {
    return DataLogCell(
      id: data.id.present ? data.id.value : this.id,
      deviceName:
          data.deviceName.present ? data.deviceName.value : this.deviceName,
      chartType: data.chartType.present ? data.chartType.value : this.chartType,
      dt: data.dt.present ? data.dt.value : this.dt,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DataLogCell(')
          ..write('id: $id, ')
          ..write('deviceName: $deviceName, ')
          ..write('chartType: $chartType, ')
          ..write('dt: $dt, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deviceName, chartType, dt, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DataLogCell &&
          other.id == this.id &&
          other.deviceName == this.deviceName &&
          other.chartType == this.chartType &&
          other.dt == this.dt &&
          other.value == this.value);
}

class DataLogCellsCompanion extends UpdateCompanion<DataLogCell> {
  final Value<int> id;
  final Value<String> deviceName;
  final Value<int> chartType;
  final Value<DateTime> dt;
  final Value<double> value;
  const DataLogCellsCompanion({
    this.id = const Value.absent(),
    this.deviceName = const Value.absent(),
    this.chartType = const Value.absent(),
    this.dt = const Value.absent(),
    this.value = const Value.absent(),
  });
  DataLogCellsCompanion.insert({
    this.id = const Value.absent(),
    required String deviceName,
    required int chartType,
    required DateTime dt,
    required double value,
  }) : deviceName = Value(deviceName),
       chartType = Value(chartType),
       dt = Value(dt),
       value = Value(value);
  static Insertable<DataLogCell> custom({
    Expression<int>? id,
    Expression<String>? deviceName,
    Expression<int>? chartType,
    Expression<DateTime>? dt,
    Expression<double>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceName != null) 'device_name': deviceName,
      if (chartType != null) 'chart_type': chartType,
      if (dt != null) 'dt': dt,
      if (value != null) 'value': value,
    });
  }

  DataLogCellsCompanion copyWith({
    Value<int>? id,
    Value<String>? deviceName,
    Value<int>? chartType,
    Value<DateTime>? dt,
    Value<double>? value,
  }) {
    return DataLogCellsCompanion(
      id: id ?? this.id,
      deviceName: deviceName ?? this.deviceName,
      chartType: chartType ?? this.chartType,
      dt: dt ?? this.dt,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceName.present) {
      map['device_name'] = Variable<String>(deviceName.value);
    }
    if (chartType.present) {
      map['chart_type'] = Variable<int>(chartType.value);
    }
    if (dt.present) {
      map['dt'] = Variable<DateTime>(dt.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DataLogCellsCompanion(')
          ..write('id: $id, ')
          ..write('deviceName: $deviceName, ')
          ..write('chartType: $chartType, ')
          ..write('dt: $dt, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $CommonSettingsTable extends CommonSettings
    with TableInfo<$CommonSettingsTable, CommonSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommonSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _maxChartWindowSecMeta = const VerificationMeta(
    'maxChartWindowSec',
  );
  @override
  late final GeneratedColumn<int> maxChartWindowSec = GeneratedColumn<int>(
    'max_chart_window_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _darkModeMeta = const VerificationMeta(
    'darkMode',
  );
  @override
  late final GeneratedColumn<bool> darkMode = GeneratedColumn<bool>(
    'dark_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dark_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, maxChartWindowSec, darkMode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'common_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<CommonSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('max_chart_window_sec')) {
      context.handle(
        _maxChartWindowSecMeta,
        maxChartWindowSec.isAcceptableOrUnknown(
          data['max_chart_window_sec']!,
          _maxChartWindowSecMeta,
        ),
      );
    }
    if (data.containsKey('dark_mode')) {
      context.handle(
        _darkModeMeta,
        darkMode.isAcceptableOrUnknown(data['dark_mode']!, _darkModeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CommonSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommonSetting(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      maxChartWindowSec:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}max_chart_window_sec'],
          )!,
      darkMode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}dark_mode'],
          )!,
    );
  }

  @override
  $CommonSettingsTable createAlias(String alias) {
    return $CommonSettingsTable(attachedDatabase, alias);
  }
}

class CommonSetting extends DataClass implements Insertable<CommonSetting> {
  final int id;
  final int maxChartWindowSec;
  final bool darkMode;
  const CommonSetting({
    required this.id,
    required this.maxChartWindowSec,
    required this.darkMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['max_chart_window_sec'] = Variable<int>(maxChartWindowSec);
    map['dark_mode'] = Variable<bool>(darkMode);
    return map;
  }

  CommonSettingsCompanion toCompanion(bool nullToAbsent) {
    return CommonSettingsCompanion(
      id: Value(id),
      maxChartWindowSec: Value(maxChartWindowSec),
      darkMode: Value(darkMode),
    );
  }

  factory CommonSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommonSetting(
      id: serializer.fromJson<int>(json['id']),
      maxChartWindowSec: serializer.fromJson<int>(json['maxChartWindowSec']),
      darkMode: serializer.fromJson<bool>(json['darkMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'maxChartWindowSec': serializer.toJson<int>(maxChartWindowSec),
      'darkMode': serializer.toJson<bool>(darkMode),
    };
  }

  CommonSetting copyWith({int? id, int? maxChartWindowSec, bool? darkMode}) =>
      CommonSetting(
        id: id ?? this.id,
        maxChartWindowSec: maxChartWindowSec ?? this.maxChartWindowSec,
        darkMode: darkMode ?? this.darkMode,
      );
  CommonSetting copyWithCompanion(CommonSettingsCompanion data) {
    return CommonSetting(
      id: data.id.present ? data.id.value : this.id,
      maxChartWindowSec:
          data.maxChartWindowSec.present
              ? data.maxChartWindowSec.value
              : this.maxChartWindowSec,
      darkMode: data.darkMode.present ? data.darkMode.value : this.darkMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommonSetting(')
          ..write('id: $id, ')
          ..write('maxChartWindowSec: $maxChartWindowSec, ')
          ..write('darkMode: $darkMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, maxChartWindowSec, darkMode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommonSetting &&
          other.id == this.id &&
          other.maxChartWindowSec == this.maxChartWindowSec &&
          other.darkMode == this.darkMode);
}

class CommonSettingsCompanion extends UpdateCompanion<CommonSetting> {
  final Value<int> id;
  final Value<int> maxChartWindowSec;
  final Value<bool> darkMode;
  const CommonSettingsCompanion({
    this.id = const Value.absent(),
    this.maxChartWindowSec = const Value.absent(),
    this.darkMode = const Value.absent(),
  });
  CommonSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.maxChartWindowSec = const Value.absent(),
    this.darkMode = const Value.absent(),
  });
  static Insertable<CommonSetting> custom({
    Expression<int>? id,
    Expression<int>? maxChartWindowSec,
    Expression<bool>? darkMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (maxChartWindowSec != null) 'max_chart_window_sec': maxChartWindowSec,
      if (darkMode != null) 'dark_mode': darkMode,
    });
  }

  CommonSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? maxChartWindowSec,
    Value<bool>? darkMode,
  }) {
    return CommonSettingsCompanion(
      id: id ?? this.id,
      maxChartWindowSec: maxChartWindowSec ?? this.maxChartWindowSec,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (maxChartWindowSec.present) {
      map['max_chart_window_sec'] = Variable<int>(maxChartWindowSec.value);
    }
    if (darkMode.present) {
      map['dark_mode'] = Variable<bool>(darkMode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommonSettingsCompanion(')
          ..write('id: $id, ')
          ..write('maxChartWindowSec: $maxChartWindowSec, ')
          ..write('darkMode: $darkMode')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DataLogCellsTable dataLogCells = $DataLogCellsTable(this);
  late final $CommonSettingsTable commonSettings = $CommonSettingsTable(this);
  late final Index idxDeviceTypeDt = Index(
    'idx_device_type_dt',
    'CREATE INDEX idx_device_type_dt ON data_log_cells (device_name, chart_type, dt)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dataLogCells,
    commonSettings,
    idxDeviceTypeDt,
  ];
}

typedef $$DataLogCellsTableCreateCompanionBuilder =
    DataLogCellsCompanion Function({
      Value<int> id,
      required String deviceName,
      required int chartType,
      required DateTime dt,
      required double value,
    });
typedef $$DataLogCellsTableUpdateCompanionBuilder =
    DataLogCellsCompanion Function({
      Value<int> id,
      Value<String> deviceName,
      Value<int> chartType,
      Value<DateTime> dt,
      Value<double> value,
    });

class $$DataLogCellsTableFilterComposer
    extends Composer<_$AppDatabase, $DataLogCellsTable> {
  $$DataLogCellsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chartType => $composableBuilder(
    column: $table.chartType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dt => $composableBuilder(
    column: $table.dt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DataLogCellsTableOrderingComposer
    extends Composer<_$AppDatabase, $DataLogCellsTable> {
  $$DataLogCellsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chartType => $composableBuilder(
    column: $table.chartType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dt => $composableBuilder(
    column: $table.dt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DataLogCellsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DataLogCellsTable> {
  $$DataLogCellsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chartType =>
      $composableBuilder(column: $table.chartType, builder: (column) => column);

  GeneratedColumn<DateTime> get dt =>
      $composableBuilder(column: $table.dt, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$DataLogCellsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DataLogCellsTable,
          DataLogCell,
          $$DataLogCellsTableFilterComposer,
          $$DataLogCellsTableOrderingComposer,
          $$DataLogCellsTableAnnotationComposer,
          $$DataLogCellsTableCreateCompanionBuilder,
          $$DataLogCellsTableUpdateCompanionBuilder,
          (
            DataLogCell,
            BaseReferences<_$AppDatabase, $DataLogCellsTable, DataLogCell>,
          ),
          DataLogCell,
          PrefetchHooks Function()
        > {
  $$DataLogCellsTableTableManager(_$AppDatabase db, $DataLogCellsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$DataLogCellsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$DataLogCellsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$DataLogCellsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> deviceName = const Value.absent(),
                Value<int> chartType = const Value.absent(),
                Value<DateTime> dt = const Value.absent(),
                Value<double> value = const Value.absent(),
              }) => DataLogCellsCompanion(
                id: id,
                deviceName: deviceName,
                chartType: chartType,
                dt: dt,
                value: value,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String deviceName,
                required int chartType,
                required DateTime dt,
                required double value,
              }) => DataLogCellsCompanion.insert(
                id: id,
                deviceName: deviceName,
                chartType: chartType,
                dt: dt,
                value: value,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DataLogCellsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DataLogCellsTable,
      DataLogCell,
      $$DataLogCellsTableFilterComposer,
      $$DataLogCellsTableOrderingComposer,
      $$DataLogCellsTableAnnotationComposer,
      $$DataLogCellsTableCreateCompanionBuilder,
      $$DataLogCellsTableUpdateCompanionBuilder,
      (
        DataLogCell,
        BaseReferences<_$AppDatabase, $DataLogCellsTable, DataLogCell>,
      ),
      DataLogCell,
      PrefetchHooks Function()
    >;
typedef $$CommonSettingsTableCreateCompanionBuilder =
    CommonSettingsCompanion Function({
      Value<int> id,
      Value<int> maxChartWindowSec,
      Value<bool> darkMode,
    });
typedef $$CommonSettingsTableUpdateCompanionBuilder =
    CommonSettingsCompanion Function({
      Value<int> id,
      Value<int> maxChartWindowSec,
      Value<bool> darkMode,
    });

class $$CommonSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $CommonSettingsTable> {
  $$CommonSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxChartWindowSec => $composableBuilder(
    column: $table.maxChartWindowSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get darkMode => $composableBuilder(
    column: $table.darkMode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CommonSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $CommonSettingsTable> {
  $$CommonSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxChartWindowSec => $composableBuilder(
    column: $table.maxChartWindowSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get darkMode => $composableBuilder(
    column: $table.darkMode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CommonSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CommonSettingsTable> {
  $$CommonSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get maxChartWindowSec => $composableBuilder(
    column: $table.maxChartWindowSec,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get darkMode =>
      $composableBuilder(column: $table.darkMode, builder: (column) => column);
}

class $$CommonSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CommonSettingsTable,
          CommonSetting,
          $$CommonSettingsTableFilterComposer,
          $$CommonSettingsTableOrderingComposer,
          $$CommonSettingsTableAnnotationComposer,
          $$CommonSettingsTableCreateCompanionBuilder,
          $$CommonSettingsTableUpdateCompanionBuilder,
          (
            CommonSetting,
            BaseReferences<_$AppDatabase, $CommonSettingsTable, CommonSetting>,
          ),
          CommonSetting,
          PrefetchHooks Function()
        > {
  $$CommonSettingsTableTableManager(
    _$AppDatabase db,
    $CommonSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CommonSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$CommonSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CommonSettingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> maxChartWindowSec = const Value.absent(),
                Value<bool> darkMode = const Value.absent(),
              }) => CommonSettingsCompanion(
                id: id,
                maxChartWindowSec: maxChartWindowSec,
                darkMode: darkMode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> maxChartWindowSec = const Value.absent(),
                Value<bool> darkMode = const Value.absent(),
              }) => CommonSettingsCompanion.insert(
                id: id,
                maxChartWindowSec: maxChartWindowSec,
                darkMode: darkMode,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CommonSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CommonSettingsTable,
      CommonSetting,
      $$CommonSettingsTableFilterComposer,
      $$CommonSettingsTableOrderingComposer,
      $$CommonSettingsTableAnnotationComposer,
      $$CommonSettingsTableCreateCompanionBuilder,
      $$CommonSettingsTableUpdateCompanionBuilder,
      (
        CommonSetting,
        BaseReferences<_$AppDatabase, $CommonSettingsTable, CommonSetting>,
      ),
      CommonSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DataLogCellsTableTableManager get dataLogCells =>
      $$DataLogCellsTableTableManager(_db, _db.dataLogCells);
  $$CommonSettingsTableTableManager get commonSettings =>
      $$CommonSettingsTableTableManager(_db, _db.commonSettings);
}
