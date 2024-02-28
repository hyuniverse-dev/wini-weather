// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Location extends _Location
    with RealmEntity, RealmObjectBase, RealmObject {
  Location(
    int id,
    String licence,
    String latitude,
    String longitude,
    String name,
    String city,
    String country,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'licence', licence);
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'longitude', longitude);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'city', city);
    RealmObjectBase.set(this, 'country', country);
  }

  Location._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => throw RealmUnsupportedSetError();

  @override
  String get licence => RealmObjectBase.get<String>(this, 'licence') as String;
  @override
  set licence(String value) => RealmObjectBase.set(this, 'licence', value);

  @override
  String get latitude =>
      RealmObjectBase.get<String>(this, 'latitude') as String;
  @override
  set latitude(String value) => RealmObjectBase.set(this, 'latitude', value);

  @override
  String get longitude =>
      RealmObjectBase.get<String>(this, 'longitude') as String;
  @override
  set longitude(String value) => RealmObjectBase.set(this, 'longitude', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get city => RealmObjectBase.get<String>(this, 'city') as String;
  @override
  set city(String value) => RealmObjectBase.set(this, 'city', value);

  @override
  String get country => RealmObjectBase.get<String>(this, 'country') as String;
  @override
  set country(String value) => RealmObjectBase.set(this, 'country', value);

  @override
  Stream<RealmObjectChanges<Location>> get changes =>
      RealmObjectBase.getChanges<Location>(this);

  @override
  Location freeze() => RealmObjectBase.freezeObject<Location>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Location._);
    return const SchemaObject(ObjectType.realmObject, Location, 'Location', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('licence', RealmPropertyType.string),
      SchemaProperty('latitude', RealmPropertyType.string),
      SchemaProperty('longitude', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('city', RealmPropertyType.string),
      SchemaProperty('country', RealmPropertyType.string),
    ]);
  }
}
