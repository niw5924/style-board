import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    // 위치 서비스가 활성화되어 있는지 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("위치 서비스가 비활성화되어 있습니다.");
    }

    // 위치 권한 확인 및 요청
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("위치 권한이 거부되었습니다.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("위치 권한이 영구적으로 거부되었습니다.");
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings);
  }
}
