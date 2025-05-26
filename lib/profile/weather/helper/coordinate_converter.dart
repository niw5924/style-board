import 'dart:math';

class CoordinateConverter {
  static const double earthRadius = 6371.00877; // 지구 반경(km)
  static const double gridSpacing = 5.0; // 격자 간격(km)
  static const double projLatitude1 = 30.0; // 투영 위도 1(degree)
  static const double projLatitude2 = 60.0; // 투영 위도 2(degree)
  static const double baseLongitude = 126.0; // 기준 경도(degree)
  static const double baseLatitude = 38.0; // 기준 위도(degree)
  static const double baseX = 43; // 기준점 X좌표(격자)
  static const double baseY = 136; // 기준점 Y좌표(격자)

  /// 위도(lat), 경도(lon)를 기상청 격자 좌표(nx, ny)로 변환
  static Map<String, int> latLonToGrid({
    required double latitude,
    required double longitude,
  }) {
    const double degrad = pi / 180.0;

    const double re = earthRadius / gridSpacing;
    const double slat1 = projLatitude1 * degrad;
    const double slat2 = projLatitude2 * degrad;
    const double olon = baseLongitude * degrad;
    const double olat = baseLatitude * degrad;

    double sn = tan(pi * 0.25 + slat2 * 0.5) / tan(pi * 0.25 + slat1 * 0.5);
    sn = log(cos(slat1) / cos(slat2)) / log(sn);
    double sf = tan(pi * 0.25 + slat1 * 0.5);
    sf = pow(sf, sn) * cos(slat1) / sn;
    double ro = tan(pi * 0.25 + olat * 0.5);
    ro = re * sf / pow(ro, sn);

    double ra = tan(pi * 0.25 + latitude * degrad * 0.5);
    ra = re * sf / pow(ra, sn);
    double theta = longitude * degrad - olon;
    if (theta > pi) theta -= 2.0 * pi;
    if (theta < -pi) theta += 2.0 * pi;
    theta *= sn;

    int x = (ra * sin(theta) + baseX + 0.5).floor();
    int y = (ro - ra * cos(theta) + baseY + 0.5).floor();
    return {'nx': x, 'ny': y};
  }
}
