class CmsModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final ContentDescription contentDescription;
  final Media? media;
  final List<Tag> tags;
  final bool inSeries;
  final String seriesName;
  final int seriesIndex;
  final int v;
  final int viewCount;
  final Map<String, dynamic> contentDescriptionJson;

  CmsModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.contentDescription,
    required this.media,
    required this.tags,
    required this.inSeries,
    required this.seriesName,
    required this.seriesIndex,
    required this.v,
    required this.viewCount,
    required this.contentDescriptionJson,
  });

  factory CmsModel.fromJson(Map<String, dynamic> json) {
    return CmsModel(
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      title: json['title'],
      contentDescription: ContentDescription.fromJson(
        json['contentDescription'],
      ),
      media: json['media'] != null ? Media.fromJson(json['media']) : null,
      tags: (json['tags'] as List).map((t) => Tag.fromJson(t)).toList(),
      inSeries: json['inSeries'],
      seriesName: json['seriesName'],
      seriesIndex: json['seriesIndex'],
      v: json['__v'],
      viewCount: json['viewCount'],
      contentDescriptionJson: json['contentDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'contentDescription': contentDescription.toJson(),
      if (media != null) 'media': media!.toJson(),
      'tags': tags.map((t) => t.toJson()).toList(),
      'inSeries': inSeries,
      'seriesName': seriesName,
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
  final int filesize;
  final int width;
  final int height;
  final int focalX;
  final int focalY;
  final int v;

  Media({
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
    required this.v,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      filename: json['filename'],
      mimeType: json['mimeType'],
      filesize: json['filesize'],
      width: json['width'],
      height: json['height'],
      focalX: json['focalX'],
      focalY: json['focalY'],
      v: json['__v'],
    );
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
    return ContentDescription(root: ContentRoot.fromJson(json['root']));
  }

  Map<String, dynamic> toJson() => {'root': root.toJson()};
}

class ContentRoot {
  final List<ContentParagraph> children;

  ContentRoot({required this.children});

  factory ContentRoot.fromJson(Map<String, dynamic> json) {
    return ContentRoot(
      children:
          (json['children'] as List)
              .map((e) => ContentParagraph.fromJson(e))
              .toList(),
    );
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
      children:
          (json['children'] as List)
              .map((c) => ContentChild.fromJson(c))
              .toList(),
      direction: json['direction'],
      format: json['format'] ?? '',
      indent: json['indent'],
      type: json['type'],
      version: json['version'],
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
      type: json['type'],
      text: json['text'],
      detail: json['detail'],
      format: json['format'],
      mode: json['mode'],
      style: json['style'],
      version: json['version'],
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
