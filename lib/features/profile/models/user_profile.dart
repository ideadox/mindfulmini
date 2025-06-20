class UserProfile {
  final String id;
  final String userId;
  final String firstName;
  final DateTime dateOfBirth;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  UserProfile({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.dateOfBirth,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      firstName: json['firstName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      profileImage: json['profileImage'],
      v: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'firstName': firstName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'profileImage': profileImage,
    };
  }

  UserProfile copyWith({
    String? id,
    String? userId,
    String? firstName,
    DateTime? dateOfBirth,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return UserProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
