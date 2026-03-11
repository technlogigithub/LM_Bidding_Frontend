class PaymentSuccessResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  List<Result>? result;

  PaymentSuccessResponseModel(
      {this.responseCode, this.success, this.message, this.result});

  PaymentSuccessResponseModel.fromJson(Map<String, dynamic> json) {
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
  dynamic design;

  Result(
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

  Result.fromJson(Map<String, dynamic> json) {
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
    design = json['design'];
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
    data['design'] = this.design;
    return data;
  }
}

class Design {
  Inputs? inputs;

  Design({this.inputs});

  Design.fromJson(Map<String, dynamic> json) {
    inputs =
    json['inputs'] != null ? new Inputs.fromJson(json['inputs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.inputs != null) {
      data['inputs'] = this.inputs!.toJson();
    }
    return data;
  }
}

class Inputs {
  Select? select;

  Inputs({this.select});

  Inputs.fromJson(Map<String, dynamic> json) {
    select =
    json['select'] != null ? new Select.fromJson(json['select']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.select != null) {
      data['select'] = this.select!.toJson();
    }
    return data;
  }
}

class Select {
  String? inputType;
  String? label;
  String? placeholder;
  String? name;
  bool? required;
  String? apiEndpoint;
  List<Options>? options;

  Select(
      {this.inputType,
        this.label,
        this.placeholder,
        this.name,
        this.required,
        this.apiEndpoint,
        this.options});

  Select.fromJson(Map<String, dynamic> json) {
    inputType = json['input_type'];
    label = json['label'];
    placeholder = json['placeholder'];
    name = json['name'];
    required = json['required'];
    apiEndpoint = json['api_endpoint'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['input_type'] = this.inputType;
    data['label'] = this.label;
    data['placeholder'] = this.placeholder;
    data['name'] = this.name;
    data['required'] = this.required;
    data['api_endpoint'] = this.apiEndpoint;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? label;
  String? value;

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
