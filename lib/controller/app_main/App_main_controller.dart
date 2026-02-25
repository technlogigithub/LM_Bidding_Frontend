import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Added
import '../../core/app_constant.dart';
import '../../core/app_config.dart';
import '../../core/network.dart';
import '../../models/App_moduls/AppResponseModel.dart';
import '../../models/Post/Post_Form_Genrate_Model.dart';
import '../../core/mock_response.dart'; // Added
import 'package:geolocator/geolocator.dart';

class AppSettingsController extends GetxController {
  Rx<AppModelResponse?> appSettings = Rx<AppModelResponse?>(null);
  RxBool isLoading = false.obs;
  RxBool isDarkMode = false.obs;

  // SEO Meta
  RxString seoTitle = "".obs;
  RxString seoAuthor = "".obs;
  RxString seoApplication = "".obs;
  RxString seoCopyright = "".obs;
  RxString seoDescription = "".obs;
  RxString seoKeywords = "".obs;

  // OG
  RxString ogType = "".obs;
  RxString ogImage = "".obs;
  RxString ogImageWidth = "".obs;
  RxString ogImageHeight = "".obs;
  RxString ogTitle = "".obs;
  RxString ogDescription = "".obs;
  RxString ogUrl = "".obs;
  RxString ogFbAppId = "".obs;

  // Instagram
  RxString instaImage = "".obs;
  RxString instaImageWidth = "".obs;
  RxString instaImageHeight = "".obs;

  // Twitter
  RxString twitterCard = "".obs;
  RxString twitterImage = "".obs;
  RxString twitterTitle = "".obs;
  RxString twitterDescription = "".obs;
  RxString twitterUrl = "".obs;

  // General
  RxString appName = "".obs;
  RxString companyName = "".obs;
  RxString logo = "".obs;
  RxString favicon = "".obs;
  RxString logoSplash = "".obs;
  RxString logoName = "".obs;
  RxString logoNameWhite = "".obs;
  RxString logoWhite = "".obs;
  RxString siteCopyright = "".obs;
  RxString contactNumber = "".obs;
  RxString whatsappNumber = "".obs;
  RxString timezone = "".obs;
  RxString orientation = "".obs;
  RxBool demoMode = false.obs;
  RxBool loginRequired = false.obs;
  RxBool socialLoginRequired = false.obs;

  // Social Login
  Rx<SocialLogin?> socialLogin = Rx<SocialLogin?>(null);
  RxString googleClientId = "".obs;
  RxString googleClientSecret = "".obs;
  RxString facebookClientId = "".obs;
  RxString facebookClientSecret = "".obs;

  // App Menu
  RxList<AppMenuItem> appMenu = <AppMenuItem>[].obs;
  RxList<AppMenuItem> bottomAppMenu = <AppMenuItem>[].obs;
  
  Rx<AppMenuItem?> userInfo = Rx<AppMenuItem?>(null);
  Rx<AppMenuItem?> myProfile = Rx<AppMenuItem?>(null);
  Rx<AppMenuItem?> support = Rx<AppMenuItem?>(null);
  Rx<Country?> country = Rx<Country?>(null);
  RxList<Country> availableCountries = <Country>[].obs;

  // NEW
  Rx<AppMenuItem?> settings = Rx<AppMenuItem?>(null);
  Rx<AppMenuItem?> referral = Rx<AppMenuItem?>(null);

  // MobileApp
  RxString androidVersion = "".obs;
  RxString iosVersion = "".obs;
  RxString playstoreUrl = "".obs;
  RxString appstoreUrl = "".obs;

  // Theme
  RxString bgColorLtr = "".obs;
  RxString bgColorTtb = "".obs;
  RxString primaryColor = "".obs;
  RxString primaryTextColor = "".obs;
  RxString secondaryColor = "".obs;
  RxString secondaryTextColor = "".obs;
  RxString mutedColor = "".obs;
  RxString mutedTextColor = "".obs;
  RxString linkTextColor = "".obs;
  RxString titleColor = "".obs;
  RxString iconColor = "".obs;
  RxString descriptiontextColor = "".obs;
  RxString bodytextColor = "".obs;

  // Font Style
  RxString fontFamily = "".obs;
  RxDouble fontTitleSize = 0.0.obs;
  RxDouble fontDescriptionSize = 0.0.obs;
  RxDouble fontBodySize = 0.0.obs;

  // Intro Sliders
  RxList<IntroSlider> introSliders = <IntroSlider>[].obs;

  // Register page (dynamic)
  Rx<RegisterPage?> registerPage = Rx<RegisterPage?>(null);
  // Login pages (dynamic)
  Rx<LoginWithPasswordPage?> loginWithPasswordPage = Rx<LoginWithPasswordPage?>(
    null,
  );
  Rx<LoginWithOtpPage?> loginWithOtpPage = Rx<LoginWithOtpPage?>(null);
  // Verify OTP page (dynamic)
  Rx<VerifyOtpPage?> verifyOtpPage = Rx<VerifyOtpPage?>(null);
  // Profile Form page (dynamic)
  Rx<ProfileFormPage?> profileFormPage = Rx<ProfileFormPage?>(null);
  // Post Form page (dynamic)
  Rx<ProfileFormPage?> postFormPage = Rx<ProfileFormPage?>(null);
  // PostForm from get-post-form API
  Rx<PostForm?> postFormFromApi = Rx<PostForm?>(null);
  Rx<HomePage?> homePage = Rx<HomePage?>(null);
  Rx<HeaderMenuSection?> homePageheader = Rx<HeaderMenuSection?>(null);
  Rx<AppMenuItem?> myPostModel = Rx<AppMenuItem?>(null);
  Rx<AppMenuItem?> myOrderModel = Rx<AppMenuItem?>(null);
  Rx<SearchPage?> searchPage = Rx<SearchPage?>(null);
  Rx<CategoryPage?> categoryPage = Rx<CategoryPage?>(null);

  // Languages
  RxList<Language> availableLanguages = <Language>[].obs;
  RxString selectedLanguageKey = "en".obs;
  RxString selectedLanguageName = "English".obs;

  // Language Page (from settings)
  RxString languagePageTitle = "".obs;
  RxString languagePageDescription = "".obs;
  RxString languageSubmitButtonLabel = "".obs;
  RxString languagePageImage = "".obs;
  RxString languagePageName = "".obs;

  // Force Update Page (from settings)
  RxString forceUpdatePageTitle = "".obs;
  RxString forceUpdatePageDescription = "".obs;
  RxString forceUpdateSubmitButtonLabel = "".obs;
  RxString forceUpdatePlaystoreUrl = "".obs;
  RxString forceUpdateAppstoreUrl = "".obs;

  Map<String, dynamic> _lightTheme = {};
  Map<String, dynamic> _darkTheme = {};

  // Fetch API and store all fields
  Future<void> fetchAllData() async {
    try {
      isLoading.value = true;

      final apiService = ApiServices();
      final token = await getAuthToken();
      print("🔐 Token Used: $token");
      
      // Get User Key from Shared Prefs
      final prefs = await SharedPreferences.getInstance();
      final userKey = prefs.getString('ukey');

      // Get Current Location (with timeout to prevent hanging on Web)
      String? lat;
      String? long;
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          
          if (permission == LocationPermission.whileInUse || 
              permission == LocationPermission.always) {
            // Added timeout only for Web to prevent hanging on reloads
            Position position = await Geolocator.getCurrentPosition(
              timeLimit: kIsWeb ? const Duration(seconds: 3) : null,
            );
            lat = position.latitude.toString();
            long = position.longitude.toString();
          }
        }
      } catch (e) {
        print("Error getting location (skipped after timeout/error): $e");
      }

      // Construct Request Body
      Map<String, dynamic> requestBody = {
        "app_key": "b2QgKe1+OFbaIVbBc76cWVVfj2W94jqB6x2yTOJI7ds"
      };

      if (userKey != null && userKey.isNotEmpty) {
        requestBody['user_key'] = userKey;
      }
      if (lat != null && lat.isNotEmpty) {
        requestBody['gps_lat'] = lat;
      }
      if (long != null && long.isNotEmpty) {
        requestBody['gps_long'] = long;
      }

      var response = await apiService.makeRequestFormData(
        endPoint: AppConstants.settings,
        method: "POST",
        headers: {
          "Authorization": "Bearer $token", // ⬅️ token added
          "Accept": "application/json",
        },
        body: requestBody,
      );

      if (response['success'] == true) {
        appSettings.value = AppModelResponse.fromJson(response);
        final result = appSettings.value?.result;

        /// Save MobileApp
        androidVersion.value = result?.mobileApp?.androidVersion ?? "";
        iosVersion.value = result?.mobileApp?.iosVersion ?? "";
        // playstoreUrl.value = result?.mobileApp?.playstoreUrl ?? "";
        // appstoreUrl.value = result?.mobileApp?.appstoreUrl ?? "";

        /// Store themes
        _lightTheme = result?.lightTheme?.toJson() ?? {};
        _darkTheme = result?.darkTheme?.toJson() ?? {};

        /// Font style
        fontFamily.value = result?.fontStyle?.fontFamily ?? "";
        fontTitleSize.value = result?.fontStyle?.title ?? 0.0;
        fontDescriptionSize.value = result?.fontStyle?.description ?? 0.0;
        fontBodySize.value = result?.fontStyle?.body ?? 0.0;

        /// SEO Meta
        seoTitle.value = result?.seo?.meta?.title ?? "";
        seoAuthor.value = result?.seo?.meta?.author ?? "";
        seoApplication.value = result?.seo?.meta?.application ?? "";
        seoCopyright.value = result?.seo?.meta?.copyright ?? "";
        seoDescription.value = result?.seo?.meta?.description ?? "";
        seoKeywords.value = result?.seo?.meta?.keywords ?? "";

        /// OG
        ogType.value = result?.seo?.og?.type ?? "";
        ogImage.value = result?.seo?.og?.image ?? "";
        ogImageWidth.value = result?.seo?.og?.imageWidth ?? "";
        ogImageHeight.value = result?.seo?.og?.imageHeight ?? "";
        ogTitle.value = result?.seo?.og?.title ?? "";
        ogDescription.value = result?.seo?.og?.description ?? "";
        ogUrl.value = result?.seo?.og?.url ?? "";
        ogFbAppId.value = result?.seo?.og?.fbAppId ?? "";

        /// Instagram
        instaImage.value = result?.seo?.instagram?.image ?? "";
        instaImageWidth.value = result?.seo?.instagram?.imageWidth ?? "";
        instaImageHeight.value = result?.seo?.instagram?.imageHeight ?? "";

        /// Twitter
        twitterCard.value = result?.seo?.twitter?.card ?? "";
        twitterImage.value = result?.seo?.twitter?.image ?? "";
        twitterTitle.value = result?.seo?.twitter?.title ?? "";
        twitterDescription.value = result?.seo?.twitter?.description ?? "";
        twitterUrl.value = result?.seo?.twitter?.url ?? "";

        /// General
        appName.value = result?.general?.appName ?? "";
        companyName.value = result?.general?.companyName ?? "";
        logo.value = result?.general?.logo ?? "";

        /// EXTRA LOGOS (new)
        logoSplash.value = result?.general?.logoSplash ?? "";
        logoName.value = result?.general?.logoName ?? "";
        logoNameWhite.value = result?.general?.logoNameWhite ?? "";
        logoWhite.value = result?.general?.logoWhite ?? "";

        favicon.value = result?.general?.favicon ?? "";
        siteCopyright.value = result?.general?.siteCopyright ?? "";
        contactNumber.value = result?.general?.contactNumber ?? "";
        whatsappNumber.value = result?.general?.whatsappNumber ?? "";
        timezone.value = result?.general?.timezone ?? "";
        orientation.value = result?.general?.orientation ?? "";
        demoMode.value = result?.general?.demoMode ?? false;
        loginRequired.value = result?.general?.loginRequired ?? false;

        /// Social Login
        socialLogin.value = result?.socialLogin;
        googleClientId.value = result?.socialLogin?.google?.clientId ?? "";
        googleClientSecret.value =
            result?.socialLogin?.google?.clientSecret ?? "";
        facebookClientId.value = result?.socialLogin?.facebook?.clientId ?? "";
        facebookClientSecret.value =
            result?.socialLogin?.facebook?.clientSecret ?? "";
        // Check if social login is enabled (if any provider has client_id configured)
        socialLoginRequired.value =
            (googleClientId.value.isNotEmpty ||
            facebookClientId.value.isNotEmpty);

        /// App Menu
        appMenu.assignAll(result?.appMenu ?? []);
        bottomAppMenu.assignAll(result?.bottomAppMenu ?? []);

        // Extract User Info (first item usually contains the flags)
        if (appMenu.isNotEmpty && (appMenu[0].dp != null || appMenu[0].name != null)) {
             userInfo.value = appMenu[0];
        }

        // Helper to find item by label
        AppMenuItem? findItem(List<AppMenuItem> list, String label) {
          return list.firstWhere((element) => element.label == label, orElse: () => AppMenuItem());
        }
        
        // Helper to find item by label safe
        AppMenuItem? findItemSafe(List<AppMenuItem> list, String label) {
          try {
             return list.firstWhere((element) => element.label == label);
          } catch(e) {
             return null;
          }
        }

        myProfile.value = findItemSafe(appMenu, "My Profile");
        support.value = findItemSafe(appMenu, "Help & Support");
        myPostModel.value = findItemSafe(appMenu, "My Post");
        myOrderModel.value = findItemSafe(appMenu, "My Order");
        settings.value = findItemSafe(appMenu, "Settings");
        referral.value = findItemSafe(appMenu, "Invite Friends");

        /// Countries
        availableCountries.assignAll(result?.country ?? []);
        if (availableCountries.isNotEmpty) {
          country.value = availableCountries.first;
        } else {
          country.value = null;
        }

        searchPage.value = result?.searchPage;
        categoryPage.value = result?.categoryPage;

        // Save loginRequired flag for support to SharedPreferences
        if (support.value != null) {
          await saveLoginRequiredStatusforsupport(support.value?.loginRequired);
        }
        if (referral.value != null) {
          await saveLoginRequiredStatusforinvite(referral.value?.loginRequired);
        }
        if (settings.value != null) {
          await saveLoginRequiredStatusforsetting(
            settings.value?.loginRequired,
          );
        }

        /// Intro Sliders
        introSliders.assignAll(result?.introSlider ?? []);

        /// Language Page
        languagePageTitle.value = result?.languagePage?.title ?? "";
        languagePageDescription.value = result?.languagePage?.description ?? "";
        languageSubmitButtonLabel.value =
            result?.languagePage?.submitButtonLabel ?? "";
        languagePageImage.value = result?.languagePage?.pageImage ?? "";
        languagePageName.value = result?.languagePage?.pageName ?? "";

        /// Force Update Page
        forceUpdatePageTitle.value = result?.forceUpdatePage?.pageTitle ?? "";
        forceUpdatePageDescription.value =
            result?.forceUpdatePage?.pageDescription ?? "";
        forceUpdateSubmitButtonLabel.value =
            result?.forceUpdatePage?.submitButtonLabel ?? "";
        forceUpdatePlaystoreUrl.value =
            result?.forceUpdatePage?.submitButtonPlaystoreUrl ?? "";
        forceUpdateAppstoreUrl.value =
            result?.forceUpdatePage?.submitButtonAppstoreUrl ?? "";

        /// Languages
        availableLanguages.assignAll(result?.languages ?? []);
        await loadSelectedLanguage();

        /// Set initial theme based on system brightness
        final Brightness systemBrightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        updateTheme(systemBrightness == Brightness.dark);
      } else {
        toast(response['message'] ?? "Something went wrong");
      }
    } catch (e) {
      toast("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  // Fetch app_content using selected/saved language and update introSliders
  Future<void> fetchAppContent() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final languageKey =
          prefs.getString('selected_language_key') ?? selectedLanguageKey.value;
      final token = await getAuthToken();

      final apiService = ApiServices();

      // Base headers (always sent)
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Add Authorization only if token is valid
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      var response = await apiService.makeRequestRaw(
        endPoint: AppConstants.appContent,
        method: AppConstants.POST,
        body: {
          'app_key': 'b2QgKe1+OFbaIVbBc76cWVVfj2W94jqB6x2yTOJI7ds',
          'language': languageKey,
        },
        headers: headers,
      );

      // 🔹 FALLBACK TO MOCK DATA IF API FAILS OR 401
      if (response['response_code'] == 401 || response['success'] == false) {
         print("⚠️ API returned ${response['response_code']}. Using MOCK DATA.");
         try {
           response = jsonDecode(mockAppContentResponse);
         } catch(e) {
           print("Error parsing mock data: $e");
         }
      }

      if (response['success'] == true && response['response_code'] == 200) {
        final parsed = AppContentResponse.fromJson(response);

        // Update intro sliders and pages
        introSliders.assignAll(
          parsed.result?.introSliderPage?.introSlider ?? [],
        );
        registerPage.value = parsed.result?.register;
        loginWithPasswordPage.value = parsed.result?.loginWithPassword;
        loginWithOtpPage.value = parsed.result?.loginWithOtp;
        verifyOtpPage.value = parsed.result?.verifyOtp;
        profileFormPage.value = parsed.result?.profileForm;
        homePage.value = parsed.result?.homePage;
        homePageheader.value = parsed.result?.homePage?.design?.headerMenu;

        print('We are checking home page Data ... ${homePage.value}');
        print('We are checking home page Data ... ${homePageheader.value}');

        if (parsed.result?.profileForm != null) {
          profileFormPage.value = parsed.result?.profileForm;
          // Save loginRequired flag to SP
          await saveLoginRequiredStatus(profileFormPage.value?.loginRequired);
        }
        // ---------------------------------------------------
        // 1. Parse the response (you already have `parsed`)
        // ---------------------------------------------------
        if (parsed.result?.profileForm != null) {
          profileFormPage.value = parsed.result?.profileForm;

          // Save loginRequired flag to SharedPreferences
          await saveLoginRequiredStatus(
            profileFormPage.value?.loginRequired ?? false,
          );
        }

        // ---------------------------------------------------
        // 2. Grab step_1 inputs (0-based index)
        // ---------------------------------------------------
        final ProfileFormInputs? formInputs = profileFormPage.value?.inputs;
        final List<RegisterInput>? step1Inputs = formInputs?.getStepInputs(0);

        // ---------------------------------------------------
        // 3. Print the values (terminal / debug console)
        // ---------------------------------------------------
        if (step1Inputs != null && step1Inputs.isNotEmpty) {
          debugPrint('=== PROFILE FORM – STEP 1 VALUES ===');
          for (final RegisterInput input in step1Inputs) {
            // `input.label` may be null → fallback to name
            final String label = input.label?.isNotEmpty == true
                ? input.label!
                : (input.name ?? 'Unnamed');

            // `input.value` can be String, int, bool, List, Map or null
            final dynamic rawValue = input.value;
            String displayValue;

            if (rawValue == null) {
              displayValue = '<null>';
            } else if (rawValue is List) {
              displayValue = rawValue.isEmpty
                  ? '[]'
                  : '[${rawValue.join(', ')}]';
            } else if (rawValue is Map) {
              displayValue = rawValue.isEmpty ? '{}' : '{…}';
            } else {
              displayValue = rawValue.toString();
            }

            debugPrint('$label: $displayValue');
          }
          debugPrint('=====================================');
        } else {
          debugPrint('No inputs found for profile_form → step_1');
        }

        postFormPage.value = parsed.result?.postForm;
      } else {
        toast(response['message'] ?? 'Failed to fetch app content');
      }
    } catch (e) {
      print('Error: $e');
      toast('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateTheme(bool darkMode) {
    isDarkMode.value = darkMode;
    final theme = darkMode ? _darkTheme : _lightTheme;

    bgColorLtr.value = theme['bg_color_ltr'] ?? "";
    bgColorTtb.value = theme['bg_color_ttb'] ?? "";
    primaryColor.value = theme['primary_color'] ?? "";
    primaryTextColor.value = theme['primary_text_color'] ?? "";
    secondaryColor.value = theme['secondary_color'] ?? "";
    secondaryTextColor.value = theme['secondary_text_color'] ?? "";
    mutedColor.value = theme['muted_color'] ?? "";
    mutedTextColor.value = theme['muted_text_color'] ?? "";
    linkTextColor.value = theme['link_text_color'] ?? "";
    iconColor.value = theme['icon_text_color'] ?? "";

    print(" description color ${theme['description_text_color'] ?? ""}");
    descriptiontextColor.value = theme['description_text_color'] ?? "";
    titleColor.value = theme['title_text_color'] ?? "";
    bodytextColor.value = theme['body_text_color'] ?? "";
  }

  // Language Management Methods
  Future<void> loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageKey = prefs.getString('selected_language_key') ?? 'en';

    // Set the selected language key
    selectedLanguageKey.value = savedLanguageKey;

    // Find the corresponding language name from available languages
    try {
      final language = availableLanguages.firstWhere(
        (lang) => lang.code == savedLanguageKey,
      );
      selectedLanguageName.value = language.name ?? 'English';
    } catch (e) {
      selectedLanguageName.value = 'English';
    }
  }

  Future<void> setSelectedLanguage(String languageKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language_key', languageKey);

    selectedLanguageKey.value = languageKey;

    // Find the corresponding language name from available languages
    try {
      final language = availableLanguages.firstWhere(
        (lang) => lang.code == languageKey,
      );
      selectedLanguageName.value = language.name ?? 'English';
    } catch (e) {
      selectedLanguageName.value = 'English';
    }
  }

  List<Map<String, String>> getLanguageOptions() {
    List<Map<String, String>> options = [];

    for (var language in availableLanguages) {
      options.add({'key': language.code ?? '', 'name': language.name ?? ''});
    }

    return options;
  }

  bool get isLanguageSelected {
    return selectedLanguageKey.value.isNotEmpty;
  }

  // Version checking methods
  Future<bool> isUpdateRequired() async {
    try {
      // Get current app version from AppInfo
      final currentVersion = await AppInfo.getCurrentVersion();

      String? requiredVersion;
      if (GetPlatform.isAndroid) {
        requiredVersion = androidVersion.value;
      } else if (GetPlatform.isIOS) {
        requiredVersion = iosVersion.value;
      }

      if (requiredVersion == null || requiredVersion.isEmpty) {
        print('No required version set, allowing app to continue');
        return false;
      }

      print(
        'Version Check - Current: $currentVersion, Required: $requiredVersion',
      );
      if (currentVersion != requiredVersion) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error checking version: $e");
      return false;
    }
  }

  String getUpdateUrl() {
    if (GetPlatform.isAndroid) {
      return forceUpdatePlaystoreUrl.value.isNotEmpty
          ? forceUpdatePlaystoreUrl.value
          : playstoreUrl.value;
    } else if (GetPlatform.isIOS) {
      return forceUpdateAppstoreUrl.value.isNotEmpty
          ? forceUpdateAppstoreUrl.value
          : appstoreUrl.value;
    }
    return "";
  }

  String getRequiredVersion() {
    if (GetPlatform.isAndroid) {
      return androidVersion.value;
    } else if (GetPlatform.isIOS) {
      return iosVersion.value;
    }
    return "";
  }

  Future<void> saveLoginRequiredStatus(bool? value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('profile_form_login_required', value ?? false);
  }

  Future<void> saveLoginRequiredStatusforsupport(bool? value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('support_login_required', value ?? false);
  }

  Future<void> saveLoginRequiredStatusforinvite(bool? value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('invite_login_required', value ?? false);
  }

  Future<void> saveLoginRequiredStatusforsetting(bool? value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setting_login_required', value ?? false);
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  void increaseTitle() => fontTitleSize.value++;
  void increaseDescription() => fontDescriptionSize.value++;
  void increaseBody() => fontBodySize.value++;

  // Decrease
  void decreaseTitle() {
    if (fontTitleSize.value > 16) fontTitleSize.value--;
  }

  void decreaseDescription() {
    if (fontDescriptionSize.value > 14) fontDescriptionSize.value--;
  }

  void decreaseBody() {
    if (fontBodySize.value > 12) fontBodySize.value--;
  }

  RxInt fontCounter = 1.obs;

  void increaseCounter() {
    if (fontCounter.value < 7) {
      fontCounter.value++;

      fontTitleSize.value++;
      fontDescriptionSize.value++;
      fontBodySize.value++;
    }
  }

  // DECREASE COUNTER AND FONT SIZES
  void decreaseCounter() {
    if (fontCounter.value > 1) {
      fontCounter.value--;
      fontTitleSize.value--;
      fontDescriptionSize.value--;
      fontBodySize.value--;
    }
  }
}
