import 'package:json_annotation/json_annotation.dart';
import 'tram.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  Data({
    this.trams,
  });

  @JsonKey(name: 'tram')
  List<Tram> trams;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
