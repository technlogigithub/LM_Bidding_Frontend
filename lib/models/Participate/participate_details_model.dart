class ParticipateDetaislResponseModel {
  int? responseCode;
  bool? success;
  dynamic message;
  Result? result;

  ParticipateDetaislResponseModel(
      {this.responseCode, this.success, this.message, this.result});

  ParticipateDetaislResponseModel.fromJson(Map<String, dynamic> json) {
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
  Hidden? hidden;
  Address? address;
  List<Items>? items;
  Details? details;
  List<MenuButton>? menuButton;
  List<MenuButton>? actionButton;
  Info? info;
  List<SubmitButton>? submitButton;

  Result(
      {this.hidden,
        this.address,
        this.items,
        this.details,
        this.menuButton,
        this.actionButton,
        this.info,
        this.submitButton});

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
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
    if (json['menu_button'] != null) {
      menuButton = <MenuButton>[];
      json['menu_button'].forEach((v) {
        menuButton!.add(new MenuButton.fromJson(v));
      });
    }
    if (json['action_button'] != null) {
      actionButton = <MenuButton>[];
      json['action_button'].forEach((v) {
        actionButton!.add(new MenuButton.fromJson(v));
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
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    if (this.menuButton != null) {
      data['menu_button'] =
          this.menuButton!.map((v) => v.toJson()).toList();
    }
    if (this.actionButton != null) {
      data['action_button'] =
          this.actionButton!.map((v) => v.toJson()).toList();
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
  dynamic ukey;
  dynamic viewType;
  bool? loginRequired;
  bool? edit;

  Hidden({this.ukey, this.viewType, this.loginRequired, this.edit});

  Hidden.fromJson(Map<String, dynamic> json) {
    ukey = json['ukey'];
    viewType = json['view_type'];
    loginRequired = json['login_required'];
    edit = json['edit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ukey'] = this.ukey;
    data['view_type'] = this.viewType;
    data['login_required'] = this.loginRequired;
    data['edit'] = this.edit;
    return data;
  }
}

class Address {
  dynamic label;
  dynamic title;
  dynamic description;
  dynamic addressLat;
  dynamic addressLong;
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
  dynamic bgColor;
  dynamic bgImg;
  dynamic label;
  bool? isActive;
  bool? loginRequired;
  dynamic apiEndpoint;
  dynamic viewType;
  dynamic viewAllLabel;
  dynamic viewAllNextPage;
  dynamic nextPageName;
  dynamic nextPageApiEndpoint;
  dynamic nextPageViewType;
  dynamic pageImage;
  dynamic title;
  dynamic description;

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

class Details {
  dynamic title;
  dynamic description;
  Map<String, dynamic>? rawData;

  Details({this.title, this.description, this.rawData});

  Details.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    rawData = json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}

class Info {
  dynamic status;
  dynamic startDateTime;
  dynamic endDateTime;
  dynamic participationStatus;
  dynamic lastBidAmount;
  dynamic lastBidTime;
  Map<String, dynamic>? rawData;

  Info(
      {this.status,
        this.startDateTime,
        this.endDateTime,
        this.participationStatus,
        this.lastBidAmount,
        this.lastBidTime,
        this.rawData});

  Info.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    startDateTime = json['start_date_time'];
    endDateTime = json['end_date_time'];
    participationStatus = json['participation_status'];
    lastBidAmount = json['last_bid_amount'];
    lastBidTime = json['last_bid_time'];
    rawData = json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['start_date_time'] = this.startDateTime;
    data['end_date_time'] = this.endDateTime;
    data['participation_status'] = this.participationStatus;
    data['last_bid_amount'] = this.lastBidAmount;
    data['last_bid_time'] = this.lastBidTime;
    return data;
  }
}

class SubmitButton {
  dynamic bgColor;
  dynamic bgImg;
  dynamic label;
  bool? isActive;
  bool? loginRequired;
  dynamic apiEndpoint;
  dynamic viewType;
  dynamic viewAllLabel;
  dynamic viewAllNextPage;
  dynamic nextPageName;
  dynamic nextPageApiEndpoint;
  dynamic nextPageViewType;
  dynamic pageImage;
  dynamic title;
  dynamic description;
  Design? design;

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
    design =
    json['design'] != null ? new Design.fromJson(json['design']) : null;
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
      data['design'] = this.design!.toJson();
    }
    return data;
  }
}

class Design {
  dynamic countdown;
  List<Inputs>? inputs;

  Design({this.countdown, this.inputs});

  Design.fromJson(Map<String, dynamic> json) {
    countdown = json['countdown'];
    if (json['inputs'] != null) {
      inputs = <Inputs>[];
      json['inputs'].forEach((v) {
        inputs!.add(new Inputs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countdown'] = this.countdown;
    if (this.inputs != null) {
      data['inputs'] = this.inputs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuButton {
  dynamic icon;
  dynamic label;
  bool? isActive;
  bool? loginRequired;
  dynamic apiEndpoint;
  dynamic viewType;
  dynamic title;
  dynamic description;
  dynamic pageImage;
  dynamic nextPageName;
  dynamic nextPageApiEndpoint;
  dynamic nextPageViewType;

  MenuButton({
    this.icon,
    this.label,
    this.isActive,
    this.loginRequired,
    this.apiEndpoint,
    this.viewType,
    this.title,
    this.description,
    this.pageImage,
    this.nextPageName,
    this.nextPageApiEndpoint,
    this.nextPageViewType,
  });

  MenuButton.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    label = json['label'];
    isActive = json['is_active'];
    loginRequired = json['login_required'];
    apiEndpoint = json['api_endpoint'];
    viewType = json['view_type'];
    title = json['title'];
    description = json['description'];
    pageImage = json['page_image'];
    nextPageName = json['next_page_name'];
    nextPageApiEndpoint = json['next_page_api_endpoint'];
    nextPageViewType = json['next_page_view_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['label'] = this.label;
    data['is_active'] = this.isActive;
    data['login_required'] = this.loginRequired;
    data['api_endpoint'] = this.apiEndpoint;
    data['view_type'] = this.viewType;
    data['title'] = this.title;
    data['description'] = this.description;
    data['page_image'] = this.pageImage;
    data['next_page_name'] = this.nextPageName;
    data['next_page_api_endpoint'] = this.nextPageApiEndpoint;
    data['next_page_view_type'] = this.nextPageViewType;
    return data;
  }
}

class Inputs {
  dynamic inputType;
  dynamic label;
  dynamic placeholder;
  dynamic name;
  bool? required;
  List<Validations>? validations;
  dynamic apiEndpoint;
  List<Options>? options;
  dynamic value;

  Inputs(
      {this.inputType,
        this.label,
        this.placeholder,
        this.name,
        this.required,
        this.validations,
        this.apiEndpoint,
        this.options,
        this.value});

  Inputs.fromJson(Map<String, dynamic> json) {
    inputType = json['input_type'];
    label = json['label'];
    placeholder = json['placeholder'];
    name = json['name'];
    required = json['required'];
    if (json['validations'] != null) {
      validations = <Validations>[];
      json['validations'].forEach((v) {
        validations!.add(new Validations.fromJson(v));
      });
    }
    apiEndpoint = json['api_endpoint'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['input_type'] = this.inputType;
    data['label'] = this.label;
    data['placeholder'] = this.placeholder;
    data['name'] = this.name;
    data['required'] = this.required;
    if (this.validations != null) {
      data['validations'] = this.validations!.map((v) => v.toJson()).toList();
    }
    data['api_endpoint'] = this.apiEndpoint;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    data['value'] = this.value;
    return data;
  }
}

class Validations {
  dynamic type;
  Meta? meta;

  Validations({this.type, this.meta});

  Validations.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class Meta {
  dynamic errorMessage;
  dynamic value;

  Meta({this.errorMessage, this.value});

  Meta.fromJson(Map<String, dynamic> json) {
    errorMessage = json['error_message'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error_message'] = this.errorMessage;
    data['value'] = this.value;
    return data;
  }
}

class Options {
  dynamic label;
  dynamic value;

  Options({this.label, this.value});

  Options.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}
