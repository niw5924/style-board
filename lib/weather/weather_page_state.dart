import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_page_state.freezed.dart';

@freezed
class WeatherState with _$WeatherState {
  const factory WeatherState({
    @Default(false) bool isLoading,
    @Default({}) Map<String, dynamic> filteredData,
  }) = _WeatherState;
}
