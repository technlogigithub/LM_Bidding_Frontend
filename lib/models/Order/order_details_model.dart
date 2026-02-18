class GetOrderDetailsResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  List<Result>? result;

  GetOrderDetailsResponseModel(
      {this.responseCode, this.success, this.message, this.result});

  GetOrderDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      if (json['result'] is List) {
        json['result'].forEach((v) {
          result!.add(new Result.fromJson(v));
        });
      } else if (json['result'] is Map<String, dynamic>) {
        result!.add(new Result.fromJson(json['result']));
      }
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
  List<DetailsItems>? detailsItems;
  Info? info;
  List<SubmitButton>? submitButton;

  Result({this.hidden, this.address, this.detailsItems, this.info, this.submitButton});

  Result.fromJson(Map<String, dynamic> json) {
    hidden =
    json['hidden'] != null ? new Hidden.fromJson(json['hidden']) : null;
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    if (json['items'] != null) {
      detailsItems = <DetailsItems>[];
      json['items'].forEach((v) {
        detailsItems!.add(new DetailsItems.fromJson(v));
      });
    }
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    if (json['submit_button'] != null) {
      submitButton = <SubmitButton>[];
      json['submit_button'].forEach((v) {
        submitButton!.add(new SubmitButton.fromJson(v));
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
    if (this.detailsItems != null) {
      data['items'] = this.detailsItems!.map((v) => v.toJson()).toList();
    }
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    if (this.submitButton != null) {
      data['submit_button'] =
          this.submitButton!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hidden {
  String? ukey;
  String? viewType;
  bool? loginRequired;
  bool? edit;
  bool? isWalletUsed;

  Hidden(
      {this.ukey,
        this.viewType,
        this.loginRequired,
        this.edit,
        this.isWalletUsed});

  Hidden.fromJson(Map<String, dynamic> json) {
    ukey = json['ukey'];
    viewType = json['view_type'];
    loginRequired = json['login_required'];
    edit = json['edit'];
    isWalletUsed = json['is_wallet_used'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ukey'] = this.ukey;
    data['view_type'] = this.viewType;
    data['login_required'] = this.loginRequired;
    data['edit'] = this.edit;
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

class DetailsItems {
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

  DetailsItems(
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

  DetailsItems.fromJson(Map<String, dynamic> json) {
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

class SubmitButton {
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
  List<dynamic>? design;

  SubmitButton(
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
        this.description,
        this.design});

  SubmitButton.fromJson(Map<String, dynamic> json) {
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
    if (json['design'] != null) {
      if (json['design'] is List) {
        design = List<dynamic>.from(json['design']);
      } else if (json['design'] is Map<String, dynamic>) {
        design = [json['design']]; // wrap map inside list
      }
    }

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
    if (this.design != null) {
      data['design'] = this.design;
    }
    return data;
  }
}
