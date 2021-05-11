import 'package:chopper/chopper.dart';
import '../models/tram.dart';
import '../models/wholejson.dart';
import 'model_converter.dart';

part 'tram_service.chopper.dart';

// 4
@ChopperApi()
// 5
abstract class TramService extends ChopperService {
  // 6
  @Get()
  // 7
  Future<Response<WholeJSON>> getTrams();

  // 8
  static TramService create() {
    // 9
    final client = ChopperClient(
      // 10
      baseUrl: 'https://api.jsonbin.io/b/6096b0fb7a19ef1245a58e21',
      interceptors: [HttpLoggingInterceptor()],

      converter: ModelConverter(),
      errorConverter: JsonConverter(),
      // 11
      services: [
        _$TramService(),
      ],
    );
    // 12
    return _$TramService(client);
  }

////////////////////////////////////////////////////////////////////////////////
  /// les lignes en bas sont utilisées pour le Provider
  List<TramUtile> allStations = [];
  List<TramUtile> stationsT1 = [];
  List<TramUtile> stationsT2 = [];
  List<TramUtile> stationsT3 = [];
  List<TramUtile> stationsT4 = [];
  List<TramUtile> stationsT5 = [];
  List<TramUtile> stationsT6 = [];

  void sortStation(List<TramUtile> allStations) {
    TramUtile tramInter;
    for (var i = 0; i < allStations.length; i++) {
      for (var j = 0; j < allStations.length; j++) {
        if (allStations[i].id < allStations[j].id) {
          tramInter = allStations[i];
          allStations[i] = allStations[j];
          allStations[j] = tramInter;
        }
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

  bool isDarkModeTheme = false;
  bool isSpanishLanguage = false;
  bool isBottomSheetOn = false;

  bool refresh;
}
