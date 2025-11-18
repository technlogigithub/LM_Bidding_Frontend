class ProfileDetailsResponeModel {
  int? responseCode;
  bool? success;
  String? message;
  Result? result;

  ProfileDetailsResponeModel(
      {this.responseCode, this.success, this.message, this.result});

  ProfileDetailsResponeModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['response_code'] = responseCode;
    data['success'] = success;
    data['message'] = message;
    if (result != null) data['result'] = result!.toJson();
    return data;
  }
}

class Result {
  String? userKey;
  String? userType;
  String? username;
  String? name;
  String? email;
  String? mobile;
  String? dpImage;
  String? bannerImage;
  String? referralCode;
  String? dpImageUrl;
  String? bannerImageUrl;

  List<BankAccount>? bankAccounts;
  List<Addresses>? addresses;
  List<Documents>? documents;

  Result({
    this.userKey,
    this.userType,
    this.username,
    this.name,
    this.email,
    this.mobile,
    this.dpImage,
    this.bannerImage,
    this.referralCode,
    this.dpImageUrl,
    this.bannerImageUrl,
    this.bankAccounts,
    this.addresses,
    this.documents,
  });

  Result.fromJson(Map<String, dynamic> json) {
    userKey = json['user_key'];
    userType = json['user_type'];
    username = json['username'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    dpImage = json['dp_image'];
    bannerImage = json['banner_image'];
    referralCode = json['referral_code'];
    dpImageUrl = json['dp_image_url'];
    bannerImageUrl = json['banner_image_url'];

    if (json['bank_accounts'] != null) {
      bankAccounts = [];
      json['bank_accounts'].forEach((v) {
        bankAccounts!.add(BankAccount.fromJson(v));
      });
    }

    if (json['addresses'] != null) {
      addresses = [];
      json['addresses'].forEach((v) {
        addresses!.add(Addresses.fromJson(v));
      });
    }

    if (json['documents'] != null) {
      documents = [];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['user_key'] = userKey;
    data['user_type'] = userType;
    data['username'] = username;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['dp_image'] = dpImage;
    data['banner_image'] = bannerImage;
    data['referral_code'] = referralCode;
    data['dp_image_url'] = dpImageUrl;
    data['banner_image_url'] = bannerImageUrl;

    if (bankAccounts != null) {
      data['bank_accounts'] = bankAccounts!.map((v) => v.toJson()).toList();
    }
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

// ---------------- BANK ACCOUNT MODEL ----------------
class BankAccount {
  String? accountNumber;
  String? bankName;
  String? ifsc;

  BankAccount({this.accountNumber, this.bankName, this.ifsc});

  BankAccount.fromJson(Map<String, dynamic> json) {
    accountNumber = json['account_number'];
    bankName = json['bank_name'];
    ifsc = json['ifsc'];
  }

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'bank_name': bankName,
      'ifsc': ifsc,
    };
  }
}

// ---------------- ADDRESS MODEL ----------------
class Addresses {
  String? addressKey;
  String? addressType;
  String? fullAddress;
  String? latitude;
  String? longitude;
  int? isDefault;

  Addresses({
    this.addressKey,
    this.addressType,
    this.fullAddress,
    this.latitude,
    this.longitude,
    this.isDefault,
  });

  Addresses.fromJson(Map<String, dynamic> json) {
    addressKey = json['address_key'];
    addressType = json['address_type'];
    fullAddress = json['full_address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    return {
      'address_key': addressKey,
      'address_type': addressType,
      'full_address': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
    };
  }
}

// ---------------- DOCUMENTS MODEL ----------------
class Documents {
  String? docKey;
  String? documentKey;
  String? documentValue;
  String? documentUrl;
  int? isVerified;
  String? documentUrlFull;

  Documents({
    this.docKey,
    this.documentKey,
    this.documentValue,
    this.documentUrl,
    this.isVerified,
    this.documentUrlFull,
  });

  Documents.fromJson(Map<String, dynamic> json) {
    docKey = json['doc_key'];
    documentKey = json['document_key'];
    documentValue = json['document_value'];
    documentUrl = json['document_url'];
    isVerified = json['is_verified'];
    documentUrlFull = json['document_url_full'];
  }

  Map<String, dynamic> toJson() {
    return {
      'doc_key': docKey,
      'document_key': documentKey,
      'document_value': documentValue,
      'document_url': documentUrl,
      'is_verified': isVerified,
      'document_url_full': documentUrlFull,
    };
  }
}
