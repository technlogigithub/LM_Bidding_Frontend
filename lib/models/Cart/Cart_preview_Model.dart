class CartPreviewResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  List<Result>? result;

  CartPreviewResponseModel(
      {this.responseCode, this.success, this.message, this.result});

  CartPreviewResponseModel.fromJson(Map<String, dynamic> json) {
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
  Hidden? hidden;
  Address? address;
  List<Items>? items;
  Info? info;
  List<PaymentMethods>? paymentMethods;

  Result(
      {this.hidden, this.address, this.items, this.info, this.paymentMethods});

  Result.fromJson(Map<String, dynamic> json) {
    hidden =
    json['hidden'] != null ? new Hidden.fromJson(json['hidden']) : null;
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    if (json['payment_methods'] != null) {
      paymentMethods = <PaymentMethods>[];
      json['payment_methods'].forEach((v) {
        paymentMethods!.add(new PaymentMethods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hidden != null) {
      data['hidden'] = this.hidden!.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    if (this.paymentMethods != null) {
      data['payment_methods'] =
          this.paymentMethods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hidden {
  String? ukey;
  String? viewType;
  bool? loginRequired;
  bool? isWalletUsed;

  Hidden({this.ukey, this.viewType, this.loginRequired, this.isWalletUsed});

  Hidden.fromJson(Map<String, dynamic> json) {
    ukey = json['ukey'];
    viewType = json['view_type'];
    loginRequired = json['login_required'];
    isWalletUsed = json['is_wallet_used'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ukey'] = this.ukey;
    data['view_type'] = this.viewType;
    data['login_required'] = this.loginRequired;
    data['is_wallet_used'] = this.isWalletUsed;
    return data;
  }
}

class Address {
  String? label;
  String? title;
  String? description;
  String? addressLat;
  String? addressLong;
  bool? edit;

  Address(
      {this.label,
        this.title,
        this.description,
        this.addressLat,
        this.addressLong,
        this.edit});

  Address.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    title = json['title'];
    description = json['description'];
    addressLat = json['address_lat'];
    addressLong = json['address_long'];
    edit = json['edit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['title'] = this.title;
    data['description'] = this.description;
    data['address_lat'] = this.addressLat;
    data['address_long'] = this.addressLong;
    data['edit'] = this.edit;
    return data;
  }
}

class Items {
  String? bgColor;
  Null? bgImg;
  String? label;
  bool? isActive;
  bool? loginRequired;
  String? apiEndpoint;
  String? viewType;
  String? viewAllLabel;
  String? viewAllNextPage;
  String? nextPageName;
  String? nextPageApiEndpoint;
  String? nextPageViewType;
  String? pageImage;
  String? title;
  String? description;

  Items(
      {this.bgColor,
        this.bgImg,
        this.label,
        this.isActive,
        this.loginRequired,
        this.apiEndpoint,
        this.viewType,
        this.viewAllLabel,
        this.viewAllNextPage,
        this.nextPageName,
        this.nextPageApiEndpoint,
        this.nextPageViewType,
        this.pageImage,
        this.title,
        this.description});

  Items.fromJson(Map<String, dynamic> json) {
    bgColor = json['bg_color'];
    bgImg = json['bg_img'];
    label = json['label'];
    isActive = json['is_active'];
    loginRequired = json['login_required'];
    apiEndpoint = json['api_endpoint'];
    viewType = json['view_type'];
    viewAllLabel = json['view_all_label'];
    viewAllNextPage = json['view_all_next_page'];
    nextPageName = json['next_page_name'];
    nextPageApiEndpoint = json['next_page_api_endpoint'];
    nextPageViewType = json['next_page_view_type'];
    pageImage = json['page_image'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bg_color'] = this.bgColor;
    data['bg_img'] = this.bgImg;
    data['label'] = this.label;
    data['is_active'] = this.isActive;
    data['login_required'] = this.loginRequired;
    data['api_endpoint'] = this.apiEndpoint;
    data['view_type'] = this.viewType;
    data['view_all_label'] = this.viewAllLabel;
    data['view_all_next_page'] = this.viewAllNextPage;
    data['next_page_name'] = this.nextPageName;
    data['next_page_api_endpoint'] = this.nextPageApiEndpoint;
    data['next_page_view_type'] = this.nextPageViewType;
    data['page_image'] = this.pageImage;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}

class Info {
  Map<String, dynamic>? rawData;

  Info({this.rawData});

  Info.fromJson(Map<String, dynamic> json) {
    rawData = json;
  }

  Map<String, dynamic> toJson() {
    return rawData ?? {};
  }
}

class PaymentMethods {
  String? label;
  String? icon;
  Button? button;

  PaymentMethods({this.label, this.icon, this.button});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    icon = json['icon'];
    button =
    json['button'] != null ? new Button.fromJson(json['button']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['icon'] = this.icon;
    if (this.button != null) {
      data['button'] = this.button!.toJson();
    }
    return data;
  }
}

class Button {
  String? bgColor;
  dynamic bgImg;
  String? label;
  bool? isActive;
  bool? loginRequired;
  String? apiEndpoint;
  String? viewType;
  String? viewAllLabel;
  String? viewAllNextPage;
  String? nextPageName;
  String? nextPageApiEndpoint;
  String? nextPageViewType;
  String? pageImage;
  String? title;
  String? description;
  List<dynamic>? design; // ✅ FIXED

  Button({
    this.bgColor,
    this.bgImg,
    this.label,
    this.isActive,
    this.loginRequired,
    this.apiEndpoint,
    this.viewType,
    this.viewAllLabel,
    this.viewAllNextPage,
    this.nextPageName,
    this.nextPageApiEndpoint,
    this.nextPageViewType,
    this.pageImage,
    this.title,
    this.description,
    this.design,
  });

  Button.fromJson(Map<String, dynamic> json) {
    bgColor = json['bg_color'];
    bgImg = json['bg_img'];
    label = json['label'];
    isActive = json['is_active'];
    loginRequired = json['login_required'];
    apiEndpoint = json['api_endpoint'];
    viewType = json['view_type'];
    viewAllLabel = json['view_all_label'];
    viewAllNextPage = json['view_all_next_page'];
    nextPageName = json['next_page_name'];
    nextPageApiEndpoint = json['next_page_api_endpoint'];
    nextPageViewType = json['next_page_view_type'];
    pageImage = json['page_image'];
    title = json['title'];
    description = json['description'];
    design = json['design']; // ✅ direct assign
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bg_color'] = bgColor;
    data['bg_img'] = bgImg;
    data['label'] = label;
    data['is_active'] = isActive;
    data['login_required'] = loginRequired;
    data['api_endpoint'] = apiEndpoint;
    data['view_type'] = viewType;
    data['view_all_label'] = viewAllLabel;
    data['view_all_next_page'] = viewAllNextPage;
    data['next_page_name'] = nextPageName;
    data['next_page_api_endpoint'] = nextPageApiEndpoint;
    data['next_page_view_type'] = nextPageViewType;
    data['page_image'] = pageImage;
    data['title'] = title;
    data['description'] = description;
    data['design'] = design;
    return data;
  }
}

