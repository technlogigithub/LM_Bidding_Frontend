
class BannerModel {
  int? responseCode;
  bool? success;
  String? message;
  List<BannerResult>? result;

  BannerModel({this.responseCode, this.success, this.message, this.result});

  BannerModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    if (json['result'] != null) {
      result = <BannerResult>[];
      json['result'].forEach((v) {
        result!.add(BannerResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['success'] = success;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerResult {
  String? title;
  String? description;
  String? filePath;
  String? actionUrl;
  String? mediaType;

  BannerResult({
    this.title,
    this.description,
    this.filePath,
    this.actionUrl,
    this.mediaType,
  });

  BannerResult.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    filePath = json['file_path'];
    actionUrl = json['action_url'];
    mediaType = json['media_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['file_path'] = filePath;
    data['action_url'] = actionUrl;
    data['media_type'] = mediaType;
    return data;
  }
}



class BannerForVideoModel {
  int? responseCode;
  bool? success;
  String? message;
  List<BannerVidepResult>? result;

  BannerForVideoModel({this.responseCode, this.success, this.message, this.result});

  BannerForVideoModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    if (json['result'] != null) {
      result = <BannerVidepResult>[];
      json['result'].forEach((v) {
        result!.add(BannerVidepResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['success'] = success;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerVidepResult {
  String? title;
  String? description;
  String? filePath;
  String? actionUrl;
  String? mediaType;

  BannerVidepResult({
    this.title,
    this.description,
    this.filePath,
    this.actionUrl,
    this.mediaType,
  });

  BannerVidepResult.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    filePath = json['file_path'];
    actionUrl = json['action_url'];
    mediaType = json['media_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['file_path'] = filePath;
    data['action_url'] = actionUrl;
    data['media_type'] = mediaType;
    return data;
  }
}
