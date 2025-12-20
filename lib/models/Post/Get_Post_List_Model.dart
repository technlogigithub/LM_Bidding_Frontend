class GetPostListResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  List<Result>? result;
  int? nextStart;
  bool? hasMore;

  GetPostListResponseModel({
    this.responseCode,
    this.success,
    this.message,
    this.result,
    this.nextStart,
    this.hasMore,
  });

  GetPostListResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
    nextStart = json['next_start'];
    hasMore = json['has_more'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['next_start'] = this.nextStart;
    data['has_more'] = this.hasMore;
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
    hidden = json['hidden'] != null
        ? new Hidden.fromJson(json['hidden'])
        : null;
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    details = json['details'] != null
        ? new Details.fromJson(json['details'])
        : null;
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
  dynamic mediaKey;
  String? mediaType;
  dynamic fileType;
  String? fieldName;
  String? mimeType;
  dynamic size;
  String? url;

  Media({
    this.mediaKey,
    this.mediaType,
    this.fileType,
    this.fieldName,
    this.mimeType,
    this.size,
    this.url,
  });

  Media.fromJson(Map<String, dynamic> json) {
    mediaKey = json['media_key'];
    mediaType = json['media_type'];
    fileType = json['file_type'];
    fieldName = json['field_name'];
    mimeType = json['mime_type'];
    size = json['size'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media_key'] = this.mediaKey;
    data['media_type'] = this.mediaType;
    data['file_type'] = this.fileType;
    data['field_name'] = this.fieldName;
    data['mime_type'] = this.mimeType;
    data['size'] = this.size;
    data['url'] = this.url;
    return data;
  }
}

class Info {
  bool? favorite;
  String? badge;
  String? ratingReview;
  String? countdownDt;
  String? price;
  String? title;
  String? s1; // Dynamic field "1"
  String? s2; // Dynamic field "2"
  Map<String, dynamic>? _rawData; // Store all raw JSON data

  Info({
    this.favorite,
    this.badge,
    this.ratingReview,
    this.countdownDt,
    this.price,
    this.title,
    this.s1,
    this.s2,
  });

  Info.fromJson(Map<String, dynamic> json) {
    favorite = json['favorite'];
    badge = json['badge'];
    ratingReview = json['rating_review'];
    countdownDt = json['countdown_dt'];
    price = json['price'];
    title = json['title'];
    s1 = json['1']?.toString();
    s2 = json['2']?.toString();
    // Store all fields dynamically
    _rawData = Map<String, dynamic>.from(json);
  }

  Map<String, dynamic> toJson() {
    // Return all raw data if available, otherwise return known fields
    if (_rawData != null) {
      return Map<String, dynamic>.from(_rawData!);
    }
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['favorite'] = this.favorite;
    data['badge'] = this.badge;
    data['rating_review'] = this.ratingReview;
    data['countdown_dt'] = this.countdownDt;
    data['price'] = this.price;
    data['title'] = this.title;
    data['1'] = this.s1;
    data['2'] = this.s2;
    return data;
  }
}

class Details {
  String? s1; // Dynamic field "1"
  String? s2; // Dynamic field "2"
  dynamic s3; // Dynamic field "3" (can be null)
  Map<String, dynamic>? _rawData; // Store all raw JSON data

  Details({this.s1, this.s2, this.s3});

  Details.fromJson(Map<String, dynamic> json) {
    s1 = json['1']?.toString();
    s2 = json['2']?.toString();
    s3 = json['3'];
    // Store all fields dynamically
    _rawData = Map<String, dynamic>.from(json);
  }

  Map<String, dynamic> toJson() {
    // Return all raw data if available, otherwise return known fields
    if (_rawData != null) {
      return Map<String, dynamic>.from(_rawData!);
    }
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
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
