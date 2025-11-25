import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import '../../controller/bottom/bottom_bar_controller.dart';
import '../Home_screen/Home_screen.dart';
import '../Participate_screens/participate_screen.dart';
import '../Post_new_screen/Post_new_screen.dart';
import '../profile_screens/profile_screen.dart';
import '../seller screen/seller messgae/chat_list.dart';

class BottomNavigationScreen extends StatelessWidget {
   const BottomNavigationScreen({super.key});

   static final List<Widget> _widgetOptions = <Widget>[
     ClientHomeScreen(),
     const ChatScreen(),
     const PostNewScreen(),
     const ParticipateScreen(),
     ProfileScreen(),
   ];

   @override
   Widget build(BuildContext context) {
     final controller = Get.put(BottomBarController());
     bool isWeb = kIsWeb || MediaQuery.of(context).size.width > 600;

     return Obx(() => Scaffold(

       appBar: isWeb
           ? AppBar(
         elevation: 0,
         // backgroundColor: AppColors.appWhite,
         title: Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: List.generate(
             controller.navItems.length,
                 (index) => InkWell(
               onTap: () => controller.onItemTapped(index),
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Icon(
                     (controller.navItems[index]["icon"] == "home")
                         ? IconlyBold.home
                         : controller.navItems[index]["icon"] == "chat"
                         ? IconlyBold.chat
                         : controller.navItems[index]["icon"] ==
                         "post"
                         ? IconlyBold.paperPlus
                         : controller.navItems[index]
                     ["icon"] ==
                         "doc"
                         ? IconlyBold.document
                         : IconlyBold.profile,
                     color: controller.currentPage.value == index
                         ? AppColors.appColor
                         : AppColors.textgrey,
                   ),
                   Text(
                     controller.navItems[index]["label"],
                     style: TextStyle(
                       color: controller.currentPage.value == index
                           ? AppColors.appColor
                           : AppColors.textgrey,
                       fontSize: 12,
                     ),
                   )
                 ],
               ),
             ),
           ),
         ),
       )
           : null,
       body: _widgetOptions[controller.currentPage.value],
       bottomNavigationBar: isWeb
           ? null
           : Container(
         padding: const EdgeInsets.all(8.0),
         decoration: BoxDecoration(
           gradient: AppColors.appPagecolor, // <-- Gradient instead of color
           // borderRadius: const BorderRadius.only(
           //   topRight: Radius.circular(30.0),
           //   topLeft: Radius.circular(30.0),
           // ),
           // boxShadow: [
           //   BoxShadow(
           //     color: AppColors.darkWhite,
           //     blurRadius: 5.0,
           //     spreadRadius: 3.0,
           //     offset: Offset(0, -2),
           //   )
           // ],
         ),

         child:Container(
           decoration: BoxDecoration(
             gradient: AppColors.appPagecolor, // <-- your dynamic gradient
           ),
           child: BottomNavigationBar(
             elevation: 0.0,
             backgroundColor: Colors.transparent, // <-- IMPORTANT
             selectedItemColor: AppColors.appButtonColor,
             unselectedItemColor: AppColors.appIconColor,
             showUnselectedLabels: true,
             type: BottomNavigationBarType.fixed,
             currentIndex: controller.currentPage.value,
             onTap: controller.onItemTapped,
             items: const [
               BottomNavigationBarItem(
                 icon: Icon(IconlyBold.home),
                 label: "Home",
               ),
               BottomNavigationBarItem(
                 icon: Icon(IconlyBold.chat),
                 label: "Message",
               ),
               BottomNavigationBarItem(
                 icon: Icon(IconlyBold.paperPlus),
                 label: "Post Now",
               ),
               BottomNavigationBarItem(
                 icon: Icon(IconlyBold.document),
                 label: "Participate",
               ),
               BottomNavigationBarItem(
                 icon: Icon(IconlyBold.profile),
                 label: "Profile",
               ),
             ],
           ),
         )

       ),
     ));
   }
}
