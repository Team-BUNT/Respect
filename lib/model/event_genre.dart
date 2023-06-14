enum EventGenre {
  all,
  allGenre,
  hiphop,
  breaking,
  locking,
  poppin,
  waacking,
  kPop,
  etc,
}

extension EventGenreExtension on EventGenre {
  String get convertToString {
    switch (this) {
      case EventGenre.all:
        return '전체 장르';
      case EventGenre.allGenre:
        return '올장르';
      case EventGenre.hiphop:
        return '힙합';
      case EventGenre.breaking:
        return '브레이킹';
      case EventGenre.locking:
        return '락킹';
      case EventGenre.poppin:
        return '팝핑';
      case EventGenre.waacking:
        return '왁킹';
      case EventGenre.kPop:
        return '케이팝';
      case EventGenre.etc:
        return '기타';
      default:
        return "";
    }
  }
}
