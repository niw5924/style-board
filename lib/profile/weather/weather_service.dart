import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String _baseUrl =
      "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst";

  Future<Map<String, dynamic>> fetchWeather({
    required String date,
    required String time,
    required int nx,
    required int ny,
  }) async {
    final String apiKey = dotenv.env['WEATHER_API_KEY']!;

    final url = Uri.parse(
      "$_baseUrl?serviceKey=$apiKey&numOfRows=10&pageNo=1&dataType=JSON"
      "&base_date=$date&base_time=$time&nx=$nx&ny=$ny",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return data['response']['body']['items'];
    } else {
      throw Exception("Failed to fetch weather data: ${response.statusCode}");
    }
  }
}
