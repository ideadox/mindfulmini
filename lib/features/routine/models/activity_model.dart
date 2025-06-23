import 'activity_content_model.dart';

class ActivityModel {
  final String id;
  final String profileId;
  final String routineId;
  final DateTime date;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  final List<ActivityContentModel> activityContent;

  ActivityModel({
    required this.id,
    required this.profileId,
    required this.routineId,
    required this.date,
    required this.status,
    required this.createdAt,
    required this.updatedAt,

    required this.activityContent,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['_id'] ?? json['id'],
      profileId: json['profileId'],
      routineId: json['routineId'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),

      activityContent:
          (json['activityContent'] as List)
              .map((e) => ActivityContentModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'profileId': profileId,
    'routineId': routineId,
    'date': date.toIso8601String(),
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),

    'activityContent': activityContent.map((e) => e.toJson()).toList(),
  };

  ActivityModel copyWith({
    String? id,
    String? profileId,
    String? routineId,
    DateTime? date,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,

    List<ActivityContentModel>? activityContent,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      routineId: routineId ?? this.routineId,
      date: date ?? this.date,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,

      activityContent: activityContent ?? this.activityContent,
    );
  }
}
