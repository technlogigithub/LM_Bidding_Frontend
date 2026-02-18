class CartItemResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  CartItemResult? result;

  CartItemResponseModel({
    this.responseCode,
    this.success,
    this.message,
    this.result,
  });

  CartItemResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    if (json['result'] is Map<String, dynamic>) {
      result = CartItemResult.fromJson(json['result']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['success'] = success;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class CartItemResult {
  CartSummary? cartSummary;
  List<CartItem>? items;

  CartItemResult({this.cartSummary, this.items});

  CartItemResult.fromJson(Map<String, dynamic> json) {
    if (json['cart_summary'] is Map<String, dynamic>) {
      cartSummary = CartSummary.fromJson(json['cart_summary']);
    }
    if (json['items'] != null) {
      items = <CartItem>[];
      json['items'].forEach((v) {
        items!.add(CartItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cartSummary != null) {
      data['cart_summary'] = cartSummary!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartSummary {
  dynamic gross;
  dynamic discount;
  dynamic tax;
  dynamic netPayable;

  CartSummary({this.gross, this.discount, this.tax, this.netPayable});

  CartSummary.fromJson(Map<String, dynamic> json) {
    gross = json['gross'];
    discount = json['discount'];
    tax = json['tax'];
    netPayable = json['net_payable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gross'] = gross;
    data['discount'] = discount;
    data['tax'] = tax;
    data['net_payable'] = netPayable;
    return data;
  }
}

class CartItem {
  CartItemHidden? hidden;
  List<dynamic>? media;
  CartItemInfo? info;
  CartItemDetails? details;
  List<CartItemActionButton>? actionButton;

  CartItem({
    this.hidden,
    this.media,
    this.info,
    this.details,
    this.actionButton,
  });

  CartItem.fromJson(Map<String, dynamic> json) {
    hidden = json['hidden'] != null ? CartItemHidden.fromJson(json['hidden']) : null;
    media = json['media'];
    info = json['info'] != null ? CartItemInfo.fromJson(json['info']) : null;
    details = json['details'] != null ? CartItemDetails.fromJson(json['details']) : null;
    if (json['action_button'] != null) {
      actionButton = <CartItemActionButton>[];
      json['action_button'].forEach((v) {
        actionButton!.add(CartItemActionButton.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (hidden != null) {
      data['hidden'] = hidden!.toJson();
    }
    data['media'] = media;
    if (info != null) {
      data['info'] = info!.toJson();
    }
    if (details != null) {
      data['details'] = details!.toJson();
    }
    if (actionButton != null) {
      data['action_button'] = actionButton!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItemHidden {
  String? ukey;
  String? apiEndpoint;
  String? viewType;
  bool? loginRequired;

  CartItemHidden({
    this.ukey,
    this.apiEndpoint,
    this.viewType,
    this.loginRequired,
  });

  CartItemHidden.fromJson(Map<String, dynamic> json) {
    ukey = json['ukey'];
    apiEndpoint = json['api_endpoint'];
    viewType = json['view_type'];
    loginRequired = json['login_required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ukey'] = ukey;
    data['api_endpoint'] = apiEndpoint;
    data['view_type'] = viewType;
    data['login_required'] = loginRequired;
    return data;
  }
}

class CartItemInfo {
  bool? favorite;
  String? badge;
  String? price;
  String? title;
  String? ratingReview;
  String? countdownDt;
  String? category;
  String? createdAt;

  CartItemInfo({
    this.favorite,
    this.badge,
    this.price,
    this.title,
    this.ratingReview,
    this.countdownDt,
    this.category,
    this.createdAt,
  });

  CartItemInfo.fromJson(Map<String, dynamic> json) {
    favorite = json['favorite'];
    badge = json['badge'];
    price = json['price'];
    title = json['title'];
    ratingReview = json['rating_review'];
    countdownDt = json['countdown_dt'];
    category = json['category'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['favorite'] = favorite;
    data['badge'] = badge;
    data['price'] = price;
    data['title'] = title;
    data['rating_review'] = ratingReview;
    data['countdown_dt'] = countdownDt;
    data['category'] = category;
    data['created_at'] = createdAt;
    return data;
  }
}

class CartItemDetails {
  String? category;
  String? status;
  String? city;

  CartItemDetails({this.category, this.status, this.city});

  CartItemDetails.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    status = json['status'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['status'] = status;
    data['city'] = city;
    return data;
  }
}

class CartItemActionButton {
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
  CartItemActionDesign? design;

  CartItemActionButton({
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

  CartItemActionButton.fromJson(Map<String, dynamic> json) {
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
    if (json['design'] is Map<String, dynamic>) {
      design = CartItemActionDesign.fromJson(json['design']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    if (design != null) {
      data['design'] = design!.toJson();
    }
    return data;
  }
}

class CartItemActionDesign {
  String? countdown;
  List<CartItemInput>? inputs;

  CartItemActionDesign({this.countdown, this.inputs});

  CartItemActionDesign.fromJson(Map<String, dynamic> json) {
    countdown = json['countdown'];

    if (json['inputs'] != null) {
      inputs = <CartItemInput>[];
      json['inputs'].forEach((v) {
        inputs!.add(CartItemInput.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['countdown'] = countdown;
    if (inputs != null) {
      data['inputs'] = inputs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItemInput {
  String? inputType;
  String? label;
  String? placeholder;
  String? name;
  bool? required;
  String? apiEndpoint;
  List<CartItemOption>? options;

  CartItemInput({
    this.inputType,
    this.label,
    this.placeholder,
    this.name,
    this.required,
    this.apiEndpoint,
    this.options,
  });

  CartItemInput.fromJson(Map<String, dynamic> json) {
    inputType = json['input_type'];
    label = json['label'];
    placeholder = json['placeholder'];
    name = json['name'];
    required = json['required'];
    apiEndpoint = json['api_endpoint'];

    if (json['options'] != null) {
      options = <CartItemOption>[];
      json['options'].forEach((v) {
        options!.add(CartItemOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['input_type'] = inputType;
    data['label'] = label;
    data['placeholder'] = placeholder;
    data['name'] = name;
    data['required'] = required;
    data['api_endpoint'] = apiEndpoint;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItemInputs {
  CartItemSelectInput? select;

  CartItemInputs({this.select});

  CartItemInputs.fromJson(Map<String, dynamic> json) {
    select = json['select'] != null ? CartItemSelectInput.fromJson(json['select']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (select != null) {
      data['select'] = select!.toJson();
    }
    return data;
  }
}

class CartItemSelectInput {
  String? inputType;
  String? label;
  String? placeholder;
  String? name;
  bool? required;
  String? apiEndpoint;
  List<CartItemOption>? options;

  CartItemSelectInput({
    this.inputType,
    this.label,
    this.placeholder,
    this.name,
    this.required,
    this.apiEndpoint,
    this.options,
  });

  CartItemSelectInput.fromJson(Map<String, dynamic> json) {
    inputType = json['input_type'];
    label = json['label'];
    placeholder = json['placeholder'];
    name = json['name'];
    required = json['required'];
    apiEndpoint = json['api_endpoint'];
    if (json['options'] != null) {
      options = <CartItemOption>[];
      json['options'].forEach((v) {
        options!.add(CartItemOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['input_type'] = inputType;
    data['label'] = label;
    data['placeholder'] = placeholder;
    data['name'] = name;
    data['required'] = required;
    data['api_endpoint'] = apiEndpoint;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItemOption {
  String? label;
  String? value;

  CartItemOption({this.label, this.value});

  CartItemOption.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}
