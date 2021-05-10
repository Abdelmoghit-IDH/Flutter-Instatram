import 'package:json_annotation/json_annotation.dart';

part 'tram.g.dart';

@JsonSerializable()
class Tram {
  Tram({
    this.id,
    this.line,
    this.name,
    this.type,
    this.zone,
    this.connections,
    this.lat,
    this.lon,
  });

  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'line')
  String line;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'type')
  String type;
  @JsonKey(name: 'zone')
  String zone;
  @JsonKey(name: 'connections')
  String connections;
  @JsonKey(name: 'lat')
  String lat;
  @JsonKey(name: 'lon')
  String lon;

  factory Tram.fromJson(Map<String, dynamic> json) => _$TramFromJson(json);

  Map<String, dynamic> toJson() => _$TramToJson(this);
}

//.....................................................TramUtile est definie pour changer le lat et lon
//.....................................................de String a double
class TramUtile {
  TramUtile({
    this.id,
    this.line,
    this.name,
    this.type,
    this.zone,
    this.connections,
    this.lat,
    this.lon,
  });

  double id;
  String line;
  String name;
  String type;
  String zone;
  String connections;
  double lat;
  double lon;
}
