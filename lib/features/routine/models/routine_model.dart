class RoutineModel {
  final String id;
  final String profileId;
  final DateTime startDate;
  final int durationDays;
  final String timeOfDay; // morning, night, evening, etc.
  final int dailyDurationMinutes;
  final List<String> goals;
  final bool hasReminder;
  final List<String> reminderDays;
  final String reminderTime; // "09:00"
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  RoutineModel({
    required this.id,
    required this.profileId,
    required this.startDate,
    required this.durationDays,
    required this.timeOfDay,
    required this.dailyDurationMinutes,
    required this.goals,
    required this.hasReminder,
    required this.reminderDays,
    required this.reminderTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  int dayNumberSinceStart() {
    final now = DateTime.now();
    return now.difference(startDate).inDays;
  }

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      id: json['_id'] ?? '',
      profileId: json['profileId'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      durationDays: json['durationDays'] ?? 0,
      timeOfDay: json['timeOfDay'] ?? '',
      dailyDurationMinutes: json['dailyDurationMinutes'] ?? 0,
      goals: List<String>.from(json['goals'] ?? []),
      hasReminder: json['hasReminder'] ?? false,
      reminderDays: List<String>.from(json['reminderDays'] ?? []),
      reminderTime: json['reminderTime'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "profileId": profileId,
      "startDate": startDate.toIso8601String(),
      "durationDays": durationDays,
      "timeOfDay": timeOfDay,
      "dailyDurationMinutes": dailyDurationMinutes,
      "goals": goals,
      "hasReminder": hasReminder,
      "reminderDays": reminderDays,
      "reminderTime": reminderTime,
    };
  }

  RoutineModel copyWith({
    String? id,
    String? profileId,
    DateTime? startDate,
    int? durationDays,
    String? timeOfDay,
    int? dailyDurationMinutes,
    List<String>? goals,
    bool? hasReminder,
    List<String>? reminderDays,
    String? reminderTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return RoutineModel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      startDate: startDate ?? this.startDate,
      durationDays: durationDays ?? this.durationDays,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      dailyDurationMinutes: dailyDurationMinutes ?? this.dailyDurationMinutes,
      goals: goals ?? this.goals,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderDays: reminderDays ?? this.reminderDays,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
