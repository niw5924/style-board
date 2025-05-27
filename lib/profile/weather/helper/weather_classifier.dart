/// 날짜를 기준으로 계절 문자열 반환
String getSeason(DateTime date) {
  final month = date.month;
  if (month >= 3 && month <= 5) return "spring";
  if (month >= 6 && month <= 8) return "summer";
  if (month >= 9 && month <= 11) return "autumn";
  return "winter";
}

/// 온도 값을 기반으로 추천용 온도 범위 문자열 반환
String getTemperatureRange(String? temperature) {
  final temp = int.tryParse(temperature ?? "0") ?? 0;

  if (temp <= 0) return "-10-0";
  if (temp <= 10) return "1-10";
  if (temp <= 20) return "11-20";
  if (temp <= 30) return "21-30";
  return "31-50";
}

/// 하늘 상태 코드(1, 3, 4)를 텍스트로 변환
String getSkyDescription(String? value) {
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

/// 강수 형태 코드(0~4)를 텍스트로 변환
String getPrecipitationDescription(String? value) {
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
