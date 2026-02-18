class MyOrderResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  MyOrderResult? result;

  MyOrderResponseModel({
    this.responseCode,
    this.success,
    this.message,
    this.result,
  });

  MyOrderResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    if (json['result'] != null && json['result'] is Map<String, dynamic>) {
      result = MyOrderResult.fromJson(json['result']);
    } else {
      result = null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'response_code': responseCode,
      'success': success,
      'message': message,
      'result': result?.toJson(),
    };
  }
}

class MyOrderResult {
  String? nextPageName;
  String? nextPageViewType;
  String? nextPageApiEndpoint;
  String? viewType;
  String? title;
  String? apiEndpoint;
  List<OrderItem>? items;

  MyOrderResult({
    this.nextPageName,
    this.nextPageViewType,
    this.nextPageApiEndpoint,
    this.viewType,
    this.title,
    this.apiEndpoint,
    this.items,
  });

  MyOrderResult.fromJson(Map<String, dynamic> json) {
    nextPageName = json['next_page_name'];
    nextPageViewType = json['next_page_view_type'];
    nextPageApiEndpoint = json['next_page_api_endpoint'];
    viewType = json['view_type'];
    title = json['title'];
    apiEndpoint = json['api_endpoint'];

    if (json['items'] != null && json['items'] is List) {
      items = (json['items'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'next_page_name': nextPageName,
      'next_page_view_type': nextPageViewType,
      'next_page_api_endpoint': nextPageApiEndpoint,
      'view_type': viewType,
      'title': title,
      'api_endpoint': apiEndpoint,
      'items': items?.map((e) => e.toJson()).toList(),
    };
  }
}


class OrderItem {
  Hidden? hidden;
  List<dynamic>? media;
  Info? info;
  Details? details;
  List<ActionButton>? actionButton;

  OrderItem({
    this.hidden,
    this.media,
    this.info,
    this.details,
    this.actionButton,
  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    hidden = json['hidden'] != null ? Hidden.fromJson(json['hidden']) : null;
    media = json['media'] != null ? List.from(json['media']) : null;
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
    details = json['details'] != null ? Details.fromJson(json['details']) : null;

    if (json['action_button'] != null) {
      actionButton = (json['action_button'] as List)
          .map((e) => ActionButton.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'hidden': hidden?.toJson(),
      'media': media,
      'info': info?.toJson(),
      'details': details?.toJson(),
      'action_button': actionButton?.map((e) => e.toJson()).toList(),
    };
  }
}


class Hidden {
  String? ukey;
  String? apiEndpoint;
  String? viewType;
  String? nextPageName;
  String? nextPageViewType;
  String? nextPageApiEndpoint;
  bool? loginRequired;
  int? orderId;
  int? orderKey;

  Hidden(
      {this.ukey,
      this.apiEndpoint,
      this.viewType,
      this.nextPageName,
      this.nextPageViewType,
      this.nextPageApiEndpoint,
      this.loginRequired,
      this.orderId,
      this.orderKey});

  Hidden.fromJson(Map<String, dynamic> json) {
    ukey = json['ukey'];
    apiEndpoint = json['api_endpoint'];
    viewType = json['view_type'];
    nextPageName = json['next_page_name'];
    nextPageViewType = json['next_page_view_type'];
    nextPageApiEndpoint = json['next_page_api_endpoint'];
    loginRequired = json['login_required'];
    orderId = json['order_id'];
    orderKey = json['order_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ukey'] = this.ukey;
    data['api_endpoint'] = this.apiEndpoint;
    data['view_type'] = this.viewType;
    data['next_page_name'] = this.nextPageName;
    data['next_page_view_type'] = this.nextPageViewType;
    data['next_page_api_endpoint'] = this.nextPageApiEndpoint;
    data['login_required'] = this.loginRequired;
    data['order_id'] = this.orderId;
    data['order_key'] = this.orderKey;
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

  Info(
      {this.favorite,
      this.badge,
      this.price,
      this.title,
      this.ratingReview,
      this.countdownDt,
      this.category,
      this.createdAt});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['favorite'] = this.favorite;
    data['badge'] = this.badge;
    data['price'] = this.price;
    data['title'] = this.title;
    data['rating_review'] = this.ratingReview;
    data['countdown_dt'] = this.countdownDt;
    data['category'] = this.category;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Details {
  String? category;
  String? status;
  String? city;
  String? paymentMethod;
  String? paymentStatus;
  String? orderDate;

  Details(
      {this.category,
      this.status,
      this.city,
      this.paymentMethod,
      this.paymentStatus,
      this.orderDate});

  Details.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    status = json['status'];
    city = json['city'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    orderDate = json['order_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['status'] = this.status;
    data['city'] = this.city;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['order_date'] = this.orderDate;
    return data;
  }
}

class ActionButton {
  String? bgColor;
  dynamic bgImg; // using dynamic since it is null in example
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

  ActionButton(
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
