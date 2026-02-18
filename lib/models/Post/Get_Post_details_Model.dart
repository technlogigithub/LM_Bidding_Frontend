import '../App_moduls/AppResponseModel.dart';

class PostDetailsResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  List<Result>? result;

  PostDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    result = (json['result'] as List?)?.map((e) => Result.fromJson(e)).toList();
  }
}

// ================= Result =================

class Result {
  Hidden? hidden;
  Media? media;
  List<MenuButton>? menuButton;
  List<ActionButton>? actionButton;
  Info? info;
  PostOwner? postOwner;
  HtmlDetails? htmlDetails;
  List<DetailsTab>? detailsTab;
  List<Others>? others;
  List<SubmitButton>? submitButton;

  Result.fromJson(Map<String, dynamic> json) {
    hidden = json['hidden'] != null ? Hidden.fromJson(json['hidden']) : null;
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
    menuButton = (json['menu_button'] as List?)?.map((e) => MenuButton.fromJson(e)).toList();
    actionButton = (json['action_button'] as List?)?.map((e) => ActionButton.fromJson(e)).toList();
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
    postOwner = json['post_owner'] != null ? PostOwner.fromJson(json['post_owner']) : null;
    htmlDetails = json['html_details'] != null ? HtmlDetails.fromJson(json['html_details']) : null;
    detailsTab = (json['details_tab'] as List?)?.map((e) => DetailsTab.fromJson(e)).toList();
    others = (json['others'] as List?)?.map((e) => Others.fromJson(e)).toList();
    submitButton = (json['submit_button'] as List?)?.map((e) => SubmitButton.fromJson(e)).toList();
  }
}

// ================= Hidden =================

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

// ================= Media =================

class Media {
  String? viewType;
  List<MediaList>? mediaList;

  Media.fromJson(Map<String, dynamic> json) {
    viewType = json['view_type'];
    mediaList = (json['media_list'] as List?)?.map((e) => MediaList.fromJson(e)).toList();
  }
}

class MediaList {
  String? mediaType;
  String? fieldName;
  String? mimeType;
  String? url;

  MediaList.fromJson(Map<String, dynamic> json) {
    mediaType = json['media_type'];
    fieldName = json['field_name'];
    mimeType = json['mime_type'];
    url = json['url'];
  }
}

// ================= Menu & Action Buttons =================

class MenuButton {
  String? icon;
  String? label;
  bool? isActive;
  bool? loginRequired;
  String? apiEndpoint;
  String? viewType;
  String? title;
  String? description;
  String? pageImage;
  String? nextPageName;
  String? nextPageApiEndpoint;
  String? nextPageViewType;

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
}

class ActionButton extends MenuButton {
  ActionButton.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

// ================= Info (Dynamic) =================

class Info {
  Map<String, dynamic> dynamicValues = {};
  String? countdownDt;
  String? title;
  String? price;
  String? ratingReview;
  String? badge;

  Info.fromJson(Map<String, dynamic> json) {
    countdownDt = json['countdown_dt'];
    title = json['title'];
    price = json['price'];
    ratingReview = json['rating_review'];
    badge = json['badge'];

    json.forEach((key, value) {
      if (!['countdown_dt', 'title', 'price', 'rating_review', 'badge'].contains(key)) {
        dynamicValues[key] = value;
      }
    });
  }
}

// ================= Post Owner =================

class PostOwner {
  String? dp;
  String? name;
  String? label;
  String? viewLabel;
  String? apiEndpoint;
  String? nextPageName;

  PostOwner.fromJson(Map<String, dynamic> json) {
    dp = json['dp'];
    name = json['name'];
    label = json['label'];
    viewLabel = json['view_label'];
    apiEndpoint = json['api_endpoint'];
    nextPageName = json['next_page_name'];
  }
}

// ================= Html Details =================

class HtmlDetails {
  String? label;
  String? html;

  HtmlDetails.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    html = json['html'];
  }
}

// ================= Details Tab (Dynamic) =================

class DetailsTab {
  String? label;
  String? icon;
  Map<String, dynamic> values = {};

  DetailsTab.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    icon = json['icon'];

    json.forEach((key, value) {
      if (key != 'label' && key != 'icon') {
        values[key] = value;
      }
    });
  }
}

// ================= Others =================

class Others {
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

  Others.fromJson(Map<String, dynamic> json) {
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
}

// ================= Submit Button =================

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
  SubmitButtonDesign? design;

  SubmitButton({
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
    description = json['description'];
    if (json['design'] != null && json['design'] is Map<String, dynamic>) {
      design = SubmitButtonDesign.fromJson(json['design']);
    }
  }
}

class SubmitButtonDesign {
  String? countdown;
  List<RegisterInput>? inputs;
  Map<String, String> inputApiEndpoints = {};

  SubmitButtonDesign({this.countdown, this.inputs});

  SubmitButtonDesign.fromJson(Map<String, dynamic> json) {
    countdown = json['countdown'];
    if (json['inputs'] != null) {
      inputs = [];
      if (json['inputs'] is List) {
        (json['inputs'] as List).forEach((v) {
          final input = RegisterInput.fromJson(v);
          inputs!.add(input);
          if (v['api_endpoint'] != null && input.name != null) {
            final endpoint = v['api_endpoint'].toString();
            inputApiEndpoints[input.name!] = endpoint;
            print("DEBUG: Extracted endpoint for ${input.name}: $endpoint");
          }
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countdown'] = countdown;
    if (inputs != null) {
      data['inputs'] = inputs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
