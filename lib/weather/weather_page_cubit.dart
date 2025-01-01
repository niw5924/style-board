import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/weather/weather_page_state.dart';
import '../weather/weather_service.dart';
import '../weather/location_service.dart';
import '../weather/coordinate_converter.dart';
import '../weather/time_calculator.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  Map<String, dynamic>? _recommendations;

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

      // 추천 코디 가져오기
      final recommendations = await _getRecommendations(result, now);

      emit(state.copyWith(
        isLoading: false,
        filteredData: result,
        recommendations: recommendations,
      ));
    } catch (e) {
      print(e.toString());
      emit(state
          .copyWith(isLoading: false, filteredData: {}, recommendations: {}));
    }
  }

  Future<Map<String, String>> _getRecommendations(
      Map<String, dynamic> weatherData, DateTime now) async {
    if (_recommendations == null) {
      final jsonString =
          await rootBundle.loadString('assets/jsons/recommendations.json');
      _recommendations = jsonDecode(jsonString);
    }

    final season = _getSeason(now);
    final temperatureRange = _getTemperatureRange(weatherData['온도']);
    final precipitationType =
        _getPrecipitationDescription(weatherData['강수 형태']);
    final skyState = _getSkyDescription(weatherData['하늘 상태']);

    final seasonData = _recommendations?['recommendations'][season];
    if (seasonData == null) return _defaultRecommendations();

    final tempData = seasonData['temperatureRanges'][temperatureRange];
    if (tempData == null) return _defaultRecommendations();

    final precipitationData = tempData['precipitation'][precipitationType];
    if (precipitationData == null) return _defaultRecommendations();

    final skyStateData = precipitationData[skyState];
    if (skyStateData == null) return _defaultRecommendations();

    return Map<String, String>.from(skyStateData);
  }

  String _getSeason(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) return "spring";
    if (month >= 6 && month <= 8) return "summer";
    if (month >= 9 && month <= 11) return "autumn";
    return "winter";
  }

  String _getTemperatureRange(String? temperature) {
    final temp =
        int.tryParse(temperature?.replaceAll('°C', '').trim() ?? "0") ?? 0;

    if (temp <= 0) return "-10-0";
    if (temp <= 10) return "1-10";
    if (temp <= 20) return "11-20";
    if (temp <= 30) return "21-30";
    return "31-50";
  }

  String _getPrecipitationDescription(String? value) {
    switch (value) {
      case '0':
        return "없음";
      case '1':
        return "비";
      case '2':
      case '3':
        return "눈";
      case '4':
        return "소나기";
      default:
        return "-";
    }
  }

  String _getSkyDescription(String? value) {
    switch (value) {
      case '1':
        return "맑음";
      case '3':
        return "구름 많음";
      case '4':
        return "흐림";
      default:
        return "-";
    }
  }

  Map<String, String> _defaultRecommendations() {
    return {
      "상의": "추천 없음",
      "하의": "추천 없음",
      "아우터": "추천 없음",
      "신발": "추천 없음",
    };
  }
}
