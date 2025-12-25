import 'package:get/get.dart';
import '../../models/App_moduls/AppResponseModel.dart';
import '../../models/Post/Get_Post_List_Model.dart';
import '../app_main/App_main_controller.dart';
import '../post/app_post_controller.dart';

import 'package:get/get.dart';

class SearchAndFilterController extends GetxController {
  late final AppPostController appPostController;

  final selectedTabIndex = 0.obs;
  final selectedStatusValue = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // ✅ SAME INSTANCE (NO DUPLICATE CONTROLLER)
    appPostController = Get.find<AppPostController>();

    final appSettings = Get.find<AppSettingsController>();

    /// 🔁 when searchPage loads / updates
    ever(appSettings.searchPage, (_) {
      extractInitialStatus();
      if (selectedStatusValue.value.isNotEmpty) {
        getPostList();
      }
    });

    /// first time load
    extractInitialStatus();
    if (selectedStatusValue.value.isNotEmpty) {
      getPostList();
    }
  }

  /// 🔹 Helper to extract options
  List<CustomOption>? _getOptions() {
    final app = Get.find<AppSettingsController>();
    final searchPage = app.searchPage.value;
    final customTapbar = searchPage?.design?.customTapbar;

    if (customTapbar == null) return null;

    // 1️⃣ Direct options
    if (customTapbar.options != null && customTapbar.options!.isNotEmpty) {
      return customTapbar.options;
    } 
    
    // 2️⃣ Options inside design map
    else if (customTapbar.design is Map<String, dynamic>) {
      final designMap = customTapbar.design as Map<String, dynamic>;
      
      // A) Simple 'options' list in design
      if (designMap['options'] is List) {
        return (designMap['options'] as List)
            .map((e) => CustomOption.fromJson(e))
            .toList();
      }
      
      // B) Complex 'inputs' -> 'select' structure (Same as UI)
      final inputs = designMap['inputs'];
      if (inputs != null && inputs is Map<String, dynamic>) {
        SettingsInput? selectInput;

        // Find select input
        if (inputs.containsKey('select')) {
          final selectData = inputs['select'];
          if (selectData is Map<String, dynamic>) {
            selectInput = SettingsInput.fromJson(selectData);
          }
        } else {
          try {
            final selectEntry = inputs.entries.firstWhere((entry) {
              if (entry.value is Map<String, dynamic>) {
                return entry.value['input_type'] == 'select';
              }
              return false;
            });
            if (selectEntry.value is Map<String, dynamic>) {
              selectInput = SettingsInput.fromJson(selectEntry.value);
            }
          } catch (_) {}
        }

        // Extract options from selectInput
        if (selectInput != null) {
          // optionItems (Object with label, value)
          if (selectInput.optionItems != null && selectInput.optionItems!.isNotEmpty) {
             return selectInput.optionItems!.map((e) {
               return CustomOption(
                 label: e.label, 
                 value: e.value
               );
             }).toList();
          }
          // options (Simple String List)
          else if (selectInput.options != null && selectInput.options!.isNotEmpty) {
            return selectInput.options!.map((e) {
               return CustomOption(
                 label: e, 
                 value: e
               );
            }).toList();
          }
        }
      }
    }
    return null;
  }

  /// 🔹 Initial tab status (first option)
  void extractInitialStatus() {
    final options = _getOptions();
    if (options == null || options.isEmpty) return;

    final status = options.first.value;
    if (status != null && status.isNotEmpty) {
      selectedTabIndex.value = 0;
      selectedStatusValue.value = status;
      appPostController.updateStatus(status);
    }
  }

  /// 🔹 On tab click
  void updateTab(int index) {
    selectedTabIndex.value = index;

    final options = _getOptions();
    if (options == null || index >= options.length) return;

    final status = options[index].value ?? '';
    selectedStatusValue.value = status;

    appPostController.updateStatus(status);

    /// 🔥 no param needed now
    getPostList();
  }

  /// 🔹 Update tab by value string (e.g. from navigation arguments)
  void updateTabByValue(String value) {
    if (value.isEmpty) return;
    
    final options = _getOptions();
    if (options == null || options.isEmpty) return;

    // Try to find index by label or value
    int index = -1;
    
    // Check by value first
    index = options.indexWhere((opt) => opt.value == value);
    
    // If not found, check by label
    if (index == -1) {
       index = options.indexWhere((opt) => opt.label == value);
    }

    if (index != -1) {
      updateTab(index);
    }
  }



  /// 🔹 API call
  Future<void> getPostList() async {
    final searchPage = Get.find<AppSettingsController>().searchPage.value;

    String? endpoint;

    /// 1️⃣ Get options same way as UI
    final options = _getOptions();

    if (options != null && options.isNotEmpty) {
      final selectedOption = options[selectedTabIndex.value];
      endpoint = selectedOption.apiEndpoint;
      print("🔹 Endpoint from TAB OPTION: $endpoint");
    }

    /// 2️⃣ Fallback
    endpoint ??= searchPage?.apiEndpoint;
    print("🔹 Fallback Page Endpoint: $endpoint");

    if (endpoint == null || endpoint.isEmpty) {
      print("❌ ERROR: API endpoint is empty");
      return;
    }

    /// 3️⃣ ALWAYS use controller state
    final status = selectedStatusValue.value;

    print("🟢 FINAL API CALL");
    print("STATUS   : $status");
    print("ENDPOINT : $endpoint");

    appPostController.updatePageName('search_page');

    if (status.isNotEmpty) {
      appPostController.updateStatus(status);
    }

    await appPostController.getPostList(endpoint: endpoint);
  }



  /// 🔹 passthrough getters
  Rx<GetPostListResponseModel?> get response =>
      appPostController.getPostListResponseModel;

  RxBool get isLoading => appPostController.isLoading;
}

