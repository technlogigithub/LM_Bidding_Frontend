class GetPostListResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  List<Result>? result;
  int? nextStart;
  bool? hasMore;

  factory GetPostListResponseModel.fromJson(Map<String, dynamic> json) {
    return GetPostListResponseModel(
      responseCode: json['response_code'],
      success: json['success'],
      message: json['message'],
      result: (json['result'] as List?)
          ?.map((e) => Result.fromJson(e))
          .toList(),
      nextStart: json['next_start'],
      hasMore: json['has_more'],
    );
  }

  GetPostListResponseModel({
    this.responseCode,
    this.success,
    this.message,
    this.result,
    this.nextStart,
    this.hasMore,
  });
}

class Result {
  Hidden? hidden;
  List<Media>? media;
  Info? info;
  Details? details;

  List<dynamic>? actionButton;

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      hidden: json['hidden'] != null ? Hidden.fromJson(json['hidden']) : null,
      media: (json['media'] as List?)?.map((e) => Media.fromJson(e)).toList(),
      info: json['info'] != null ? Info.fromJson(json['info']) : null,
      details:
      json['details'] != null ? Details.fromJson(json['details']) : null,
      actionButton: json['action_button'],
    );
  }

  Result({this.hidden, this.media, this.info, this.details, this.actionButton});
}

class Hidden {
  String? ukey;
  String? apiEndpoint;
  String? viewType;
  bool? loginRequired;

  factory Hidden.fromJson(Map<String, dynamic> json) {
    return Hidden(
      ukey: json['ukey'],
      apiEndpoint: json['api_endpoint'],
      viewType: json['view_type'],
      loginRequired: json['login_required'],
    );
  }

  Hidden({this.ukey, this.apiEndpoint, this.viewType, this.loginRequired});
}

class Media {
  String? mediaType;
  String? fieldName;
  String? mimeType;
  String? url;

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      mediaType: json['media_type'],
      fieldName: json['field_name'],
      mimeType: json['mime_type'],
      url: json['url'],
    );
  }

  Media({this.mediaType, this.fieldName, this.mimeType, this.url});
}

class Info {
  final Map<String, dynamic> _data;

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(Map<String, dynamic>.from(json));
  }

  Info(this._data);

  dynamic operator [](String key) => _data[key];

  void operator []=(String key, dynamic value) {
    _data[key] = value;
  }

  String? getValue(int index) => _data[index.toString()]?.toString();
}

class Details {
  final Map<String, dynamic> _data;

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(Map<String, dynamic>.from(json));
  }

  Details(this._data);

  dynamic operator [](String key) => _data[key];

  String? getValue(int index) => _data[index.toString()]?.toString();

  Map<String, dynamic> toJson() => _data;
}
