// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import '../../core/app_color.dart';
// import '../../core/app_textstyle.dart';
//
// class ClientAllCategories extends StatefulWidget {
//   const ClientAllCategories({super.key});
//
//   @override
//   State<ClientAllCategories> createState() => _ClientAllCategoriesState();
// }
//
// class _ClientAllCategoriesState extends State<ClientAllCategories> {
//
//   List<String> catName = [
//     'Graphics Design',
//     'Video Editing',
//     'Digital Marketing',
//     'Business',
//     'Writing & Translation',
//     'Programming',
//     'Lifestyle'
//   ];
//   List<String> catIcon = [
//     'images/graphic.png',
//     'images/videoicon.png',
//     'images/dm.png',
//     'images/b.png',
//     'images/t.png',
//     'images/p.png',
//     'images/l.png'
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.appWhite,
//       appBar: AppBar(
//         elevation: 0.0,
//         backgroundColor: AppColors.appWhite,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: AppColors.neutralColor),
//         title: Text(
//           'All Categories',
//           style: AppTextStyle.kTextStyle.copyWith(
//             color: AppColors.neutralColor,
//             fontWeight: FontWeight.bold,
//           ),
//           // style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 15.0),
//         child: Container(
//           padding: const EdgeInsets.only(left: 15.0,right: 15),
//           decoration: BoxDecoration(
//             color: AppColors.appWhite,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30.0),
//               topRight: Radius.circular(30.0),
//             ),
//           ),
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               children: [
//                 const SizedBox(height: 15.0),
//                 ListView.builder(
//                   itemCount: catName.length,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemBuilder: (_,i){
//                   return Container(
//                     margin: const EdgeInsets.only(top: 10.0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.0),
//                       border: Border.all(color: AppColors.kBorderColorTextField),
//                     ),
//                     child: Theme(
//                       data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//                       child: ExpansionTile(
//                         initiallyExpanded: i == 0 ? true : false,
//                         tilePadding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                         childrenPadding: EdgeInsets.zero,
//                         leading: Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             image: DecorationImage(image: AssetImage(catIcon[i]), fit: BoxFit.cover),
//                           ),
//                         ),
//                         title: Text(
//                           catName[i],
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: AppTextStyle.kTextStyle.copyWith(
//                             color: AppColors.neutralColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           // style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Text(
//                           'Related all categories',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: AppTextStyle.kTextStyle.copyWith(
//                             color: AppColors.textgrey,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           // style: kTextStyle.copyWith(color: kLightNeutralColor),
//                         ),
//                         trailing: Icon(
//                           FeatherIcons.chevronDown,
//                           color: AppColors.subTitleColor,
//                         ),
//                         children: [
//                           Column(
//                             children: [
//                               Divider(
//                                 height: 1,
//                                 thickness: 1.0,
//                                 color: AppColors.kBorderColorTextField,
//                               ),
//                             GestureDetector(
//                                      // onTap: () => const SearchPage().launch(context),
//                                 child: ListTile(
//                                   visualDensity: const VisualDensity(vertical: -4),
//                                   contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                                   horizontalTitleGap: 10,
//                                   title: Text(
//                                     'Logo Design',
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: AppTextStyle.kTextStyle.copyWith(
//                                       color: AppColors.subTitleColor,
//                                     ),
//                                     // style: AppTextStyle.kTextStyle.copyWith(
//                         color: AppColors.subTitleColor,
//                       ),
//                                   ),
//                                   trailing: GestureDetector(
//                                      // onTap: () => const SearchPage().launch(context),
//                                     child: Icon(
//                                       FeatherIcons.chevronRight,
//                                       color: AppColors.subTitleColor,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Divider(
//                                 thickness: 1.0,
//                                 color: AppColors.kBorderColorTextField,
//                               ),
//                               ListTile(
//                                 visualDensity: const VisualDensity(vertical: -4),
//                                 contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                                 horizontalTitleGap: 10,
//                                 title: Text(
//                                   'Brand Style Guides',
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: AppTextStyle.kTextStyle.copyWith(
//                                     color: AppColors.subTitleColor,
//                                   ),
//                                   // style: AppTextStyle.kTextStyle.copyWith(
//                         color: AppColors.subTitleColor,
//                       ),
//                                 ),
//                                 trailing: GestureDetector(
//                                    // onTap: () => const SellerNotification().launch(context),
//                                   child: Icon(
//                                     FeatherIcons.chevronRight,
//                                     color: AppColors.subTitleColor,
//                                   ),
//                                 ),
//                               ),
//                               Divider(
//                                 thickness: 1.0,
//                                 color: AppColors.kBorderColorTextField,
//                               ),
//                               ListTile(
//                                 visualDensity: const VisualDensity(vertical: -4),
//                                 contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                                 horizontalTitleGap: 10,
//                                 title: Text(
//                                   'Fonts & Typography',
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: AppTextStyle.kTextStyle.copyWith(
//                                     color: AppColors.subTitleColor,
//                                   ),
//                                 ),
//                                 trailing: GestureDetector(
//                                   // onTap: () => const SellerNotification().launch(context),
//                                   child: Icon(
//                                     FeatherIcons.chevronRight,
//                                     color: AppColors.subTitleColor,
//                                   ),
//                                 ),
//                               ),
//                               Divider(
//                                 thickness: 1.0,
//                                 color: AppColors.kBorderColorTextField,
//                               ),
//                               ListTile(
//                                 visualDensity: const VisualDensity(vertical: -4),
//                                 contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                                 horizontalTitleGap: 10,
//                                 title: Text(
//                                   'Business Cards & Stationery',
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: AppTextStyle.kTextStyle.copyWith(
//                                     color: AppColors.subTitleColor,
//                                   ),
//                                 ),
//                                 trailing: GestureDetector(
//                                   // onTap: () => const SellerNotification().launch(context),
//                                   child: Icon(
//                                     FeatherIcons.chevronRight,
//                                     color: AppColors.subTitleColor,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 15,),
//
//
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../widget/custom_view_widget.dart';

class SelectCategoriesScreen extends StatefulWidget {
  const SelectCategoriesScreen({super.key});

  @override
  State<SelectCategoriesScreen> createState() => _SelectCategoriesScreenState();
}

class _SelectCategoriesScreenState extends State<SelectCategoriesScreen> {
  late final ClientHomeController homeController;
  late final AppSettingsController appSettingcontroller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    homeController = Get.find<ClientHomeController>();
    appSettingcontroller = Get.find<AppSettingsController>();
    
    // Ensure the filtered list is initialized with full list when screen starts
    homeController.filteredCategoryList.assignAll(homeController.categoryList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Future<void> _loadData() async {
  //   // Refresh categories data
  //   await homeController.fetchCategory();
  // }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Access categoryPage through appSettings model
    final categoryPage =
        appSettingcontroller.appSettings.value?.result?.categoryPage;
    var appbarTitle = categoryPage?.title ?? '';
    var viewtype = categoryPage?.viewType ?? '';

    return Scaffold(
      // backgroundColor: AppColors.appWhite,
      appBar: AppBar(
        title: Text(
          appbarTitle,
          style: AppTextStyle.title(color: AppColors.appTextColor),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.appTextColor),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withValues(alpha: 0.2),
            //     spreadRadius: 2,
            //     blurRadius: 6,
            //     offset: Offset(0, 3),
            //   ),
            // ],
            gradient: AppColors.appbarColor,
          ),
        ),
      ),
      // appBar: AppBar(
      //   elevation: 0.0,
      //   backgroundColor: AppColors.appWhite,
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   toolbarHeight: screenHeight * 0.072,
      //   flexibleSpace: Container(
      //     height: screenHeight * 0.072,
      //     width: screenWidth,
      //     padding: const EdgeInsets.symmetric(horizontal: 10),
      //     decoration: BoxDecoration(
      //     // boxShadow: [
      //     //   BoxShadow(
      //     //     color: Colors.black.withValues(alpha: 0.2), // shadow color
      //     //     spreadRadius: 0, // how much the shadow spreads
      //     //     blurRadius: 6,   // blur effect
      //     //     offset: Offset(0, 3), // x, y offset
      //     //   ),
      //     // ],
      //     gradient: AppColors.appbarColor,
      //
      //   ),
      //     child: Row(
      //       children: [
      //         GestureDetector(
      //           onTap: (){
      //             Navigator.pop(context);
      //           },
      //             child: Icon(Icons.arrow_back,color: AppColors.appTextColor,)),
      //         SizedBox(
      //           width: screenWidth - screenWidth * 0.2,
      //           child: Center(
      //             child: Text(
      //               'All Categories',
      //               style: AppTextStyle.kTextStyle.copyWith(
      //                 color: AppColors.appTextColor,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh categories data - shimmer will show automatically via isLoading
            // await _loadData();
          },
          color: AppColors.appButtonColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
              child: Column(
                children: [
                  // Same UI as search bar in custom_mobile_number_textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => homeController.filterCategories(value),
                      style: AppTextStyle.body(color: AppColors.appTitleColor),
                      decoration: InputDecoration(
                        hintText: 'Search categories...',
                        hintStyle: AppTextStyle.description(
                            color: AppColors.appDescriptionColor),
                        prefixIcon:
                            Icon(Icons.search, color: AppColors.appDescriptionColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.appBodyTextColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.appBodyTextColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.appColor),
                        ),
                        fillColor: Colors.transparent,
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Use CustomViewWidget with viewType from categoryPage or default to "category_vertical_list_widget"
                  CustomViewWidget(
                    type: viewtype.isNotEmpty
                        ? viewtype
                        : 'category_vertical_list_widget',
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
