import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/weather/weather_page_state.dart';
import '../weather/weather_service.dart';
import '../weather/location_service.dart';
import '../weather/coordinate_converter.dart';
import '../weather/time_calculator.dart';
import 'package:geolocator/geolocator.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  WeatherCubit() : super(const WeatherState());

  Future<void> fetchWeather() async {
    emit(state.copyWith(isLoading: true));

    try {
      // 위치 가져오기
      Position position = await _locationService.getCurrentLocation();
      Map<String, int> grid = CoordinateConverter.latLonToGrid(
        position.latitude,
        position.longitude,
      );

      // 시간 계산
      DateTime now = DateTime.now();
      String baseDate = TimeCalculator.calculateBaseDate(now);
      String baseTime = TimeCalculator.calculateBaseTime(now);

      // 날씨 데이터 호출
      Map<String, dynamic> data = await _weatherService.fetchWeather(
        date: baseDate,
        time: baseTime,
        nx: grid['nx']!,
        ny: grid['ny']!,
      );

      // 데이터 가공
      List<dynamic> items = data['item'];
      Map<String, dynamic> result = {};

      for (var item in items) {
        switch (item['category']) {
          case 'TMP':
            result['온도'] = "${item['fcstValue']}°C";
            break;
          case 'SKY':
            result['하늘 상태'] = item['fcstValue'];
            break;
          case 'PTY':
            result['강수 형태'] = item['fcstValue'];
            break;
          case 'POP':
            result['강수 확률'] = "${item['fcstValue']}%";
            break;
        }
      }

      emit(state.copyWith(isLoading: false, filteredData: result));
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(isLoading: false, filteredData: {}));
    }
  }
}
