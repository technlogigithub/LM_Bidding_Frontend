import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../controller/home/home_controller.dart';
import '../../core/api_config.dart';
import '../../core/app_color.dart';
import '../../core/app_constant.dart';
import '../../core/app_textstyle.dart';
import '../../widget/custom_vertical_listview_list.dart';
import '../client service details/client_service_details.dart';

class RecentlyView extends StatefulWidget {
  const RecentlyView({super.key});

  @override
  State<RecentlyView> createState() => _RecentlyViewState();
}

class _RecentlyViewState extends State<RecentlyView> {
   List<dynamic> notifications = [];
  bool isLoading = true;
   final ClientHomeController controller = Get.put(ClientHomeController());

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }
  Future<void> fetchOrders() async {
    try {
      final res = await  ApiService.getRequest("ordersApi");
      setState(() {
        notifications = res["data"] ?? []; // <-- API response structure ke hisaab se adjust karna
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      toast("Error: $e");
    }
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme:  IconThemeData(color: AppColors.appTextColor,),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appbarColor,
            // borderRadius: const BorderRadius.only(
            //   bottomLeft: Radius.circular(50.0),
            //   bottomRight: Radius.circular(50.0),
            // ),
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        title: Obx(() {
          return Text(
             'Recently Post',
            style:  AppTextStyle.title(
              color: AppColors.appTextColor,
              fontWeight: FontWeight.bold,

            ),
          );
        }),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),
        child:    Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
          child: CustomVerticalListviewList(items: controller.recentViewedList, onFavoriteToggle: controller.toggleFavorite, isLoading: controller.isLoading),
        ),

      ),
    );
  }
}
