import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/home/home_controller.dart';
import '../../controller/post/app_post_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../widget/custom_vertical_listview_list.dart';
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final ClientHomeController controller = Get.put(ClientHomeController());
  final AppPostController appPostController = Get.find<AppPostController>();
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
            'Favorite',
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
          child: CustomVerticalListviewList(
            model: appPostController.getPostListResponseModel,
            onFavoriteToggle: (index, newValue) {
              // Update favorite in the model
              final result =
                  appPostController.getPostListResponseModel.value?.result;
              if (result != null && index < result.length) {
                if (result[index].info != null) {
                  result[index].info!['favorite'] = newValue;
                  appPostController.getPostListResponseModel.refresh();
                }
              }
            },
            isLoading: appPostController.isLoading,
          )
        ),

      ),
    );
  }
}
