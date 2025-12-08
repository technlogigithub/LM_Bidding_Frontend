import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../models/App_moduls/AppResponseModel.dart';

class SettingsController extends GetxController {
  Rx<SettingsMenuItem?> settings = Rx(null);

  // toggle values - using RxMap for reactivity
  RxMap<String, bool> toggleValues = <String, bool>{}.obs;

  // language text
  String selectedLanguage = "English";

  void openPage(SettingsLink link) {
    // custom html viewer push
  }
}
