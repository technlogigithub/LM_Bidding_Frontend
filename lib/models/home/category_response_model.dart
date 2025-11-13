
class CategoryModel {
  int? responseCode;
  String? response;
  String? message;
  List<CategoryResult>? result;

  CategoryModel({this.responseCode, this.response, this.message, this.result});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    response = json['response'];
    message = json['message'];
    if (json['result'] != null) {
      result = <CategoryResult>[];
      json['result'].forEach((v) {
        result!.add(CategoryResult.fromJson(v));
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

class CategoryResult {
  int? id;
  String? ukey;
  String? name;
  String? categoryDetail;
  String? image;
  String? title;
  int? status;
  dynamic createdAt;
  dynamic updatedAt;

  CategoryResult({
    this.id,
    this.ukey,
    this.name,
    this.categoryDetail,
    this.image,
    this.title,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  CategoryResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ukey = json['ukey'];
    name = json['name'];
    categoryDetail = json['category_detail'];
    image = json['image'];
    title = json['title'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ukey'] = ukey;
    data['name'] = name;
    data['category_detail'] = categoryDetail;
    data['image'] = image;
    data['title'] = title;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
