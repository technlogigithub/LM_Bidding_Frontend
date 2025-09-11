class Notification {
  int? responseCode;
  String? response;
  String? message;
  List<NotificationResult>? result;

  Notification({this.responseCode, this.response, this.message, this.result});

  Notification.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    response = json['response'];
    message = json['message'];
    if (json['result'] != null) {
      result = <NotificationResult>[];
      json['result'].forEach((v) {
        result!.add(new NotificationResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['response'] = this.response;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationResult {
  int? id;
  Null? ukey;
  String? title;
  String? image;
  String? description;
  String? redirectUrl;
  int? status;
  Null? createdAt;
  Null? updatedAt;

  NotificationResult(
      {this.id,
      this.ukey,
      this.title,
      this.image,
      this.description,
      this.redirectUrl,
      this.status,
      this.createdAt,
      this.updatedAt});

  NotificationResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ukey = json['ukey'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    redirectUrl = json['redirect_url'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ukey'] = this.ukey;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    data['redirect_url'] = this.redirectUrl;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
