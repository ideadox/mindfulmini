class GratiudeJournalModel {
  final String id;
  final String profileId;
  final String emotion;
  final String emotionDescription;
  final List<String> accomplishments;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  GratiudeJournalModel({
    required this.id,
    required this.profileId,
    required this.emotion,
    required this.emotionDescription,
    required this.accomplishments,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GratiudeJournalModel.fromJson(Map<String, dynamic> json) {
    return GratiudeJournalModel(
      id: json['_id'],
      profileId: json['profileId'],
      emotion: json['mood'],
      emotionDescription: json["description"],
      accomplishments: List<String>.from(json["accomplishments"]),
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'profileId': profileId,

    'mood': emotion,
    'description': emotionDescription,
    'accomplishments': accomplishments,
    'date': date.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  // GratiudeJournalModel copyWith({
  //   String? id,
  //   String? profileId,
  //   String? emotion,
  //   String? description,
  //   String? accomplishments,
  //   DateTime? date,
  //   DateTime? createdAt,
  //   DateTime? updatedAt,
  //   int? v,
  // }) {
  //   return GratiudeJournalModel(
  //     id: id ?? this.id,
  //     profileId: profileId ?? this.profileId,

  //     emotion: emotion ?? this.emotion,
  //     emotionDescription: emotionDescription ?? this.description,
  //     accomplishments: accomplishments ?? this.accomplishments,
  //     date: date ?? this.date,
  //     createdAt: createdAt ?? this.createdAt,
  //     updatedAt: updatedAt ?? this.updatedAt,
  //     v: v ?? this.v,
  //   );
  // }
}
