import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:style_board/profile/weather/helper/coordinate_converter.dart';
import 'package:style_board/profile/weather/helper/time_calculator.dart';
import 'package:style_board/profile/weather/helper/weather_classifier.dart';
import 'package:style_board/profile/weather/service/location_service.dart';
import 'package:style_board/profile/weather/service/weather_service.dart';
import 'package:style_board/profile/weather/weather_page_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();

  WeatherCubit() : super(const WeatherState());

  Future<void> fetchWeather() async {
    emit(state.copyWith(isLoading: true));
    try {
      // 위치 가져오기
      Position position = await _locationService.getCurrentLocation();
      Map<String, int> grid = CoordinateConverter.latLonToGrid(
        latitude: position.latitude,
        longitude: position.longitude,
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
        final value = item['fcstValue'];
        switch (item['category']) {
          case 'TMP':
            result['온도'] = value;
            break;
          case 'SKY':
            result['하늘 상태'] = value;
            break;
          case 'PTY':
            result['강수 형태'] = value;
            break;
          case 'POP':
            result['강수 확률'] = value;
            break;
        }
      }

      // 추천 코디 가져오기
      final outfitRecommendations = await _getOutfitRecommendations(
        weatherData: result,
        now: now,
      );

      emit(state.copyWith(
        isLoading: false,
        filteredData: result,
        recommendations: outfitRecommendations,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
        isLoading: false,
        filteredData: {},
        recommendations: {},
      ));
    }
  }

  Future<Map<String, String>> _getOutfitRecommendations({
    required Map<String, dynamic> weatherData,
    required DateTime now,
  }) async {
    final jsonString =
        await rootBundle.loadString('assets/jsons/outfit_recommendations.json');
    final outfitRecommendations = jsonDecode(jsonString);

    final season = getSeason(now);
    final temperatureRange = getTemperatureRange(weatherData['온도']);
    final precipitationType = getPrecipitationDescription(weatherData['강수 형태']);
    final skyState = getSkyDescription(weatherData['하늘 상태']);

    final seasonData = outfitRecommendations['outfits'][season];

    final tempData = seasonData['temperatureRanges'][temperatureRange];
    if (tempData == null) return _defaultOutfitRecommendations();

    final precipitationData = tempData['precipitation'][precipitationType];
    if (precipitationData == null) return _defaultOutfitRecommendations();

    final skyStateData = precipitationData[skyState];
    if (skyStateData == null) return _defaultOutfitRecommendations();

    return Map<String, String>.from(skyStateData);
  }

  Map<String, String> _defaultOutfitRecommendations() {
    return {
      "상의": "추천 없음",
      "하의": "추천 없음",
      "아우터": "추천 없음",
      "신발": "추천 없음",
    };
  }
}
