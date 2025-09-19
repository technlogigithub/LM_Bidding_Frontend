// Model classes to represent the data
class UserProfile {
  final String name;
  final String username;
  final String email;
  final String mobile;
  final String? dpImageUrl;
  final String? bannerImageUrl;
  final List<BankAccount> bankAccounts;
  final List<UserAddress> addresses;
  final List<Document> documents;

  UserProfile({
    required this.name,
    required this.username,
    required this.email,
    required this.mobile,
    this.dpImageUrl,
    this.bannerImageUrl,
    required this.bankAccounts,
    required this.addresses,
    required this.documents,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? 'N/A',
      username: json['username'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      mobile: json['mobile'] ?? 'N/A',
      dpImageUrl: json['dp_image_url'],
      bannerImageUrl: json['banner_image_url'],
      bankAccounts: (json['bank_accounts'] as List<dynamic>)
          .map((bank) => BankAccount.fromJson(bank))
          .toList(),
      addresses: (json['addresses'] as List<dynamic>)
          .map((addr) => UserAddress.fromJson(addr))
          .toList(),
      documents: (json['documents'] as List<dynamic>)
          .map((doc) => Document.fromJson(doc))
          .toList(),
    );
  }
}

class BankAccount {
  final String? accountKey;
  final String? beneficiaryName;
  final String? accountNumber;
  final String? ifscCode;
  final String? upiAddress;
  final bool isPrimary;
  final String? documentUrl;

  BankAccount({
    this.accountKey,
    this.beneficiaryName,
    this.accountNumber,
    this.ifscCode,
    this.upiAddress,
    required this.isPrimary,
    this.documentUrl,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      accountKey: json['account_key'],
      beneficiaryName: json['beneficiary_name'] ?? 'N/A',
      accountNumber: json['account_number'] ?? 'N/A',
      ifscCode: json['ifsc_code'] ?? 'N/A',
      upiAddress: json['upi_address'] ?? 'N/A',
      isPrimary: json['is_primary'] == 1,
      documentUrl: json['bank_document_url'],
    );
  }
}

class UserAddress {
  final String? addressKey;
  final String? addressType;
  final String? fullAddress;
  final String? latitude;
  final String? longitude;
  final bool isDefault;

  UserAddress({
    this.addressKey,
    this.addressType,
    this.fullAddress,
    this.latitude,
    this.longitude,
    required this.isDefault,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      addressKey: json['address_key'],
      addressType: json['address_type'] ?? 'N/A',
      fullAddress: json['full_address'] ?? 'Address not provided',
      latitude: json['latitude'],
      longitude: json['longitude'],
      isDefault: json['is_default'] == 1,
    );
  }
}

class Document {
  final String? docKey;
  final String documentKey;
  final String? documentValue;
  final String? documentUrl;
  final bool isVerified;

  Document({
    this.docKey,
    required this.documentKey,
    this.documentValue,
    this.documentUrl,
    required this.isVerified,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      docKey: json['doc_key'],
      documentKey: json['document_key'] ?? 'N/A',
      documentValue: json['document_value'],
      documentUrl: json['document_url_full'],
      isVerified: json['is_verified'] == 1,
    );
  }
}
