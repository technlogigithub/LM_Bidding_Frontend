
class BannerModel {
  int? responseCode;
  String? response;
  String? message;
  List<BannerResult>? result;

  BannerModel({this.responseCode, this.response, this.message, this.result});

  BannerModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    response = json['response'];
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
    data['response'] = response;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerResult {
  int? id;
  dynamic ukey;
  String? title;
  String? image;
  String? redirectUrl;
  int? status;
  dynamic createdAt;
  dynamic updatedAt;

  BannerResult({
    this.id,
    this.ukey,
    this.title,
    this.image,
    this.redirectUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  BannerResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ukey = json['ukey'];
    title = json['title'];
    image = json['image'];
    redirectUrl = json['redirect_url'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ukey'] = ukey;
    data['title'] = title;
    data['image'] = image;
    data['redirect_url'] = redirectUrl;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
