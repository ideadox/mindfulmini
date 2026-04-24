class CmsModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final ContentDescription contentDescription;
  final Media? thumbnail;
  final Media? media;
  final Media? motionPicture;
  final Media? audio;
  final Media? audioTimings;
  final List<Tag> tags;
  final bool inSeries;
  final String seriesId;
  final int seriesIndex;
  final int v;
  final int viewCount;
  final Map<String, dynamic> contentDescriptionJson;

  /// Preferred image for cards/lists: thumbnail first, then media.
  String? get cardImageFilename => thumbnail?.filename ?? media?.filename;

  /// Hero / initial play screen: **media** first, then thumbnail.
  Media? get stillVisualMedia => media ?? thumbnail;

  /// While audio plays: motion first, then media, then thumbnail.
  Media? get playingVisualMedia =>
      motionPicture ?? media ?? thumbnail;

  /// Filename for initial play hero ([stillVisualMedia]).
  String? get stillImageFilename => stillVisualMedia?.filename;

  /// Filename for the playing-state visual ([playingVisualMedia]).
  String? get playingImageFilename => playingVisualMedia?.filename;

  String? _plainTextCache;

  /// Flattens the Lexical content description tree into plain text.
  String get plainTextContent {
    if (_plainTextCache != null) return _plainTextCache!;
    final buffer = StringBuffer();
    for (final paragraph in contentDescription.root.children) {
      for (final child in paragraph.children) {
        if (child.text != null && child.text!.isNotEmpty) {
          buffer.write(child.text);
          buffer.write(' ');
        }
      }
    }
    _plainTextCache = buffer.toString().trim();
    return _plainTextCache!;
  }

  /// Estimated listen/read duration based on word count (200 WPM).
  Duration get estimatedDuration {
    final trimmed = plainTextContent;
    if (trimmed.isEmpty) return Duration.zero;
    final wordCount = trimmed.split(RegExp(r'\s+')).length;
    return Duration(minutes: (wordCount / 200).ceil());
  }

  CmsModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.contentDescription,
    this.thumbnail,
    required this.media,
    this.motionPicture,
    this.audio,
    this.audioTimings,
    required this.tags,
    required this.inSeries,
    required this.seriesId,
    required this.seriesIndex,
    required this.v,
    required this.viewCount,
    required this.contentDescriptionJson,
  });

  factory CmsModel.fromJson(Map<String, dynamic> json) {
    return CmsModel(
      id: json['_id'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
      title: json['title'] ?? '',
      contentDescription: json['contentDescription'] != null
          ? ContentDescription.fromJson(json['contentDescription'])
          : ContentDescription(root: ContentRoot(children: [])),
      thumbnail: json['thumbnail'] != null && json['thumbnail'] is Map
          ? Media.fromJson(json['thumbnail'])
          : null,
      media: json['media'] != null ? Media.fromJson(json['media']) : null,
      motionPicture: json['motionPicture'] != null && json['motionPicture'] is Map
          ? Media.fromJson(json['motionPicture'])
          : null,
      audio: json['audio'] != null && json['audio'] is Map
          ? Media.fromJson(json['audio'])
          : null,
      audioTimings: json['audioTimings'] != null && json['audioTimings'] is Map
          ? Media.fromJson(json['audioTimings'])
          : null,
      tags: json['tags'] != null && json['tags'] is List
          ? (json['tags'] as List).map((t) => Tag.fromJson(t)).toList()
          : [],
      inSeries: json['inSeries'] ?? false,
      seriesId: json['series']?.toString() ?? json['seriesName']?.toString() ?? '',
      seriesIndex: json['seriesIndex'] ?? 0,
      v: json['__v'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      contentDescriptionJson: json['contentDescription'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'contentDescription': contentDescription.toJson(),
      if (thumbnail != null) 'thumbnail': thumbnail!.toJson(),
      if (media != null) 'media': media!.toJson(),
      if (motionPicture != null) 'motionPicture': motionPicture!.toJson(),
      if (audio != null) 'audio': audio!.toJson(),
      if (audioTimings != null) 'audioTimings': audioTimings!.toJson(),
      'tags': tags.map((t) => t.toJson()).toList(),
      'inSeries': inSeries,
      'series': seriesId,
      'seriesIndex': seriesIndex,
      '__v': v,
      'viewCount': viewCount,
    };
  }
}

class Media {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String filename;
  final String mimeType;
  final int? filesize;
  final int? width;
  final int? height;
  final int? focalX;
  final int? focalY;
  final int? v;

  Media({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.filename,
    required this.mimeType,
    this.filesize,
    this.width,
    this.height,
    this.focalX,
    this.focalY,
    this.v,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      filename: json['filename'],
      mimeType: json['mimeType'],
      filesize: _parseIntSafe(json['filesize']),
      width: _parseIntSafe(json['width']),
      height: _parseIntSafe(json['height']),
      focalX: _parseIntSafe(json['focalX']),
      focalY: _parseIntSafe(json['focalY']),
      v: _parseIntSafe(json['__v']),
    );
  }

  static int? _parseIntSafe(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed;
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
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
      '__v': v,
    };
  }
}

class Tag {
  final String value;
  final String id;

  Tag({required this.value, required this.id});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(value: json['value'], id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'id': id};
  }
}

class ContentDescription {
  final ContentRoot root;

  ContentDescription({required this.root});

  factory ContentDescription.fromJson(Map<String, dynamic> json) {
    if (json['root'] != null) {
    return ContentDescription(root: ContentRoot.fromJson(json['root']));
    }
    // Return empty content description if root is null
    return ContentDescription(
      root: ContentRoot(children: []),
    );
  }

  Map<String, dynamic> toJson() => {'root': root.toJson()};
}

class ContentRoot {
  final List<ContentParagraph> children;

  ContentRoot({required this.children});

  factory ContentRoot.fromJson(Map<String, dynamic> json) {
    if (json['children'] != null && json['children'] is List) {
    return ContentRoot(
      children:
          (json['children'] as List)
              .map((e) => ContentParagraph.fromJson(e))
              .toList(),
    );
    }
    return ContentRoot(children: []);
  }

  Map<String, dynamic> toJson() => {
    'children': children.map((e) => e.toJson()).toList(),
  };
}

class ContentParagraph {
  final List<ContentChild> children;
  final String? direction;
  final String format;
  final int indent;
  final String type;
  final int version;

  ContentParagraph({
    required this.children,
    this.direction,
    required this.format,
    required this.indent,
    required this.type,
    required this.version,
  });

  factory ContentParagraph.fromJson(Map<String, dynamic> json) {
    return ContentParagraph(
      children: json['children'] != null && json['children'] is List
          ? (json['children'] as List)
              .map((c) => ContentChild.fromJson(c))
              .toList()
          : [],
      direction: json['direction'],
      format: json['format'] ?? '',
      indent: Media._parseIntSafe(json['indent']) ?? 0,
      type: json['type'] ?? '',
      version: Media._parseIntSafe(json['version']) ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'children': children.map((e) => e.toJson()).toList(),
    'direction': direction,
    'format': format,
    'indent': indent,
    'type': type,
    'version': version,
  };
}

class ContentChild {
  final String type;
  final String? text;
  final int? detail;
  final int? format;
  final String? mode;
  final String? style;
  final int? version;

  ContentChild({
    required this.type,
    this.text,
    this.detail,
    this.format,
    this.mode,
    this.style,
    this.version,
  });

  factory ContentChild.fromJson(Map<String, dynamic> json) {
    return ContentChild(
      type: json['type'] ?? '',
      text: json['text'],
      detail: Media._parseIntSafe(json['detail']),
      format: Media._parseIntSafe(json['format']),
      mode: json['mode'],
      style: json['style'],
      version: Media._parseIntSafe(json['version']),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    if (text != null) 'text': text,
    if (detail != null) 'detail': detail,
    if (format != null) 'format': format,
    if (mode != null) 'mode': mode,
    if (style != null) 'style': style,
    if (version != null) 'version': version,
  };
}
