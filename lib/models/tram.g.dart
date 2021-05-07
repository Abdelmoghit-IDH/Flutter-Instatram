// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tram.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tram _$TramFromJson(Map<String, dynamic> json) {
  return Tram(
    id: json['id'] as String,
    line: json['line'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    zone: json['zone'] as String,
    connections: json['connections'] as String,
    lat: json['lat'] as String,
    lon: json['lon'] as String,
  );
}

Map<String, dynamic> _$TramToJson(Tram instance) => <String, dynamic>{
      'id': instance.id,
      'line': instance.line,
      'name': instance.name,
      'type': instance.type,
      'zone': instance.zone,
      'connections': instance.connections,
      'lat': instance.lat,
      'lon': instance.lon,
    };
