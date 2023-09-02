enum EventType { all, battle, performance, workshop, party, etc }

extension EventTypeExtension on EventType {
  String get convertToString {
    switch (this) {
      case EventType.all:
        return '전체';
      case EventType.battle:
        return '배틀';
      case EventType.performance:
        return '퍼포먼스';
      case EventType.workshop:
        return '워크샵';
      case EventType.party:
        return '파티';
      case EventType.etc:
        return '기타';
      default:
        return "";
    }
  }
}
