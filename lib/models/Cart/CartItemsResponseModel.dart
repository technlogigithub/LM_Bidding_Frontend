class CartItemsResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  CartResult? result;

  CartItemsResponseModel({
    this.responseCode,
    this.success,
    this.message,
    this.result,
  });

  CartItemsResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    result =
        json['result'] != null ? CartResult.fromJson(json['result']) : null;
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

class CartResult {
  CartSummary? cartSummary;
  List<CartItem>? items;

  CartResult({this.cartSummary, this.items});

  CartResult.fromJson(Map<String, dynamic> json) {
    cartSummary = json['cart_summary'] != null
        ? CartSummary.fromJson(json['cart_summary'])
        : null;
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
  num? gross;
  num? discount;
  num? tax;
  num? netPayable;

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
  Hidden? hidden;
  List<dynamic>? media;
  Info? info;
  Details? details;
  List<ActionButton>? actionButton;

  CartItem({
    this.hidden,
    this.media,
    this.info,
    this.details,
    this.actionButton,
  });

  CartItem.fromJson(Map<String, dynamic> json) {
    hidden =
        json['hidden'] != null ? Hidden.fromJson(json['hidden']) : null;
    if (json['media'] != null) {
      media = <dynamic>[];
      json['media'].forEach((v) {
        media!.add(v);
      });
    }
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
    details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
    if (json['action_button'] != null) {
      actionButton = <ActionButton>[];
      json['action_button'].forEach((v) {
        actionButton!.add(ActionButton.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (hidden != null) {
      data['hidden'] = hidden!.toJson();
    }
    if (media != null) {
      data['media'] = media!.map((v) => v).toList();
    }
    if (info != null) {
      data['info'] = info!.toJson();
    }
    if (details != null) {
      data['details'] = details!.toJson();
    }
    if (actionButton != null) {
      data['action_button'] =
          actionButton!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hidden {
  String? ukey;
  String? apiEndpoint;
  String? viewType;
  bool? loginRequired;

  Hidden({this.ukey, this.apiEndpoint, this.viewType, this.loginRequired});

  Hidden.fromJson(Map<String, dynamic> json) {
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

class Info {
  bool? favorite;
  String? badge;
  String? price;
  String? title;
  String? ratingReview;
  String? countdownDt;
  String? category;
  String? createdAt;

  Info({
    this.favorite,
    this.badge,
    this.price,
    this.title,
    this.ratingReview,
    this.countdownDt,
    this.category,
    this.createdAt,
  });

  Info.fromJson(Map<String, dynamic> json) {
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

class Details {
  String? category;
  String? status;
  String? city;

  Details({this.category, this.status, this.city});

  Details.fromJson(Map<String, dynamic> json) {
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

class ActionButton {
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
  List<dynamic>? design;

  ActionButton({
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

  ActionButton.fromJson(Map<String, dynamic> json) {
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
      design = <dynamic>[];
      json['design'].forEach((v) {
        design!.add(v);
      });
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
      data['design'] = design!.map((v) => v).toList();
    }
    return data;
  }
}
