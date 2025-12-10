class UserProfile {
  final String id;
  final String userId;
  final String fullname;
  final DateTime dob;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  UserProfile({
    required this.id,
    required this.userId,
    required this.fullname,
    required this.dob,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      fullname: json['fullname'] ?? '',
      dob: DateTime.parse(json['dob']),
      profileImage:
          json['image'] == null
              ? null
              : (json['image'] as String).isEmpty
              ? null
              : json['image'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // `_id`, `createdAt`, `updatedAt`, and `__v` usually come from server → excluded when sending API update
      // 'userId': userId,
      'fullname': fullname,
      // 'dob': dob.toIso8601String(),
      if (profileImage != null) 'image': profileImage,
    };
  }

  Map<String, dynamic> toName() {
    return {'fullname': fullname};
  }

  Map<String, dynamic> toImage() {
    return {'image': profileImage};
  }

  UserProfile copyWith({
    String? id,
    String? userId,
    String? fullname,
    DateTime? dob,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return UserProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullname: fullname ?? this.fullname,
      dob: dob ?? this.dob,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
