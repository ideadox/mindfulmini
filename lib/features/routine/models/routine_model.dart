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
  final DateTime? extendedDate;
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
    this.extendedDate,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  /// The computed end date of the routine.
  DateTime get endDate => startDate.add(Duration(days: durationDays));

  /// Whether the routine was extended from a previous end date.
  bool get wasExtended => extendedDate != null;

  /// Returns the 0-based day number since the routine started.
  /// If the routine hasn't started yet, returns 0.
  int dayNumberSinceStart() {
    final now = DateTime.now();
    final diff = now.difference(startDate).inDays;
    return diff < 0 ? 0 : diff;
  }

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      id: json['_id'] ?? json['id'] ?? '',
      profileId: json['profileId'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      durationDays: json['durationDays'] ?? 0,
      timeOfDay: json['timeOfDay'] ?? '',
      dailyDurationMinutes: json['dailyDurationMinutes'] ?? 0,
      goals: List<String>.from(json['goals'] ?? []),
      hasReminder: json['hasReminder'] ?? false,
      reminderDays: List<String>.from(json['reminderDays'] ?? []),
      reminderTime: json['reminderTime'] ?? '',
      extendedDate: json['extendedDate'] != null
          ? DateTime.parse(json['extendedDate'])
          : null,
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
      if (extendedDate != null)
        "extendedDate": extendedDate!.toIso8601String(),
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
    DateTime? extendedDate,
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
      extendedDate: extendedDate ?? this.extendedDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
