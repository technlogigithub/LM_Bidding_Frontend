import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkInitialConnection();
    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  Future<void> checkInitialConnection() async {
    try {
      List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      print("Connectivity check failed: $e");
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      isConnected.value = false;
    } else {
      isConnected.value = true;
    }
  }
}
