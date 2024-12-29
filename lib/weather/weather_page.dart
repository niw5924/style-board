import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:style_board/weather/weather_page_cubit.dart';
import 'package:style_board/weather/weather_page_state.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    super.initState();
    context.read<WeatherCubit>().fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("코디 추천")),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final lottiePath = _getLottiePath(
              skyState: state.filteredData['하늘 상태'],
              precipitationType: state.filteredData['강수 형태'],
            );

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildIconWithText(
                        Icons.thermostat_outlined,
                        state.filteredData['온도'] ?? "-",
                      ),
                      buildIconWithText(
                        _skyDetails(state.filteredData['하늘 상태'])['icon'],
                        _skyDetails(state.filteredData['하늘 상태'])['description'],
                      ),
                      buildIconWithText(
                        _precipitationDetails(
                            state.filteredData['강수 형태'])['icon'],
                        _precipitationDetails(
                            state.filteredData['강수 형태'])['description'],
                      ),
                      buildIconWithText(
                        Icons.water_drop,
                        state.filteredData['강수 확률'] ?? "-",
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (lottiePath != null)
                    Lottie.asset(
                      lottiePath,
                      width: 200,
                      height: 200,
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildIconWithText(IconData icon, String description) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Text(
          description,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Map<String, dynamic> _skyDetails(String? value) {
    switch (value) {
      case '1':
        return {'icon': Icons.wb_sunny, 'description': '맑음'};
      case '3':
        return {'icon': Icons.cloud, 'description': '구름 많음'};
      case '4':
        return {'icon': Icons.cloud_outlined, 'description': '흐림'};
      default:
        return {'icon': Icons.help_outline, 'description': '-'};
    }
  }

  Map<String, dynamic> _precipitationDetails(String? value) {
    switch (value) {
      case '0':
        return {'icon': Icons.umbrella, 'description': '없음'};
      case '1':
        return {'icon': Icons.grain, 'description': '비'};
      case '2':
      case '3':
        return {'icon': Icons.ac_unit, 'description': '눈'};
      case '4':
        return {'icon': Icons.shower, 'description': '소나기'};
      default:
        return {'icon': Icons.help_outline, 'description': '-'};
    }
  }

  String? _getLottiePath(
      {required String? skyState, required String? precipitationType}) {
    switch (precipitationType) {
      case '1':
      case '4':
        return 'assets/lotties/rain_lottie.json';
      case '2':
      case '3':
        return 'assets/lotties/snow_lottie.json';
      case '0':
        switch (skyState) {
          case '1':
            return 'assets/lotties/clear_lottie.json';
          case '3':
            return 'assets/lotties/partly_cloudy_lottie.json';
          case '4':
            return 'assets/lotties/cloudy_lottie.json';
          default:
            return null;
        }
      default:
        return null;
    }
  }
}
