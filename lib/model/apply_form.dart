class ApplyForm {
  ApplyForm({
    required this.deviceId,
    required this.name,
    required this.createAt,
    required this.link,
  });

  final String deviceId;
  final String name;
  final DateTime createAt;
  final String link;

  ApplyForm.fromFirestore(Map<String, Object?> json)
      : this(
          deviceId: json['deviceId'] as String,
          name: json['thumbnail'] as String,
          createAt: json['posterURL'] as DateTime,
          link: json['name'] as String,
        );

  Map<String, Object?> toFirestore() {
    return {
      'deviceId': deviceId,
      'name': name,
      'createAt': createAt,
      'link': link
    };
  }
}
