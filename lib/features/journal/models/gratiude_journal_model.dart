class GratiudeJournalModel {
  final String id;
  final String profileId;
  final String activityId;
  final String emotion;
  final String emotionDescription;
  final String accomplishments;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  GratiudeJournalModel({
    required this.id,
    required this.profileId,
    required this.activityId,
    required this.emotion,
    required this.emotionDescription,
    required this.accomplishments,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory GratiudeJournalModel.fromJson(Map<String, dynamic> json) {
    return GratiudeJournalModel(
      id: json['_id'],
      profileId: json['profileId'],
      activityId: json['activityId'],
      emotion: json['emotion'],
      emotionDescription: json['emotionDescription'],
      accomplishments: json['accomplishments'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'profileId': profileId,
    'activityId': activityId,
    'emotion': emotion,
    'emotionDescription': emotionDescription,
    'accomplishments': accomplishments,
    'date': date.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };

  GratiudeJournalModel copyWith({
    String? id,
    String? profileId,
    String? activityId,
    String? emotion,
    String? emotionDescription,
    String? accomplishments,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return GratiudeJournalModel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      activityId: activityId ?? this.activityId,
      emotion: emotion ?? this.emotion,
      emotionDescription: emotionDescription ?? this.emotionDescription,
      accomplishments: accomplishments ?? this.accomplishments,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
