class GetParticipateListResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  Result? result;

  GetParticipateListResponseModel(
      {this.responseCode, this.success, this.message, this.result});

  GetParticipateListResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? viewType;
  String? title;
  String? nextPageApiEndpoint;
  String? nextPageViewType;
  List<Items>? items;

  Result({this.viewType, this.title, this.nextPageApiEndpoint, this.nextPageViewType, this.items});

  Result.fromJson(Map<String, dynamic> json) {
    viewType = json['view_type'];
    title = json['title'];
    nextPageApiEndpoint = json['next_page_api_endpoint'];
    nextPageViewType = json['next_page_view_type'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['view_type'] = this.viewType;
    data['title'] = this.title;
    data['next_page_api_endpoint'] = this.nextPageApiEndpoint;
    data['next_page_view_type'] = this.nextPageViewType;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  Hidden? hidden;
  List<dynamic>? media;
  Info? info;
  Details? details;
  List<ActionButton>? actionButton;

  Items({this.hidden, this.media, this.info, this.details, this.actionButton});

  Items.fromJson(Map<String, dynamic> json) {
    hidden =
    json['hidden'] != null ? new Hidden.fromJson(json['hidden']) : null;
    if (json['media'] != null) {
      media = <dynamic>[];
      json['media'].forEach((v) {
        media!.add(v);
      });
    }
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
    if (json['action_button'] != null) {
      actionButton = <ActionButton>[];
      json['action_button'].forEach((v) {
        actionButton!.add(new ActionButton.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hidden != null) {
      data['hidden'] = this.hidden!.toJson();
    }
    if (this.media != null) {
      data['media'] = this.media;
    }
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    if (this.actionButton != null) {
      data['action_button'] = this.actionButton!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hidden {
  String? ukey;
  String? participantKey;
  int? orderId;
  String? nextPageName;
  String? nextPageViewType;
  String? nextPageApiEndpoint;
  String? postKey;
  String? apiEndpoint;
  bool? loginRequired;

  Hidden(
      {this.ukey,
        this.participantKey,
        this.orderId,
        this.nextPageName,
        this.nextPageViewType,
        this.nextPageApiEndpoint,
        this.postKey,
        this.apiEndpoint,
        this.loginRequired});

  Hidden.fromJson(Map<String, dynamic> json) {
    ukey = json['ukey'];
    participantKey = json['participant_key'];
    orderId = json['order_id'];
    nextPageName = json['next_page_name'];
    nextPageViewType = json['next_page_view_type'];
    nextPageApiEndpoint = json['next_page_api_endpoint'];
    postKey = json['post_key'];
    apiEndpoint = json['api_endpoint'];
    loginRequired = json['login_required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ukey'] = this.ukey;
    data['participant_key'] = this.participantKey;
    data['order_id'] = this.orderId;
    data['next_page_name'] = this.nextPageName;
    data['next_page_view_type'] = this.nextPageViewType;
    data['next_page_api_endpoint'] = this.nextPageApiEndpoint;
    data['post_key'] = this.postKey;
    data['api_endpoint'] = this.apiEndpoint;
    data['login_required'] = this.loginRequired;
    return data;
  }
}

class Info {
  String? title;
  String? price;
  String? badge;
  bool? favorite;
  String? countdownDt;
  Map<String, dynamic>? extraInfo;

  Info({this.title, this.price, this.badge, this.favorite, this.countdownDt, this.extraInfo});

  Info.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = json['price'];
    badge = json['badge'];
    favorite = json['favorite'];
    countdownDt = json['countdown_dt'];
    
    // Catch dynamic keys (1, 2, etc.)
    extraInfo = {};
    json.forEach((key, value) {
      if (!['title', 'price', 'badge', 'favorite', 'countdown_dt'].contains(key)) {
        extraInfo![key] = value;
      }
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['price'] = this.price;
    data['badge'] = this.badge;
    data['favorite'] = this.favorite;
    data['countdown_dt'] = this.countdownDt;
    if (this.extraInfo != null) {
      data.addAll(this.extraInfo!);
    }
    return data;
  }
}

class Details {
  String? participationStatus;
  dynamic lastBidAmount;
  int? totalBids;
  String? emdAmount;
  int? winnerFlag;
  String? orderDate;
  String? paymentMethod;
  String? paymentStatus;

  Details(
      {this.participationStatus,
        this.lastBidAmount,
        this.totalBids,
        this.emdAmount,
        this.winnerFlag,
        this.orderDate,
        this.paymentMethod,
        this.paymentStatus});

  Details.fromJson(Map<String, dynamic> json) {
    participationStatus = json['participation_status'];
    lastBidAmount = json['last_bid_amount'];
    totalBids = json['total_bids'];
    emdAmount = json['emd_amount'];
    winnerFlag = json['winner_flag'];
    orderDate = json['order_date'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['participation_status'] = this.participationStatus;
    data['last_bid_amount'] = this.lastBidAmount;
    data['total_bids'] = this.totalBids;
    data['emd_amount'] = this.emdAmount;
    data['winner_flag'] = this.winnerFlag;
    data['order_date'] = this.orderDate;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
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
