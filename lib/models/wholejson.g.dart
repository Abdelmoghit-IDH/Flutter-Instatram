// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wholejson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WholeJSON _$WholeJSONFromJson(Map<String, dynamic> json) {
  return WholeJSON(
    code: json['code'] as int,
    data: json['data'] == null
        ? null
        : Data.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WholeJSONToJson(WholeJSON instance) => <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
    };
