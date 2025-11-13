class AppModelResponse {
  int? responseCode;
  bool? success;
  String? message;
  Result? result;

  AppModelResponse(
      {this.responseCode, this.success, this.message, this.result});

  AppModelResponse.fromJson(Map<String, dynamic> json) {
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
  MobileApp? mobileApp;
  ForceUpdatePage? forceUpdatePage;
  LightTheme? lightTheme;
  LightTheme? darkTheme;
  General? general;
  Seo? seo;
  List<IntroSlider>? introSlider;
  LanguagePage? languagePage;
  List<Language>? languages;

  Result(
      {this.mobileApp,
        this.forceUpdatePage,
        this.lightTheme,
        this.darkTheme,
        this.general,
        this.seo,
        this.introSlider,
        this.languagePage,
        this.languages});

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
    general =
    json['general'] != null ? new General.fromJson(json['general']) : null;
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
    if (json['languages'] != null) {
      languages = <Language>[];
      json['languages'].forEach((v) {
        languages!.add(new Language.fromJson(v));
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
    if (this.general != null) {
      data['general'] = this.general!.toJson();
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
    if (this.languages != null) {
      data['languages'] = this.languages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MobileApp {
  String? androidVersion;
  String? iosVersion;
  String? playstoreUrl;
  String? appstoreUrl;

  MobileApp(
      {this.androidVersion,
        this.iosVersion,
        this.playstoreUrl,
        this.appstoreUrl});

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

  LightTheme(
      {this.bgColorLtr,
        this.bgColorTtb,
        this.primaryColor,
        this.primaryTextColor,
        this.secondaryColor,
        this.secondaryTextColor,
        this.mutedColor,
        this.mutedTextColor,
        this.linkTextColor});

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
    return data;
  }
}

class General {
  String? appName;
  String? companyName;
  String? logo;
  String? favicon;
  String? siteCopyright;
  String? contactNumber;
  String? whatsappNumber;
  String? timezone;
  String? orientation;
  bool? demoMode;
  bool? loginRequired;
  bool? socialLogin;

  General(
      {
        this.appName,
        this.companyName,
        this.logo,
        this.favicon,
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
    twitter =
    json['twitter'] != null ? new Twitter.fromJson(json['twitter']) : null;
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

  Meta(
      {this.title,
        this.author,
        this.application,
        this.copyright,
        this.description,
        this.keywords});

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

  Og(
      {this.type,
        this.image,
        this.imageWidth,
        this.imageHeight,
        this.title,
        this.description,
        this.url,
        this.fbAppId});

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

class LanguagePage {
  String? pageTitle;
  String? pageDescription;
  String? submitButtonLabel;

  LanguagePage({this.pageTitle, this.pageDescription, this.submitButtonLabel});

  LanguagePage.fromJson(Map<String, dynamic> json) {
    pageTitle = json['page_title'];
    pageDescription = json['page_description'];
    submitButtonLabel = json['submit_button_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_title'] = this.pageTitle;
    data['page_description'] = this.pageDescription;
    data['submit_button_label'] = this.submitButtonLabel;
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

// New models for app_content endpoint minimal parsing
class AppContentResponse {
  int? responseCode;
  bool? success;
  String? message;
  AppContentResult? result;

  AppContentResponse({this.responseCode, this.success, this.message, this.result});

  factory AppContentResponse.fromJson(Map<String, dynamic> json) {
    return AppContentResponse(
      responseCode: json['response_code'],
      success: json['success'],
      message: json['message'],
      result: json['result'] != null ? AppContentResult.fromJson(json['result']) : null,
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
      introSliderPage: json['intro_slider'] != null ? IntroSliderPage.fromJson(json['intro_slider']) : null,
      homePage: json['home_page'] != null ? HomePage.fromJson(json['home_page']) : null,
      register: json['register'] != null ? RegisterPage.fromJson(json['register']) : null,
      loginWithPassword: json['login_with_password'] != null ? LoginWithPasswordPage.fromJson(json['login_with_password']) : null,
      loginWithOtp: json['login_with_otp'] != null ? LoginWithOtpPage.fromJson(json['login_with_otp']) : null,
      verifyOtp: json['verify_otp'] != null ? VerifyOtpPage.fromJson(json['verify_otp']) : null,
      profileForm: json['profile_form'] != null ? ProfileFormPage.fromJson(json['profile_form']) : null,
      postForm: json['post_form'] != null ? ProfileFormPage.fromJson(json['post_form']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (introSliderPage != null) 'intro_slider': introSliderPage!.toJson(),
        if (homePage != null) 'home_page': homePage!.toJson(),
        if (register != null) 'register': register!.toJson(),
        if (loginWithPassword != null) 'login_with_password': loginWithPassword!.toJson(),
        if (loginWithOtp != null) 'login_with_otp': loginWithOtp!.toJson(),
        if (verifyOtp != null) 'verify_otp': verifyOtp!.toJson(),
        if (profileForm != null) 'profile_form': profileForm!.toJson(),
        if (postForm != null) 'post_form': postForm!.toJson(),
      };
}

class RegisterPage {
  String? pageTitle;
  String? pageDescription;
  bool? loginRequired;
  List<RegisterInput>? inputs;
  String? submitButtonLabel;
  String? loginLabel;
  String? loginLink;

  RegisterPage({this.pageTitle, this.pageDescription, this.loginRequired, this.inputs, this.submitButtonLabel, this.loginLabel, this.loginLink});

  factory RegisterPage.fromJson(Map<String, dynamic> json) {
    List<RegisterInput>? fields;
    if (json['inputs'] != null) {
      fields = <RegisterInput>[];
      (json['inputs'] as List).forEach((v) {
        fields!.add(RegisterInput.fromJson(v));
      });
    }
    return RegisterPage(
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
  String? inputType; // text, textarea, password, toggle, radio, check, file, dropdown, date_time, date_range
  String? label;
  String? placeholder;
  String? name;
  bool? required;
  List<InputValidation>? validations;
  List<String>? options; // legacy simple string options
  List<OptionItem>? optionItems; // structured options with label/value
  dynamic value; // Can be String, int, bool, List, Map, or null

  RegisterInput({this.inputType, this.label, this.placeholder, this.name, this.required, this.validations, this.options, this.optionItems, this.value});

  factory RegisterInput.fromJson(Map<String, dynamic> json) {
    List<InputValidation>? rules;
    if (json['validations'] != null) {
      rules = <InputValidation>[];
      (json['validations'] as List).forEach((v) {
        rules!.add(InputValidation.fromJson(v));
      });
    }
    List<String>? opts;
    List<OptionItem>? structuredOptions;
    if (json['options'] != null) {
      final list = (json['options'] as List);
      for (final e in list) {
        if (e is Map<String, dynamic>) {
          structuredOptions ??= <OptionItem>[];
          structuredOptions.add(OptionItem.fromJson(e));
        } else {
          opts ??= <String>[];
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
      validations: rules,
      options: opts,
      optionItems: structuredOptions,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
        'input_type': inputType,
        'label': label,
        'placeholder': placeholder,
        'name': name,
        'required': required,
        if (validations != null) 'validations': validations!.map((e) => e.toJson()).toList(),
        if (optionItems != null) 'options': optionItems!.map((e) => e.toJson()).toList() else if (options != null) 'options': options,
        'value': value,
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

  Map<String, dynamic> toJson() => {
        'label': label,
        'value': value,
      };
}

class InputValidation {
  String? type; // numeric, exact_length, min_length, max_length, pattern, matches, password, file, max_size, min, in
  int? value; // for exact_length, min_length, max_length, max_size, min
  String? stringValue; // Allow values for String type Data like "jpg, jpeg, png",
  String? pattern; // regex pattern
  String? field; // for matches
  String? errorMessage; // generic error

  // Extended fields for password constraints
  int? minLength;
  int? maxLength;
  String? minLengthError;
  String? maxLengthError;
  String? patternErrorMessage;

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
          : (json['min_length'] is String ? int.tryParse(json['min_length']) : null),
      maxLength: json['max_length'] is int
          ? json['max_length']
          : (json['max_length'] is String ? int.tryParse(json['max_length']) : null),
      minLengthError: json['min_length_error'],
      maxLengthError: json['max_length_error'],
      patternErrorMessage: json['pattern_error_message'],
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
      };
}

// New models for the updated API response structure

class IntroSliderPage {
  String? pageTitle;
  String? pageDescription;
  bool? loginRequired;
  List<IntroSlider>? introSlider;

  IntroSliderPage({this.pageTitle, this.pageDescription, this.loginRequired, this.introSlider});

  factory IntroSliderPage.fromJson(Map<String, dynamic> json) {
    List<IntroSlider>? sliders;
    if (json['intro_slider'] != null) {
      sliders = <IntroSlider>[];
      (json['intro_slider'] as List).forEach((v) {
        sliders!.add(IntroSlider.fromJson(v));
      });
    }
    return IntroSliderPage(
      pageTitle: json['page_title'],
      pageDescription: json['page_description'],
      loginRequired: json['login_required'],
      introSlider: sliders,
    );
  }

  Map<String, dynamic> toJson() => {
        'page_title': pageTitle,
        'page_description': pageDescription,
        'login_required': loginRequired,
        if (introSlider != null) 'intro_slider': introSlider!.map((e) => e.toJson()).toList(),
      };
}

class HomePage {
  String? pageTitle;
  String? pageDescription;
  bool? loginRequired;
  HomePageDesign? design;

  HomePage({this.pageTitle, this.pageDescription, this.loginRequired, this.design});

  factory HomePage.fromJson(Map<String, dynamic> json) {
    return HomePage(
      pageTitle: json['page_title'],
      pageDescription: json['page_description'],
      loginRequired: json['login_required'],
      design: json['design'] != null ? HomePageDesign.fromJson(json['design']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
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
  // Custom sections - stored as dynamic map to handle various custom sections
  Map<String, dynamic>? customSections;

  HomePageDesign({
    this.headerMenu,
    this.searchBar,
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
    
    // Parse all custom sections (custom_category_horizontal_list, custom_banner, etc.)
    json.forEach((key, value) {
      if (key != 'header_menu' && key != 'search_bar' && value is Map) {
        customSectionsMap[key] = CustomSection.fromJson(Map<String, dynamic>.from(value));
      }
    });

    return HomePageDesign(
      headerMenu: headerMenuSection,
      searchBar: searchBarSection,
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
        if (headerMenu != null) 'header_menu': headerMenu!.map((e) => e.toJson()).toList(),
      };
}

class SearchBarSection {
  String? bgColor;
  String? bgImg;

  SearchBarSection({this.bgColor, this.bgImg});

  factory SearchBarSection.fromJson(Map<String, dynamic> json) {
    return SearchBarSection(
      bgColor: json['bg_color'],
      bgImg: json['bg_img'],
    );
  }

  Map<String, dynamic> toJson() => {
        'bg_color': bgColor,
        'bg_img': bgImg,
      };
}

class CustomSection {
  String? bgColor;
  String? bgImg;
  String? apiEndpoint;

  CustomSection({this.bgColor, this.bgImg, this.apiEndpoint});

  factory CustomSection.fromJson(Map<String, dynamic> json) {
    return CustomSection(
      bgColor: json['bg_color'],
      bgImg: json['bg_img'],
      apiEndpoint: json['api_endpoint'],
    );
  }

  Map<String, dynamic> toJson() => {
        'bg_color': bgColor,
        'bg_img': bgImg,
        'api_endpoint': apiEndpoint,
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

  HeaderMenu({
    this.icon,
    this.label,
    this.description,
    this.redirectTo,
    this.apiEndpoint,
    this.viewType,
    this.loginRequired,
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
  String? pageTitle;
  String? pageDescription;
  bool? loginRequired;
  List<RegisterInput>? inputs;

  LoginWithPasswordPage({this.pageTitle, this.pageDescription, this.loginRequired, this.inputs});

  factory LoginWithPasswordPage.fromJson(Map<String, dynamic> json) {
    List<RegisterInput>? fields;
    if (json['inputs'] != null) {
      fields = <RegisterInput>[];
      (json['inputs'] as List).forEach((v) {
        fields!.add(RegisterInput.fromJson(v));
      });
    }
    return LoginWithPasswordPage(
      pageTitle: json['page_title'],
      pageDescription: json['page_description'],
      loginRequired: json['login_required'],
      inputs: fields,
    );
  }

  Map<String, dynamic> toJson() => {
        'page_title': pageTitle,
        'page_description': pageDescription,
        'login_required': loginRequired,
        if (inputs != null) 'inputs': inputs!.map((e) => e.toJson()).toList(),
      };
}

class LoginWithOtpPage {
  String? pageTitle;
  String? pageDescription;
  bool? loginRequired;
  List<RegisterInput>? inputs;

  LoginWithOtpPage({this.pageTitle, this.pageDescription, this.loginRequired, this.inputs});

  factory LoginWithOtpPage.fromJson(Map<String, dynamic> json) {
    List<RegisterInput>? fields;
    if (json['inputs'] != null) {
      fields = <RegisterInput>[];
      (json['inputs'] as List).forEach((v) {
        fields!.add(RegisterInput.fromJson(v));
      });
    }
    return LoginWithOtpPage(
      pageTitle: json['page_title'],
      pageDescription: json['page_description'],
      loginRequired: json['login_required'],
      inputs: fields,
    );
  }

  Map<String, dynamic> toJson() => {
        'page_title': pageTitle,
        'page_description': pageDescription,
        'login_required': loginRequired,
        if (inputs != null) 'inputs': inputs!.map((e) => e.toJson()).toList(),
      };
}

class VerifyOtpPage {
  String? pageTitle;
  String? pageDescription;
  bool? loginRequired;
  List<RegisterInput>? inputs;

  VerifyOtpPage({this.pageTitle, this.pageDescription, this.loginRequired, this.inputs});

  factory VerifyOtpPage.fromJson(Map<String, dynamic> json) {
    List<RegisterInput>? fields;
    if (json['inputs'] != null) {
      fields = <RegisterInput>[];
      (json['inputs'] as List).forEach((v) {
        fields!.add(RegisterInput.fromJson(v));
      });
    }
    return VerifyOtpPage(
      pageTitle: json['page_title'],
      pageDescription: json['page_description'],
      loginRequired: json['login_required'],
      inputs: fields,
    );
  }

  Map<String, dynamic> toJson() => {
        'page_title': pageTitle,
        'page_description': pageDescription,
        'login_required': loginRequired,
        if (inputs != null) 'inputs': inputs!.map((e) => e.toJson()).toList(),
      };
}

class ProfileFormPage {
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
      stepTitlesList = (json['step_titles'] as List).map((e) => e.toString()).toList();
    }

    List<ProfileFormButton>? buttonsList;
    if (json['buttons'] != null) {
      buttonsList = (json['buttons'] as List)
          .map((v) => ProfileFormButton.fromJson(v))
          .toList();
    }

    return ProfileFormPage(
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
    'page_title': pageTitle,
    'page_description': pageDescription,
    'progress_bar': progressBar,
    'auto_forward': autoForward,
    'login_required': loginRequired,
    'total_steps': totalSteps,
    if (stepTitles != null) 'step_titles': stepTitles,
    if (apiEndpoints != null) 'api_endpoints': apiEndpoints!.toJson(),
    if (buttons != null)
      'buttons': buttons!.map((e) => e.toJson()).toList(),
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
      if (key.startsWith('step_') && key.endsWith('_api_endpoint') && value is String) {
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
    Map<String, dynamic> result = {
      'submit_form': submitForm,
      'upload_file': uploadFile,
    };

    stepEndpoints.forEach((key, value) {
      if (value != null) {
        result[key] = value;
      }
    });

    return result;
  }

  // Helper method to get API endpoint for a specific step
  String? getStepEndpoint(int stepIndex) {
    String endpointKey = 'step_${stepIndex + 1}_api_endpoint'; // Convert 0-based index to 1-based key
    return stepEndpoints[endpointKey];
  }

  // Helper method to get all available step endpoints
  List<int> getAvailableStepEndpoints() {
    List<int> availableSteps = [];
    stepEndpoints.forEach((key, value) {
      if (key.startsWith('step_') && key.endsWith('_api_endpoint') && value != null) {
        String stepNumber = key.replaceFirst('step_', '').replaceFirst('_api_endpoint', '');
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
    String stepKey = 'step_${stepIndex + 1}'; // Convert 0-based index to 1-based key
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