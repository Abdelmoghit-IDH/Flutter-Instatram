import 'package:json_annotation/json_annotation.dart';
import 'data.dart';

part 'wholejson.g.dart';

@JsonSerializable()
class WholeJSON {
  @JsonKey(name: 'code') // nom dans l api
  int code;

  @JsonKey(name: 'data')
  Data data;

  WholeJSON({
    this.code,
    this.data,
  });

  factory WholeJSON.fromJson(Map<String, dynamic> json) =>
      _$WholeJSONFromJson(json);

  Map<String, dynamic> toJson() => _$WholeJSONToJson(this);
}
