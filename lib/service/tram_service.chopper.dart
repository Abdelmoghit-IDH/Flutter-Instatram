// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tram_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$TramService extends TramService {
  _$TramService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = TramService;

  @override
  Future<Response<WholeJSON>> getTrams() {
    final $url = '';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<WholeJSON, WholeJSON>($request);
  }
}
