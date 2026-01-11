import 'package:mindfulminis/core/api_constants.dart';

class ActivityDetailModel {
  final String id;
  final DateTime date;
  final String goal;
  final String routineId;
  final String profileId;
  final String? contentId;
  final DateTime createdAt;
  final bool hasDisliked;
  final bool hasFinished;
  final bool hasLiked;
  final bool hasStarted;
  final int progressStatus;
  final String status;
  final DateTime updatedAt;
  final bool viewCounted;
  final ContentDetail? content;

  ActivityDetailModel({
    required this.id,
    required this.date,
    required this.goal,
    required this.routineId,
    required this.profileId,
    this.contentId,
    required this.createdAt,
    required this.hasDisliked,
    required this.hasFinished,
    required this.hasLiked,
    required this.hasStarted,
    required this.progressStatus,
    required this.status,
    required this.updatedAt,
    required this.viewCounted,
    this.content,
  });

  factory ActivityDetailModel.fromJson(Map<String, dynamic> json) {
    return ActivityDetailModel(
      id: json['_id'] as String,
      date: DateTime.parse(json['date'] as String),
      goal: json['goal'] as String,
      routineId: json['routineId'] as String,
      profileId: json['profileId'] as String,
      contentId: json['contentId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      hasDisliked: json['hasDisliked'] as bool? ?? false,
      hasFinished: json['hasFinished'] as bool? ?? false,
      hasLiked: json['hasLiked'] as bool? ?? false,
      hasStarted: json['hasStarted'] as bool? ?? false,
      progressStatus: json['progressStatus'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      viewCounted: json['viewCounted'] as bool? ?? false,
      content:
          json['content'] != null
              ? ContentDetail.fromJson(json['content'] as Map<String, dynamic>)
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'date': date.toIso8601String(),
    'goal': goal,
    'routineId': routineId,
    'profileId': profileId,
    'contentId': contentId,
    'createdAt': createdAt.toIso8601String(),
    'hasDisliked': hasDisliked,
    'hasFinished': hasFinished,
    'hasLiked': hasLiked,
    'hasStarted': hasStarted,
    'progressStatus': progressStatus,
    'status': status,
    'updatedAt': updatedAt.toIso8601String(),
    'viewCounted': viewCounted,
    'content': content?.toJson(),
  };

  ActivityDetailModel copyWith({
    String? id,
    DateTime? date,
    String? goal,
    String? routineId,
    String? profileId,
    String? contentId,
    DateTime? createdAt,
    bool? hasDisliked,
    bool? hasFinished,
    bool? hasLiked,
    bool? hasStarted,
    int? progressStatus,
    String? status,
    DateTime? updatedAt,
    bool? viewCounted,
    ContentDetail? content,
  }) {
    return ActivityDetailModel(
      id: id ?? this.id,
      date: date ?? this.date,
      goal: goal ?? this.goal,
      routineId: routineId ?? this.routineId,
      profileId: profileId ?? this.profileId,
      contentId: contentId ?? this.contentId,
      createdAt: createdAt ?? this.createdAt,
      hasDisliked: hasDisliked ?? this.hasDisliked,
      hasFinished: hasFinished ?? this.hasFinished,
      hasLiked: hasLiked ?? this.hasLiked,
      hasStarted: hasStarted ?? this.hasStarted,
      progressStatus: progressStatus ?? this.progressStatus,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      viewCounted: viewCounted ?? this.viewCounted,
      content: content ?? this.content,
    );
  }
}

class ContentDetail {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final Map<String, dynamic> contentDescription;
  final MediaDetail? media;
  final List<Tag>? tags;
  final bool? inSeries;
  final String? seriesName;
  final int? seriesIndex;

  ContentDetail({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.contentDescription,
    this.media,
    this.tags,
    this.inSeries,
    this.seriesName,
    this.seriesIndex,
  });

  factory ContentDetail.fromJson(Map<String, dynamic> json) {
    return ContentDetail(
      id: json['_id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      title: json['title'] as String,
      contentDescription: json['contentDescription'] as Map<String, dynamic>,
      media:
          json['media'] != null
              ? MediaDetail.fromJson(json['media'] as Map<String, dynamic>)
              : null,
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
              .toList(),
      inSeries: json['inSeries'] as bool?,
      seriesName: json['seriesName'] as String?,
      seriesIndex: json['seriesIndex'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'title': title,
    'contentDescription': contentDescription,
    'media': media?.toJson(),
    'tags': tags?.map((t) => t.toJson()).toList(),
    'inSeries': inSeries,
    'seriesName': seriesName,
    'seriesIndex': seriesIndex,
  };

  ContentDetail copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    Map<String, dynamic>? contentDescription,
    MediaDetail? media,
    List<Tag>? tags,
    bool? inSeries,
    String? seriesName,
    int? seriesIndex,
  }) {
    return ContentDetail(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      contentDescription: contentDescription ?? this.contentDescription,
      media: media ?? this.media,
      tags: tags ?? this.tags,
      inSeries: inSeries ?? this.inSeries,
      seriesName: seriesName ?? this.seriesName,
      seriesIndex: seriesIndex ?? this.seriesIndex,
    );
  }
}

class MediaDetail {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String filename;
  final String mimeType;
  final int filesize;
  final int width;
  final int height;
  final int focalX;
  final int focalY;
  final String prefix;

  MediaDetail({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.filename,
    required this.mimeType,
    required this.filesize,
    required this.width,
    required this.height,
    required this.focalX,
    required this.focalY,
    required this.prefix,
  });

  factory MediaDetail.fromJson(Map<String, dynamic> json) {
    return MediaDetail(
      id: json['_id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      filename: json['filename'] as String,
      mimeType: json['mimeType'] as String,
      filesize: json['filesize'] as int,
      width: json['width'] as int,
      height: json['height'] as int,
      focalX: json['focalX'] as int,
      focalY: json['focalY'] as int,
      prefix: json['prefix'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'filename': filename,
    'mimeType': mimeType,
    'filesize': filesize,
    'width': width,
    'height': height,
    'focalX': focalX,
    'focalY': focalY,
    'prefix': prefix,
  };

  String getFullImageUrl() {
    return '${ApiConstants.mediaBaseUrl}/$filename';
  }

  MediaDetail copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? filename,
    String? mimeType,
    int? filesize,
    int? width,
    int? height,
    int? focalX,
    int? focalY,
    String? prefix,
  }) {
    return MediaDetail(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      filename: filename ?? this.filename,
      mimeType: mimeType ?? this.mimeType,
      filesize: filesize ?? this.filesize,
      width: width ?? this.width,
      height: height ?? this.height,
      focalX: focalX ?? this.focalX,
      focalY: focalY ?? this.focalY,
      prefix: prefix ?? this.prefix,
    );
  }
}

class Tag {
  final String value;
  final String id;

  Tag({required this.value, required this.id});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(value: json['value'] as String, id: json['id'] as String);
  }

  Map<String, dynamic> toJson() => {'value': value, 'id': id};

  Tag copyWith({String? value, String? id}) {
    return Tag(value: value ?? this.value, id: id ?? this.id);
  }
}
