class TimeCalculator {
  static String _twoDigits(int n) => n.toString().padLeft(2, '0');

  /// Base Date 계산
  static String calculateBaseDate(DateTime now) {
    List<int> baseTimes = [2, 5, 8, 11, 14, 17, 20, 23]; // Base Time (시)
    DateTime baseDateTime = now;

    // 현재 시간이 Base Time 제공 시간보다 이르면 전 Base Time으로 이동
    for (int i = 0; i < baseTimes.length; i++) {
      DateTime apiAvailableTime = DateTime(
        now.year,
        now.month,
        now.day,
        baseTimes[i],
        10, // Base Time + 10분
      );

      if (now.isBefore(apiAvailableTime)) {
        // 전 Base Time으로 이동
        if (i == 0) {
          // 02:10 이전이면 전날의 23:00 사용
          baseDateTime = now.subtract(const Duration(days: 1));
          return "${baseDateTime.year}${_twoDigits(baseDateTime.month)}${_twoDigits(baseDateTime.day)}";
        } else {
          break;
        }
      }
    }

    return "${baseDateTime.year}${_twoDigits(baseDateTime.month)}${_twoDigits(baseDateTime.day)}";
  }

  /// Base Time 계산
  static String calculateBaseTime(DateTime now) {
    List<int> baseTimes = [2, 5, 8, 11, 14, 17, 20, 23]; // Base Time (시)

    for (int i = baseTimes.length - 1; i >= 0; i--) {
      DateTime apiAvailableTime = DateTime(
        now.year,
        now.month,
        now.day,
        baseTimes[i],
        10, // Base Time + 10분
      );

      if (now.isAfter(apiAvailableTime)) {
        return "${_twoDigits(baseTimes[i])}00";
      }
    }

    return "2300"; // 기본값 (전날 23:00)
  }
}
