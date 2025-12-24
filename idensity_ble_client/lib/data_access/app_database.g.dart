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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DataLogCellsTable dataLogCells = $DataLogCellsTable(this);
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DataLogCellsTableTableManager get dataLogCells =>
      $$DataLogCellsTableTableManager(_db, _db.dataLogCells);
}
