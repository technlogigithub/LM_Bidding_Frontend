import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_constant.dart';
import '../../controller/post/favorite_posts_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../models/App_moduls/AppResponseModel.dart';
import '../../widget/custom_tapbar.dart';
import '../../widget/custom_view_widget.dart';
import '../../widget/custom_navigator.dart'; // Added

class FavoriteScreen extends StatelessWidget {
  final AppMenuItem? menuItem;
  const FavoriteScreen({super.key, this.menuItem});

  @override
  Widget build(BuildContext context) {
    // Get menu item from arguments - handle various formats and protect against null
    final dynamic args = Get.arguments;
    debugPrint("🔎 ARGS RECEIVED: $args");
    
    AppMenuItem? effectiveMenuItem = menuItem;

    if (effectiveMenuItem == null) {
      if (args is AppMenuItem) {
        effectiveMenuItem = args;
      } else if (args is Map) {
        try {
          effectiveMenuItem = AppMenuItem.fromJson(Map<String, dynamic>.from(args));
        } catch (e) {
          debugPrint("⚠️ Error parsing Map to AppMenuItem: $e");
        }
      }
    }
    
    // Set endpoint with aggressive fallback
    String? endpoint = effectiveMenuItem?.nextPageApiEndpoint;
    
    // If MenuItem parsing failed or field is null, check the raw map directly
    if ((endpoint == null || endpoint.isEmpty) && args is Map) {
      final mapArgs = Map<String, dynamic>.from(args);
      endpoint = mapArgs['next_page_api_endpoint']?.toString() ?? 
                 mapArgs['nextPageApiEndpoint']?.toString() ??
                 mapArgs['api_endpoint']?.toString();
    }
    
    // Put or find the controller
    final FavoritePostsController controller = Get.put(FavoritePostsController());

    if (endpoint != null && endpoint.isNotEmpty) {
      controller.dynamicEndpoint.value = endpoint;
      debugPrint("🚀 SUCCESS: Final Endpoint determined: $endpoint");
    } else {
      debugPrint("❌ FAILURE: Could not find endpoint in arguments. Available keys: ${args is Map ? args.keys : 'None'}");
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.appbarColor,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.appTextColor),
          title: Text(
            effectiveMenuItem?.title ?? "Favorite",
            style: AppTextStyle.title(
              color: AppColors.appTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              // Dynamic TabBar based on JSON config
              Builder(builder: (context) {
                final design = effectiveMenuItem?.design;
                final inputs = (design != null && design is Map) ? design['inputs'] : null;
                final select = inputs != null ? inputs['select'] : null;
                
                List<String> tabs = [];
                List<String> values = [];

                if (select != null && select is Map && select['options'] != null) {
                  final options = select['options'] as List;
                  for (var opt in options) {
                    if (opt is Map) {
                      tabs.add(opt['label']?.toString() ?? '');
                      values.add(opt['value']?.toString() ?? '');
                    }
                  }
                }

                // Fallback for tabs if not found in config
                if (tabs.isEmpty) {
                  tabs = ['Posts', 'Categories', 'Users'];
                  values = ['POSTS', 'CATEGORIES', 'USERS'];
                }

                // Auto-initiate fetch for the first tab
                if (!controller.hasInitiatedFetch && values.isNotEmpty) {
                  controller.hasInitiatedFetch = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.updateTab(0, values[0]);
                  });
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: Obx(() => CustomTabBar(
                    initialIndex: controller.selectedTabIndex.value,
                    tabs: tabs,
                    textStyle: AppTextStyle.description(),
                    onTap: (index) {
                      if (index < values.length) {
                        controller.updateTab(index, values[index]);
                      }
                    },
                  )),
                );
              }),
              
              const SizedBox(height: 10),
              
              // Dynamic List based on view type
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value && controller.allFavorites.isEmpty) {
                    return Center(child: CircularProgressIndicator(color: AppColors.appColor,));
                  }
                  
                  if (!controller.isLoading.value && controller.allFavorites.isEmpty) {
                    return Center(
                      child: Text(
                        controller.favoriteResponseModel.value?.message ?? "No favorites found",
                        style: AppTextStyle.description(color: AppColors.appDescriptionColor),
                      ),
                    );
                  }

                  // Use CustomViewWidget for dynamic layout (List/Grid etc)
                  return CustomViewWidget(
                    type: effectiveMenuItem?.nextPageViewType ?? "custom_vertical_listview_list",
                    controller: controller,
                    itemDataList: controller.allFavorites.map((e) => e.toJson()).toList(),
                    onFavoriteToggle: (index, value) => controller.toggleFavorite(index, value),
                    onItemTap: (ukey) {
                       final item = controller.allFavorites.firstWhereOrNull((e) => e.hidden?.ukey == ukey);
                       // Navigate using CustomNavigator with dynamic viewType or fallback
                       CustomNavigator.navigate(item?.hidden?.viewType ?? "post_detail_screen", arguments: ukey);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}