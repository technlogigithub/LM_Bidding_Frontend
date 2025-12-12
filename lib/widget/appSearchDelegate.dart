import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/widget/form_widgets/app_textfield.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controller/app_main/App_main_controller.dart';
import '../controller/home/search_controller.dart';
import '../controller/post/My_Post_controller.dart';
import '../core/app_color.dart';
import '../models/App_moduls/AppResponseModel.dart';
import '../view/profile_screens/My Posts/Post_Details_screen.dart';
import 'my_post_list_custom.dart';


class CustomSearchDelegate extends SearchDelegate {
  List<String> searchItems = [
    'UI UX Designer',
    'Logo designer',
    'App developer',
    'Designer',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: IconButton(
          onPressed: () {
            query = '';
          },
          icon:  Icon(Icons.clear, color: AppColors.appIconColor),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      color: AppColors.appTextColor,
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back, color: AppColors.appIconColor),
    );
  }


  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = searchItems
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      decoration: BoxDecoration(
        gradient:AppColors.appPagecolor
      ),
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(
              matchQuery[i],
              style: AppTextStyle.description(
                color: AppColors.appDescriptionColor,
              ),
            ),
          );
        },
      ),
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = searchItems
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.appPagecolor
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: matchQuery.length,
        itemBuilder: (_, i) {
          return Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Text(
                  matchQuery[i],
                  style: AppTextStyle.description(
                      color: AppColors.appDescriptionColor),
                ),
              ),
              const Spacer(),
              Icon(Icons.clear, color: AppColors.appIconColor),
            ],
          );
        },
      ),
    );
  }

}


// class CustomSearchDelegate extends StatelessWidget {
//   const CustomSearchDelegate({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final SearchForPostsController controller = Get.put(SearchForPostsController());
//     final AppSettingsController appSettingcontroller = Get.put(
//       AppSettingsController(),
//     );
//
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     // Extract tab labels from myPostModel design inputs select options
//     // Returns null if no valid labels found, otherwise returns list of labels
//     List<String>? getTabLabels(MyPostModel? myPostModel) {
//       if (myPostModel?.design?.inputs != null) {
//         // Try to find select input - check for key "select" or any input with inputType "select"
//         SettingsInput? selectInput;
//
//         // First try to find by key "select"
//         if (myPostModel!.design!.inputs!.containsKey('select')) {
//           selectInput = myPostModel.design!.inputs!['select'];
//         } else {
//           // Try to find any input with inputType "select"
//           try {
//             selectInput = myPostModel.design!.inputs!.values.firstWhere(
//                   (input) => input.inputType == 'select',
//             );
//           } catch (e) {
//             // No select input found
//             selectInput = null;
//           }
//         }
//
//         if (selectInput != null) {
//           // Get labels from optionItems
//           if (selectInput.optionItems != null &&
//               selectInput.optionItems!.isNotEmpty) {
//             final labels = selectInput.optionItems!
//                 .map((e) => e.label ?? '')
//                 .where((label) => label.isNotEmpty)
//                 .toList();
//             // Return labels only if not empty
//             if (labels.isNotEmpty) {
//               return labels;
//             }
//           }
//           // Fallback to simple options list
//           if (selectInput.options != null && selectInput.options!.isNotEmpty) {
//             return selectInput.options!;
//           }
//         }
//       }
//       // Return null when no valid labels found
//       return null;
//     }
//
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           automaticallyImplyLeading: true,
//           flexibleSpace: Container(
//             decoration: BoxDecoration(gradient: AppColors.appbarColor),
//           ),
//           centerTitle: true,
//           iconTheme: IconThemeData(color: AppColors.appTextColor),
//           title: Obx(() {
//             var myPostModel = appSettingcontroller.myPostModel.value;
//             return Text(
//               "Search Posts",
//               style: AppTextStyle.title(
//                 color: AppColors.appTextColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             );
//           }),
//         ),
//         body: Container(
//           height: double.infinity,
//           width: double.infinity,
//           decoration: BoxDecoration(gradient: AppColors.appPagecolor),
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: screenHeight * 0.020),
//                 CustomTextfield(label: "Search", hintText: " Search Post",controller: controller.searchController),
//                 SizedBox(height: screenHeight * 0.010),
//                 Obx(
//                       () => MypostListCustomWidget(
//                     model: controller.getPostListResponseModel,
//                     statusValue: "",
//                     isLoading: controller.isLoading,
//                     onItemTap: () {
//                       const PostDetailsScreen().launch(context);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

