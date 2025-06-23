class ActivityContentModel {
  final String id;
  final String profileId;
  final String routineId;
  final String activityId;
  final String contentId;
  final String goal;
  final int progressStatus;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  ActivityContentModel({
    required this.id,
    required this.profileId,
    required this.routineId,
    required this.activityId,
    required this.contentId,
    required this.goal,
    required this.progressStatus,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ActivityContentModel.fromJson(Map<String, dynamic> json) {
    return ActivityContentModel(
      id: json['_id'],
      profileId: json['profileId'],
      routineId: json['routineId'],
      activityId: json['activityId'],
      contentId: json['contentId'],
      goal: json['goal'],
      progressStatus: json['progressStatus'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'profileId': profileId,
    'routineId': routineId,
    'activityId': activityId,
    'contentId': contentId,
    'goal': goal,
    'progressStatus': progressStatus,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };

  ActivityContentModel copyWith({
    String? id,
    String? profileId,
    String? routineId,
    String? activityId,
    String? contentId,
    String? goal,
    int? progressStatus,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return ActivityContentModel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      routineId: routineId ?? this.routineId,
      activityId: activityId ?? this.activityId,
      contentId: contentId ?? this.contentId,
      goal: goal ?? this.goal,
      progressStatus: progressStatus ?? this.progressStatus,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
