import 'package:get/get.dart';

import '../../models/static models/participation_order.dart';

class ParticipateController extends GetxController {
  // Tab Index
  var selectedTabIndex = 0.obs;

  // Loading States
  var isLoadingActive = true.obs;
  var isLoadingPending = true.obs;
  var isLoadingCompleted = true.obs;
  var isLoadingCancelled = true.obs;

  // Lists
  var activeOrders = <ParticipationOrder>[].obs;
  var pendingOrders = <ParticipationOrder>[].obs;
  var completedOrders = <ParticipationOrder>[].obs;
  var cancelledOrders = <ParticipationOrder>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStaticData();
  }

  void loadStaticData() {
    // Simulate API delay
    Future.delayed(const Duration(seconds: 2), () {
      // Active Orders
      activeOrders.assignAll([
        ParticipationOrder(
          orderId: 'F025E15',
          sellerName: 'Shaidul Islam',
          orderDate: '24 Jun 2023',
          title: 'Mobile UI UX design or app UI UX design',
          duration: '3 Days',
          amount: '5.00',
          status: 'Active',
          countdownDuration: const Duration(days: 2, hours: 10),
        ),
        ParticipationOrder(
          orderId: 'F025E16',
          sellerName: 'Rahim Khan',
          orderDate: '22 Jun 2023',
          title: 'Logo Design for Tech Startup',
          duration: '5 Days',
          amount: '15.00',
          status: 'Active',
          countdownDuration: const Duration(days: 4, hours: 5),
        ),
      ]);

      // Pending Orders
      pendingOrders.assignAll([
        ParticipationOrder(
          orderId: 'F025E17',
          sellerName: 'Karim Ahmed',
          orderDate: '20 Jun 2023',
          title: 'Website Development',
          duration: '7 Days',
          amount: '50.00',
          status: 'Pending',
          countdownDuration: const Duration(days: 6, hours: 12),
        ),
      ]);

      // Completed Orders
      completedOrders.assignAll([
        ParticipationOrder(
          orderId: 'F025E18',
          sellerName: 'John Doe',
          orderDate: '15 May 2023',
          title: 'E-commerce App UI',
          duration: '10 Days',
          amount: '100.00',
          status: 'Completed',
          countdownDuration: Duration.zero,
        ),
      ]);

      // Cancelled Orders
      cancelledOrders.assignAll([
        ParticipationOrder(
          orderId: 'F025E19',
          sellerName: 'Mike Johnson',
          orderDate: '10 May 2023',
          title: 'Social Media Banner',
          duration: '2 Days',
          amount: '8.00',
          status: 'Cancelled',
          countdownDuration: Duration.zero,
        ),
      ]);

      // Turn off loading
      isLoadingActive.value = false;
      isLoadingPending.value = false;
      isLoadingCompleted.value = false;
      isLoadingCancelled.value = false;
    });
  }

  // Get current list based on tab
  List<ParticipationOrder> get currentList {
    switch (selectedTabIndex.value) {
      case 0:
        return activeOrders;
      case 1:
        return pendingOrders;
      case 2:
        return completedOrders;
      case 3:
        return cancelledOrders;
      default:
        return activeOrders;
    }
  }

  // Get current loading state
  bool get currentLoading {
    switch (selectedTabIndex.value) {
      case 0:
        return isLoadingActive.value;
      case 1:
        return isLoadingPending.value;
      case 2:
        return isLoadingCompleted.value;
      case 3:
        return isLoadingCancelled.value;
      default:
        return true;
    }
  }

  // Update tab
  void updateTab(int index) {
    selectedTabIndex.value = index;
  }
}