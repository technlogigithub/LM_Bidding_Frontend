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
  bool? hasSubcategories;
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
    this.hasSubcategories,
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
    hasSubcategories = json['has_subcategories'];
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
    data['has_subcategories'] = hasSubcategories;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class CategoryListModel {
  int? responseCode;
  bool? success;
  String? message;
  List<Result>? result;

  CategoryListModel({
    this.responseCode,
    this.success,
    this.message,
    this.result,
  });

  CategoryListModel.fromJson(Map<String, dynamic> json) {
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
  Null? ukey;
  Null? parentUkey;
  String? name;
  String? title;
  String? categoryDetail;
  String? image;
  bool? hasSubcategories;

  Result({
    this.ukey,
    this.parentUkey,
    this.name,
    this.title,
    this.categoryDetail,
    this.image,
    this.hasSubcategories,
  });

  Result.fromJson(Map<String, dynamic> json) {
    ukey = json['ukey'];
    parentUkey = json['parent_ukey'];
    name = json['name'];
    title = json['title'];
    categoryDetail = json['category_detail'];
    image = json['image'];
    hasSubcategories = json['has_subcategories'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ukey'] = this.ukey;
    data['parent_ukey'] = this.parentUkey;
    data['name'] = this.name;
    data['title'] = this.title;
    data['category_detail'] = this.categoryDetail;
    data['image'] = this.image;
    data['has_subcategories'] = this.hasSubcategories;
    return data;
  }
}
