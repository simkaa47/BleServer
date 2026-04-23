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

class $MeasUnitRowsTable extends MeasUnitRows
    with TableInfo<$MeasUnitRowsTable, MeasUnitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasUnitRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coeffMeta = const VerificationMeta('coeff');
  @override
  late final GeneratedColumn<double> coeff = GeneratedColumn<double>(
    'coeff',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _offsetMeta = const VerificationMeta('offset');
  @override
  late final GeneratedColumn<double> offset = GeneratedColumn<double>(
    'offset',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceModeMeta = const VerificationMeta(
    'deviceMode',
  );
  @override
  late final GeneratedColumn<int> deviceMode = GeneratedColumn<int>(
    'device_mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measModeMeta = const VerificationMeta(
    'measMode',
  );
  @override
  late final GeneratedColumn<int> measMode = GeneratedColumn<int>(
    'meas_mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userCantDeleteMeta = const VerificationMeta(
    'userCantDelete',
  );
  @override
  late final GeneratedColumn<bool> userCantDelete = GeneratedColumn<bool>(
    'user_cant_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("user_cant_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    coeff,
    offset,
    deviceMode,
    measMode,
    userCantDelete,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meas_unit_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeasUnitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('coeff')) {
      context.handle(
        _coeffMeta,
        coeff.isAcceptableOrUnknown(data['coeff']!, _coeffMeta),
      );
    } else if (isInserting) {
      context.missing(_coeffMeta);
    }
    if (data.containsKey('offset')) {
      context.handle(
        _offsetMeta,
        offset.isAcceptableOrUnknown(data['offset']!, _offsetMeta),
      );
    } else if (isInserting) {
      context.missing(_offsetMeta);
    }
    if (data.containsKey('device_mode')) {
      context.handle(
        _deviceModeMeta,
        deviceMode.isAcceptableOrUnknown(data['device_mode']!, _deviceModeMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceModeMeta);
    }
    if (data.containsKey('meas_mode')) {
      context.handle(
        _measModeMeta,
        measMode.isAcceptableOrUnknown(data['meas_mode']!, _measModeMeta),
      );
    } else if (isInserting) {
      context.missing(_measModeMeta);
    }
    if (data.containsKey('user_cant_delete')) {
      context.handle(
        _userCantDeleteMeta,
        userCantDelete.isAcceptableOrUnknown(
          data['user_cant_delete']!,
          _userCantDeleteMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeasUnitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeasUnitRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      coeff:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}coeff'],
          )!,
      offset:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}offset'],
          )!,
      deviceMode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}device_mode'],
          )!,
      measMode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}meas_mode'],
          )!,
      userCantDelete:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}user_cant_delete'],
          )!,
    );
  }

  @override
  $MeasUnitRowsTable createAlias(String alias) {
    return $MeasUnitRowsTable(attachedDatabase, alias);
  }
}

class MeasUnitRow extends DataClass implements Insertable<MeasUnitRow> {
  final int id;
  final String name;
  final double coeff;
  final double offset;
  final int deviceMode;
  final int measMode;
  final bool userCantDelete;
  const MeasUnitRow({
    required this.id,
    required this.name,
    required this.coeff,
    required this.offset,
    required this.deviceMode,
    required this.measMode,
    required this.userCantDelete,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['coeff'] = Variable<double>(coeff);
    map['offset'] = Variable<double>(offset);
    map['device_mode'] = Variable<int>(deviceMode);
    map['meas_mode'] = Variable<int>(measMode);
    map['user_cant_delete'] = Variable<bool>(userCantDelete);
    return map;
  }

  MeasUnitRowsCompanion toCompanion(bool nullToAbsent) {
    return MeasUnitRowsCompanion(
      id: Value(id),
      name: Value(name),
      coeff: Value(coeff),
      offset: Value(offset),
      deviceMode: Value(deviceMode),
      measMode: Value(measMode),
      userCantDelete: Value(userCantDelete),
    );
  }

  factory MeasUnitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeasUnitRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      coeff: serializer.fromJson<double>(json['coeff']),
      offset: serializer.fromJson<double>(json['offset']),
      deviceMode: serializer.fromJson<int>(json['deviceMode']),
      measMode: serializer.fromJson<int>(json['measMode']),
      userCantDelete: serializer.fromJson<bool>(json['userCantDelete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'coeff': serializer.toJson<double>(coeff),
      'offset': serializer.toJson<double>(offset),
      'deviceMode': serializer.toJson<int>(deviceMode),
      'measMode': serializer.toJson<int>(measMode),
      'userCantDelete': serializer.toJson<bool>(userCantDelete),
    };
  }

  MeasUnitRow copyWith({
    int? id,
    String? name,
    double? coeff,
    double? offset,
    int? deviceMode,
    int? measMode,
    bool? userCantDelete,
  }) => MeasUnitRow(
    id: id ?? this.id,
    name: name ?? this.name,
    coeff: coeff ?? this.coeff,
    offset: offset ?? this.offset,
    deviceMode: deviceMode ?? this.deviceMode,
    measMode: measMode ?? this.measMode,
    userCantDelete: userCantDelete ?? this.userCantDelete,
  );
  MeasUnitRow copyWithCompanion(MeasUnitRowsCompanion data) {
    return MeasUnitRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      coeff: data.coeff.present ? data.coeff.value : this.coeff,
      offset: data.offset.present ? data.offset.value : this.offset,
      deviceMode:
          data.deviceMode.present ? data.deviceMode.value : this.deviceMode,
      measMode: data.measMode.present ? data.measMode.value : this.measMode,
      userCantDelete:
          data.userCantDelete.present
              ? data.userCantDelete.value
              : this.userCantDelete,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeasUnitRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('coeff: $coeff, ')
          ..write('offset: $offset, ')
          ..write('deviceMode: $deviceMode, ')
          ..write('measMode: $measMode, ')
          ..write('userCantDelete: $userCantDelete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    coeff,
    offset,
    deviceMode,
    measMode,
    userCantDelete,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasUnitRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.coeff == this.coeff &&
          other.offset == this.offset &&
          other.deviceMode == this.deviceMode &&
          other.measMode == this.measMode &&
          other.userCantDelete == this.userCantDelete);
}

class MeasUnitRowsCompanion extends UpdateCompanion<MeasUnitRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> coeff;
  final Value<double> offset;
  final Value<int> deviceMode;
  final Value<int> measMode;
  final Value<bool> userCantDelete;
  const MeasUnitRowsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.coeff = const Value.absent(),
    this.offset = const Value.absent(),
    this.deviceMode = const Value.absent(),
    this.measMode = const Value.absent(),
    this.userCantDelete = const Value.absent(),
  });
  MeasUnitRowsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double coeff,
    required double offset,
    required int deviceMode,
    required int measMode,
    this.userCantDelete = const Value.absent(),
  }) : name = Value(name),
       coeff = Value(coeff),
       offset = Value(offset),
       deviceMode = Value(deviceMode),
       measMode = Value(measMode);
  static Insertable<MeasUnitRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? coeff,
    Expression<double>? offset,
    Expression<int>? deviceMode,
    Expression<int>? measMode,
    Expression<bool>? userCantDelete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (coeff != null) 'coeff': coeff,
      if (offset != null) 'offset': offset,
      if (deviceMode != null) 'device_mode': deviceMode,
      if (measMode != null) 'meas_mode': measMode,
      if (userCantDelete != null) 'user_cant_delete': userCantDelete,
    });
  }

  MeasUnitRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? coeff,
    Value<double>? offset,
    Value<int>? deviceMode,
    Value<int>? measMode,
    Value<bool>? userCantDelete,
  }) {
    return MeasUnitRowsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      coeff: coeff ?? this.coeff,
      offset: offset ?? this.offset,
      deviceMode: deviceMode ?? this.deviceMode,
      measMode: measMode ?? this.measMode,
      userCantDelete: userCantDelete ?? this.userCantDelete,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (coeff.present) {
      map['coeff'] = Variable<double>(coeff.value);
    }
    if (offset.present) {
      map['offset'] = Variable<double>(offset.value);
    }
    if (deviceMode.present) {
      map['device_mode'] = Variable<int>(deviceMode.value);
    }
    if (measMode.present) {
      map['meas_mode'] = Variable<int>(measMode.value);
    }
    if (userCantDelete.present) {
      map['user_cant_delete'] = Variable<bool>(userCantDelete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasUnitRowsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('coeff: $coeff, ')
          ..write('offset: $offset, ')
          ..write('deviceMode: $deviceMode, ')
          ..write('measMode: $measMode, ')
          ..write('userCantDelete: $userCantDelete')
          ..write(')'))
        .toString();
  }
}

class $DeviceRowsTable extends DeviceRows
    with TableInfo<$DeviceRowsTable, DeviceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _connectionTypeMeta = const VerificationMeta(
    'connectionType',
  );
  @override
  late final GeneratedColumn<int> connectionType = GeneratedColumn<int>(
    'connection_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _macAddressMeta = const VerificationMeta(
    'macAddress',
  );
  @override
  late final GeneratedColumn<String> macAddress = GeneratedColumn<String>(
    'mac_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ipMeta = const VerificationMeta('ip');
  @override
  late final GeneratedColumn<String> ip = GeneratedColumn<String>(
    'ip',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    connectionType,
    macAddress,
    ip,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('connection_type')) {
      context.handle(
        _connectionTypeMeta,
        connectionType.isAcceptableOrUnknown(
          data['connection_type']!,
          _connectionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectionTypeMeta);
    }
    if (data.containsKey('mac_address')) {
      context.handle(
        _macAddressMeta,
        macAddress.isAcceptableOrUnknown(data['mac_address']!, _macAddressMeta),
      );
    } else if (isInserting) {
      context.missing(_macAddressMeta);
    }
    if (data.containsKey('ip')) {
      context.handle(_ipMeta, ip.isAcceptableOrUnknown(data['ip']!, _ipMeta));
    } else if (isInserting) {
      context.missing(_ipMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      connectionType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}connection_type'],
          )!,
      macAddress:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}mac_address'],
          )!,
      ip:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}ip'],
          )!,
    );
  }

  @override
  $DeviceRowsTable createAlias(String alias) {
    return $DeviceRowsTable(attachedDatabase, alias);
  }
}

class DeviceRow extends DataClass implements Insertable<DeviceRow> {
  final int id;
  final String name;
  final int connectionType;
  final String macAddress;
  final String ip;
  const DeviceRow({
    required this.id,
    required this.name,
    required this.connectionType,
    required this.macAddress,
    required this.ip,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['connection_type'] = Variable<int>(connectionType);
    map['mac_address'] = Variable<String>(macAddress);
    map['ip'] = Variable<String>(ip);
    return map;
  }

  DeviceRowsCompanion toCompanion(bool nullToAbsent) {
    return DeviceRowsCompanion(
      id: Value(id),
      name: Value(name),
      connectionType: Value(connectionType),
      macAddress: Value(macAddress),
      ip: Value(ip),
    );
  }

  factory DeviceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      connectionType: serializer.fromJson<int>(json['connectionType']),
      macAddress: serializer.fromJson<String>(json['macAddress']),
      ip: serializer.fromJson<String>(json['ip']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'connectionType': serializer.toJson<int>(connectionType),
      'macAddress': serializer.toJson<String>(macAddress),
      'ip': serializer.toJson<String>(ip),
    };
  }

  DeviceRow copyWith({
    int? id,
    String? name,
    int? connectionType,
    String? macAddress,
    String? ip,
  }) => DeviceRow(
    id: id ?? this.id,
    name: name ?? this.name,
    connectionType: connectionType ?? this.connectionType,
    macAddress: macAddress ?? this.macAddress,
    ip: ip ?? this.ip,
  );
  DeviceRow copyWithCompanion(DeviceRowsCompanion data) {
    return DeviceRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      connectionType:
          data.connectionType.present
              ? data.connectionType.value
              : this.connectionType,
      macAddress:
          data.macAddress.present ? data.macAddress.value : this.macAddress,
      ip: data.ip.present ? data.ip.value : this.ip,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('connectionType: $connectionType, ')
          ..write('macAddress: $macAddress, ')
          ..write('ip: $ip')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, connectionType, macAddress, ip);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.connectionType == this.connectionType &&
          other.macAddress == this.macAddress &&
          other.ip == this.ip);
}

class DeviceRowsCompanion extends UpdateCompanion<DeviceRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> connectionType;
  final Value<String> macAddress;
  final Value<String> ip;
  const DeviceRowsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.connectionType = const Value.absent(),
    this.macAddress = const Value.absent(),
    this.ip = const Value.absent(),
  });
  DeviceRowsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int connectionType,
    required String macAddress,
    required String ip,
  }) : name = Value(name),
       connectionType = Value(connectionType),
       macAddress = Value(macAddress),
       ip = Value(ip);
  static Insertable<DeviceRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? connectionType,
    Expression<String>? macAddress,
    Expression<String>? ip,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (connectionType != null) 'connection_type': connectionType,
      if (macAddress != null) 'mac_address': macAddress,
      if (ip != null) 'ip': ip,
    });
  }

  DeviceRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? connectionType,
    Value<String>? macAddress,
    Value<String>? ip,
  }) {
    return DeviceRowsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      connectionType: connectionType ?? this.connectionType,
      macAddress: macAddress ?? this.macAddress,
      ip: ip ?? this.ip,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (connectionType.present) {
      map['connection_type'] = Variable<int>(connectionType.value);
    }
    if (macAddress.present) {
      map['mac_address'] = Variable<String>(macAddress.value);
    }
    if (ip.present) {
      map['ip'] = Variable<String>(ip.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceRowsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('connectionType: $connectionType, ')
          ..write('macAddress: $macAddress, ')
          ..write('ip: $ip')
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

class $ChartSettingTableRowsTable extends ChartSettingTableRows
    with TableInfo<$ChartSettingTableRowsTable, ChartSettingTableRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChartSettingTableRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceNameMeta = const VerificationMeta(
    'deviceName',
  );
  @override
  late final GeneratedColumn<String> deviceName = GeneratedColumn<String>(
    'device_name',
    aliasedName,
    false,
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
  static const VerificationMeta _rightAxisMeta = const VerificationMeta(
    'rightAxis',
  );
  @override
  late final GeneratedColumn<bool> rightAxis = GeneratedColumn<bool>(
    'right_axis',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("right_axis" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    color,
    deviceName,
    chartType,
    rightAxis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chart_setting_table_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChartSettingTableRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
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
    if (data.containsKey('right_axis')) {
      context.handle(
        _rightAxisMeta,
        rightAxis.isAcceptableOrUnknown(data['right_axis']!, _rightAxisMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChartSettingTableRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChartSettingTableRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      color:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}color'],
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
      rightAxis:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}right_axis'],
          )!,
    );
  }

  @override
  $ChartSettingTableRowsTable createAlias(String alias) {
    return $ChartSettingTableRowsTable(attachedDatabase, alias);
  }
}

class ChartSettingTableRow extends DataClass
    implements Insertable<ChartSettingTableRow> {
  final int id;
  final String color;
  final String deviceName;
  final int chartType;
  final bool rightAxis;
  const ChartSettingTableRow({
    required this.id,
    required this.color,
    required this.deviceName,
    required this.chartType,
    required this.rightAxis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['color'] = Variable<String>(color);
    map['device_name'] = Variable<String>(deviceName);
    map['chart_type'] = Variable<int>(chartType);
    map['right_axis'] = Variable<bool>(rightAxis);
    return map;
  }

  ChartSettingTableRowsCompanion toCompanion(bool nullToAbsent) {
    return ChartSettingTableRowsCompanion(
      id: Value(id),
      color: Value(color),
      deviceName: Value(deviceName),
      chartType: Value(chartType),
      rightAxis: Value(rightAxis),
    );
  }

  factory ChartSettingTableRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChartSettingTableRow(
      id: serializer.fromJson<int>(json['id']),
      color: serializer.fromJson<String>(json['color']),
      deviceName: serializer.fromJson<String>(json['deviceName']),
      chartType: serializer.fromJson<int>(json['chartType']),
      rightAxis: serializer.fromJson<bool>(json['rightAxis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'color': serializer.toJson<String>(color),
      'deviceName': serializer.toJson<String>(deviceName),
      'chartType': serializer.toJson<int>(chartType),
      'rightAxis': serializer.toJson<bool>(rightAxis),
    };
  }

  ChartSettingTableRow copyWith({
    int? id,
    String? color,
    String? deviceName,
    int? chartType,
    bool? rightAxis,
  }) => ChartSettingTableRow(
    id: id ?? this.id,
    color: color ?? this.color,
    deviceName: deviceName ?? this.deviceName,
    chartType: chartType ?? this.chartType,
    rightAxis: rightAxis ?? this.rightAxis,
  );
  ChartSettingTableRow copyWithCompanion(ChartSettingTableRowsCompanion data) {
    return ChartSettingTableRow(
      id: data.id.present ? data.id.value : this.id,
      color: data.color.present ? data.color.value : this.color,
      deviceName:
          data.deviceName.present ? data.deviceName.value : this.deviceName,
      chartType: data.chartType.present ? data.chartType.value : this.chartType,
      rightAxis: data.rightAxis.present ? data.rightAxis.value : this.rightAxis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChartSettingTableRow(')
          ..write('id: $id, ')
          ..write('color: $color, ')
          ..write('deviceName: $deviceName, ')
          ..write('chartType: $chartType, ')
          ..write('rightAxis: $rightAxis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, color, deviceName, chartType, rightAxis);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChartSettingTableRow &&
          other.id == this.id &&
          other.color == this.color &&
          other.deviceName == this.deviceName &&
          other.chartType == this.chartType &&
          other.rightAxis == this.rightAxis);
}

class ChartSettingTableRowsCompanion
    extends UpdateCompanion<ChartSettingTableRow> {
  final Value<int> id;
  final Value<String> color;
  final Value<String> deviceName;
  final Value<int> chartType;
  final Value<bool> rightAxis;
  const ChartSettingTableRowsCompanion({
    this.id = const Value.absent(),
    this.color = const Value.absent(),
    this.deviceName = const Value.absent(),
    this.chartType = const Value.absent(),
    this.rightAxis = const Value.absent(),
  });
  ChartSettingTableRowsCompanion.insert({
    this.id = const Value.absent(),
    required String color,
    required String deviceName,
    required int chartType,
    this.rightAxis = const Value.absent(),
  }) : color = Value(color),
       deviceName = Value(deviceName),
       chartType = Value(chartType);
  static Insertable<ChartSettingTableRow> custom({
    Expression<int>? id,
    Expression<String>? color,
    Expression<String>? deviceName,
    Expression<int>? chartType,
    Expression<bool>? rightAxis,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (color != null) 'color': color,
      if (deviceName != null) 'device_name': deviceName,
      if (chartType != null) 'chart_type': chartType,
      if (rightAxis != null) 'right_axis': rightAxis,
    });
  }

  ChartSettingTableRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? color,
    Value<String>? deviceName,
    Value<int>? chartType,
    Value<bool>? rightAxis,
  }) {
    return ChartSettingTableRowsCompanion(
      id: id ?? this.id,
      color: color ?? this.color,
      deviceName: deviceName ?? this.deviceName,
      chartType: chartType ?? this.chartType,
      rightAxis: rightAxis ?? this.rightAxis,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (deviceName.present) {
      map['device_name'] = Variable<String>(deviceName.value);
    }
    if (chartType.present) {
      map['chart_type'] = Variable<int>(chartType.value);
    }
    if (rightAxis.present) {
      map['right_axis'] = Variable<bool>(rightAxis.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChartSettingTableRowsCompanion(')
          ..write('id: $id, ')
          ..write('color: $color, ')
          ..write('deviceName: $deviceName, ')
          ..write('chartType: $chartType, ')
          ..write('rightAxis: $rightAxis')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DataLogCellsTable dataLogCells = $DataLogCellsTable(this);
  late final $MeasUnitRowsTable measUnitRows = $MeasUnitRowsTable(this);
  late final $DeviceRowsTable deviceRows = $DeviceRowsTable(this);
  late final $CommonSettingsTable commonSettings = $CommonSettingsTable(this);
  late final $ChartSettingTableRowsTable chartSettingTableRows =
      $ChartSettingTableRowsTable(this);
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
    measUnitRows,
    deviceRows,
    commonSettings,
    chartSettingTableRows,
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
typedef $$MeasUnitRowsTableCreateCompanionBuilder =
    MeasUnitRowsCompanion Function({
      Value<int> id,
      required String name,
      required double coeff,
      required double offset,
      required int deviceMode,
      required int measMode,
      Value<bool> userCantDelete,
    });
typedef $$MeasUnitRowsTableUpdateCompanionBuilder =
    MeasUnitRowsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> coeff,
      Value<double> offset,
      Value<int> deviceMode,
      Value<int> measMode,
      Value<bool> userCantDelete,
    });

class $$MeasUnitRowsTableFilterComposer
    extends Composer<_$AppDatabase, $MeasUnitRowsTable> {
  $$MeasUnitRowsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get coeff => $composableBuilder(
    column: $table.coeff,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get offset => $composableBuilder(
    column: $table.offset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deviceMode => $composableBuilder(
    column: $table.deviceMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get measMode => $composableBuilder(
    column: $table.measMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get userCantDelete => $composableBuilder(
    column: $table.userCantDelete,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MeasUnitRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasUnitRowsTable> {
  $$MeasUnitRowsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get coeff => $composableBuilder(
    column: $table.coeff,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get offset => $composableBuilder(
    column: $table.offset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deviceMode => $composableBuilder(
    column: $table.deviceMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get measMode => $composableBuilder(
    column: $table.measMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get userCantDelete => $composableBuilder(
    column: $table.userCantDelete,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MeasUnitRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasUnitRowsTable> {
  $$MeasUnitRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get coeff =>
      $composableBuilder(column: $table.coeff, builder: (column) => column);

  GeneratedColumn<double> get offset =>
      $composableBuilder(column: $table.offset, builder: (column) => column);

  GeneratedColumn<int> get deviceMode => $composableBuilder(
    column: $table.deviceMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get measMode =>
      $composableBuilder(column: $table.measMode, builder: (column) => column);

  GeneratedColumn<bool> get userCantDelete => $composableBuilder(
    column: $table.userCantDelete,
    builder: (column) => column,
  );
}

class $$MeasUnitRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeasUnitRowsTable,
          MeasUnitRow,
          $$MeasUnitRowsTableFilterComposer,
          $$MeasUnitRowsTableOrderingComposer,
          $$MeasUnitRowsTableAnnotationComposer,
          $$MeasUnitRowsTableCreateCompanionBuilder,
          $$MeasUnitRowsTableUpdateCompanionBuilder,
          (
            MeasUnitRow,
            BaseReferences<_$AppDatabase, $MeasUnitRowsTable, MeasUnitRow>,
          ),
          MeasUnitRow,
          PrefetchHooks Function()
        > {
  $$MeasUnitRowsTableTableManager(_$AppDatabase db, $MeasUnitRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MeasUnitRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$MeasUnitRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$MeasUnitRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> coeff = const Value.absent(),
                Value<double> offset = const Value.absent(),
                Value<int> deviceMode = const Value.absent(),
                Value<int> measMode = const Value.absent(),
                Value<bool> userCantDelete = const Value.absent(),
              }) => MeasUnitRowsCompanion(
                id: id,
                name: name,
                coeff: coeff,
                offset: offset,
                deviceMode: deviceMode,
                measMode: measMode,
                userCantDelete: userCantDelete,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double coeff,
                required double offset,
                required int deviceMode,
                required int measMode,
                Value<bool> userCantDelete = const Value.absent(),
              }) => MeasUnitRowsCompanion.insert(
                id: id,
                name: name,
                coeff: coeff,
                offset: offset,
                deviceMode: deviceMode,
                measMode: measMode,
                userCantDelete: userCantDelete,
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

typedef $$MeasUnitRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeasUnitRowsTable,
      MeasUnitRow,
      $$MeasUnitRowsTableFilterComposer,
      $$MeasUnitRowsTableOrderingComposer,
      $$MeasUnitRowsTableAnnotationComposer,
      $$MeasUnitRowsTableCreateCompanionBuilder,
      $$MeasUnitRowsTableUpdateCompanionBuilder,
      (
        MeasUnitRow,
        BaseReferences<_$AppDatabase, $MeasUnitRowsTable, MeasUnitRow>,
      ),
      MeasUnitRow,
      PrefetchHooks Function()
    >;
typedef $$DeviceRowsTableCreateCompanionBuilder =
    DeviceRowsCompanion Function({
      Value<int> id,
      required String name,
      required int connectionType,
      required String macAddress,
      required String ip,
    });
typedef $$DeviceRowsTableUpdateCompanionBuilder =
    DeviceRowsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> connectionType,
      Value<String> macAddress,
      Value<String> ip,
    });

class $$DeviceRowsTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceRowsTable> {
  $$DeviceRowsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get macAddress => $composableBuilder(
    column: $table.macAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ip => $composableBuilder(
    column: $table.ip,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeviceRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceRowsTable> {
  $$DeviceRowsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get macAddress => $composableBuilder(
    column: $table.macAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ip => $composableBuilder(
    column: $table.ip,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeviceRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceRowsTable> {
  $$DeviceRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get macAddress => $composableBuilder(
    column: $table.macAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ip =>
      $composableBuilder(column: $table.ip, builder: (column) => column);
}

class $$DeviceRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceRowsTable,
          DeviceRow,
          $$DeviceRowsTableFilterComposer,
          $$DeviceRowsTableOrderingComposer,
          $$DeviceRowsTableAnnotationComposer,
          $$DeviceRowsTableCreateCompanionBuilder,
          $$DeviceRowsTableUpdateCompanionBuilder,
          (
            DeviceRow,
            BaseReferences<_$AppDatabase, $DeviceRowsTable, DeviceRow>,
          ),
          DeviceRow,
          PrefetchHooks Function()
        > {
  $$DeviceRowsTableTableManager(_$AppDatabase db, $DeviceRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$DeviceRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$DeviceRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$DeviceRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> connectionType = const Value.absent(),
                Value<String> macAddress = const Value.absent(),
                Value<String> ip = const Value.absent(),
              }) => DeviceRowsCompanion(
                id: id,
                name: name,
                connectionType: connectionType,
                macAddress: macAddress,
                ip: ip,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int connectionType,
                required String macAddress,
                required String ip,
              }) => DeviceRowsCompanion.insert(
                id: id,
                name: name,
                connectionType: connectionType,
                macAddress: macAddress,
                ip: ip,
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

typedef $$DeviceRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceRowsTable,
      DeviceRow,
      $$DeviceRowsTableFilterComposer,
      $$DeviceRowsTableOrderingComposer,
      $$DeviceRowsTableAnnotationComposer,
      $$DeviceRowsTableCreateCompanionBuilder,
      $$DeviceRowsTableUpdateCompanionBuilder,
      (DeviceRow, BaseReferences<_$AppDatabase, $DeviceRowsTable, DeviceRow>),
      DeviceRow,
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
typedef $$ChartSettingTableRowsTableCreateCompanionBuilder =
    ChartSettingTableRowsCompanion Function({
      Value<int> id,
      required String color,
      required String deviceName,
      required int chartType,
      Value<bool> rightAxis,
    });
typedef $$ChartSettingTableRowsTableUpdateCompanionBuilder =
    ChartSettingTableRowsCompanion Function({
      Value<int> id,
      Value<String> color,
      Value<String> deviceName,
      Value<int> chartType,
      Value<bool> rightAxis,
    });

class $$ChartSettingTableRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ChartSettingTableRowsTable> {
  $$ChartSettingTableRowsTableFilterComposer({
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

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
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

  ColumnFilters<bool> get rightAxis => $composableBuilder(
    column: $table.rightAxis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChartSettingTableRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChartSettingTableRowsTable> {
  $$ChartSettingTableRowsTableOrderingComposer({
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

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
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

  ColumnOrderings<bool> get rightAxis => $composableBuilder(
    column: $table.rightAxis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChartSettingTableRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChartSettingTableRowsTable> {
  $$ChartSettingTableRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chartType =>
      $composableBuilder(column: $table.chartType, builder: (column) => column);

  GeneratedColumn<bool> get rightAxis =>
      $composableBuilder(column: $table.rightAxis, builder: (column) => column);
}

class $$ChartSettingTableRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChartSettingTableRowsTable,
          ChartSettingTableRow,
          $$ChartSettingTableRowsTableFilterComposer,
          $$ChartSettingTableRowsTableOrderingComposer,
          $$ChartSettingTableRowsTableAnnotationComposer,
          $$ChartSettingTableRowsTableCreateCompanionBuilder,
          $$ChartSettingTableRowsTableUpdateCompanionBuilder,
          (
            ChartSettingTableRow,
            BaseReferences<
              _$AppDatabase,
              $ChartSettingTableRowsTable,
              ChartSettingTableRow
            >,
          ),
          ChartSettingTableRow,
          PrefetchHooks Function()
        > {
  $$ChartSettingTableRowsTableTableManager(
    _$AppDatabase db,
    $ChartSettingTableRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ChartSettingTableRowsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ChartSettingTableRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ChartSettingTableRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> deviceName = const Value.absent(),
                Value<int> chartType = const Value.absent(),
                Value<bool> rightAxis = const Value.absent(),
              }) => ChartSettingTableRowsCompanion(
                id: id,
                color: color,
                deviceName: deviceName,
                chartType: chartType,
                rightAxis: rightAxis,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String color,
                required String deviceName,
                required int chartType,
                Value<bool> rightAxis = const Value.absent(),
              }) => ChartSettingTableRowsCompanion.insert(
                id: id,
                color: color,
                deviceName: deviceName,
                chartType: chartType,
                rightAxis: rightAxis,
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

typedef $$ChartSettingTableRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChartSettingTableRowsTable,
      ChartSettingTableRow,
      $$ChartSettingTableRowsTableFilterComposer,
      $$ChartSettingTableRowsTableOrderingComposer,
      $$ChartSettingTableRowsTableAnnotationComposer,
      $$ChartSettingTableRowsTableCreateCompanionBuilder,
      $$ChartSettingTableRowsTableUpdateCompanionBuilder,
      (
        ChartSettingTableRow,
        BaseReferences<
          _$AppDatabase,
          $ChartSettingTableRowsTable,
          ChartSettingTableRow
        >,
      ),
      ChartSettingTableRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DataLogCellsTableTableManager get dataLogCells =>
      $$DataLogCellsTableTableManager(_db, _db.dataLogCells);
  $$MeasUnitRowsTableTableManager get measUnitRows =>
      $$MeasUnitRowsTableTableManager(_db, _db.measUnitRows);
  $$DeviceRowsTableTableManager get deviceRows =>
      $$DeviceRowsTableTableManager(_db, _db.deviceRows);
  $$CommonSettingsTableTableManager get commonSettings =>
      $$CommonSettingsTableTableManager(_db, _db.commonSettings);
  $$ChartSettingTableRowsTableTableManager get chartSettingTableRows =>
      $$ChartSettingTableRowsTableTableManager(_db, _db.chartSettingTableRows);
}
