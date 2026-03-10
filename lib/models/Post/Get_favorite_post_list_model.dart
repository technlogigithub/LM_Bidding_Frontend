class FavoriteResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  List<Result>? result;

  FavoriteResponseModel(
      {this.responseCode, this.success, this.message, this.result});

  FavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  Hidden? hidden;
  List<Media>? media;
  Info? info;
  Details? details;

  Result({this.hidden, this.media, this.info, this.details});

  Result.fromJson(Map<String, dynamic> json) {
    hidden =
        json['hidden'] != null ? new Hidden.fromJson(json['hidden']) : null;
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hidden != null) {
      data['hidden'] = this.hidden!.toJson();
    }
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Media {
  String? mediaType;
  String? fieldName;
  String? mimeType;
  String? url;

  Media({this.mediaType, this.fieldName, this.mimeType, this.url});

  Media.fromJson(Map<String, dynamic> json) {
    mediaType = json['media_type'];
    fieldName = json['field_name'];
    mimeType = json['mime_type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media_type'] = this.mediaType;
    data['field_name'] = this.fieldName;
    data['mime_type'] = this.mimeType;
    data['url'] = this.url;
    return data;
  }
}

class Hidden {
  String? ukey;
  String? apiEndpoint;
  String? viewType;
  bool? loginRequired;

  Hidden({this.ukey, this.apiEndpoint, this.viewType, this.loginRequired});

  Hidden.fromJson(Map<String, dynamic> json) {
    ukey = json['ukey'];
    apiEndpoint = json['api_endpoint'];
    viewType = json['view_type'];
    loginRequired = json['login_required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ukey'] = this.ukey;
    data['api_endpoint'] = this.apiEndpoint;
    data['view_type'] = this.viewType;
    data['login_required'] = this.loginRequired;
    return data;
  }
}

class Info {
  final Map<String, dynamic> _data;

  Info(this._data);

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(Map<String, dynamic>.from(json));
  }

  dynamic operator [](String key) => _data[key];

  void operator []=(String key, dynamic value) {
    _data[key] = value;
  }

  String? getValue(int index) => _data[index.toString()]?.toString();

  Map<String, dynamic> toJson() => _data;
}

class Details {
  final Map<String, dynamic> _data;

  Details(this._data);

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(Map<String, dynamic>.from(json));
  }

  dynamic operator [](String key) => _data[key];

  void operator []=(String key, dynamic value) {
    _data[key] = value;
  }

  String? getValue(int index) => _data[index.toString()]?.toString();

  Map<String, dynamic> toJson() => _data;
}

