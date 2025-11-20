import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:libdding/core/app_constant.dart';
import 'package:libdding/view/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_config.dart';
import '../../core/utils.dart';
import '../../models/home/banner_response_model.dart';
import '../../models/home/category_response_model.dart';
import '../../models/static models/service_items_model.dart';
import '../../widget/form_widgets/location_picker.dart';
import '../../service/razorpay_service.dart';

class ClientHomeController extends GetxController {
  static ClientHomeController get to => Get.find();

  // Reactive variables
  var isFavorite = false.obs;
  var isLoggedIn = false.obs;
  var isLoading = true.obs;
  var showShimmer = true.obs;

  var categoryList = <CategoryResult>[].obs;
  var bannerList = <BannerResult>[].obs;
  var livePostList = <dynamic>[].obs;
  var notifications = <dynamic>[].obs;
  var currentLocation = ''.obs;
  var currentLatLng = const LatLng(0, 0).obs;

  var services = <ServiceItem>[].obs;
  var recentViewedList = <ServiceItem>[].obs;

  // Razorpay service
  final RazorpayService razorpayService = RazorpayService();

  void toggleFavorite(int index, bool newValue) {
    if (isLoggedIn.value) {
      services[index].isFavorite.value = newValue;
    } else {
      Get.offAll(LoginScreen());
    }
  }

  // Static media data
  final List<Map<String, dynamic>> staticMediaItems = [
    {
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'type': 'video',
      'redirectUrl': null,
    },
    {
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'type': 'video',
      'redirectUrl': null,
    },
    {
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      'type': 'video',
      'redirectUrl': null,
    },
    {
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
      'type': 'video',
      'redirectUrl': null,
    },
    {
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
      'type': 'video',
      'redirectUrl': null,
    },
    {
      'url': 'https://picsum.photos/800/600?random=1',
      'type': 'image',
      'redirectUrl': 'https://example.com/redirect1',
    },
    {
      'url': 'https://picsum.photos/800/600?random=2',
      'type': 'image',
      'redirectUrl': 'https://example.com/redirect2',
    },
    {
      'url': 'https://picsum.photos/800/600?random=3',
      'type': 'image',
      'redirectUrl': 'https://example.com/redirect3',
    },
    {
      'url': 'https://picsum.photos/800/600?random=4',
      'type': 'image',
      'redirectUrl': 'https://example.com/redirect4',
    },
  ];

  final List<String> serviceList = [
    'All',
    'Logo Design',
    'Brand Style Guide',
    'Fonts & Typography',
  ];

  @override
  void onInit() {
    super.onInit();
    razorpayService.initRazorpay();
    print(" hello");
    services.assignAll(
        [
      ServiceItem(
        imagePath: 'assets/images/shot1.png',
        title: 'Mobile UI/UX Design or App Design',
        rating: 5.0,
        reviewCount: 520,
        price: 30,
        profileImagePath: 'assets/images/profilepic2.png',
        sellerName: 'William Liam',
        sellerLevel: 'Seller Level - 1',
        isFavorite: true,
      ),
      ServiceItem(
        imagePath: 'assets/images/shot1.png',
        title: 'Mobile UI/UX Design or App Design',
        rating: 5.0,
        reviewCount: 520,
        price: 30,
        profileImagePath: 'assets/images/profilepic2.png',
        sellerName: 'William Liam',
        sellerLevel: 'Seller Level - 1',
        isFavorite: true,
      ),
      ServiceItem(
        imagePath: 'assets/images/shot1.png',
        title: 'Website Design and Development',
        rating: 4.8,
        reviewCount: 320,
        price: 45,
        profileImagePath: 'assets/images/profilepic2.png',
        sellerName: 'Sarah Smith',
        sellerLevel: 'Seller Level - 2',
        isFavorite: true,
      ),
      ServiceItem(
        imagePath: 'assets/images/shot1.png',
        title: 'Website Design and Development',
        rating: 4.8,
        reviewCount: 320,
        price: 45,
        profileImagePath: 'assets/images/profilepic2.png',
        sellerName: 'Sarah Smith',
        sellerLevel: 'Seller Level - 2',
        isFavorite: true,
      ),
    ]);
    recentViewedList.assignAll([
      ServiceItem(
        imagePath: 'assets/images/shot5.png',
        title: 'modern unique business logo design',
        rating: 5.0,
        reviewCount: 520,
        price: 30,
        profileImagePath: 'assets/images/profilepic2.png',
        sellerName: 'William Liam',
        sellerLevel: 'Seller Level - 1',
        isFavorite: true,
      ),
      ServiceItem(
        imagePath: 'assets/images/shot5.png',
        title: 'Website Design and Development',
        rating: 4.8,
        reviewCount: 320,
        price: 45,
        profileImagePath: 'assets/images/profilepic2.png',
        sellerName: 'Sarah Smith',
        sellerLevel: 'Seller Level - 2',
        isFavorite: true,
      ),
    ]);
    // initializeData();
    _loadSavedLocation();
    checkLoginStatus();
    initializeData();
  }

  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('currentLocation');
    final savedLat = prefs.getDouble('currentLat');
    final savedLng = prefs.getDouble('currentLng');
    if (savedAddress != null && savedLat != null && savedLng != null) {
      currentLocation.value = savedAddress;
      currentLatLng.value = LatLng(savedLat, savedLng);
    } else {
      _getCurrentLocation(); // Fetch current location if no saved location
    }

  }

  Future<void> _saveLocation(String address, LatLng latLng) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentLocation', address);
    await prefs.setDouble('currentLat', latLng.latitude);
    await prefs.setDouble('currentLng', latLng.longitude);
  }

  Future<void> getCurrentLocation() async {
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          currentLocation.value = 'Location permission denied';
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        currentLocation.value = 'Location permission permanently denied';
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLatLng.value = LatLng(position.latitude, position.longitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      String fullAddress = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country,
      ].where((e) => e != null && e.isNotEmpty).join(', ');
      currentLocation.value = fullAddress.isNotEmpty ? fullAddress : 'Unable to fetch location';
      await _saveLocation(currentLocation.value, currentLatLng.value); // Save location
    } catch (e) {
      print('Error fetching location: $e');
      currentLocation.value = 'Unable to fetch location';
      Utils.showSnackbar(isSuccess: false, title: 'Error', message: 'Failed to fetch location: $e');

    }
  }

  void updateLocation(LatLng latLng, String address) {
    currentLatLng.value = latLng;
    currentLocation.value = address;
    _saveLocation(address, latLng);
  }

  void changeLocation() {
    Get.to(() => LocationPickerScreen(
      initialLat: currentLatLng.value.latitude,
      initialLng: currentLatLng.value.longitude,
    ));
  }
  Future<void> initializeData() async {
    print("Initializing home data...");
    isLoading.value = true;
      fetchCategory();
      fetchBanner();
    isLoading.value = false; // Stop loading
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> fetchCategory() async {
    try {
      isLoading.value = true; // Set loading to true
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final headers = token != null
          ? {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }
          : null;

      print('============================');
      print('📤 API REQUEST => POST /category');
      print('Headers: $headers');
      print('Body: {}');
      print('============================');

      final res = await ApiService.postRequest(AppConstants.category, {}, headers: headers);

      print('============================');
      print('📥 API RESPONSE => /category');
      print(res);
      print('============================');

      final categoryModel = CategoryModel.fromJson(res);
      categoryList.assignAll(categoryModel.result ?? []);

      // Ensure asset images are correctly assigned (modify based on your API response)
      categoryList.forEach((category) {
        // Example: If API returns image names, map them to asset paths
        if (category.image != null && category.image!.isNotEmpty) {
          category.image = 'assets/images/${category.image}'; // Adjust path as needed
        }
      });

      print('✅ Parsed CategoryModel:');
      print('Total Categories: ${categoryModel.result?.length ?? 0}');
      print('----------------------------');
    } catch (e, stack) {
      print('❌ Error fetching categories: $e');
      print(stack);
      Utils.showSnackbar(isSuccess: false, title: 'Error', message: 'Failed to load categories: $e');

    } finally {
      isLoading.value = false; // Set loading to false
    }
  }



  Future<void> fetchBanner() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      print('Home side Token : $token');

      final headers = token != null
          ? {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }
          : null;

      // Log request details
      print('============================');
      print('📤 Sending GET Request: banner');
      print('Headers: $headers');
      print('============================');

      final res = await ApiService.getRequest(AppConstants.banner, headers: headers);

      // Log raw API response
      print('============================');
      print('📥 Response from banner API:');
      print(res);
      print('============================');

      final bannerModel = BannerModel.fromJson(res);
      bannerList.assignAll(bannerModel.result ?? []);

      // Print parsed banners
      print('Parsed Banners:');
      for (var b in bannerList) {
        print(b.toJson());
      }
    } catch (e) {
      print('❌ Error fetching banners: $e');
      Utils.showSnackbar(isSuccess: false, title: 'Error', message: 'Failed to load banners: $e');

    }
  }


  Future<void> livePost() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final headers = token != null
          ? {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }  : null;
      final res = await ApiService.getRequest("get-post",headers: headers);
      livePostList.assignAll(res["data"] ?? []);
      // Print live posts data
      print('Live Posts API response:');
      for (var post in livePostList) {
        print(post);
      }
    } catch (e) {
      Utils.showSnackbar(isSuccess: false, title: 'Error', message: 'Failed to load live posts: $e');
    }
  }

  void handleRestrictedFeature(VoidCallback onLoggedIn) {
    print('Checking value ${isLoggedIn.value}');
    if (isLoggedIn.value) {
      onLoggedIn();
    } else {
      Get.offAll(LoginScreen()); // Replace with actual login route
    }
  }

  // Static payment method for demo
  void initiatePayment() {
    // Static bill amount for demo
    const double staticAmount = 1000.0;
    
    razorpayService.openCheckout(
      amount: staticAmount,
      name: 'Libdding',
      description: 'Payment for services',
      prefillEmail: 'demo@libdding.com',
      prefillContact: '9999999999',
    );
  }

  @override
  void onClose() {
    razorpayService.dispose();
    super.onClose();
  }

}

class Service {
  final String title;
  final String image;
  final double rating;
  final int reviews;
  final int price;
  bool isFavorite;

  Service({
    required this.title,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.price,
    this.isFavorite = false,
  });
}

List<Service> services = [
  Service(
      title: 'Mobile UI UX design or app design',
      image: 'images/shot1.png',
      rating: 5.0,
      reviews: 520,
      price: 30),
  Service(
      title: 'Web Design & Development',
      image: 'images/shot2.png',
      rating: 4.8,
      reviews: 310,
      price: 50),
  Service(
      title: 'Logo Design Premium',
      image: 'images/shot1.png',
      rating: 4.9,
      reviews: 410,
      price: 25),
  Service(
      title: 'Fonts & Typography Pack',
      image: 'images/shot2.png',
      rating: 4.7,
      reviews: 200,
      price: 15),
];
