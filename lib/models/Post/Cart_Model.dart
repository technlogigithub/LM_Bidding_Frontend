class CartResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  List<Result>? result;

  CartResponseModel({
    this.responseCode,
    this.success,
    this.message,
    this.result,
  });

  CartResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    if (json['result'] != null) {
      result = (json['result'] as List)
          .map((e) => Result.fromJson(e))
          .toList();
    }
  }
}
class Result {
  Hidden? hidden;
  Address? address;
  Items? items;
  Items? coupon;
  Items? walletUse;
  Info? info;
  List<SubmitButton>? submitButton;

  Result({
    this.hidden,
    this.address,
    this.items,
    this.coupon,
    this.walletUse,
    this.info,
    this.submitButton,
  });

  Result.fromJson(Map<String, dynamic> json) {
    hidden =
    json['hidden'] != null ? Hidden.fromJson(json['hidden']) : null;
    address =
    json['address'] != null ? Address.fromJson(json['address']) : null;
    items = json['items'] != null ? Items.fromJson(json['items']) : null;
    coupon = json['coupon'] != null ? Items.fromJson(json['coupon']) : null;
    walletUse = json['wallet_use'] != null
        ? Items.fromJson(json['wallet_use'])
        : null;
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
    if (json['submit_button'] != null) {
      submitButton = (json['submit_button'] as List)
          .map((e) => SubmitButton.fromJson(e))
          .toList();
    }
  }
}
class Hidden {
  String? ukey;
  String? viewType;
  bool? loginRequired;

  Hidden.fromJson(Map<String, dynamic> json) {
    ukey = json['ukey'];
    viewType = json['view_type'];
    loginRequired = json['login_required'];
  }
}

class Address {
  String? label;
  String? title;
  String? description;
  bool? edit;

  Address.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    title = json['title'];
    description = json['description'];
    edit = json['edit'];
  }
}
class Items {
  String? bgColor;
  String? label;
  bool? isActive;
  bool? loginRequired;
  String? apiEndpoint;
  String? viewType;
  String? title;
  String? description;
  ActionDesign? design;

  Items.fromJson(Map<String, dynamic> json) {
    bgColor = json['bg_color'];
    label = json['label'];
    isActive = json['is_active'];
    loginRequired = json['login_required'];
    apiEndpoint = json['api_endpoint'];
    viewType = json['view_type'];
    title = json['title'];
    description = json['description'];
    design = json['design'] != null
        ? ActionDesign.fromJson(json['design'])
        : null;
  }
}
class ActionDesign {
  List<ActionButton>? actionButtons;

  ActionDesign.fromJson(Map<String, dynamic> json) {
    if (json['action_button'] != null) {
      actionButtons = (json['action_button'] as List)
          .map((e) => ActionButton.fromJson(e))
          .toList();
    }
  }
}
class ActionButton {
  String? icon;
  String? label;
  bool? isActive;
  String? apiEndpoint;
  String? viewType;

  ActionButton.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    label = json['label'];
    isActive = json['is_active'];
    apiEndpoint = json['api_endpoint'];
    viewType = json['view_type'];
  }
}
class InputDesign {
  InputFields? inputs;

  InputDesign.fromJson(Map<String, dynamic> json) {
    inputs =
    json['inputs'] != null ? InputFields.fromJson(json['inputs']) : null;
  }
}

class InputFields {
  ButtonInput? button;
  ButtonInput? checkbox;

  InputFields.fromJson(Map<String, dynamic> json) {
    button =
    json['button'] != null ? ButtonInput.fromJson(json['button']) : null;
    checkbox = json['checkbox'] != null
        ? ButtonInput.fromJson(json['checkbox'])
        : null;
  }
}
class ButtonInput {
  String? inputType;
  String? label;
  String? placeholder;
  String? name;
  bool? required;
  String? apiEndpoint;
  List<dynamic>? options;

  ButtonInput.fromJson(Map<String, dynamic> json) {
    inputType = json['input_type'];
    label = json['label'];
    placeholder = json['placeholder'];
    name = json['name'];
    required = json['required'];
    apiEndpoint = json['api_endpoint'];
    options = json['options'];
  }
}
class Info {
  String? gross;
  String? discount;
  String? charges;
  String? tax;
  String? netPayable;
  Map<String, dynamic>? rawData;

  Info.fromJson(Map<String, dynamic> json) {
    rawData = json;
    gross = json['Gross'];
    discount = json['Discount'];
    charges = json['Charges'];
    tax = json['Tax'];
    netPayable = json['Net Payable'];
  }
}
class SubmitButton {
  String? bgColor;
  String? bgImg;
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
  }
}
