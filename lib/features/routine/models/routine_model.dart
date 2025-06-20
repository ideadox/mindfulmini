class RoutineModel {
  final String id;
  final String profileId;
  final String period;
  final String session;
  final List<String> goals;
  final int duration;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final List<ReminderModel> reminders;

  RoutineModel({
    required this.id,
    required this.profileId,
    required this.period,
    required this.session,
    required this.goals,
    required this.duration,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.reminders,
  });

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      id: json['_id'] ?? json['id'],
      profileId: json['profileId'],
      period: json['period'],
      session: json['session'],
      goals: List<String>.from(json['goals']),
      duration: json['duration'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
      reminders:
          (json['reminders'] as List<dynamic>)
              .map((e) => ReminderModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'profileId': profileId,
      'period': period,
      'session': session,
      'goals': goals,
      'duration': duration,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'reminders': reminders.map((e) => e.toJson()).toList(),
    };
  }

  RoutineModel copyWith({
    String? id,
    String? profileId,
    String? period,
    String? session,
    List<String>? goals,
    int? duration,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    List<ReminderModel>? reminders,
  }) {
    return RoutineModel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      period: period ?? this.period,
      session: session ?? this.session,
      goals: goals ?? this.goals,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      reminders: reminders ?? this.reminders,
    );
  }
}

class ReminderModel {
  final String id;
  final String routineId;
  final bool isActive;
  final List<String> days;
  final String time;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  ReminderModel({
    required this.id,
    required this.routineId,
    required this.isActive,
    required this.days,
    required this.time,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['_id'],
      routineId: json['routineId'],
      isActive: json['isActive'],
      days: List<String>.from(json['days']),
      time: json['time'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'routineId': routineId,
      'isActive': isActive,
      'days': days,
      'time': time,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }

  ReminderModel copyWith({
    String? id,
    String? routineId,
    bool? isActive,
    List<String>? days,
    String? time,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      isActive: isActive ?? this.isActive,
      days: days ?? this.days,
      time: time ?? this.time,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
