import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/network.dart';
import '../../models/Participate/participate_list_model.dart';
import '../app_main/App_main_controller.dart';

class ParticipateController extends GetxController {
  // Tab Index
  var selectedTabIndex = 0.obs;
  var currentStatus = "".obs;
  RxString dynamicEndpoint = "".obs;
  RxBool isLoading = false.obs;

  var participateList = <Items>[].obs;
  Rx<GetParticipateListResponseModel?> getParticipateListResponseModel = Rx<GetParticipateListResponseModel?>(null);




  @override
  void onInit() {
    super.onInit();
  }



  // Get current list based on tab
  List<Items> get currentList {
    if (participateList.isEmpty) return [];
    return participateList;
  }

  // Get current loading state
  bool get currentLoading {
    return isLoading.value;
  }

  // Update tab
  void updateTab(int index, String statusValue) {
    selectedTabIndex.value = index;
    currentStatus.value = statusValue;
    fetchParticipateList();
  }


  Future<void> fetchParticipateList({String? endpoint}) async {
    isLoading.value = true;
    participateList.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      String? ukey = prefs.getString('ukey');
      String? token = prefs.getString('auth_token');

      // Get Location
      String lat = '';
      String long = '';
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          ).timeout(const Duration(seconds: 5));
          lat = position.latitude.toString();
          long = position.longitude.toString();
        }
      } catch (e) {
        print("❌ Error getting location for cart: $e");
      }

      final apiService = ApiServices();
      final headers = {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final body = <String, dynamic>{
        if (ukey != null) 'user_key': ukey,
        if (lat.isNotEmpty) 'gps_lat': lat,
        if (long.isNotEmpty) 'gps_long': long,
        // 'status': currentStatus.value,
      };

      var apiEndpoint = endpoint ?? dynamicEndpoint.value;

      var response = await apiService.makeRequestFormData(
        endPoint: apiEndpoint,
        method: 'POST',
        body: body,
        headers: headers,
      );

      if (response != null) {
        getParticipateListResponseModel.value = GetParticipateListResponseModel.fromJson(response);

        if (getParticipateListResponseModel.value?.result != null && getParticipateListResponseModel.value!.result!.items != null) {
          participateList.assignAll(getParticipateListResponseModel.value!.result!.items!);
        } else {
          participateList.clear();
        }
      } else {
        // Handle error or empty response
      }
    } catch (e) {
      print("Error fetching m order list : $e");
      // rethrow; // Optional: handle error gracefully in UI
    } finally {
      isLoading.value = false;
    }
  }
}