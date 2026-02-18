class CouponsGetResponseModel {
  bool? success;
  List<CouponsGet>? data;

  CouponsGetResponseModel({this.success, this.data});

  CouponsGetResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <CouponsGet>[];
      json['data'].forEach((v) {
        data!.add(CouponsGet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData['success'] = success;
    if (data != null) {
      jsonData['data'] = data!.map((v) => v.toJson()).toList();
    }
    return jsonData;
  }
}

class CouponsGet {
  int? id;
  String? code;
  String? description;
  String? discountType;
  String? discountValue;
  int? usageLimit;
  int? usedCount;
  String? validFrom;
  String? validTo;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  CouponsGet({
    this.id,
    this.code,
    this.description,
    this.discountType,
    this.discountValue,
    this.usageLimit,
    this.usedCount,
    this.validFrom,
    this.validTo,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  CouponsGet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    description = json['description'];
    discountType = json['discount_type'];
    discountValue = json['discount_value'];
    usageLimit = json['usage_limit'];
    usedCount = json['used_count'];
    validFrom = json['valid_from'];
    validTo = json['valid_to'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData['id'] = id;
    jsonData['code'] = code;
    jsonData['description'] = description;
    jsonData['discount_type'] = discountType;
    jsonData['discount_value'] = discountValue;
    jsonData['usage_limit'] = usageLimit;
    jsonData['used_count'] = usedCount;
    jsonData['valid_from'] = validFrom;
    jsonData['valid_to'] = validTo;
    jsonData['is_active'] = isActive;
    jsonData['created_at'] = createdAt;
    jsonData['updated_at'] = updatedAt;
    return jsonData;
  }
}
