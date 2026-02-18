class AppModelResponse {
  int? responseCode;
  bool? success;
  String? message;
  Result? result;

  AppModelResponse({
    this.responseCode,
    this.success,
    this.message,
    this.result,
  });

  AppModelResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    result = json['result'] != null
        ? new Result.fromJson(json['result'])
        : null;
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
  MobileApp? mobileApp;
  ForceUpdatePage? forceUpdatePage;
  LightTheme? lightTheme;
  LightTheme? darkTheme;
  AppFontStyle? fontStyle;
  General? general;
  SocialLogin? socialLogin;
  Seo? seo;
  List<IntroSlider>? introSlider;
  LanguagePage? languagePage;
  List<AppMenuItem>? appMenu;
  List<AppMenuItem>? bottomAppMenu;
  SearchPage? searchPage;
  CategoryPage? categoryPage;
  List<Language>? languages;
  List<Country>? country;

  Result({
    this.mobileApp,
    this.forceUpdatePage,
    this.lightTheme,
    this.darkTheme,
    this.fontStyle,
    this.general,
    this.socialLogin,
    this.seo,
    this.introSlider,
    this.languagePage,
    this.appMenu,
    this.bottomAppMenu,
    this.searchPage,
    this.categoryPage,
    this.languages,
    this.country,
  });

  Result.fromJson(Map<String, dynamic> json) {
    mobileApp = json['mobile_app'] != null
        ? new MobileApp.fromJson(json['mobile_app'])
        : null;
    forceUpdatePage = json['force_update_page'] != null
        ? new ForceUpdatePage.fromJson(json['force_update_page'])
        : null;
    lightTheme = json['light_theme'] != null
        ? new LightTheme.fromJson(json['light_theme'])
        : null;
    darkTheme = json['dark_theme'] != null
        ? new LightTheme.fromJson(json['dark_theme'])
        : null;
    fontStyle = json['font_style'] != null
        ? AppFontStyle.fromJson(json['font_style'])
        : null;
    general = json['general'] != null
        ? new General.fromJson(json['general'])
        : null;
    socialLogin = json['social_login'] != null
        ? new SocialLogin.fromJson(json['social_login'])
        : null;
    seo = json['seo'] != null ? new Seo.fromJson(json['seo']) : null;
    if (json['intro_slider'] != null) {
      introSlider = <IntroSlider>[];
      json['intro_slider'].forEach((v) {
        introSlider!.add(new IntroSlider.fromJson(v));
      });
    }
    languagePage = json['language_page'] != null
        ? new LanguagePage.fromJson(json['language_page'])
        : null;
    if (json['app_menu'] != null) {
      appMenu = <AppMenuItem>[];
      json['app_menu'].forEach((v) {
        appMenu!.add(new AppMenuItem.fromJson(v));
      });
    }
    if (json['bottom_app_menu'] != null) {
      bottomAppMenu = <AppMenuItem>[];
      json['bottom_app_menu'].forEach((v) {
        bottomAppMenu!.add(new AppMenuItem.fromJson(v));
      });
    }
    searchPage = json['search_page'] != null
        ? new SearchPage.fromJson(json['search_page'])
        : null;
    categoryPage = json['category_page'] != null
        ? new CategoryPage.fromJson(json['category_page'])
        : null;
    if (json['languages'] != null) {
      languages = <Language>[];
      json['languages'].forEach((v) {
        languages!.add(new Language.fromJson(v));
      });
    }
    if (json['country'] != null) {
      country = <Country>[];
      json['country'].forEach((v) {
        country!.add(new Country.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mobileApp != null) {
      data['mobile_app'] = this.mobileApp!.toJson();
    }
    if (this.forceUpdatePage != null) {
      data['force_update_page'] = this.forceUpdatePage!.toJson();
    }
    if (this.lightTheme != null) {
      data['light_theme'] = this.lightTheme!.toJson();
    }
    if (this.darkTheme != null) {
      data['dark_theme'] = this.darkTheme!.toJson();
    }
    if (this.fontStyle != null) {
      data['font_style'] = this.fontStyle!.toJson();
    }
    if (this.general != null) {
      data['general'] = this.general!.toJson();
    }
    if (this.socialLogin != null) {
      data['social_login'] = this.socialLogin!.toJson();
    }
    if (this.seo != null) {
      data['seo'] = this.seo!.toJson();
    }
    if (this.introSlider != null) {
      data['intro_slider'] = this.introSlider!.map((v) => v.toJson()).toList();
    }
    if (this.languagePage != null) {
      data['language_page'] = this.languagePage!.toJson();
    }
    if (this.appMenu != null) {
      data['app_menu'] = this.appMenu!.map((v) => v.toJson()).toList();
    }
    if (this.bottomAppMenu != null) {
      data['bottom_app_menu'] =
          this.bottomAppMenu!.map((v) => v.toJson()).toList();
    }
    if (this.searchPage != null) {
      data['search_page'] = this.searchPage!.toJson();
    }
    if (this.categoryPage != null) {
      data['category_page'] = this.categoryPage!.toJson();
    }
    if (this.languages != null) {
      data['languages'] = this.languages!.map((v) => v.toJson()).toList();
    }
    if (this.country != null) {
      data['country'] = this.country!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppMenuItem {
  bool? dp;
  bool? name;
  bool? mobile;
  bool? email;
  bool? walletBalance;
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

  AppMenuItem({
    this.dp,
    this.name,
    this.mobile,
    this.email,
    this.walletBalance,
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

  AppMenuItem.fromJson(Map<String, dynamic> json) {
    dp = json['dp'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    walletBalance = json['wallet_balance'];
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
    data['dp'] = this.dp;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['wallet_balance'] = this.walletBalance;
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


class MobileApp {
  String? androidVersion;
  String? iosVersion;
  String? playstoreUrl;
  String? appstoreUrl;

  MobileApp({
    this.androidVersion,
    this.iosVersion,
    this.playstoreUrl,
    this.appstoreUrl,
  });

  MobileApp.fromJson(Map<String, dynamic> json) {
    androidVersion = json['android_version'];
    iosVersion = json['ios_version'];
    playstoreUrl = json['playstore_url'];
    appstoreUrl = json['appstore_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['android_version'] = this.androidVersion;
    data['ios_version'] = this.iosVersion;
    data['playstore_url'] = this.playstoreUrl;
    data['appstore_url'] = this.appstoreUrl;
    return data;
  }
}

class LightTheme {
  String? bgColorLtr;
  String? bgColorTtb;
  String? primaryColor;
  String? primaryTextColor;
  String? secondaryColor;
  String? secondaryTextColor;
  String? mutedColor;
  String? mutedTextColor;
  String? linkTextColor;
  String? iconTexColor;
  String? titleTextColor;
  String? descriptionTextColor;
  String? bodyTextColor;

  LightTheme({
    this.bgColorLtr,
    this.bgColorTtb,
    this.primaryColor,
    this.primaryTextColor,
    this.secondaryColor,
    this.secondaryTextColor,
    this.mutedColor,
    this.mutedTextColor,
    this.linkTextColor,
    this.iconTexColor,
    this.titleTextColor,
    this.descriptionTextColor,
    this.bodyTextColor,
  });

  LightTheme.fromJson(Map<String, dynamic> json) {
    bgColorLtr = json['bg_color_ltr'];
    bgColorTtb = json['bg_color_ttb'];
    primaryColor = json['primary_color'];
    primaryTextColor = json['primary_text_color'];
    secondaryColor = json['secondary_color'];
    secondaryTextColor = json['secondary_text_color'];
    mutedColor = json['muted_color'];
    mutedTextColor = json['muted_text_color'];
    linkTextColor = json['link_text_color'];
    iconTexColor = json['icon_text_color'];
    titleTextColor = json['title_text_color'];
    descriptionTextColor = json['description_text_color'];
    bodyTextColor = json['body_text_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bg_color_ltr'] = this.bgColorLtr;
    data['bg_color_ttb'] = this.bgColorTtb;
    data['primary_color'] = this.primaryColor;
    data['primary_text_color'] = this.primaryTextColor;
    data['secondary_color'] = this.secondaryColor;
    data['secondary_text_color'] = this.secondaryTextColor;
    data['muted_color'] = this.mutedColor;
    data['muted_text_color'] = this.mutedTextColor;
    data['link_text_color'] = this.linkTextColor;
    data['icon_text_color'] = this.iconTexColor;
    data['title_text_color'] = this.titleTextColor;
    data['description_text_color'] = this.descriptionTextColor;
    data['body_text_color'] = this.bodyTextColor;
    return data;
  }
}

class AppFontStyle {
  String? fontFamily;
  double? title;
  double? description;
  double? body;

  AppFontStyle({this.fontFamily, this.title, this.description, this.body});

  factory AppFontStyle.fromJson(Map<String, dynamic> json) {
    double? parseSize(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      final trimmed = value.toString().trim();
      if (trimmed.isEmpty) return null;
      return double.tryParse(trimmed);
    }

    return AppFontStyle(
      fontFamily: json['font_family'],
      title: parseSize(json['title']),
      description: parseSize(json['description']),
      body: parseSize(json['body']),
    );
  }

  Map<String, dynamic> toJson() => {
    'font_family': fontFamily,
    'title': title?.toString(),
    'description': description?.toString(),
    'body': body?.toString(),
  };
}

class General {
  String? appName;
  String? companyName;
  String? logo;
  String? favicon;
  String? logoSplash;
  String? logoName;
  String? logoNameWhite;
  String? logoWhite;
  String? siteCopyright;
  String? contactNumber;
  String? whatsappNumber;
  String? timezone;
  String? orientation;
  bool? demoMode;
  bool? loginRequired;
  bool? socialLogin;

  General({
    this.appName,
    this.companyName,
    this.logo,
    this.favicon,
    this.logoSplash,
    this.logoName,
    this.logoNameWhite,
    this.logoWhite,
    this.siteCopyright,
    this.contactNumber,
    this.whatsappNumber,
    this.timezone,
    this.orientation,
    this.demoMode,
    this.loginRequired,
    this.socialLogin,
  });

  General.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    companyName = json['company_name'];
    logo = json['logo'];
    favicon = json['favicon'];
    logoSplash = json['logo_splash'];
    logoName = json['logo_name'];
    logoNameWhite = json['logo_name_white'];
    logoWhite = json['logo_white'];
    siteCopyright = json['site_copyright'];
    contactNumber = json['contact_number'];
    whatsappNumber = json['whatsapp_number'];
    timezone = json['timezone'];
    orientation = json['orientation'];
    demoMode = json['demo_mode'];
    loginRequired = json['login_required'];
    socialLogin = json['social_login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_name'] = this.appName;
    data['company_name'] = this.companyName;
    data['logo'] = this.logo;
    data['favicon'] = this.favicon;
    data['logo_splash'] = this.logoSplash;
    data['logo_name'] = this.logoName;
    data['logo_name_white'] = this.logoNameWhite;
    data['logo_white'] = this.logoWhite;
    data['site_copyright'] = this.siteCopyright;
    data['contact_number'] = this.contactNumber;
    data['whatsapp_number'] = this.whatsappNumber;
    data['timezone'] = this.timezone;
    data['orientation'] = this.orientation;
    data['demo_mode'] = this.demoMode;
    data['login_required'] = this.loginRequired;
    data['social_login'] = this.socialLogin;
    return data;
  }
}

class Seo {
  Meta? meta;
  Og? og;
  Instagram? instagram;
  Twitter? twitter;

  Seo({this.meta, this.og, this.instagram, this.twitter});

  Seo.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    og = json['og'] != null ? new Og.fromJson(json['og']) : null;
    instagram = json['instagram'] != null
        ? new Instagram.fromJson(json['instagram'])
        : null;
    twitter = json['twitter'] != null
        ? new Twitter.fromJson(json['twitter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    if (this.og != null) {
      data['og'] = this.og!.toJson();
    }
    if (this.instagram != null) {
      data['instagram'] = this.instagram!.toJson();
    }
    if (this.twitter != null) {
      data['twitter'] = this.twitter!.toJson();
    }
    return data;
  }
}

class Meta {
  String? title;
  String? author;
  String? application;
  String? copyright;
  String? description;
  String? keywords;

  Meta({
    this.title,
    this.author,
    this.application,
    this.copyright,
    this.description,
    this.keywords,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    author = json['author'];
    application = json['application'];
    copyright = json['copyright'];
    description = json['description'];
    keywords = json['keywords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['author'] = this.author;
    data['application'] = this.application;
    data['copyright'] = this.copyright;
    data['description'] = this.description;
    data['keywords'] = this.keywords;
    return data;
  }
}

class Og {
  String? type;
  String? image;
  String? imageWidth;
  String? imageHeight;
  String? title;
  String? description;
  String? url;
  String? fbAppId;

  Og({
    this.type,
    this.image,
    this.imageWidth,
    this.imageHeight,
    this.title,
    this.description,
    this.url,
    this.fbAppId,
  });

  Og.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    image = json['image'];
    imageWidth = json['image_width'];
    imageHeight = json['image_height'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    fbAppId = json['fb_app_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['image'] = this.image;
    data['image_width'] = this.imageWidth;
    data['image_height'] = this.imageHeight;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['fb_app_id'] = this.fbAppId;
    return data;
  }
}

class Instagram {
  String? image;
  String? imageWidth;
  String? imageHeight;

  Instagram({this.image, this.imageWidth, this.imageHeight});

  Instagram.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    imageWidth = json['image_width'];
    imageHeight = json['image_height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['image_width'] = this.imageWidth;
    data['image_height'] = this.imageHeight;
    return data;
  }
}

class Twitter {
  String? card;
  String? image;
  String? title;
  String? description;
  String? url;

  Twitter({this.card, this.image, this.title, this.description, this.url});

  Twitter.fromJson(Map<String, dynamic> json) {
    card = json['card'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['card'] = this.card;
    data['image'] = this.image;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
}

class IntroSlider {
  String? image;
  String? title;
  String? description;
  String? redirectTo;

  IntroSlider({this.image, this.title, this.description, this.redirectTo});

  IntroSlider.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
    description = json['description'];
    redirectTo = json['redirect_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['title'] = this.title;
    data['description'] = this.description;
    data['redirect_to'] = this.redirectTo;
    return data;
  }
}

class Language {
  String? code;
  String? name;

  Language({this.code, this.name});

  Language.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class Country {
  String? code;
  String? flag;
  String? name;

  Country({this.code, this.flag, this.name});

  Country.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    flag = json['flag'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['flag'] = this.flag;
    data['name'] = this.name;
    return data;
  }
}

class LanguagePage {
  String? pageName;
  String? pageImage;
  String? title;
  String? description;
  String? submitButtonLabel;

  LanguagePage({
    this.pageName,
    this.pageImage,
    this.title,
    this.description,
    this.submitButtonLabel,
  });

  LanguagePage.fromJson(Map<String, dynamic> json) {
    pageName = json['page_name'];
    pageImage = json['page_image'];
    title = json['title'];
    description = json['description'];
    submitButtonLabel = json['submit_button_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['page_name'] = pageName;
    data['page_image'] = pageImage;
    data['title'] = title;
    data['description'] = description;
    data['submit_button_label'] = submitButtonLabel;
    return data;
  }
}

class ForceUpdatePage {
  String? pageTitle;
  String? pageDescription;
  String? submitButtonLabel;
  String? submitButtonPlaystoreUrl;
  String? submitButtonAppstoreUrl;

  ForceUpdatePage({
    this.pageTitle,
    this.pageDescription,
    this.submitButtonLabel,
    this.submitButtonPlaystoreUrl,
    this.submitButtonAppstoreUrl,
  });

  ForceUpdatePage.fromJson(Map<String, dynamic> json) {
    pageTitle = json['page_title'];
    pageDescription = json['page_description'];
    submitButtonLabel = json['submit_button_label'];
    submitButtonPlaystoreUrl = json['submit_button_playstore_url'];
    submitButtonAppstoreUrl = json['submit_button_appstore_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_title'] = this.pageTitle;
    data['page_description'] = this.pageDescription;
    data['submit_button_label'] = this.submitButtonLabel;
    data['submit_button_playstore_url'] = this.submitButtonPlaystoreUrl;
    data['submit_button_appstore_url'] = this.submitButtonAppstoreUrl;
    return data;
  }
}

class SocialLogin {
  SocialLoginProvider? google;
  SocialLoginProvider? facebook;

  SocialLogin({this.google, this.facebook});

  SocialLogin.fromJson(Map<String, dynamic> json) {
    google = json['google'] != null
        ? new SocialLoginProvider.fromJson(json['google'])
        : null;
    facebook = json['facebook'] != null
        ? new SocialLoginProvider.fromJson(json['facebook'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.google != null) {
      data['google'] = this.google!.toJson();
    }
    if (this.facebook != null) {
      data['facebook'] = this.facebook!.toJson();
    }
    return data;
  }
}

class SocialLoginProvider {
  String? clientId;
  String? clientSecret;

  SocialLoginProvider({this.clientId, this.clientSecret});

  SocialLoginProvider.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'];
    clientSecret = json['client_secret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_id'] = this.clientId;
    data['client_secret'] = this.clientSecret;
    return data;
  }
}

class AppMenu {
  UserInfo? userInfo;
  MenuItem? myProfile;
  MyPostModel? myPost;
  MyOrderModel? myOrder;
  SettingsMenuItem? settings;
  ReferralMenuItem? referral;
  SupportMenuItem? support;

  AppMenu({
    this.userInfo,
    this.myProfile,
    this.myPost,
    this.myOrder,
    this.settings,
    this.referral,
    this.support,
  });

  AppMenu.fromJson(Map<String, dynamic> json) {
    userInfo = json['user_info'] != null
        ? UserInfo.fromJson(json['user_info'])
        : null;

    myProfile = json['my_profile'] != null
        ? MenuItem.fromJson(json['my_profile'])
        : null;

    myPost = json['my_post'] != null
        ? MyPostModel.fromJson(json['my_post'])
        : null;

    myOrder = json['my_order'] != null
        ? MyOrderModel.fromJson(json['my_order'])
        : null;

    settings = json['settings'] != null
        ? SettingsMenuItem.fromJson(json['settings'])
        : null;

    referral = json['referral'] != null
        ? ReferralMenuItem.fromJson(json['referral'])
        : null;

    support = json['support'] != null
        ? SupportMenuItem.fromJson(json['support'])
        : null;
  }

  Map<String, dynamic> toJson() => {
    if (userInfo != null) 'user_info': userInfo!.toJson(),
    if (myProfile != null) 'my_profile': myProfile!.toJson(),
    if (myProfile != null) 'my_profile': myProfile!.toJson(),
    if (myPost != null) 'my_post': myPost!.toJson(),
    if (myOrder != null) 'my_order': myOrder!.toJson(),
    if (settings != null) 'settings': settings!.toJson(),
    if (settings != null) 'settings': settings!.toJson(),
    if (referral != null) 'referral': referral!.toJson(),
    if (support != null) 'support': support!.toJson(),
  };
}

class UserInfo {
  bool? dp;
  bool? name;
  bool? mobile;
  bool? email;
  bool? walletBalance;

  UserInfo({this.dp, this.name, this.mobile, this.email, this.walletBalance});

  UserInfo.fromJson(Map<String, dynamic> json) {
    dp = json['dp'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    walletBalance = json['wallet_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dp'] = this.dp;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['wallet_balance'] = this.walletBalance;
    return data;
  }
}

class MenuItem {
  String? label;
  String? apiEndpoint;
  String? pageType;
  String? pageName;
  String? pageImage;
  String? title;
  String? description;

  MenuItem({
    this.label,
    this.apiEndpoint,
    this.pageType,
    this.pageName,
    this.pageImage,
    this.title,
    this.description,
  });

  MenuItem.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    apiEndpoint = json['api_endpoint'];
    pageType = json['page_type'];
    pageName = json['page_name'];
    pageImage = json['page_image'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['api_endpoint'] = this.apiEndpoint;
    data['page_type'] = this.pageType;
    data['page_name'] = this.pageName;
    data['page_image'] = this.pageImage;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}

class SupportMenuItem {
  bool? loginRequired;
  bool? isActive;
  String? label;
  String? apiEndpoint;
  String? pageType;
  String? pageName;
  String? pageImage;
  String? title;
  String? description;
  SupportDesign? design;

  SupportMenuItem({
    this.loginRequired,
    this.isActive,
    this.label,
    this.apiEndpoint,
    this.pageType,
    this.pageName,
    this.pageImage,
    this.title,
    this.description,
    this.design,
  });

  SupportMenuItem.fromJson(Map<String, dynamic> json) {
    loginRequired = json['login_required'];
    isActive = json['is_active'];
    label = json['label'];
    apiEndpoint = json['api_endpoint'];
    pageType = json['page_type'];
    pageName = json['page_name'];
    pageImage = json['page_image'];
    title = json['title'];
    description = json['description'];
    design = json['design'] != null
        ? new SupportDesign.fromJson(json['design'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login_required'] = this.loginRequired;
    data['is_active'] = this.isActive;
    data['label'] = this.label;
    data['api_endpoint'] = this.apiEndpoint;
    data['page_type'] = this.pageType;
    data['page_name'] = this.pageName;
    data['page_image'] = this.pageImage;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.design != null) {
      data['design'] = this.design!.toJson();
    }
    return data;
  }
}

class SupportDesign {
  ContactItem? call;
  ContactItem? whatsapp;
  ContactItem? email;
  SocialMedia? socialMedia;

  SupportDesign({this.call, this.whatsapp, this.email, this.socialMedia});

  SupportDesign.fromJson(Map<String, dynamic> json) {
    call = json['call'] != null ? new ContactItem.fromJson(json['call']) : null;
    whatsapp = json['whatsapp'] != null
        ? new ContactItem.fromJson(json['whatsapp'])
        : null;
    email = json['email'] != null
        ? new ContactItem.fromJson(json['email'])
        : null;
    socialMedia = json['social_media'] != null
        ? new SocialMedia.fromJson(json['social_media'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.call != null) {
      data['call'] = this.call!.toJson();
    }
    if (this.whatsapp != null) {
      data['whatsapp'] = this.whatsapp!.toJson();
    }
    if (this.email != null) {
      data['email'] = this.email!.toJson();
    }
    if (this.socialMedia != null) {
      data['social_media'] = this.socialMedia!.toJson();
    }
    return data;
  }
}

class ContactItem {
  String? icon;
  String? detail;
  String? message;

  ContactItem({this.icon, this.detail, this.message});

  ContactItem.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    detail = json['detail'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['detail'] = this.detail;
    if (this.message != null) {
      data['message'] = this.message;
    }
    return data;
  }
}

class SocialMedia {
  SocialMediaItem? facebook;
  SocialMediaItem? instagram;
  SocialMediaItem? youtube;
  SocialMediaItem? twitter;
  SocialMediaItem? linkedin;

  SocialMedia({
    this.facebook,
    this.instagram,
    this.youtube,
    this.twitter,
    this.linkedin,
  });

  SocialMedia.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'] != null
        ? new SocialMediaItem.fromJson(json['facebook'])
        : null;
    instagram = json['instagram'] != null
        ? new SocialMediaItem.fromJson(json['instagram'])
        : null;
    youtube = json['youtube'] != null
        ? new SocialMediaItem.fromJson(json['youtube'])
        : null;
    twitter = json['twitter'] != null
        ? new SocialMediaItem.fromJson(json['twitter'])
        : null;
    linkedin = json['linkedin'] != null
        ? new SocialMediaItem.fromJson(json['linkedin'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.facebook != null) {
      data['facebook'] = this.facebook!.toJson();
    }
    if (this.instagram != null) {
      data['instagram'] = this.instagram!.toJson();
    }
    if (this.youtube != null) {
      data['youtube'] = this.youtube!.toJson();
    }
    if (this.twitter != null) {
      data['twitter'] = this.twitter!.toJson();
    }
    if (this.linkedin != null) {
      data['linkedin'] = this.linkedin!.toJson();
    }
    return data;
  }
}

class SocialMediaItem {
  String? icon;
  String? url;

  SocialMediaItem({this.icon, this.url});

  SocialMediaItem.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['url'] = this.url;
    return data;
  }
}

class ReferralMenuItem {
  bool? isActive;
  bool? loginRequired;
  String? label;
  String? apiEndpoint;
  String? pageType;
  String? pageName;
  String? pageImage;
  String? title;
  String? description;
  ReferralDesign? design;

  ReferralMenuItem({
    this.isActive,
    this.loginRequired,
    this.label,
    this.apiEndpoint,
    this.pageType,
    this.pageName,
    this.pageImage,
    this.title,
    this.description,
    this.design,
  });

  ReferralMenuItem.fromJson(Map<String, dynamic> json) {
    isActive = json['is_active'];
    loginRequired = json['login_required'];
    label = json['label'];
    apiEndpoint = json['api_endpoint'];
    pageType = json['page_type'];
    pageName = json['page_name'];
    pageImage = json['page_image'];
    title = json['title'];
    description = json['description'];
    design = json['design'] != null
        ? ReferralDesign.fromJson(json['design'])
        : null;
  }

  Map<String, dynamic> toJson() => {
    'is_active': isActive,
    'login_required': loginRequired,
    'label': label,
    'api_endpoint': apiEndpoint,
    'page_type': pageType,
    'page_name': pageName,
    'page_image': pageImage,
    'title': title,
    'description': description,
    if (design != null) 'design': design!.toJson(),
  };
}

class ReferralDesign {
  ContactItem? code;
  SocialMedia? socialMedia;

  ReferralDesign({this.code, this.socialMedia});

  ReferralDesign.fromJson(Map<String, dynamic> json) {
    code = json['code'] != null ? ContactItem.fromJson(json['code']) : null;
    socialMedia = json['social_media'] != null
        ? SocialMedia.fromJson(json['social_media'])
        : null;
  }

  Map<String, dynamic> toJson() => {
    if (code != null) 'code': code!.toJson(),
    if (socialMedia != null) 'social_media': socialMedia!.toJson(),
  };
}

class SettingsMenuItem {
  bool? isActive;
  bool? loginRequired;
  String? label;
  String? apiEndpoint;
  String? pageType;
  String? pageName;
  String? pageImage;
  String? title;
  String? description;
  SettingsDesign? design;

  SettingsMenuItem({
    this.isActive,
    this.loginRequired,
    this.label,
    this.apiEndpoint,
    this.pageType,
    this.pageName,
    this.pageImage,
    this.title,
    this.description,
    this.design,
  });

  SettingsMenuItem.fromJson(Map<String, dynamic> json) {
    isActive = json['is_active'];
    loginRequired = json['login_required'];
    label = json['label'];
    apiEndpoint = json['api_endpoint'];
    pageType = json['page_type'];
    pageName = json['page_name'];
    pageImage = json['page_image'];
    title = json['title'];
    description = json['description'];
    design = json['design'] != null
        ? SettingsDesign.fromJson(json['design'])
        : null;
  }

  Map<String, dynamic> toJson() => {
    'is_active': isActive,
    'login_required': loginRequired,
    'label': label,
    'api_endpoint': apiEndpoint,
    'page_type': pageType,
    'page_name': pageName,
    'page_image': pageImage,
    'title': title,
    'description': description,
    if (design != null) 'design': design!.toJson(),
  };
}

class MyPostModel {
  bool? isActive;
  bool? loginRequired;
  String? label;
  String? apiEndpoint;
  String? viewtype;
  String? pageType;
  String? pageName;
  String? pageImage;
  String? title;
  String? description;
  SettingsDesign? design;

  MyPostModel({
    this.isActive,
    this.loginRequired,
    this.label,
    this.apiEndpoint,
    this.viewtype,
    this.pageType,
    this.pageName,
    this.pageImage,
    this.title,
    this.description,
    this.design,
  });

  MyPostModel.fromJson(Map<String, dynamic> json) {
    isActive = json['is_active'];
    loginRequired = json['login_required'];
    label = json['label'];
    apiEndpoint = json['api_endpoint'];
    viewtype = json['view_type'];
    pageType = json['page_type'];
    pageName = json['page_name'];
    pageImage = json['page_image'];
    title = json['title'];
    description = json['description'];
    design = json['design'] != null
        ? SettingsDesign.fromJson(json['design'])
        : null;
  }

  Map<String, dynamic> toJson() => {
    'is_active': isActive,
    'login_required': loginRequired,
    'label': label,
    'api_endpoint': apiEndpoint,
    'view_type': viewtype,
    'page_type': pageType,
    'page_name': pageName,
    'page_image': pageImage,
    'title': title,
    'description': description,
    if (design != null) 'design': design!.toJson(),
  };
}

class MyOrderModel {
  bool? isActive;
  bool? loginRequired;
  String? label;
  String? apiEndpoint;
  String? viewtype;
  String? pageType;
  String? pageName;
  String? pageImage;
  String? title;
  String? description;
  SettingsDesign? design;

  MyOrderModel({
    this.isActive,
    this.loginRequired,
    this.label,
    this.apiEndpoint,
    this.viewtype,
    this.pageType,
    this.pageName,
    this.pageImage,
    this.title,
    this.description,
    this.design,
  });

  MyOrderModel.fromJson(Map<String, dynamic> json) {
    isActive = json['is_active'];
    loginRequired = json['login_required'];
    label = json['label'];
    apiEndpoint = json['api_endpoint'];
    viewtype = json['view_type'];
    pageType = json['page_type'];
    pageName = json['page_name'];
    pageImage = json['page_image'];
    title = json['title'];
    description = json['description'];
    design = json['design'] != null
        ? SettingsDesign.fromJson(json['design'])
        : null;
  }

  Map<String, dynamic> toJson() => {
    'is_active': isActive,
    'login_required': loginRequired,
    'label': label,
    'api_endpoint': apiEndpoint,
    'view_type': viewtype,
    'page_type': pageType,
    'page_name': pageName,
    'page_image': pageImage,
    'title': title,
    'description': description,
    if (design != null) 'design': design!.toJson(),
  };
}

class SettingsDesign {
  Map<String, SettingsInput>? inputs;
  List<SettingsLink>? link;

  SettingsDesign({this.inputs, this.link});

  SettingsDesign.fromJson(Map<String, dynamic> json) {
    if (json['inputs'] != null) {
      inputs = {};
      json['inputs'].forEach((key, value) {
        inputs![key] = SettingsInput.fromJson(value);
      });
    }

    if (json['link'] != null) {
      link = (json['link'] as List)
          .map((e) => SettingsLink.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() => {
    if (inputs != null)
      'inputs': inputs!.map((k, v) => MapEntry(k, v.toJson())),
    if (link != null) 'link': link!.map((e) => e.toJson()).toList(),
  };
}

class SettingsInput {
  String? inputType;
  String? label;
  String? placeholder;
  String? name;
  bool? required;
  String? apiEndpoint;
  // For simple string options
  List<String>? options;
  // For structured options [{label, value}]
  List<OptionItem>? optionItems;

  SettingsInput({
    this.inputType,
    this.label,
    this.placeholder,
    this.name,
    this.required,
    this.apiEndpoint,
    this.options,
    this.optionItems,
  });

  SettingsInput.fromJson(Map<String, dynamic> json) {
    inputType = json['input_type'];
    label = json['label'];
    placeholder = json['placeholder'];
    name = json['name'];
    required = json['required'];
    apiEndpoint = json['api_endpoint'];

    // Parse options (supports both string & object)
    if (json['options'] != null) {
      final list = json['options'] as List;
      List<String>? opts;
      List<OptionItem>? structuredOptions;
      for (final e in list) {
        if (e is Map<String, dynamic>) {
          structuredOptions ??= [];
          structuredOptions.add(OptionItem.fromJson(e));
        } else {
          opts ??= [];
          opts.add(e.toString());
        }
      }
      options = opts;
      optionItems = structuredOptions;
    }
  }

  Map<String, dynamic> toJson() => {
    'input_type': inputType,
    'label': label,
    'placeholder': placeholder,
    'name': name,
    'required': required,
    'api_endpoint': apiEndpoint,
    if (optionItems != null)
      'options': optionItems!.map((e) => e.toJson()).toList()
    else if (options != null)
      'options': options,
  };
}

class SettingsLink {
  String? label;
  String? apiEndpoint;
  String? pageType;

  SettingsLink({this.label, this.apiEndpoint, this.pageType});

  SettingsLink.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    apiEndpoint = json['api_endpoint'];
    pageType = json['page_type'];
  }

  Map<String, dynamic> toJson() => {
    'label': label,
    'api_endpoint': apiEndpoint,
    'page_type': pageType,
  };
}

class SearchPage {
  bool? isActive;
  bool? loginRequired;
  String? label;
  String? apiEndpoint;
  String? viewType;
  String? pageName;
  String? pageImage;
  String? title;
  String? description;
  SearchPageDesign? design;

  SearchPage({
    this.isActive,
    this.loginRequired,
    this.label,
    this.apiEndpoint,
    this.viewType,
    this.pageName,
    this.pageImage,
    this.title,
    this.description,
    this.design,
  });

  factory SearchPage.fromJson(Map<String, dynamic> json) {
    return SearchPage(
      isActive: json['is_active'],
      loginRequired: json['login_required'],
      label: json['label'],
      apiEndpoint: json['api_endpoint'],
      viewType: json['view_type'],
      pageName: json['page_name'],
      pageImage: json['page_image'],
      title: json['title'],
      description: json['description'],
      design: json['design'] != null
          ? SearchPageDesign.fromJson(json['design'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'is_active': isActive,
    'login_required': loginRequired,
    'label': label,
    'api_endpoint': apiEndpoint,
    'view_type': viewType,
    'page_name': pageName,
    'page_image': pageImage,
    'title': title,
    'description': description,
    if (design != null) 'design': design!.toJson(),
  };
}

class SearchPageDesign {
  List<HeaderMenu>? headerMenu;
  CustomSection? customTapbar;

  SearchPageDesign({this.headerMenu, this.customTapbar});

  factory SearchPageDesign.fromJson(Map<String, dynamic> json) {
    List<HeaderMenu>? headerMenus;
    if (json['header_menu'] != null && json['header_menu'] is List) {
      headerMenus = <HeaderMenu>[];
      (json['header_menu'] as List).forEach((v) {
        headerMenus!.add(HeaderMenu.fromJson(v));
      });
    }

    CustomSection? customTapbarSection;
    if (json['custom_tapbar'] != null) {
      customTapbarSection = CustomSection.fromJson(json['custom_tapbar']);
    }

    return SearchPageDesign(
      headerMenu: headerMenus,
      customTapbar: customTapbarSection,
    );
  }

  Map<String, dynamic> toJson() => {
    if (headerMenu != null)
      'header_menu': headerMenu!.map((e) => e.toJson()).toList(),
    if (customTapbar != null) 'custom_tapbar': customTapbar!.toJson(),
  };
}

class CategoryPage {
  bool? isActive;
  bool? loginRequired;
  String? label;
  String? apiEndpoint;
  String? viewType;
  String? pageName;
  String? pageImage;
  String? title;
  String? description;
  dynamic design; // Can be List, Map, or null

  CategoryPage({
    this.isActive,
    this.loginRequired,
    this.label,
    this.apiEndpoint,
    this.viewType,
    this.pageName,
    this.pageImage,
    this.title,
    this.description,
    this.design,
  });

  factory CategoryPage.fromJson(Map<String, dynamic> json) {
    return CategoryPage(
      isActive: json['is_active'],
      loginRequired: json['login_required'],
      label: json['label'],
      apiEndpoint: json['api_endpoint'],
      viewType: json['view_type'],
      pageName: json['page_name'],
      pageImage: json['page_image'],
      title: json['title'],
      description: json['description'],
      design: json['design'],
    );
  }

  Map<String, dynamic> toJson() => {
    'is_active': isActive,
    'login_required': loginRequired,
    'label': label,
    'api_endpoint': apiEndpoint,
    'view_type': viewType,
    'page_name': pageName,
    'page_image': pageImage,
    'title': title,
    'description': description,
    if (design != null) 'design': design,
  };
}

// New models for app_content endpoint minimal parsing
class AppContentResponse {
  int? responseCode;
  bool? success;
  String? message;
  AppContentResult? result;

  AppContentResponse({
    this.responseCode,
    this.success,
    this.message,
    this.result,
  });

  factory AppContentResponse.fromJson(Map<String, dynamic> json) {
    return AppContentResponse(
      responseCode: json['response_code'],
      success: json['success'],
      message: json['message'],
      result: json['result'] != null
          ? AppContentResult.fromJson(json['result'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'response_code': responseCode,
    'success': success,
    'message': message,
    if (result != null) 'result': result!.toJson(),
  };
}

class AppContentResult {
  IntroSliderPage? introSliderPage;
  HomePage? homePage;
  RegisterPage? register;
  LoginWithPasswordPage? loginWithPassword;
  LoginWithOtpPage? loginWithOtp;
  VerifyOtpPage? verifyOtp;
  ProfileFormPage? profileForm;
  ProfileFormPage? postForm;

  AppContentResult({
    this.introSliderPage,
    this.homePage,
    this.register,
    this.loginWithPassword,
    this.loginWithOtp,
    this.verifyOtp,
    this.profileForm,
    this.postForm,
  });

  factory AppContentResult.fromJson(Map<String, dynamic> json) {
    return AppContentResult(
      introSliderPage: json['intro_slider'] != null
          ? IntroSliderPage.fromJson(json['intro_slider'])
          : null,
      homePage: json['home_page'] != null
          ? HomePage.fromJson(json['home_page'])
          : null,
      register: json['register'] != null
          ? RegisterPage.fromJson(json['register'])
          : null,
      loginWithPassword: json['login_with_password'] != null
          ? LoginWithPasswordPage.fromJson(json['login_with_password'])
          : null,
      loginWithOtp: json['login_with_otp'] != null
          ? LoginWithOtpPage.fromJson(json['login_with_otp'])
          : null,
      verifyOtp: json['verify_otp'] != null
          ? VerifyOtpPage.fromJson(json['verify_otp'])
          : null,
      profileForm: json['profile_form'] != null
          ? ProfileFormPage.fromJson(json['profile_form'])
          : null,
      postForm: json['post_form'] != null
          ? ProfileFormPage.fromJson(json['post_form'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (introSliderPage != null) 'intro_slider': introSliderPage!.toJson(),
    if (homePage != null) 'home_page': homePage!.toJson(),
    if (register != null) 'register': register!.toJson(),
    if (loginWithPassword != null)
      'login_with_password': loginWithPassword!.toJson(),
    if (loginWithOtp != null) 'login_with_otp': loginWithOtp!.toJson(),
    if (verifyOtp != null) 'verify_otp': verifyOtp!.toJson(),
    if (profileForm != null) 'profile_form': profileForm!.toJson(),
    if (postForm != null) 'post_form': postForm!.toJson(),
  };
}

class RegisterPage {
  String? pageName;
  String? pageTitle;
  String? pageDescription;
  bool? loginRequired;
  List<RegisterInput>? inputs;
  String? submitButtonLabel;
  String? loginLabel;
  String? loginLink;

  RegisterPage({
    this.pageName,
    this.pageTitle,
    this.pageDescription,
    this.loginRequired,
    this.inputs,
    this.submitButtonLabel,
    this.loginLabel,
    this.loginLink,
  });

  factory RegisterPage.fromJson(Map<String, dynamic> json) {
    List<RegisterInput>? fields;
    if (json['inputs'] != null) {
      fields = <RegisterInput>[];
      (json['inputs'] as List).forEach((v) {
        fields!.add(RegisterInput.fromJson(v));
      });
    }
    return RegisterPage(
      pageName: json['page_name'],
      pageTitle: json['page_title'],
      pageDescription: json['page_description'],
      loginRequired: json['login_required'],
      inputs: fields,
      submitButtonLabel: json['submit_button_label'],
      loginLabel: json['login_label'],
      loginLink: json['login_link'],
    );
  }

  Map<String, dynamic> toJson() => {
    'page_name': pageName,
    'page_title': pageTitle,
    'page_description': pageDescription,
    'login_required': loginRequired,
    if (inputs != null) 'inputs': inputs!.map((e) => e.toJson()).toList(),
    'submit_button_label': submitButtonLabel,
    'login_label': loginLabel,
    'login_link': loginLink,
  };
}

class RegisterInput {
  String?
  inputType; // select, text, textarea, checkbox, radio, toggle, file, files, number, date, datetime, daterange, datetimerange, group, address, dropdown, email, hidden, single, multiple
  String? label;
  String? placeholder;
  String? name;
  bool? required;

  bool? autoForward;
  bool? enterEnable;

  List<InputValidation>? validations;

  // For simple string options
  List<String>? options;

  // For structured options [{label, value}]
  List<OptionItem>? optionItems;

  // For group type fields (like addresses, user_documents)
  List<dynamic>? groupValue;

  // Step settings for group type inputs
  List<dynamic>? stepSetting;

  dynamic value; // String, int, bool, List, Map, null
  Map<String, dynamic>? design;

  RegisterInput({
    this.inputType,
    this.label,
    this.placeholder,
    this.name,
    this.required,
    this.autoForward,
    this.enterEnable,
    this.validations,
    this.options,
    this.optionItems,
    this.groupValue,
    this.stepSetting,
    this.value,
    this.design,
  });

  factory RegisterInput.fromJson(Map<String, dynamic> json) {
    // Validations
    List<InputValidation>? rules;
    if (json['validations'] != null) {
      rules = (json['validations'] as List)
          .map((e) => InputValidation.fromJson(e))
          .toList();
    }

    // Options (supports both string & object)
    List<String>? opts;
    List<OptionItem>? structuredOptions;
    if (json['options'] != null) {
      final list = json['options'] as List;
      for (final e in list) {
        if (e is Map<String, dynamic>) {
          structuredOptions ??= [];
          structuredOptions.add(OptionItem.fromJson(e));
        } else {
          opts ??= [];
          opts.add(e.toString());
        }
      }
    }

    return RegisterInput(
      inputType: json['input_type'],
      label: json['label'],
      placeholder: json['placeholder'],
      name: json['name'],
      required: json['required'],
      autoForward: json['auto_forward'],
      enterEnable: json['enter_enable'],
      validations: rules,
      options: opts,
      optionItems: structuredOptions,
      groupValue: json['input_type'] == 'group'
          ? (json['value'] as List?) ?? []
          : null,
      stepSetting: json['step_setting'] != null
          ? (json['step_setting'] as List)
          : null,
      value: json['value'],
      design: json['design'],
    );
  }

  Map<String, dynamic> toJson() => {
    'input_type': inputType,
    'label': label,
    'placeholder': placeholder,
    'name': name,
    'required': required,
    'auto_forward': autoForward,
    'enter_enable': enterEnable,
    if (validations != null)
      'validations': validations!.map((e) => e.toJson()).toList(),
    if (optionItems != null)
      'options': optionItems!.map((e) => e.toJson()).toList()
    else if (options != null)
      'options': options,
    if (stepSetting != null) 'step_setting': stepSetting,
    'value': value,
    'design': design,
  };
}

class OptionItem {
  String? label;
  String? value;

  OptionItem({this.label, this.value});

  factory OptionItem.fromJson(Map<String, dynamic> json) {
    return OptionItem(
      label: json['label']?.toString(),
      value: json['value']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {'label': label, 'value': value};
}

class InputValidation {
  String?
  type; // numeric, exact_length, min_length, max_length, pattern, matches, password, file, max_size, min, in, allow_past, regex
  int? value; // for exact_length, min_length, max_length, max_size, min
  String?
  stringValue; // Allow values for String type Data like "jpg, jpeg, png", or boolean values like "false" for allow_past
  String? pattern; // regex pattern
  String? field; // for matches
  String? errorMessage; // generic error

  // Extended fields for password constraints
  int? minLength;
  int? maxLength;
  String? minLengthError;
  String? maxLengthError;
  String? patternErrorMessage;
  Map<String, dynamic>? meta;

  InputValidation({
    this.type,
    this.value,
    this.stringValue,
    this.pattern,
    this.field,
    this.errorMessage,
    this.minLength,
    this.maxLength,
    this.minLengthError,
    this.maxLengthError,
    this.patternErrorMessage,
    this.meta,
  });

  factory InputValidation.fromJson(Map<String, dynamic> json) {
    final String? t = json['type']?.toString().toLowerCase();
    final dynamic rawValue = json['value'];

    int? parsedIntValue;
    String? inferredPattern;
    String? stringVal;

    if (rawValue is int) {
      parsedIntValue = rawValue;
      stringVal = rawValue.toString();
    } else if (rawValue is String) {
      stringVal = rawValue;
      final maybeInt = int.tryParse(rawValue);
      if (maybeInt != null) {
        parsedIntValue = maybeInt;
      } else {
        // Some backends put regex/pattern under "value" for types like regex/pattern/password
        if (t == 'regex' || t == 'pattern' || t == 'password') {
          inferredPattern = rawValue;
        }
        // For file type, value contains allowed file extensions (e.g., "jpg, jpeg, png")
        // For in type, value contains allowed values (e.g., "public,private")
        // These are stored in stringValue
      }
    } else if (rawValue != null) {
      // Handle other types (e.g., double, bool) by converting to string
      stringVal = rawValue.toString();
    }

    return InputValidation(
      type: json['type'],
      value: parsedIntValue,
      stringValue: stringVal,
      pattern: json['pattern'] ?? inferredPattern,
      field: json['field'],
      errorMessage: json['error_message'],
      minLength: json['min_length'] is int
          ? json['min_length']
          : (json['min_length'] is String
                ? int.tryParse(json['min_length'])
                : null),
      maxLength: json['max_length'] is int
          ? json['max_length']
          : (json['max_length'] is String
                ? int.tryParse(json['max_length'])
                : null),
      minLengthError: json['min_length_error'],
      maxLengthError: json['max_length_error'],
      patternErrorMessage: json['pattern_error_message'],
      meta: json['meta'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'value': value ?? stringValue,
    'pattern': pattern,
    'field': field,
    'error_message': errorMessage,
    'min_length': minLength,
    'max_length': maxLength,
    'min_length_error': minLengthError,
    'max_length_error': maxLengthError,
    'pattern_error_message': patternErrorMessage,
    'meta': meta,
  };
}

// New models for the updated API response structure

class IntroSliderPage {
  String? pageName;
  String? pageTitle;
  String? pageDescription;
  bool? loginRequired;
  List<IntroSlider>? introSlider;

  IntroSliderPage({
    this.pageName,
    this.pageTitle,
    this.pageDescription,
    this.loginRequired,
    this.introSlider,
  });

  factory IntroSliderPage.fromJson(Map<String, dynamic> json) {
    List<IntroSlider>? sliders;
    if (json['intro_slider'] != null) {
      sliders = <IntroSlider>[];
      (json['intro_slider'] as List).forEach((v) {
        sliders!.add(IntroSlider.fromJson(v));
      });
    }
    return IntroSliderPage(
      pageName: json['page_name'],
      pageTitle: json['page_title'],
      pageDescription: json['page_description'],
      loginRequired: json['login_required'],
      introSlider: sliders,
    );
  }

  Map<String, dynamic> toJson() => {
    'page_name': pageName,
    'page_title': pageTitle,
    'page_description': pageDescription,
    'login_required': loginRequired,
    if (introSlider != null)
      'intro_slider': introSlider!.map((e) => e.toJson()).toList(),
  };
}

class HomePage {
  String? pageName;
  String? pageTitle;
  String? pageDescription;
  bool? loginRequired;
  HomePageDesign? design;

  HomePage({
    this.pageName,
    this.pageTitle,
    this.pageDescription,
    this.loginRequired,
    this.design,
  });

  factory HomePage.fromJson(Map<String, dynamic> json) {
    return HomePage(
      pageName: json['page_name'],
      pageTitle: json['page_title'],
      pageDescription: json['page_description'],
      loginRequired: json['login_required'],
      design: json['design'] != null
          ? HomePageDesign.fromJson(json['design'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'page_name': pageName,
    'page_title': pageTitle,
    'page_description': pageDescription,
    'login_required': loginRequired,
    if (design != null) 'design': design!.toJson(),
  };
}

class HomePageDesign {
  // Header menu section
  HeaderMenuSection? headerMenu;
  // Search bar section
  SearchBarSection? searchBar;
  // Body section
  List<CustomSection>? body;
  // Custom sections - stored as dynamic map to handle various custom sections
  Map<String, dynamic>? customSections;

  HomePageDesign({
    this.headerMenu,
    this.searchBar,
    this.body,
    this.customSections,
  });

  factory HomePageDesign.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> customSectionsMap = {};

    // Parse header_menu section
    HeaderMenuSection? headerMenuSection;
    if (json['header_menu'] != null) {
      headerMenuSection = HeaderMenuSection.fromJson(json['header_menu']);
    }

    // Parse search_bar section
    SearchBarSection? searchBarSection;
    if (json['search_bar'] != null) {
      searchBarSection = SearchBarSection.fromJson(json['search_bar']);
    }

    // Parse body section
    List<CustomSection>? bodyList;
    if (json['body'] != null && json['body'] is List) {
      bodyList = (json['body'] as List)
          .map((e) => CustomSection.fromJson(e))
          .toList();
    }

    // Parse all custom sections (custom_category_horizontal_list, custom_banner, etc.)
    json.forEach((key, value) {
      if (key != 'header_menu' &&
          key != 'search_bar' &&
          key != 'body' &&
          value is Map) {
        customSectionsMap[key] = CustomSection.fromJson(
          Map<String, dynamic>.from(value),
        );
      }
    });

    return HomePageDesign(
      headerMenu: headerMenuSection,
      searchBar: searchBarSection,
      body: bodyList,
      customSections: customSectionsMap.isNotEmpty ? customSectionsMap : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};

    if (headerMenu != null) {
      result['header_menu'] = headerMenu!.toJson();
    }

    if (searchBar != null) {
      result['search_bar'] = searchBar!.toJson();
    }

    if (body != null) {
      result['body'] = body!.map((e) => e.toJson()).toList();
    }

    if (customSections != null) {
      customSections!.forEach((key, value) {
        if (value is CustomSection) {
          result[key] = value.toJson();
        } else {
          result[key] = value;
        }
      });
    }

    return result;
  }
}

class HeaderMenuSection {
  String? bgColor;
  String? bgImg;
  bool? userInfo;
  bool? currentLocation;
  List<HeaderMenu>? headerMenu;

  HeaderMenuSection({
    this.bgColor,
    this.bgImg,
    this.userInfo,
    this.currentLocation,
    this.headerMenu,
  });

  factory HeaderMenuSection.fromJson(Map<String, dynamic> json) {
    List<HeaderMenu>? headerMenus;
    if (json['header_menu'] != null && json['header_menu'] is List) {
      headerMenus = <HeaderMenu>[];
      (json['header_menu'] as List).forEach((v) {
        headerMenus!.add(HeaderMenu.fromJson(v));
      });
    }

    return HeaderMenuSection(
      bgColor: json['bg_color'],
      bgImg: json['bg_img'],
      userInfo: json['user_info'],
      currentLocation: json['current_location'],
      headerMenu: headerMenus,
    );
  }

  Map<String, dynamic> toJson() => {
    'bg_color': bgColor,
    'bg_img': bgImg,
    'user_info': userInfo,
    'current_location': currentLocation,
    if (headerMenu != null)
      'header_menu': headerMenu!.map((e) => e.toJson()).toList(),
  };
}

class SearchBarSection {
  String? bgColor;
  String? bgImg;
  String? label;
  bool? isActive;
  bool? loginRequired;
  String? apiEndpoint;
  String? viewType;
  String? pageName;
  String? pageImage;
  String? title;
  String? description;
  dynamic design; // Can be List, Map, or null

  SearchBarSection({
    this.bgColor,
    this.bgImg,
    this.label,
    this.isActive,
    this.loginRequired,
    this.apiEndpoint,
    this.viewType,
    this.pageName,
    this.pageImage,
    this.title,
    this.description,
    this.design,
  });

  factory SearchBarSection.fromJson(Map<String, dynamic> json) {
    return SearchBarSection(
      bgColor: json['bg_color'],
      bgImg: json['bg_img'],
      label: json['label'],
      isActive: json['is_active'],
      loginRequired: json['login_required'],
      apiEndpoint: json['api_endpoint'],
      viewType: json['view_type'],
      pageName: json['page_name'],
      pageImage: json['page_image'],
      title: json['title'],
      description: json['description'],
      design: json['design'],
    );
  }

  Map<String, dynamic> toJson() => {
    'bg_color': bgColor,
    'bg_img': bgImg,
    if (label != null) 'label': label,
    if (isActive != null) 'is_active': isActive,
    if (loginRequired != null) 'login_required': loginRequired,
    if (apiEndpoint != null) 'api_endpoint': apiEndpoint,
    if (viewType != null) 'view_type': viewType,
    if (pageName != null) 'page_name': pageName,
    if (pageImage != null) 'page_image': pageImage,
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (design != null) 'design': design,
  };
}

class CustomSection {
  String? bgColor;
  String? bgImg;
  String? sectionHeading;
  String? label;
  bool? isActive;
  bool? loginRequired;
  String? apiEndpoint;
  String? viewType;
  String? pageName;
  String? pageImage;
  String? nextPageName;
  String? nextPageApiEndpoint;
  String? nextPageViewType;
  String? viewAllLabel;
  String? viewAllNextPage;
  String? title;
  String? description;
  List<CustomOption>? options;
  dynamic design; // Can be null, List, or Map with options

  CustomSection({
    this.bgColor,
    this.bgImg,
    this.sectionHeading,
    this.label,
    this.isActive,
    this.loginRequired,
    this.apiEndpoint,
    this.viewType,
    this.pageName,
    this.pageImage,
    this.nextPageName,
    this.nextPageApiEndpoint,
    this.nextPageViewType,
    this.viewAllLabel,
    this.viewAllNextPage,
    this.title,
    this.description,
    this.options,
    this.design,
  });

  factory CustomSection.fromJson(Map<String, dynamic> json) {
    // Handle design field - it can be null, empty array, or an object
    dynamic designValue = json['design'];

    // Parse options - can be in root or in design
    List<CustomOption>? optionsList;
    if (json['options'] != null && json['options'] is List) {
      optionsList = (json['options'] as List)
          .map((e) => CustomOption.fromJson(e))
          .toList();
    } else if (designValue is Map<String, dynamic> &&
        designValue.containsKey('options')) {
      final options = designValue['options'];
      if (options is List) {
        optionsList = options
            .map((e) => CustomOption.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    return CustomSection(
      bgColor: json['bg_color'],
      bgImg: json['bg_img'],
      sectionHeading: json['section_heading'],
      label: json['label'],
      isActive: json['is_active'],
      loginRequired: json['login_required'],
      apiEndpoint: json['api_endpoint'],
      viewType: json['view_type'],
      pageName: json['page_name'],
      pageImage: json['page_image'],
      nextPageName: json['next_page_name'],
      nextPageApiEndpoint: json['next_page_api_endpoint'],
      nextPageViewType: json['next_page_view_type'],
      viewAllLabel: json['view_all_label'],
      viewAllNextPage: json['view_all_next_page'],
      title: json['title'],
      description: json['description'],
      options: optionsList,
      design: designValue,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'bg_color': bgColor,
      'bg_img': bgImg,
      if (sectionHeading != null) 'section_heading': sectionHeading,
      if (label != null) 'label': label,
      if (isActive != null) 'is_active': isActive,
      if (loginRequired != null) 'login_required': loginRequired,
      if (apiEndpoint != null) 'api_endpoint': apiEndpoint,
      if (viewType != null) 'view_type': viewType,
      if (pageName != null) 'page_name': pageName,
      if (pageImage != null) 'page_image': pageImage,
      if (nextPageName != null) 'next_page_name': nextPageName,
      if (nextPageApiEndpoint != null)
        'next_page_api_endpoint': nextPageApiEndpoint,
      if (nextPageViewType != null) 'next_page_view_type': nextPageViewType,
      if (viewAllLabel != null) 'view_all_label': viewAllLabel,
      if (viewAllNextPage != null) 'view_all_next_page': viewAllNextPage,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
    };

    // If design exists and has options, use it; otherwise use root-level options
    if (design != null) {
      result['design'] = design;
    } else if (options != null) {
      result['options'] = options!.map((e) => e.toJson()).toList();
    }

    return result;
  }
}

class CustomOption {
  String? label;
  String? value;
  String? apiEndpoint;
  String? viewType;

  CustomOption({this.label, this.value, this.apiEndpoint, this.viewType});

  factory CustomOption.fromJson(Map<String, dynamic> json) {
    return CustomOption(
      label: json['label'],
      value: json['value'],
      apiEndpoint: json['api_endpoint'],
      viewType: json['view_type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'label': label,
    'value': value,
    'api_endpoint': apiEndpoint,
    'view_type': viewType,
  };
}

class HeaderMenu {
  String? icon;
  String? label;
  String? description;
  String? redirectTo;
  String? apiEndpoint;
  String? viewType;
  bool? loginRequired;
  bool? isActive;
  String? pageName;
  String? pageImage;
  String? nextPageName;
  String? nextPageApiEndpoint;
  String? nextPageViewType;
  String? viewAllLabel;
  String? viewAllNextPage;
  String? title;
  dynamic design; // Can be List or Map

  HeaderMenu({
    this.icon,
    this.label,
    this.description,
    this.redirectTo,
    this.apiEndpoint,
    this.viewType,
    this.loginRequired,
    this.isActive,
    this.pageName,
    this.pageImage,
    this.nextPageName,
    this.nextPageApiEndpoint,
    this.nextPageViewType,
    this.viewAllLabel,
    this.viewAllNextPage,
    this.title,
    this.design,
  });

  factory HeaderMenu.fromJson(Map<String, dynamic> json) {
    return HeaderMenu(
      icon: json['icon'],
      label: json['label'],
      description: json['description'],
      redirectTo: json['redirect_to'],
      apiEndpoint: json['api_endpoint'],
      viewType: json['view_type'],
      loginRequired: json['login_required'],
      isActive: json['is_active'],
      pageName: json['page_name'],
      pageImage: json['page_image'],
      nextPageName: json['next_page_name'],
      nextPageApiEndpoint: json['next_page_api_endpoint'],
      nextPageViewType: json['next_page_view_type'],
      viewAllLabel: json['view_all_label'],
      viewAllNextPage: json['view_all_next_page'],
      title: json['title'],
      design: json['design'],
    );
  }

  Map<String, dynamic> toJson() => {
    'icon': icon,
    'label': label,
    'description': description,
    'redirect_to': redirectTo,
    'api_endpoint': apiEndpoint,
    'view_type': viewType,
    'login_required': loginRequired,
    if (isActive != null) 'is_active': isActive,
    if (pageName != null) 'page_name': pageName,
    if (pageImage != null) 'page_image': pageImage,
    if (nextPageName != null) 'next_page_name': nextPageName,
    if (nextPageApiEndpoint != null)
      'next_page_api_endpoint': nextPageApiEndpoint,
    if (nextPageViewType != null) 'next_page_view_type': nextPageViewType,
    if (viewAllLabel != null) 'view_all_label': viewAllLabel,
    if (viewAllNextPage != null) 'view_all_next_page': viewAllNextPage,
    if (title != null) 'title': title,
    if (design != null) 'design': design,
  };
}

class BannerItem {
  String? image;
  String? title;
  String? description;
  String? redirectTo;

  BannerItem({this.image, this.title, this.description, this.redirectTo});

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      image: json['image'],
      title: json['title'],
      description: json['description'],
      redirectTo: json['redirect_to'],
    );
  }

  Map<String, dynamic> toJson() => {
    'image': image,
    'title': title,
    'description': description,
    'redirect_to': redirectTo,
  };
}

class ButtonItem {
  String? label;
  String? redirectTo;
  String? viewType;

  ButtonItem({this.label, this.redirectTo, this.viewType});

  factory ButtonItem.fromJson(Map<String, dynamic> json) {
    return ButtonItem(
      label: json['label'],
      redirectTo: json['redirect_to'],
      viewType: json['view_type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'label': label,
    'redirect_to': redirectTo,
    'view_type': viewType,
  };
}

class ListViewScrollItem {
  String? label;
  String? redirectTo;
  String? viewType;

  ListViewScrollItem({this.label, this.redirectTo, this.viewType});

  factory ListViewScrollItem.fromJson(Map<String, dynamic> json) {
    return ListViewScrollItem(
      label: json['label'],
      redirectTo: json['redirect_to'],
      viewType: json['view_type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'label': label,
    'redirect_to': redirectTo,
    'view_type': viewType,
  };
}

class GridViewScrollItem {
  String? label;
  String? redirectTo;
  String? viewType;

  GridViewScrollItem({this.label, this.redirectTo, this.viewType});

  factory GridViewScrollItem.fromJson(Map<String, dynamic> json) {
    return GridViewScrollItem(
      label: json['label'],
      redirectTo: json['redirect_to'],
      viewType: json['view_type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'label': label,
    'redirect_to': redirectTo,
    'view_type': viewType,
  };
}

class LoginWithPasswordPage {
  String? pageName;
  String? pageTitle;
  String? pageDescription;
  bool? loginRequired;
  List<RegisterInput>? inputs;

  LoginWithPasswordPage({
    this.pageName,
    this.pageTitle,
    this.pageDescription,
    this.loginRequired,
    this.inputs,
  });

  factory LoginWithPasswordPage.fromJson(Map<String, dynamic> json) {
    List<RegisterInput>? fields;
    if (json['inputs'] != null) {
      fields = <RegisterInput>[];
      (json['inputs'] as List).forEach((v) {
        fields!.add(RegisterInput.fromJson(v));
      });
    }
    return LoginWithPasswordPage(
      pageName: json['page_name'],
      pageTitle: json['page_title'],
      pageDescription: json['page_description'],
      loginRequired: json['login_required'],
      inputs: fields,
    );
  }

  Map<String, dynamic> toJson() => {
    'page_name': pageName,
    'page_title': pageTitle,
    'page_description': pageDescription,
    'login_required': loginRequired,
    if (inputs != null) 'inputs': inputs!.map((e) => e.toJson()).toList(),
  };
}

class LoginWithOtpPage {
  String? pageName;
  String? pageTitle;
  String? pageDescription;
  bool? loginRequired;
  List<RegisterInput>? inputs;

  LoginWithOtpPage({
    this.pageName,
    this.pageTitle,
    this.pageDescription,
    this.loginRequired,
    this.inputs,
  });

  factory LoginWithOtpPage.fromJson(Map<String, dynamic> json) {
    List<RegisterInput>? fields;
    if (json['inputs'] != null) {
      fields = <RegisterInput>[];
      (json['inputs'] as List).forEach((v) {
        fields!.add(RegisterInput.fromJson(v));
      });
    }
    return LoginWithOtpPage(
      pageName: json['page_name'],
      pageTitle: json['page_title'],
      pageDescription: json['page_description'],
      loginRequired: json['login_required'],
      inputs: fields,
    );
  }

  Map<String, dynamic> toJson() => {
    'page_name': pageName,
    'page_title': pageTitle,
    'page_description': pageDescription,
    'login_required': loginRequired,
    if (inputs != null) 'inputs': inputs!.map((e) => e.toJson()).toList(),
  };
}

class VerifyOtpPage {
  String? pageName;
  String? pageTitle;
  String? pageDescription;
  bool? loginRequired;
  List<RegisterInput>? inputs;

  VerifyOtpPage({
    this.pageName,
    this.pageTitle,
    this.pageDescription,
    this.loginRequired,
    this.inputs,
  });

  factory VerifyOtpPage.fromJson(Map<String, dynamic> json) {
    List<RegisterInput>? fields;
    if (json['inputs'] != null) {
      fields = <RegisterInput>[];
      (json['inputs'] as List).forEach((v) {
        fields!.add(RegisterInput.fromJson(v));
      });
    }
    return VerifyOtpPage(
      pageName: json['page_name'],
      pageTitle: json['page_title'],
      pageDescription: json['page_description'],
      loginRequired: json['login_required'],
      inputs: fields,
    );
  }

  Map<String, dynamic> toJson() => {
    'page_name': pageName,
    'page_title': pageTitle,
    'page_description': pageDescription,
    'login_required': loginRequired,
    if (inputs != null) 'inputs': inputs!.map((e) => e.toJson()).toList(),
  };
}

class ProfileFormPage {
  String? postKey;
  String? pageName;
  String? pageTitle;
  String? pageDescription;
  bool? progressBar;
  bool? autoForward;
  bool? loginRequired;
  int? totalSteps;
  List<String>? stepTitles;
  ProfileFormApiEndpoints? apiEndpoints;
  List<ProfileFormButton>? buttons;
  ProfileFormInputs? inputs;

  ProfileFormPage({
    this.postKey,
    this.pageName,
    this.pageTitle,
    this.pageDescription,
    this.progressBar,
    this.autoForward,
    this.loginRequired,
    this.totalSteps,
    this.stepTitles,
    this.apiEndpoints,
    this.buttons,
    this.inputs,
  });

  factory ProfileFormPage.fromJson(Map<String, dynamic> json) {
    List<String>? stepTitlesList;
    if (json['step_titles'] != null) {
      stepTitlesList = (json['step_titles'] as List)
          .map((e) => e.toString())
          .toList();
    }

    List<ProfileFormButton>? buttonsList;
    if (json['buttons'] != null) {
      buttonsList = (json['buttons'] as List)
          .map((v) => ProfileFormButton.fromJson(v))
          .toList();
    }

    return ProfileFormPage(
      postKey: json['post_key']?.toString(),
      pageName: json['page_name'],
      pageTitle: json['page_title'],
      pageDescription: json['page_description'],
      progressBar: json['progress_bar'],
      autoForward: json['auto_forward'],
      loginRequired: json['login_required'],
      totalSteps: json['total_steps'],
      stepTitles: stepTitlesList,
      apiEndpoints: json['api_endpoints'] != null
          ? ProfileFormApiEndpoints.fromJson(json['api_endpoints'])
          : null,
      buttons: buttonsList,
      inputs: json['inputs'] != null
          ? ProfileFormInputs.fromJson(json['inputs'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (postKey != null) 'post_key': postKey,
    if (pageName != null) 'page_name': pageName,
    'page_title': pageTitle,
    'page_description': pageDescription,
    'progress_bar': progressBar,
    'auto_forward': autoForward,
    'login_required': loginRequired,
    'total_steps': totalSteps,
    if (stepTitles != null) 'step_titles': stepTitles,
    if (apiEndpoints != null) 'api_endpoints': apiEndpoints!.toJson(),
    if (buttons != null) 'buttons': buttons!.map((e) => e.toJson()).toList(),
    if (inputs != null) 'inputs': inputs!.toJson(),
  };
}

class ProfileFormApiEndpoints {
  String? submitForm;
  String? uploadFile;
  Map<String, String?> stepEndpoints;

  ProfileFormApiEndpoints({
    this.submitForm,
    this.uploadFile,
    required this.stepEndpoints,
  });

  factory ProfileFormApiEndpoints.fromJson(Map<String, dynamic> json) {
    Map<String, String?> endpointsMap = {};

    // Dynamically parse all step_X_api_endpoint keys
    json.forEach((key, value) {
      if (key.startsWith('step_') &&
          key.endsWith('_api_endpoint') &&
          value is String) {
        endpointsMap[key] = value;
      }
    });

    return ProfileFormApiEndpoints(
      submitForm: json['submit_form'],
      uploadFile: json['upload_file'],
      stepEndpoints: endpointsMap,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};

    if (submitForm != null) {
      result['submit_form'] = submitForm;
    }
    if (uploadFile != null) {
      result['upload_file'] = uploadFile;
    }

    stepEndpoints.forEach((key, value) {
      if (value != null) {
        result[key] = value;
      }
    });

    return result;
  }

  // Helper method to get API endpoint for a specific step
  String? getStepEndpoint(int stepIndex) {
    String endpointKey =
        'step_${stepIndex + 1}_api_endpoint'; // Convert 0-based index to 1-based key
    return stepEndpoints[endpointKey];
  }

  // Helper method to get all available step endpoints
  List<int> getAvailableStepEndpoints() {
    List<int> availableSteps = [];
    stepEndpoints.forEach((key, value) {
      if (key.startsWith('step_') &&
          key.endsWith('_api_endpoint') &&
          value != null) {
        String stepNumber = key
            .replaceFirst('step_', '')
            .replaceFirst('_api_endpoint', '');
        int stepIndex = int.tryParse(stepNumber) ?? 0;
        if (stepIndex > 0) {
          availableSteps.add(stepIndex - 1); // Convert to 0-based index
        }
      }
    });
    availableSteps.sort();
    return availableSteps;
  }
}

class ProfileFormButton {
  String? label;
  String? action;
  String? style;
  int? visibleFromStep;
  int? visibleUntilStep;
  int? visibleOnStep;

  ProfileFormButton({
    this.label,
    this.action,
    this.style,
    this.visibleFromStep,
    this.visibleUntilStep,
    this.visibleOnStep,
  });

  factory ProfileFormButton.fromJson(Map<String, dynamic> json) {
    return ProfileFormButton(
      label: json['label'],
      action: json['action'],
      style: json['style'],
      visibleFromStep: json['visible_from_step'],
      visibleUntilStep: json['visible_until_step'],
      visibleOnStep: json['visible_on_step'],
    );
  }

  Map<String, dynamic> toJson() => {
    'label': label,
    'action': action,
    'style': style,
    'visible_from_step': visibleFromStep,
    'visible_until_step': visibleUntilStep,
    'visible_on_step': visibleOnStep,
  };
}

class ProfileFormInputs {
  Map<String, List<RegisterInput>?> steps;

  ProfileFormInputs({required this.steps});

  factory ProfileFormInputs.fromJson(Map<String, dynamic> json) {
    Map<String, List<RegisterInput>?> stepsMap = {};

    // Dynamically parse all step_X keys
    json.forEach((key, value) {
      if (key.startsWith('step_') && value is List) {
        List<RegisterInput> stepInputs = [];
        for (var item in value) {
          stepInputs.add(RegisterInput.fromJson(item));
        }
        stepsMap[key] = stepInputs;
      }
    });

    return ProfileFormInputs(steps: stepsMap);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    steps.forEach((key, value) {
      if (value != null) {
        result[key] = value.map((e) => e.toJson()).toList();
      }
    });
    return result;
  }

  // Helper method to get inputs for a specific step
  List<RegisterInput>? getStepInputs(int stepIndex) {
    String stepKey =
        'step_${stepIndex + 1}'; // Convert 0-based index to 1-based key
    return steps[stepKey];
  }

  // Helper method to get all available steps
  List<int> getAvailableSteps() {
    List<int> availableSteps = [];
    steps.forEach((key, value) {
      if (key.startsWith('step_') && value != null) {
        String stepNumber = key.replaceFirst('step_', '');
        int stepIndex = int.tryParse(stepNumber) ?? 0;
        if (stepIndex > 0) {
          availableSteps.add(stepIndex - 1); // Convert to 0-based index
        }
      }
    });
    availableSteps.sort();
    return availableSteps;
  }
}
