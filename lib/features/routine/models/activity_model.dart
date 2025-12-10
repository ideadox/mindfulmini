class Goal {
  final String title;
  final int progress;

  Goal({required this.title, required this.progress});

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      title: json['title'] as String,
      progress:
          (json['progress'] is int)
              ? json['progress'] as int
              : int.tryParse(json['progress'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'title': title, 'progress': progress};

  Goal copyWith({String? title, int? progress}) {
    return Goal(
      title: title ?? this.title,
      progress: progress ?? this.progress,
    );
  }
}

class GoalsSummary {
  final List<Goal> goals;
  final double averageProgress;

  GoalsSummary({required this.goals, required this.averageProgress});

  factory GoalsSummary.fromJson(Map<String, dynamic> json) {
    return GoalsSummary(
      goals:
          (json['goals'] as List<dynamic>? ?? [])
              .map((e) => Goal.fromJson(e as Map<String, dynamic>))
              .toList(),
      averageProgress:
          (json['averageProgress'] is num)
              ? (json['averageProgress'] as num).toDouble()
              : double.tryParse(json['averageProgress']?.toString() ?? '0') ??
                  0,
    );
  }

  Map<String, dynamic> toJson() => {
    'goals': goals.map((g) => g.toJson()).toList(),
    'averageProgress': averageProgress,
  };

  GoalsSummary copyWith({List<Goal>? goals, double? averageProgress}) {
    return GoalsSummary(
      goals: goals ?? this.goals,
      averageProgress: averageProgress ?? this.averageProgress,
    );
  }
}
