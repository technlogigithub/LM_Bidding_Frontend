import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../models/App_moduls/AppResponseModel.dart';
import '../../models/Post/Get_Post_List_Model.dart';
import '../app_main/App_main_controller.dart';
import 'app_post_controller.dart';

class MyPostController extends GetxController {
  // Get AppPostController instance
  late final AppPostController appPostController;

  // Tab Index
  var selectedTabIndex = 0.obs;

  // tab ke status value store karega (for backward compatibility)
  var selectedStatusValue = ''.obs;

  // Lists
  // var activeOrders = <ParticipationOrder>[].obs;
  // var pendingOrders = <ParticipationOrder>[].obs;
  // var completedOrders = <ParticipationOrder>[].obs;
  // var cancelledOrders = <ParticipationOrder>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize AppPostController
    appPostController = Get.put(AppPostController());
    
    // Listen to AppPostController's loading state
    ever(appPostController.isLoading, (isLoading) {
      // Sync loading state if needed
    });
    
    // Listen to AppPostController's response model
    ever(appPostController.getPostListResponseModel, (model) {
      // Sync response model if needed
    });
    
    extractStatusValue(); // ⬅️ Extract initial status value
    // getPostList(); // ⬅️ Call API with initial status value
  }

  void extractStatusValue() {
    final app = Get.find<AppSettingsController>();
    final model = app.myPostModel.value;

    // Check if design is a Map (it might be a List or null)
    if (model?.design == null || model!.design is! Map) return;

    // Parse design into SettingsDesign
    final SettingsDesign? design = SettingsDesign.fromJson(model.design);

    if (design?.inputs == null) return;

    SettingsInput? selectInput;

    // find select input
    if (design!.inputs!.containsKey('select')) {
      selectInput = design.inputs!['select'];
    } else {
      try {
        selectInput = design.inputs!.values.firstWhere(
          (e) => e.inputType == "select",
        );
      } catch (e) {
        return;
      }
    }

    String? statusValue;

    // optionItems → label + value case
    if (selectInput?.optionItems != null &&
        selectInput!.optionItems!.isNotEmpty) {
      statusValue = selectInput.optionItems!.first.value ?? "";
    } else if (selectInput?.options != null && selectInput!.options!.isNotEmpty) {
      // simple options array
      statusValue = selectInput.options!.first;
    }

    // Update both local and AppPostController status
    if (statusValue != null && statusValue.isNotEmpty) {
      selectedStatusValue.value = statusValue;
      appPostController.updateStatus(statusValue);
    }
  }

  // Get current list based on tab
  // List<ParticipationOrder> get currentList {
  //   switch (selectedTabIndex.value) {
  //     case 0:
  //       return activeOrders;
  //     case 1:
  //       return pendingOrders;
  //     case 2:
  //       return completedOrders;
  //     case 3:
  //       return cancelledOrders;
  //     default:
  //       return activeOrders;
  //   }
  // }

  // Get current loading state from AppPostController
  bool get currentLoading {
    return appPostController.isLoading.value;
  }

  // Get response model from AppPostController
  Rx<GetPostListResponseModel?> get getPostListResponseModel {
    return appPostController.getPostListResponseModel;
  }

  // Get isLoading from AppPostController
  RxBool get isLoading {
    return appPostController.isLoading;
  }

  // Update tab and fetch posts for selected status
  void updateTab(int index) {
    selectedTabIndex.value = index;

    // Extract status value for the selected tab
    final app = Get.find<AppSettingsController>();
    final model = app.myPostModel.value;

    // Check if design is a Map
    if (model?.design == null || model!.design is! Map) return;
    
    // Parse design
    final SettingsDesign? design = SettingsDesign.fromJson(model.design);

    if (design?.inputs == null) return;

    SettingsInput? selectInput;

    // Find select input
    if (design!.inputs!.containsKey('select')) {
      selectInput = design.inputs!['select'];
    } else {
      try {
        selectInput = design.inputs!.values.firstWhere(
          (e) => e.inputType == "select",
        );
      } catch (e) {
        return;
      }
    }

    // Get status value for selected tab index
    String? statusValue;

    // optionItems → label + value case
    if (selectInput?.optionItems != null &&
        selectInput!.optionItems!.isNotEmpty) {
      if (index < selectInput.optionItems!.length) {
        statusValue = selectInput.optionItems![index].value;
      }
    } else if (selectInput?.options != null &&
        selectInput!.options!.isNotEmpty) {
      // simple options array
      if (index < selectInput.options!.length) {
        statusValue = selectInput.options![index];
      }
    }

    // Update status in both local and AppPostController, then call API
    if (statusValue != null && statusValue.isNotEmpty) {
      selectedStatusValue.value = statusValue;
      appPostController.updateStatus(statusValue); // Store in AppPostController
      getPostList(); // Call API with new status value
    }
  }

  var dynamicEndpoint = ''.obs;

  // Use AppPostController to make API call
  Future<void> getPostList() async {
    // Get myPostModel to extract endpoint and page_name
    final app = Get.find<AppSettingsController>();
    final myPostModel = app.myPostModel.value;
    
    // Get endpoint from myPostModel
    final endpoint = dynamicEndpoint.value.isNotEmpty
        ? dynamicEndpoint.value
        : myPostModel?.apiEndpoint;
    
    // Get page_name from myPostModel
    // final pageName = myPostModel?.pageName;
    
    // Update page_name in AppPostController if available
    // if (pageName != null && pageName.isNotEmpty) {
    //   appPostController.updatePageName(pageName);
    // }
    
    // Ensure status is updated in AppPostController
    if (selectedStatusValue.value.isNotEmpty) {
      appPostController.updateStatus(selectedStatusValue.value);
    }
    
    // Call API using AppPostController with dynamic endpoint
    await appPostController.getPostList(endpoint: endpoint);
  }
}
