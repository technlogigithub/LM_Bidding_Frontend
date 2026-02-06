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
  List<Items>? items;
  Items? coupon;
  Items? walletUse;
  Info? info;
  List<SubmitButton>? submitButton;
  Map<String, dynamic>? rawData;

  Result({
    this.hidden,
    this.address,
    this.items,
    this.coupon,
    this.walletUse,
    this.info,
    this.submitButton,
    this.rawData,
  });

  Result.fromJson(Map<String, dynamic> json) {
    rawData = json;
    hidden = json['hidden'] is Map<String, dynamic> ? Hidden.fromJson(json['hidden']) : null;
    address = json['address'] is Map<String, dynamic> ? Address.fromJson(json['address']) : null;
    
    if (json['items'] != null) {
      if (json['items'] is List) {
        items = (json['items'] as List).map((e) => Items.fromJson(e)).toList();
      } else if (json['items'] is Map<String, dynamic>) {
        items = [Items.fromJson(json['items'])];
      }
    }

    if (json['coupon'] != null) {
      if (json['coupon'] is List && (json['coupon'] as List).isNotEmpty) {
        coupon = Items.fromJson(json['coupon'][0]);
      } else if (json['coupon'] is Map<String, dynamic>) {
        coupon = Items.fromJson(json['coupon']);
      }
    }

    if (json['wallet_use'] != null) {
      if (json['wallet_use'] is List && (json['wallet_use'] as List).isNotEmpty) {
        walletUse = Items.fromJson(json['wallet_use'][0]);
      } else if (json['wallet_use'] is Map<String, dynamic>) {
        walletUse = Items.fromJson(json['wallet_use']);
      }
    }
    
    info = json['info'] is Map<String, dynamic> ? Info.fromJson(json['info']) : null;
    
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
  bool? isWalletUsed;

  Hidden.fromJson(Map<String, dynamic> json) {
    ukey = json['ukey'];
    viewType = json['view_type'];
    loginRequired = json['login_required'];
    isWalletUsed = json['is_wallet_used'];
  }
}

class Address {
  String? label;
  String? title;
  String? description;
  String? addressLat;
  String? addressLong;
  bool? edit;

  Address.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    title = json['title'];
    description = json['description'];
    addressLat = json['address_lat'];
    addressLong = json['address_long'];
    edit = json['edit'];
  }
}

class Items {
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
  ActionDesign? design;

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
    design = json['design'] is Map<String, dynamic> ? ActionDesign.fromJson(json['design']) : null;
  }
}

class ActionDesign {
  List<ActionButton>? actionButtons;
  InputFields? inputs;

  ActionDesign.fromJson(Map<String, dynamic> json) {
    if (json['action_button'] != null) {
      actionButtons = (json['action_button'] as List)
          .map((e) => ActionButton.fromJson(e))
          .toList();
    }
    if (json['inputs'] is Map<String, dynamic>) {
      inputs = InputFields.fromJson(json['inputs']);
    }
  }
}

class ActionButton {
  String? icon;
  String? label;
  bool? isActive;
  bool? loginRequired;
  String? apiEndpoint;
  String? viewType;
  String? nextPageName;
  String? nextPageApiEndpoint;
  String? nextPageViewType;
  String? pageImage;
  String? title;
  String? description;

  ActionButton.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    label = json['label'];
    isActive = json['is_active'];
    loginRequired = json['login_required'];
    apiEndpoint = json['api_endpoint'];
    viewType = json['view_type'];
    nextPageName = json['next_page_name'];
    nextPageApiEndpoint = json['next_page_api_endpoint'];
    nextPageViewType = json['next_page_view_type'];
    pageImage = json['page_image'];
    title = json['title'];
    description = json['description'];
  }
}

class InputFields {
  ButtonInput? button;
  ButtonInput? checkbox;
  ButtonInput? toggle;
  Map<String, dynamic>? otherInputs;

  InputFields.fromJson(Map<String, dynamic> json) {
    if (json['button'] != null) {
      button = ButtonInput.fromJson(json['button']);
    } else if (json['botton'] != null) {
      button = ButtonInput.fromJson(json['botton']);
    }
    if (json['checkbox'] != null) {
      checkbox = ButtonInput.fromJson(json['checkbox']);
    }
    if (json['toggle'] != null) {
      toggle = ButtonInput.fromJson(json['toggle']);
    }
    json.forEach((key, value) {
      if (key != 'button' && key != 'botton' && key != 'checkbox' && key != 'toggle') {
        otherInputs ??= {};
        otherInputs![key] = value;
      }
    });
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
  Map<String, dynamic>? rawData;

  Info.fromJson(Map<String, dynamic> json) {
    rawData = json;
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
