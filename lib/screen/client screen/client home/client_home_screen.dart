// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
// import 'package:freelancer/screen/app_config/api_config.dart';
// import 'package:freelancer/screen/client%20screen/client%20home/popular_services.dart';
// import 'package:freelancer/screen/client%20screen/client%20home/recently_view.dart';
// import 'package:freelancer/screen/client%20screen/client%20home/top_seller.dart';
// import 'package:freelancer/screen/client%20screen/client%20recent%20post/client_recent_post.dart';
// import 'package:freelancer/screen/client%20screen/client_authentication/client_log_in.dart';
// import 'package:nb_utils/nb_utils.dart';
// import '../../widgets/constant.dart';
// import '../client notification/client_notification.dart';
// import '../client service details/client_service_details.dart';
// import '../search/search.dart';
// import 'client_all_categories.dart';

// class ClientHomeScreen extends StatefulWidget {
//   const ClientHomeScreen({super.key});

//   @override
//   State<ClientHomeScreen> createState() => _ClientHomeScreenState();
// }

// class _ClientHomeScreenState extends State<ClientHomeScreen> {
//   bool isFavorite = false;
//   bool isLoggedIn = false; 

//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus(); 
//     fetchOrders();
//     livePost();
//     fetchCategory();
//   }

//   Future<void> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       isLoggedIn = prefs.getBool('isLoggedIn') ?? false; 
//     });
//   }

//   void _handleRestrictedFeature(VoidCallback onLoggedIn) {
//     if (isLoggedIn) {
//       onLoggedIn(); 
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const ClientLogIn()),
//       );
//     }
//   }
//  List<dynamic> notifications = [];
//  List<dynamic> categoryList = [];
//  List<dynamic> livePostList = [];
//   bool isLoading = true;

 
//   Future<void> fetchOrders() async {
//     try {
//       final res = await  ApiService.getRequest("notification");
//       setState(() {
//         notifications = res["data"] ?? []; 
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       toast("Error: $e");
//     }
  
//   }
//   Future<void> fetchCategory() async {
//     try {
//       final res = await  ApiService.getRequest("category");
//       setState(() {
//         categoryList = res["data"] ?? []; 
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       toast("Error: $e");
//     }
  
//   }

//    Future<void> livePost() async {
//     try {
//       final res = await  ApiService.getRequest("get-post");
//       setState(() {
//         livePostList = res["data"] ?? []; 
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       toast("Error: $e");
//     }
  
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: kDarkWhite,
//       appBar: AppBar(
//   backgroundColor: kDarkWhite,
//   elevation: 0,
//   automaticallyImplyLeading: false,
//   title: Padding(
//     padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
//     child: Row(
//       children: [
//         // Leading: Profile Image
//         GestureDetector(
//           onTap: () => _handleRestrictedFeature(() {
//             const ClientLogIn().launch(context);
//           }),
//           child: Container(
//             height: 44,
//             width: 44,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               image: DecorationImage(
//                 image: AssetImage('images/profile3.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),

//         const SizedBox(width: 12),

//         // Title + Subtitle
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 isLoggedIn ? 'Shaidulislam' : 'Guest',
//                 style: kTextStyle.copyWith(
//                     color: kNeutralColor, fontWeight: FontWeight.bold,fontSize: 16),
//               ),
//               Text(
//                 isLoggedIn ? 'I’m a Client' : 'Please log in',
//                 style: kTextStyle.copyWith(color: kLightNeutralColor,fontSize: 14),
//               ),
//             ],
//           ),
//         ),

//         // Trailing Icons
//         Row(
//           children: [
//             GestureDetector(
//               onTap: () => _handleRestrictedFeature(() {
//                 const ClientNotification().launch(context);
//               }),
//               child: Container(
//                 padding: const EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: kPrimaryColor.withOpacity(0.2),
//                   ),
//                 ),
//                 child: const Icon(
//                   IconlyLight.notification,
//                   color: kNeutralColor,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 6),
//             GestureDetector(
//               onTap: () {
//                 const ClientRecentPost().launch(context);
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: kPrimaryColor.withOpacity(0.2),
//                   ),
//                 ),
//                 child: const Icon(
//                   IconlyLight.infoSquare,
//                   color: kNeutralColor,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   ),
// ),

//         body: Padding(
//           padding: const EdgeInsets.only(top: 15.0),
//           child: Container(
//             width: context.width(),
//             decoration: const BoxDecoration(
//               color: kWhite,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(30.0),
//                 topRight: Radius.circular(30.0),
//               ),
//             ),
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: kDarkWhite,
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       child: ListTile(
//                         horizontalTitleGap: 0,
//                         visualDensity: const VisualDensity(vertical: -2),
//                         leading: const Icon(
//                           FeatherIcons.search,
//                           color: kNeutralColor,
//                         ),
//                         title: Text(
//                           'Search services...',
//                           style: kTextStyle.copyWith(color: kSubTitleColor),
//                         ),
//                         onTap: () {
//                           showSearch(
//                             context: context,
//                             delegate: CustomSearchDelegate(),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                   HorizontalList(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.only(left: 15),
//                     spacing: 10.0,
//                     itemCount: 10,
//                     itemBuilder: (_, i) {
//                       return Container(
//                         height: 140,
//                         width: 304,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8.0),
//                           image: const DecorationImage(
//                               image: AssetImage('images/banner.png'),
//                               fit: BoxFit.cover),
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 25.0),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                     child: Row(
//                       children: [
//                         Text(
//                           'Categories',
//                           style: kTextStyle.copyWith(
//                               color: kNeutralColor, fontWeight: FontWeight.bold),
//                         ),
//                         const Spacer(),
//                         GestureDetector(
//                           onTap: () => const ClientAllCategories().launch(context),
//                           child: Text(
//                             'View All',
//                             style: kTextStyle.copyWith(color: kLightNeutralColor),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   HorizontalList(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.only(
//                         top: 20, bottom: 20, left: 15.0, right: 15.0),
//                     spacing: 10.0,
//                     itemCount: catName.length,
//                     itemBuilder: (_, i) {
//                       return Container(
//                         padding: const EdgeInsets.only(
//                             left: 5.0, right: 10.0, top: 5.0, bottom: 5.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(30.0),
//                           color: kWhite,
//                           boxShadow: const [
//                             BoxShadow(
//                               color: kBorderColorTextField,
//                               blurRadius: 7.0,
//                               spreadRadius: 1.0,
//                               offset: Offset(0, 0),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Container(
//                               height: 39,
//                               width: 39,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 image: DecorationImage(
//                                     image: AssetImage(catIcon[i]),
//                                     fit: BoxFit.cover),
//                               ),
//                             ),
//                             const SizedBox(width: 5.0),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   catName[i],
//                                   style: kTextStyle.copyWith(
//                                       color: kNeutralColor,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 const SizedBox(height: 2.0),
//                                 Text(
//                                   'Related all categories',
//                                   style: kTextStyle.copyWith(
//                                       color: kLightNeutralColor),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
//                     child: Row(
//                       children: [
//                         Text(
//                           'Live Post',
//                           style: kTextStyle.copyWith(
//                               color: kNeutralColor, fontWeight: FontWeight.bold),
//                         ),
//                         const Spacer(),
//                         GestureDetector(
//                           onTap: () 
//                           //=> _handleRestrictedFeature(() 
//                           {
//                             const PopularServices().launch(context);
//                           }
//                           ,
//                           child: Text(
//                             'View All',
//                             style: kTextStyle.copyWith(color: kLightNeutralColor),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   HorizontalList(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.only(
//                         top: 20, bottom: 20, left: 15.0, right: 15.0),
//                     spacing: 10.0,
//                     itemCount: 10,
//                     itemBuilder: (_, i) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 10.0),
//                         child: GestureDetector(
//                           onTap: () => _handleRestrictedFeature(() {
//                             const ClientServiceDetails().launch(context);
//                           }),
//                           child: Container(
//                             height: 120,
//                             decoration: BoxDecoration(
//                               color: kWhite,
//                               borderRadius: BorderRadius.circular(8.0),
//                               border: Border.all(color: kBorderColorTextField),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: kDarkWhite,
//                                   blurRadius: 5.0,
//                                   spreadRadius: 2.0,
//                                   offset: Offset(0, 5),
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Stack(
//                                   alignment: Alignment.topLeft,
//                                   children: [
//                                     Container(
//                                       height: 120,
//                                       width: 120,
//                                       decoration: const BoxDecoration(
//                                         borderRadius: BorderRadius.only(
//                                           bottomLeft: Radius.circular(8.0),
//                                           topLeft: Radius.circular(8.0),
//                                         ),
//                                         image: DecorationImage(
//                                             image: AssetImage('images/shot1.png'),
//                                             fit: BoxFit.cover),
//                                       ),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         _handleRestrictedFeature(() {
//                                           setState(() {
//                                             isFavorite = !isFavorite;
//                                           });
//                                         });
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(5.0),
//                                         child: Container(
//                                           height: 25,
//                                           width: 25,
//                                           decoration: const BoxDecoration(
//                                             color: Colors.white,
//                                             shape: BoxShape.circle,
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.black12,
//                                                 blurRadius: 10.0,
//                                                 spreadRadius: 1.0,
//                                                 offset: Offset(0, 2),
//                                               ),
//                                             ],
//                                           ),
//                                           child: isFavorite
//                                               ? const Center(
//                                                   child: Icon(
//                                                     Icons.favorite,
//                                                     color: Colors.red,
//                                                     size: 16.0,
//                                                   ),
//                                                 )
//                                               : const Center(
//                                                   child: Icon(
//                                                     Icons.favorite_border,
//                                                     color: kNeutralColor,
//                                                     size: 16.0,
//                                                   ),
//                                                 ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(5.0),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Flexible(
//                                         child: SizedBox(
//                                           width: 190,
//                                           child: Text(
//                                             'Mobile UI UX design or app design',
//                                             style: kTextStyle.copyWith(
//                                                 color: kNeutralColor,
//                                                 fontWeight: FontWeight.bold),
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 5.0),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           const Icon(
//                                             IconlyBold.star,
//                                             color: Colors.amber,
//                                             size: 18.0,
//                                           ),
//                                           const SizedBox(width: 2.0),
//                                           Text(
//                                             '5.0',
//                                             style: kTextStyle.copyWith(
//                                                 color: kNeutralColor),
//                                           ),
//                                           const SizedBox(width: 2.0),
//                                           Text(
//                                             '(520)',
//                                             style: kTextStyle.copyWith(
//                                                 color: kLightNeutralColor),
//                                           ),
//                                           const SizedBox(width: 40),
//                                           RichText(
//                                             text: TextSpan(
//                                               text: 'Price: ',
//                                               style: kTextStyle.copyWith(
//                                                   color: kLightNeutralColor),
//                                               children: [
//                                                 TextSpan(
//                                                   text: '$currencySign${30}',
//                                                   style: kTextStyle.copyWith(
//                                                       color: kPrimaryColor,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 )
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                       const SizedBox(height: 5.0),
//                                       Row(
//                                         children: [
//                                           Container(
//                                             height: 32,
//                                             width: 32,
//                                             decoration: const BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               image: DecorationImage(
//                                                   image: AssetImage(
//                                                       'images/profilepic2.png'),
//                                                   fit: BoxFit.cover),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 5.0),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 'William Liam',
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: kTextStyle.copyWith(
//                                                     color: kNeutralColor,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                               Text(
//                                                 'Seller Level - 1',
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: kTextStyle.copyWith(
//                                                     color: kSubTitleColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                  Padding(
//                     padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
//                     child: Row(
//                       children: [
//                         Text(
//                           'Upcoming Post',
//                           style: kTextStyle.copyWith(
//                               color: kNeutralColor, fontWeight: FontWeight.bold),
//                         ),
//                         const Spacer(),
//                         GestureDetector(
//                           onTap: () 
//                           //=> _handleRestrictedFeature(() 
//                           {
//                             const PopularServices().launch(context);
//                           }
//                           ,
//                           child: Text(
//                             'View All',
//                             style: kTextStyle.copyWith(color: kLightNeutralColor),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   HorizontalList(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.only(
//                         top: 20, bottom: 20, left: 15.0, right: 15.0),
//                     spacing: 10.0,
//                     itemCount: 10,
//                     itemBuilder: (_, i) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 10.0),
//                         child: GestureDetector(
//                           onTap: () => _handleRestrictedFeature(() {
//                             const ClientServiceDetails().launch(context);
//                           }),
//                           child: Container(
//                             height: 120,
//                             decoration: BoxDecoration(
//                               color: kWhite,
//                               borderRadius: BorderRadius.circular(8.0),
//                               border: Border.all(color: kBorderColorTextField),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: kDarkWhite,
//                                   blurRadius: 5.0,
//                                   spreadRadius: 2.0,
//                                   offset: Offset(0, 5),
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Stack(
//                                   alignment: Alignment.topLeft,
//                                   children: [
//                                     Container(
//                                       height: 120,
//                                       width: 120,
//                                       decoration: const BoxDecoration(
//                                         borderRadius: BorderRadius.only(
//                                           bottomLeft: Radius.circular(8.0),
//                                           topLeft: Radius.circular(8.0),
//                                         ),
//                                         image: DecorationImage(
//                                             image: AssetImage('images/shot1.png'),
//                                             fit: BoxFit.cover),
//                                       ),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         _handleRestrictedFeature(() {
//                                           setState(() {
//                                             isFavorite = !isFavorite;
//                                           });
//                                         });
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(5.0),
//                                         child: Container(
//                                           height: 25,
//                                           width: 25,
//                                           decoration: const BoxDecoration(
//                                             color: Colors.white,
//                                             shape: BoxShape.circle,
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.black12,
//                                                 blurRadius: 10.0,
//                                                 spreadRadius: 1.0,
//                                                 offset: Offset(0, 2),
//                                               ),
//                                             ],
//                                           ),
//                                           child: isFavorite
//                                               ? const Center(
//                                                   child: Icon(
//                                                     Icons.favorite,
//                                                     color: Colors.red,
//                                                     size: 16.0,
//                                                   ),
//                                                 )
//                                               : const Center(
//                                                   child: Icon(
//                                                     Icons.favorite_border,
//                                                     color: kNeutralColor,
//                                                     size: 16.0,
//                                                   ),
//                                                 ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(5.0),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Flexible(
//                                         child: SizedBox(
//                                           width: 190,
//                                           child: Text(
//                                             'Mobile UI UX design or app design',
//                                             style: kTextStyle.copyWith(
//                                                 color: kNeutralColor,
//                                                 fontWeight: FontWeight.bold),
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 5.0),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           const Icon(
//                                             IconlyBold.star,
//                                             color: Colors.amber,
//                                             size: 18.0,
//                                           ),
//                                           const SizedBox(width: 2.0),
//                                           Text(
//                                             '5.0',
//                                             style: kTextStyle.copyWith(
//                                                 color: kNeutralColor),
//                                           ),
//                                           const SizedBox(width: 2.0),
//                                           Text(
//                                             '(520)',
//                                             style: kTextStyle.copyWith(
//                                                 color: kLightNeutralColor),
//                                           ),
//                                           const SizedBox(width: 40),
//                                           RichText(
//                                             text: TextSpan(
//                                               text: 'Price: ',
//                                               style: kTextStyle.copyWith(
//                                                   color: kLightNeutralColor),
//                                               children: [
//                                                 TextSpan(
//                                                   text: '$currencySign${30}',
//                                                   style: kTextStyle.copyWith(
//                                                       color: kPrimaryColor,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 )
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                       const SizedBox(height: 5.0),
//                                       Row(
//                                         children: [
//                                           Container(
//                                             height: 32,
//                                             width: 32,
//                                             decoration: const BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               image: DecorationImage(
//                                                   image: AssetImage(
//                                                       'images/profilepic2.png'),
//                                                   fit: BoxFit.cover),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 5.0),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 'William Liam',
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: kTextStyle.copyWith(
//                                                     color: kNeutralColor,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                               Text(
//                                                 'Seller Level - 1',
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: kTextStyle.copyWith(
//                                                     color: kSubTitleColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
                
                
//                   Padding(
//                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                     child: Row(
//                       children: [
//                         Text(
//                           'Top Poster',
//                           style: kTextStyle.copyWith(
//                               color: kNeutralColor, fontWeight: FontWeight.bold),
//                         ),
//                         const Spacer(),
//                         GestureDetector(
//                           onTap: () => _handleRestrictedFeature(() {
//                             const TopSeller().launch(context);
//                           }),
//                           child: Text(
//                             'View All',
//                             style: kTextStyle.copyWith(color: kLightNeutralColor),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   HorizontalList(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.only(
//                         top: 20, bottom: 20, left: 15.0, right: 15.0),
//                     spacing: 10.0,
//                     itemCount: 10,
//                     itemBuilder: (_, i) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 10.0),
//                         child: GestureDetector(
//                           onTap: () => _handleRestrictedFeature(() {
//                             // Navigate to seller profile or details
//                           }),
//                           child: Container(
//                             height: 220,
//                             width: 156,
//                             decoration: BoxDecoration(
//                               color: kWhite,
//                               borderRadius: BorderRadius.circular(8.0),
//                               border: Border.all(color: kBorderColorTextField),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: kDarkWhite,
//                                   blurRadius: 5.0,
//                                   spreadRadius: 2.0,
//                                   offset: Offset(0, 5),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: 135,
//                                   width: 156,
//                                   decoration: const BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topRight: Radius.circular(8.0),
//                                       topLeft: Radius.circular(8.0),
//                                     ),
//                                     image: DecorationImage(
//                                         image: AssetImage('images/dev1.png'),
//                                         fit: BoxFit.cover),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(6.0),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'William Liam',
//                                         style: kTextStyle.copyWith(
//                                             color: kNeutralColor,
//                                             fontWeight: FontWeight.bold),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       const SizedBox(height: 6.0),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           const Icon(
//                                             IconlyBold.star,
//                                             color: Colors.amber,
//                                             size: 18.0,
//                                           ),
//                                           const SizedBox(width: 2.0),
//                                           Text(
//                                             '5.0',
//                                             style: kTextStyle.copyWith(
//                                                 color: kNeutralColor),
//                                           ),
//                                           const SizedBox(width: 2.0),
//                                           Text(
//                                             '(520 review)',
//                                             style: kTextStyle.copyWith(
//                                                 color: kLightNeutralColor),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 6.0),
//                                       RichText(
//                                         text: TextSpan(
//                                           text: 'Seller Level - ',
//                                           style: kTextStyle.copyWith(
//                                               color: kNeutralColor),
//                                           children: [
//                                             TextSpan(
//                                               text: '2',
//                                               style: kTextStyle.copyWith(
//                                                   color: kLightNeutralColor),
//                                             )
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                     child: Row(
//                       children: [
//                         Text(
//                           'Recent Viewed',
//                           style: kTextStyle.copyWith(
//                               color: kNeutralColor, fontWeight: FontWeight.bold),
//                         ),
//                         const Spacer(),
//                         GestureDetector(
//                           onTap: () => _handleRestrictedFeature(() {
//                             const RecentlyView().launch(context);
//                           }),
//                           child: Text(
//                             'View All',
//                             style: kTextStyle.copyWith(color: kLightNeutralColor),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   HorizontalList(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.only(
//                         top: 20, bottom: 10, left: 15.0, right: 15.0),
//                     spacing: 10.0,
//                     itemCount: 10,
//                     itemBuilder: (_, i) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 10.0),
//                         child: GestureDetector(
//                           onTap: () => _handleRestrictedFeature(() {
//                             const ClientServiceDetails().launch(context);
//                           }),
//                           child: Container(
//                             height: 120,
//                             decoration: BoxDecoration(
//                               color: kWhite,
//                               borderRadius: BorderRadius.circular(8.0),
//                               border: Border.all(color: kBorderColorTextField),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: kDarkWhite,
//                                   blurRadius: 5.0,
//                                   spreadRadius: 2.0,
//                                   offset: Offset(0, 5),
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Stack(
//                                   alignment: Alignment.topLeft,
//                                   children: [
//                                     Container(
//                                       height: 120,
//                                       width: 120,
//                                       decoration: const BoxDecoration(
//                                         borderRadius: BorderRadius.only(
//                                           bottomLeft: Radius.circular(8.0),
//                                           topLeft: Radius.circular(8.0),
//                                         ),
//                                         image: DecorationImage(
//                                             image: AssetImage('images/shot5.png'),
//                                             fit: BoxFit.cover),
//                                       ),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         _handleRestrictedFeature(() {
//                                           setState(() {
//                                             isFavorite = !isFavorite;
//                                           });
//                                         });
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(5.0),
//                                         child: Container(
//                                           height: 25,
//                                           width: 25,
//                                           decoration: const BoxDecoration(
//                                             color: Colors.white,
//                                             shape: BoxShape.circle,
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.black12,
//                                                 blurRadius: 10.0,
//                                                 spreadRadius: 1.0,
//                                                 offset: Offset(0, 2),
//                                               ),
//                                             ],
//                                           ),
//                                           child: isFavorite
//                                               ? const Center(
//                                                   child: Icon(
//                                                     Icons.favorite,
//                                                     color: Colors.red,
//                                                     size: 16.0,
//                                                   ),
//                                                 )
//                                               : const Center(
//                                                   child: Icon(
//                                                     Icons.favorite_border,
//                                                     color: kNeutralColor,
//                                                     size: 16.0,
//                                                   ),
//                                                 ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(5.0),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Flexible(
//                                         child: SizedBox(
//                                           width: 190,
//                                           child: Text(
//                                             'modern unique business logo design',
//                                             style: kTextStyle.copyWith(
//                                                 color: kNeutralColor,
//                                                 fontWeight: FontWeight.bold),
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 5.0),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           const Icon(
//                                             IconlyBold.star,
//                                             color: Colors.amber,
//                                             size: 18.0,
//                                           ),
//                                           const SizedBox(width: 2.0),
//                                           Text(
//                                             '5.0',
//                                             style: kTextStyle.copyWith(
//                                                 color: kNeutralColor),
//                                           ),
//                                           const SizedBox(width: 2.0),
//                                           Text(
//                                             '(520)',
//                                             style: kTextStyle.copyWith(
//                                                 color: kLightNeutralColor),
//                                           ),
//                                           const SizedBox(width: 40),
//                                           RichText(
//                                             text: TextSpan(
//                                               text: 'Price: ',
//                                               style: kTextStyle.copyWith(
//                                                   color: kLightNeutralColor),
//                                               children: [
//                                                 TextSpan(
//                                                   text: '$currencySign${30}',
//                                                   style: kTextStyle.copyWith(
//                                                       color: kPrimaryColor,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 )
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                       const SizedBox(height: 5.0),
//                                       Row(
//                                         children: [
//                                           Container(
//                                             height: 32,
//                                             width: 32,
//                                             decoration: const BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               image: DecorationImage(
//                                                   image: AssetImage(
//                                                       'images/profilepic2.png'),
//                                                   fit: BoxFit.cover),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 5.0),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 'William Liam',
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: kTextStyle.copyWith(
//                                                     color: kNeutralColor,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                               Text(
//                                                 'Seller Level - 1',
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: kTextStyle.copyWith(
//                                                     color: kSubTitleColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:freelancer/screen/app_config/api_config.dart';
import 'package:freelancer/screen/client%20screen/client%20home/popular_services.dart';
import 'package:freelancer/screen/client%20screen/client%20home/recently_view.dart';
import 'package:freelancer/screen/client%20screen/client%20home/top_seller.dart';
import 'package:freelancer/screen/client%20screen/client%20recent%20post/client_recent_post.dart';
import 'package:freelancer/screen/client%20screen/client_authentication/client_log_in.dart';
import 'package:freelancer/screen/model/banner_model.dart';
import 'package:freelancer/screen/model/category.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import '../../widgets/constant.dart';
import '../client%20notification/client_notification.dart';
import '../client%20service%20details/client_service_details.dart';
import '../search/search.dart';
import 'client_all_categories.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  bool isFavorite = false;
  bool isLoggedIn = false;
  List<dynamic> notifications = [];
  List<Result> categoryList = [];
  List<BannerResult> bannerList = [];
  List<dynamic> livePostList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
 
    livePost();
    fetchCategory();
    fetchBanner();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  void _handleRestrictedFeature(VoidCallback onLoggedIn) {
    if (isLoggedIn) {
      onLoggedIn();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ClientLogIn()),
      );
    }
  }

  Future<void> _fetchData({
    required String endpoint,
    required Function(dynamic response) onSuccess,
    String? token,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final headers = token != null
          ? {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            }
          : null;

      final res = await ApiService.getRequest(endpoint, headers: headers);
      setState(() {
        onSuccess(res);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      toast("Error: $e");
    }
  }

 

  Future<void> fetchCategory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    await _fetchData(
      endpoint: "category",
      onSuccess: (res) {
        final categoryModel = CategoryModel.fromJson(res);
        categoryList = categoryModel.result ?? [];
      },
      token: token,
    );
  }

  Future<void> fetchBanner() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    await _fetchData(
      endpoint: "banner",
      onSuccess: (res) {
        final bannerModel = BannerModel.fromJson(res);
        bannerList = bannerModel.result ?? [];
      },
      token: token,
    );
  }

  Future<void> livePost() async {
    await _fetchData(
      endpoint: "get-post",
      onSuccess: (res) => livePostList = res["data"] ?? [],
    );
  }

  // Shimmer Widgets for each section
  Widget _buildBannerShimmer() {
    return HorizontalList(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 15),
      spacing: 10.0,
      itemCount: 3, // Placeholder count
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 140,
            width: 304,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryShimmer() {
    return HorizontalList(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15.0, right: 15.0),
      spacing: 10.0,
      itemCount: 4, // Placeholder count
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: kBorderColorTextField,
                  blurRadius: 7.0,
                  spreadRadius: 1.0,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 39,
                  width: 39,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 2.0),
                    Container(
                      width: 150,
                      height: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostShimmer() {
    return HorizontalList(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15.0, right: 15.0),
      spacing: 10.0,
      itemCount: 3, // Placeholder count
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: kBorderColorTextField),
              boxShadow: const [
                BoxShadow(
                  color: kDarkWhite,
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  color: Colors.white,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 190,
                          height: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 2.0),
                            Container(
                              width: 30,
                              height: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 40),
                            Container(
                              width: 60,
                              height: 14,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            Container(
                              height: 32,
                              width: 32,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 2.0),
                                Container(
                                  width: 80,
                                  height: 12,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopPosterShimmer() {
    return HorizontalList(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15.0, right: 15.0),
      spacing: 10.0,
      itemCount: 3, // Placeholder count
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 220,
            width: 156,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: kBorderColorTextField),
              boxShadow: const [
                BoxShadow(
                  color: kDarkWhite,
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 135,
                  width: 156,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6.0),
                      Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 2.0),
                          Container(
                            width: 30,
                            height: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 2.0),
                          Container(
                            width: 80,
                            height: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        width: 120,
                        height: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          backgroundColor: kDarkWhite,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _handleRestrictedFeature(() {
                    const ClientLogIn().launch(context);
                  }),
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('images/profile3.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLoggedIn ? 'Shaidulislam' : 'Guest',
                        style: kTextStyle.copyWith(
                            color: kNeutralColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        isLoggedIn ? 'I’m a Client' : 'Please log in',
                        style: kTextStyle.copyWith(
                            color: kLightNeutralColor, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _handleRestrictedFeature(() {
                        const ClientNotification().launch(context);
                      }),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: kPrimaryColor.withOpacity(0.2),
                          ),
                        ),
                        child: const Icon(
                          IconlyLight.notification,
                          color: kNeutralColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        const ClientRecentPost().launch(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: kPrimaryColor.withOpacity(0.2),
                          ),
                        ),
                        child: const Icon(
                          IconlyLight.infoSquare,
                          color: kNeutralColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: isLoading
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    width: context.width(),
                    decoration: const BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: ListTile(
                                horizontalTitleGap: 0,
                                visualDensity: const VisualDensity(vertical: -2),
                                leading: Container(
                                  width: 24,
                                  height: 24,
                                  color: Colors.white,
                                ),
                                title: Container(
                                  width: 150,
                                  height: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        _buildBannerShimmer(),
                        const SizedBox(height: 25.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 100,
                                  height: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 60,
                                  height: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildCategoryShimmer(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 100,
                                  height: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 60,
                                  height: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildPostShimmer(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 100,
                                  height: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 60,
                                  height: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildPostShimmer(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 100,
                                  height: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 60,
                                  height: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildTopPosterShimmer(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 100,
                                  height: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 60,
                                  height: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildPostShimmer(),
                      ],
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  width: context.width(),
                  decoration: const BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: kDarkWhite,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: ListTile(
                              horizontalTitleGap: 0,
                              visualDensity: const VisualDensity(vertical: -2),
                              leading: const Icon(
                                FeatherIcons.search,
                                color: kNeutralColor,
                              ),
                              title: Text(
                                'Search services...',
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                              onTap: () {
                                showSearch(
                                  context: context,
                                  delegate: CustomSearchDelegate(),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        HorizontalList(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(left: 15),
                          spacing: 10.0,
                          itemCount: bannerList.length,
                          itemBuilder: (_, i) {
                            final banner = bannerList[i];
                            return GestureDetector(
                              onTap: () {
                                if (banner.redirectUrl != null) {
                                  toast("Opening: ${banner.redirectUrl}");
                                  // Implement URL launching logic here
                                }
                              },
                              child: Container(
                                height: 140,
                                width: 304,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: banner.image != null
                                        ? NetworkImage(banner.image!)
                                        : const AssetImage('images/banner.png')
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                    onError: (exception, stackTrace) =>
                                        const AssetImage('images/banner.png'),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 25.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              Text(
                                'Categories',
                                style: kTextStyle.copyWith(
                                    color: kNeutralColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () =>
                                    const ClientAllCategories().launch(context),
                                child: Text(
                                  'View All',
                                  style:
                                      kTextStyle.copyWith(color: kLightNeutralColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        HorizontalList(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 15.0, right: 15.0),
                          spacing: 10.0,
                          itemCount: categoryList.length,
                          itemBuilder: (_, i) {
                            final category = categoryList[i];
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 10.0, top: 5.0, bottom: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: kWhite,
                                boxShadow: const [
                                  BoxShadow(
                                    color: kBorderColorTextField,
                                    blurRadius: 7.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 39,
                                    width: 39,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: category.image != null
                                            ? NetworkImage(category.image!)
                                            : const AssetImage(
                                                'images/placeholder.png')
                                                as ImageProvider,
                                        fit: BoxFit.cover,
                                        onError: (exception, stackTrace) =>
                                            const AssetImage(
                                                'images/placeholder.png'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category.name ?? 'Category',
                                        style: kTextStyle.copyWith(
                                            color: kNeutralColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        category.categoryDetail ??
                                            'Related all categories',
                                        style: kTextStyle.copyWith(
                                            color: kLightNeutralColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                          child: Row(
                            children: [
                              Text(
                                'Live Post',
                                style: kTextStyle.copyWith(
                                    color: kNeutralColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  const PopularServices().launch(context);
                                },
                                child: Text(
                                  'View All',
                                  style:
                                      kTextStyle.copyWith(color: kLightNeutralColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        HorizontalList(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 15.0, right: 15.0),
                          spacing: 10.0,
                          itemCount: livePostList.length,
                          itemBuilder: (_, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: GestureDetector(
                                onTap: () => _handleRestrictedFeature(() {
                                  const ClientServiceDetails().launch(context);
                                }),
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: kBorderColorTextField),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: kDarkWhite,
                                        blurRadius: 5.0,
                                        spreadRadius: 2.0,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(8.0),
                                                topLeft: Radius.circular(8.0),
                                              ),
                                              image: DecorationImage(
                                                  image: AssetImage('images/shot1.png'),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _handleRestrictedFeature(() {
                                                setState(() {
                                                  isFavorite = !isFavorite;
                                                });
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 10.0,
                                                      spreadRadius: 1.0,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: isFavorite
                                                    ? const Center(
                                                        child: Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                          size: 16.0,
                                                        ),
                                                      )
                                                    : const Center(
                                                        child: Icon(
                                                          Icons.favorite_border,
                                                          color: kNeutralColor,
                                                          size: 16.0,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: SizedBox(
                                                width: 190,
                                                child: Text(
                                                  'Mobile UI UX design or app design',
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor,
                                                      fontWeight: FontWeight.bold),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  IconlyBold.star,
                                                  color: Colors.amber,
                                                  size: 18.0,
                                                ),
                                                const SizedBox(width: 2.0),
                                                Text(
                                                  '5.0',
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor),
                                                ),
                                                const SizedBox(width: 2.0),
                                                Text(
                                                  '(520)',
                                                  style: kTextStyle.copyWith(
                                                      color: kLightNeutralColor),
                                                ),
                                                const SizedBox(width: 40),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Price: ',
                                                    style: kTextStyle.copyWith(
                                                        color: kLightNeutralColor),
                                                    children: [
                                                      TextSpan(
                                                        text: '$currencySign${30}',
                                                        style: kTextStyle.copyWith(
                                                            color: kPrimaryColor,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 5.0),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 32,
                                                  width: 32,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'images/profilepic2.png'),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                const SizedBox(width: 5.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'William Liam',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: kTextStyle.copyWith(
                                                          color: kNeutralColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Seller Level - 1',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: kTextStyle.copyWith(
                                                          color: kSubTitleColor),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                          child: Row(
                            children: [
                              Text(
                                'Upcoming Post',
                                style: kTextStyle.copyWith(
                                    color: kNeutralColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  const PopularServices().launch(context);
                                },
                                child: Text(
                                  'View All',
                                  style:
                                      kTextStyle.copyWith(color: kLightNeutralColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        HorizontalList(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 15.0, right: 15.0),
                          spacing: 10.0,
                          itemCount: 10,
                          itemBuilder: (_, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: GestureDetector(
                                onTap: () => _handleRestrictedFeature(() {
                                  const ClientServiceDetails().launch(context);
                                }),
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: kBorderColorTextField),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: kDarkWhite,
                                        blurRadius: 5.0,
                                        spreadRadius: 2.0,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(8.0),
                                                topLeft: Radius.circular(8.0),
                                              ),
                                              image: DecorationImage(
                                                  image: AssetImage('images/shot1.png'),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _handleRestrictedFeature(() {
                                                setState(() {
                                                  isFavorite = !isFavorite;
                                                });
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 10.0,
                                                      spreadRadius: 1.0,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: isFavorite
                                                    ? const Center(
                                                        child: Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                          size: 16.0,
                                                        ),
                                                      )
                                                    : const Center(
                                                        child: Icon(
                                                          Icons.favorite_border,
                                                          color: kNeutralColor,
                                                          size: 16.0,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: SizedBox(
                                                width: 190,
                                                child: Text(
                                                  'Mobile UI UX design or app design',
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor,
                                                      fontWeight: FontWeight.bold),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  IconlyBold.star,
                                                  color: Colors.amber,
                                                  size: 18.0,
                                                ),
                                                const SizedBox(width: 2.0),
                                                Text(
                                                  '5.0',
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor),
                                                ),
                                                const SizedBox(width: 2.0),
                                                Text(
                                                  '(520)',
                                                  style: kTextStyle.copyWith(
                                                      color: kLightNeutralColor),
                                                ),
                                                const SizedBox(width: 40),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Price: ',
                                                    style: kTextStyle.copyWith(
                                                        color: kLightNeutralColor),
                                                    children: [
                                                      TextSpan(
                                                        text: '$currencySign${30}',
                                                        style: kTextStyle.copyWith(
                                                            color: kPrimaryColor,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 5.0),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 32,
                                                  width: 32,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'images/profilepic2.png'),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                const SizedBox(width: 5.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'William Liam',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: kTextStyle.copyWith(
                                                          color: kNeutralColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Seller Level - 1',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: kTextStyle.copyWith(
                                                          color: kSubTitleColor),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              Text(
                                'Top Poster',
                                style: kTextStyle.copyWith(
                                    color: kNeutralColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => _handleRestrictedFeature(() {
                                  const TopSeller().launch(context);
                                }),
                                child: Text(
                                  'View All',
                                  style:
                                      kTextStyle.copyWith(color: kLightNeutralColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        HorizontalList(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 15.0, right: 15.0),
                          spacing: 10.0,
                          itemCount: 10,
                          itemBuilder: (_, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: GestureDetector(
                                onTap: () => _handleRestrictedFeature(() {
                                  // Navigate to seller profile or details
                                }),
                                child: Container(
                                  height: 220,
                                  width: 156,
                                  decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: kBorderColorTextField),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: kDarkWhite,
                                        blurRadius: 5.0,
                                        spreadRadius: 2.0,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 135,
                                        width: 156,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8.0),
                                            topLeft: Radius.circular(8.0),
                                          ),
                                          image: DecorationImage(
                                              image: AssetImage('images/dev1.png'),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'William Liam',
                                              style: kTextStyle.copyWith(
                                                  color: kNeutralColor,
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 6.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  IconlyBold.star,
                                                  color: Colors.amber,
                                                  size: 18.0,
                                                ),
                                                const SizedBox(width: 2.0),
                                                Text(
                                                  '5.0',
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor),
                                                ),
                                                const SizedBox(width: 2.0),
                                                Text(
                                                  '(520 review)',
                                                  style: kTextStyle.copyWith(
                                                      color: kLightNeutralColor),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6.0),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Seller Level - ',
                                                style: kTextStyle.copyWith(
                                                    color: kNeutralColor),
                                                children: [
                                                  TextSpan(
                                                    text: '2',
                                                    style: kTextStyle.copyWith(
                                                        color: kLightNeutralColor),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              Text(
                                'Recent Viewed',
                                style: kTextStyle.copyWith(
                                    color: kNeutralColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => _handleRestrictedFeature(() {
                                  const RecentlyView().launch(context);
                                }),
                                child: Text(
                                  'View All',
                                  style:
                                      kTextStyle.copyWith(color: kLightNeutralColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        HorizontalList(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 10, left: 15.0, right: 15.0),
                          spacing: 10.0,
                          itemCount: 10,
                          itemBuilder: (_, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: GestureDetector(
                                onTap: () => _handleRestrictedFeature(() {
                                  const ClientServiceDetails().launch(context);
                                }),
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: kBorderColorTextField),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: kDarkWhite,
                                        blurRadius: 5.0,
                                        spreadRadius: 2.0,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(8.0),
                                                topLeft: Radius.circular(8.0),
                                              ),
                                              image: DecorationImage(
                                                  image: AssetImage('images/shot5.png'),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _handleRestrictedFeature(() {
                                                setState(() {
                                                  isFavorite = !isFavorite;
                                                });
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 10.0,
                                                      spreadRadius: 1.0,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: isFavorite
                                                    ? const Center(
                                                        child: Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                          size: 16.0,
                                                        ),
                                                      )
                                                    : const Center(
                                                        child: Icon(
                                                          Icons.favorite_border,
                                                          color: kNeutralColor,
                                                          size: 16.0,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: SizedBox(
                                                width: 190,
                                                child: Text(
                                                  'modern unique business logo design',
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor,
                                                      fontWeight: FontWeight.bold),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  IconlyBold.star,
                                                  color: Colors.amber,
                                                  size: 18.0,
                                                ),
                                                const SizedBox(width: 2.0),
                                                Text(
                                                  '5.0',
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor),
                                                ),
                                                const SizedBox(width: 2.0),
                                                Text(
                                                  '(520)',
                                                  style: kTextStyle.copyWith(
                                                      color: kLightNeutralColor),
                                                ),
                                                const SizedBox(width: 40),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Price: ',
                                                    style: kTextStyle.copyWith(
                                                        color: kLightNeutralColor),
                                                    children: [
                                                      TextSpan(
                                                        text: '$currencySign${30}',
                                                        style: kTextStyle.copyWith(
                                                            color: kPrimaryColor,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 5.0),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 32,
                                                  width: 32,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'images/profilepic2.png'),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                const SizedBox(width: 5.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'William Liam',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: kTextStyle.copyWith(
                                                          color: kNeutralColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Seller Level - 1',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: kTextStyle.copyWith(
                                                          color: kSubTitleColor),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}