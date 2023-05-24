enum Province {
  all,
  seoul,
  gyeonggi,
  daejeon,
  gyeongsang,
  jeolla,
  gangwon,
}

extension ProvinceExtension on Province {
  String get convertToString {
    switch (this) {
      case Province.all:
        return '전체 지역';
      case Province.seoul:
        return '서울';
      case Province.gyeonggi:
        return '경기·인천';
      case Province.daejeon:
        return '대전·충청·세종';
      case Province.gyeongsang:
        return '경상·부산·대구·울산';
      case Province.jeolla:
        return '전라·광주';
      case Province.gangwon:
        return '강원·제주';
      default:
        return "";
    }
  }
}
