import 'package:freezed_annotation/freezed_annotation.dart';

part 'styling_3d_page_state.freezed.dart';

@freezed
class Styling3DPageState with _$Styling3DPageState {
  const factory Styling3DPageState({
    /// 각 카테고리별 로딩 상태
    @Default({
      '상의': false,
      '하의': false,
      '아우터': false,
      '신발': false,
    })
    Map<String, bool> isLoading,

    /// 각 카테고리별 변환 진행률 (0~100)
    @Default({
      '상의': null,
      '하의': null,
      '아우터': null,
      '신발': null,
    })
    Map<String, int?> progress,

    /// 각 카테고리별 GLB 파일 경로
    @Default({
      '상의': null,
      '하의': null,
      '아우터': null,
      '신발': null,
    })
    Map<String, String?> glbUrls,
  }) = _Styling3DPageState;
}
