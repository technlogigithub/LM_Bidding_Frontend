class ProfileDetailsResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  Result? result;

  ProfileDetailsResponseModel({
    this.responseCode,
    this.success,
    this.message,
    this.result,
  });

  ProfileDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['success'] = success;
    data['message'] = message;
    if (result != null) data['result'] = result!.toJson();
    return data;
  }
}

class Result {
  Hidden? hidden;
  DP? dp;
  BannerImage? banner;
  BasicInfo? basicInfo;
  List<Address>? address;
  List<Documents>? documents;

  /// Store full API response for dynamic UI
  Map<String, dynamic>? rawData;

  Result({
    this.hidden,
    this.dp,
    this.banner,
    this.basicInfo,
    this.address,
    this.documents,
    this.rawData,
  });

  Result.fromJson(Map<String, dynamic> json) {
    rawData = json;

    hidden = json['hidden'] != null ? Hidden.fromJson(json['hidden']) : null;

    // Correct keys
    dp = json['dp'] != null ? DP.fromJson(json['dp']) : null;
    banner = json['banner'] != null ? BannerImage.fromJson(json['banner']) : null;

    basicInfo = json['Basic Info'] != null
        ? BasicInfo.fromJson(json['Basic Info'])
        : null;

    if (json['Address'] != null) {
      address = [];
      json['Address'].forEach((v) {
        address!.add(Address.fromJson(v));
      });
    }

    if (json['Documents'] != null) {
      documents = [];
      json['Documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (hidden != null) data['hidden'] = hidden!.toJson();
    if (dp != null) data['dp'] = dp!.toJson();
    if (banner != null) data['banner'] = banner!.toJson();
    if (basicInfo != null) data['Basic Info'] = basicInfo!.toJson();

    if (address != null) {
      data['Address'] = address!.map((e) => e.toJson()).toList();
    }

    if (documents != null) {
      data['Documents'] = documents!.map((e) => e.toJson()).toList();
    }

    return data;
  }
}

class Hidden {
  String? userKey;
  String? referralCode;
  String? walletBalance;

  Hidden({this.userKey, this.referralCode, this.walletBalance});

  Hidden.fromJson(Map<String, dynamic> json) {
    userKey = json['user_key'];
    referralCode = json['referral_code'];
    walletBalance = json['wallet_balance'];
  }

  Map<String, dynamic> toJson() {
    return {
      'user_key': userKey,
      'referral_code': referralCode,
      'wallet_balance': walletBalance,
    };
  }
}

class DP {
  String? dp;

  DP({this.dp});

  DP.fromJson(Map<String, dynamic> json) {
    dp = json['DP'];
  }

  Map<String, dynamic> toJson() {
    return {'DP': dp};
  }
}

class BannerImage {
  String? banner;

  BannerImage({this.banner});

  BannerImage.fromJson(Map<String, dynamic> json) {
    banner = json['Banner'];
  }

  Map<String, dynamic> toJson() {
    return {'Banner': banner};
  }
}

class BasicInfo {
  String? userType;
  String? name;
  String? username;
  String? mobile;
  String? email;

  BasicInfo({
    this.userType,
    this.name,
    this.username,
    this.mobile,
    this.email,
  });

  BasicInfo.fromJson(Map<String, dynamic> json) {
    userType = json['User Type'];
    name = json['Name'];
    username = json['Username'];
    mobile = json['Mobile'];
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    return {
      'User Type': userType,
      'Name': name,
      'Username': username,
      'Mobile': mobile,
      'Email': email,
    };
  }
}

class Address {
  String? type;
  String? address;
  String? isDefault;

  Address({this.type, this.address, this.isDefault});

  Address.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    address = json['Address'];
    isDefault = json['Default'];
  }

  Map<String, dynamic> toJson() {
    return {
      'Type': type,
      'Address': address,
      'Default': isDefault,
    };
  }
}

class Documents {
  String? name;
  String? number;
  String? image;
  String? verified;

  Documents({
    this.name,
    this.number,
    this.image,
    this.verified,
  });

  Documents.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    number = json['Number']; // may be null
    image = json['Image'];   // may be null
    verified = json['Verified'];
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Number': number,
      'Image': image,
      'Verified': verified,
    };
  }
}
