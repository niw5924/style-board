import 'package:flip_card/flip_card.dart';
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
                  if (state.filteredData['하늘 상태'] != null &&
                      state.filteredData['강수 형태'] != null)
                    Lottie.asset(
                      _getLottiePath(
                        skyState: state.filteredData['하늘 상태'],
                        precipitationType: state.filteredData['강수 형태'],
                      )!,
                      width: 200,
                      height: 200,
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    "추천 코디",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (state.recommendations.isNotEmpty)
                    Column(
                      children: state.recommendations.entries.map((entry) {
                        return FlipCard(
                          direction: FlipDirection.HORIZONTAL,
                          front: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _getIconForCategory(entry.key),
                                    size: 32,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          back: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    entry.value,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    const Card(
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "추천 코디 정보를 가져올 수 없습니다.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
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

  String? _getLottiePath({
    required String? skyState,
    required String? precipitationType,
  }) {
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

  IconData _getIconForCategory(String category) {
    switch (category) {
      case "아우터":
        return Icons.checkroom;
      case "상의":
        return Icons.emoji_people;
      case "하의":
        return Icons.work_outline;
      case "신발":
        return Icons.hiking;
      default:
        return Icons.help_outline;
    }
  }
}
