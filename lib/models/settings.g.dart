// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Settings extends _Settings
    with RealmEntity, RealmObjectBase, RealmObject {
  Settings(
    String uid,
    bool isCelsius,
    bool isNotificationOn,
    int notificationHour,
    int notificationMinute,
    bool isTemperatureEnabled,
    bool isFeelsLikeEnabled,
    bool isSkyConditionEnabled,
    bool isWindConditionEnabled,
  ) {
    RealmObjectBase.set(this, 'uid', uid);
    RealmObjectBase.set(this, 'isCelsius', isCelsius);
    RealmObjectBase.set(this, 'isNotificationOn', isNotificationOn);
    RealmObjectBase.set(this, 'notificationHour', notificationHour);
    RealmObjectBase.set(this, 'notificationMinute', notificationMinute);
    RealmObjectBase.set(this, 'isTemperatureEnabled', isTemperatureEnabled);
    RealmObjectBase.set(this, 'isFeelsLikeEnabled', isFeelsLikeEnabled);
    RealmObjectBase.set(this, 'isSkyConditionEnabled', isSkyConditionEnabled);
    RealmObjectBase.set(this, 'isWindConditionEnabled', isWindConditionEnabled);
  }

  Settings._();

  @override
  String get uid => RealmObjectBase.get<String>(this, 'uid') as String;
  @override
  set uid(String value) => throw RealmUnsupportedSetError();

  @override
  bool get isCelsius => RealmObjectBase.get<bool>(this, 'isCelsius') as bool;
  @override
  set isCelsius(bool value) => RealmObjectBase.set(this, 'isCelsius', value);

  @override
  bool get isNotificationOn =>
      RealmObjectBase.get<bool>(this, 'isNotificationOn') as bool;
  @override
  set isNotificationOn(bool value) =>
      RealmObjectBase.set(this, 'isNotificationOn', value);

  @override
  int get notificationHour =>
      RealmObjectBase.get<int>(this, 'notificationHour') as int;
  @override
  set notificationHour(int value) =>
      RealmObjectBase.set(this, 'notificationHour', value);

  @override
  int get notificationMinute =>
      RealmObjectBase.get<int>(this, 'notificationMinute') as int;
  @override
  set notificationMinute(int value) =>
      RealmObjectBase.set(this, 'notificationMinute', value);

  @override
  bool get isTemperatureEnabled =>
      RealmObjectBase.get<bool>(this, 'isTemperatureEnabled') as bool;
  @override
  set isTemperatureEnabled(bool value) =>
      RealmObjectBase.set(this, 'isTemperatureEnabled', value);

  @override
  bool get isFeelsLikeEnabled =>
      RealmObjectBase.get<bool>(this, 'isFeelsLikeEnabled') as bool;
  @override
  set isFeelsLikeEnabled(bool value) =>
      RealmObjectBase.set(this, 'isFeelsLikeEnabled', value);

  @override
  bool get isSkyConditionEnabled =>
      RealmObjectBase.get<bool>(this, 'isSkyConditionEnabled') as bool;
  @override
  set isSkyConditionEnabled(bool value) =>
      RealmObjectBase.set(this, 'isSkyConditionEnabled', value);

  @override
  bool get isWindConditionEnabled =>
      RealmObjectBase.get<bool>(this, 'isWindConditionEnabled') as bool;
  @override
  set isWindConditionEnabled(bool value) =>
      RealmObjectBase.set(this, 'isWindConditionEnabled', value);

  @override
  Stream<RealmObjectChanges<Settings>> get changes =>
      RealmObjectBase.getChanges<Settings>(this);

  @override
  Settings freeze() => RealmObjectBase.freezeObject<Settings>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Settings._);
    return const SchemaObject(ObjectType.realmObject, Settings, 'Settings', [
      SchemaProperty('uid', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('isCelsius', RealmPropertyType.bool),
      SchemaProperty('isNotificationOn', RealmPropertyType.bool),
      SchemaProperty('notificationHour', RealmPropertyType.int),
      SchemaProperty('notificationMinute', RealmPropertyType.int),
      SchemaProperty('isTemperatureEnabled', RealmPropertyType.bool),
      SchemaProperty('isFeelsLikeEnabled', RealmPropertyType.bool),
      SchemaProperty('isSkyConditionEnabled', RealmPropertyType.bool),
      SchemaProperty('isWindConditionEnabled', RealmPropertyType.bool),
    ]);
  }
}
