import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_countdown/slide_countdown.dart';
import '../../core/app_color.dart';
import '../../core/app_constant.dart';
import '../../widget/button_global.dart';
import '../../widget/custom_html_viewer.dart';
import '../view/post_details_service/bidding_sheet.dart';
import 'custom_view_widget.dart';
import 'custom_alert_dialog.dart';
import '../../widget/custom_navigator.dart';
import '../../controller/post/get_post_details_controller.dart';
import '../../models/Post/Get_Post_details_Model.dart';
import '../../controller/post/app_post_controller.dart';
import '../../controller/post/post_form_controller.dart';
import '../controller/home/home_controller.dart';
import '../view/Bottom_navigation_screen/Botom_navigation_screen.dart';
import '../controller/bottom/bottom_bar_controller.dart';



class PostDetailScreen extends StatefulWidget {
  final String? ukey;

  const PostDetailScreen({
    super.key,
    this.ukey,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> with TickerProviderStateMixin {
  PageController pageController = PageController(initialPage: 0);
  GetPostDetailsController getPostDetailsController = Get.put(GetPostDetailsController());


  ScrollController? _scrollController;
  bool lastStatus = false;
  double height = 290;
  bool isFavorite = false;
  List<dynamic> notifications = [];
  bool isLoading = true;

  // Static Data
  final String profileImagePath = 'https://i.pravatar.cc/150?img=3';
  final String status = 'bidding';




  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    getPostDetailsController.getPostDetails(widget.ukey ?? '');
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset > (height - kToolbarHeight);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();

    super.dispose();
  }

  // void toggleFavorite(int index, bool newValue) {
  //   // recentViewedList[index].isFavorite.value = newValue;
  // }

  void _showCustomDialog(BuildContext context, dynamic menu) {
    showDialog(
      context: context, 
      builder: (context) {
        return CustomAlertDialog(
          title: menu.title ?? menu.label ?? '',
          description: menu.description ?? '',
          backgroundImage: menu.pageImage,
          onConfirm: () async {
            finish(context); // Close dialog
             if (menu.apiEndpoint != null && menu.apiEndpoint!.isNotEmpty) {
               bool success = await getPostDetailsController.executeApiAction(menu.apiEndpoint!);
               if (success) {
                  // Refresh Home Data
                  if (Get.isRegistered<ClientHomeController>()) {
                    await ClientHomeController.to.refreshData();
                  } else {
                     // In case it's not registered (unlikely if we came from home, but safe check)
                     final homeController = Get.put(ClientHomeController());
                     await homeController.refreshData();
                  }

                  // Reset Bottom Navigation to Home (Index 0)
                  if (Get.isRegistered<BottomBarController>()) {
                    Get.find<BottomBarController>().onItemTapped(0);
                  } else {
                    Get.put(BottomBarController()).onItemTapped(0);
                  }

                  Get.offAll(() => const BottomNavigationScreen());
               }
            } else {
               toast("Action Confirmed: ${menu.label}");
            }
          },
        );
      }
    );
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.appPagecolor,
      ),
      child: Obx(() {
          final model = getPostDetailsController.getPostDetailsModel.value;
          final result = model?.result?.firstOrNull;
          final info = result?.info;
          final postOwner = result?.postOwner;
          final media = result?.media;
          final menuButtons = result?.menuButton;
          final detailsTabs = result?.detailsTab;
          final htmlDetails = result?.htmlDetails;


          if (getPostDetailsController.isLoading.value) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Shimmer.fromColors(
                baseColor: AppColors.appMutedColor,
                highlightColor: AppColors.appMutedTextColor,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner Placeholder
                      Container(
                        height: 290,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title Placeholder
                            Container(width: double.infinity, height: 24, color: Colors.white),
                            const SizedBox(height: 10),
                            Container(width: 200.0, height: 24, color: Colors.white),
                            const SizedBox(height: 20),
                            
                            // Rating/Price Row
                            Row(
                              children: [
                                Container(width: 20, height: 20, color: Colors.white),
                                const SizedBox(width: 5),
                                Container(width: 50, height: 16, color: Colors.white),
                                const Spacer(),
                                Container(width: 80, height: 24, color: Colors.white),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Profile Row
                            Row(
                              children: [
                                Container(
                                  width: 44, height: 44,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(width: 120, height: 16, color: Colors.white),
                                    const SizedBox(height: 5),
                                    Container(width: 80, height: 12, color: Colors.white),
                                  ],
                                )
                              ],
                            ),
                            const Divider(height: 30),
                            
                            // Description / HTML
                            Container(width: 100, height: 20, color: Colors.white),
                            const SizedBox(height: 10),
                            Container(width: double.infinity, height: 14, color: Colors.white),
                            const SizedBox(height: 5),
                            Container(width: double.infinity, height: 14, color: Colors.white),
                            const SizedBox(height: 5),
                            Container(width: 250.0, height: 14, color: Colors.white),
                            const SizedBox(height: 30),

                            // Tabs / Pricing
                            Container(
                              height: 350.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          print("model $model,result $result ");
          if (model == null || result == null) {
             return const Scaffold(
              body: Center(child: Text("No details found")),
            );
          }
          
           // Map Media
          List<Map<String, dynamic>> dynamicMediaItems = [];
          if (media?.mediaList != null) {
            final videoItems = media!.mediaList!
                .where((m) => m.mediaType == 'video')
                .map((m) => {'type': 'video', 'url': m.url})
                .toList();
            final imageItems = media.mediaList!
                 .where((m) => m.mediaType == 'image')
                .map((m) => {'type': 'image', 'url': m.url, 'redirectUrl': null})
                .toList();
            dynamicMediaItems = [...videoItems, ...imageItems];
          } else {
             dynamicMediaItems = [];
          }


        return Scaffold(
          backgroundColor: Colors.transparent,
        bottomNavigationBar: (result?.submitButton != null && result!.submitButton!.isNotEmpty)
            ? Container(
                decoration: BoxDecoration(gradient: AppColors.appPagecolor),
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                child: Builder(
                  builder: (context) {
                    final buttons = result!.submitButton!;
                    List<Widget> rows = [];
                    
                    Widget buildBtn(SubmitButton btn) {
                        String label = btn.label ?? '';
                        VoidCallback? onPressed;

                        onPressed = () async {
                           bool hasApi = btn.apiEndpoint != null && btn.apiEndpoint!.isNotEmpty;
                           bool hasNextPage = btn.nextPageName != null && btn.nextPageName!.isNotEmpty;
                           bool hasNextApi = btn.nextPageApiEndpoint != null && btn.nextPageApiEndpoint!.isNotEmpty;
                           bool hasNextView = btn.nextPageViewType != null && btn.nextPageViewType!.isNotEmpty;

                           bool hasConfirmData =
                               (btn.title != null && btn.title!.isNotEmpty) &&
                               (btn.description != null && btn.description!.isNotEmpty);

                           // RULE 1: Direct API
                           if (hasApi && !hasNextPage && !hasNextApi && !hasNextView && !hasConfirmData) {
                             print("Rule 1 → Direct API");
                             await getPostDetailsController.actionButtonAction(btn.apiEndpoint!);
                             return;
                           }

                           // RULE 2: Navigate (Edit/Other)
                           if (!hasApi && hasNextPage && hasNextApi && !hasConfirmData) {
                             print("Rule 2 → Next API + Navigate");
                             // await Get.put(PostFormController()).getPostForm(
                             //     endpoint: btn.nextPageApiEndpoint, isEditMode: true); // Assuming Edit mode is standard for this flow? Or maybe optional.
                             CustomNavigator.navigate(btn.nextPageName);
                             return;
                           }

                           // Rule 2b: Simple Navigate (No API fetch needed) - Implicitly covered if hasNextApi is false but hasNextPage is true.
                           if (hasNextPage && !hasNextApi && !hasConfirmData) {
                              CustomNavigator.navigate(btn.nextPageName);
                              return;
                           }


                           // RULE 3: Confirm Data -> Show BidBottomSheet instead of Dialog
                           if (!hasNextPage && !hasNextApi && !hasNextView && hasConfirmData) {
                             print("Rule 3 → BidBottomSheet");
                             showModalBottomSheet(
                               context: context,
                               isScrollControlled: true,
                               shape: const RoundedRectangleBorder(
                                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                               ),
                               builder: (context) => Padding(
                                 padding: EdgeInsets.only(
                                   bottom: MediaQuery.of(context).viewInsets.bottom,
                                 ),
                                 child: BidBottomSheet(
                                   title: btn.title,
                                   description: btn.description,
                                   pageImage: btn.pageImage,
                                   design: btn.design,
                                 ),
                               ),
                             );
                             return;
                           }

                           // Fallback for unmatched cases (e.g. just label)
                           print("No matching rule for bottom button: $label");
                        };

                        return ButtonGlobalWithoutIcon(
                          buttontext: label,
                          buttonDecoration: kButtonDecoration.copyWith(
                            borderRadius: BorderRadius.circular(30.0),
                            color: AppColors.appButtonColor,
                          ),
                          onPressed: onPressed,
                          buttonTextColor: AppColors.appButtonTextColor,
                        );
                    }

                    for (int i = 0; i < buttons.length; i += 2) {

                      bool hasSecond = (i + 1 < buttons.length);
                      
                      if (hasSecond) {

                        rows.add(
                          Row(
                            children: [
                              Expanded(
                                child: buildBtn(buttons[i]),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: buildBtn(buttons[i + 1]),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Single button (last one): Full Width
                        rows.add(
                          Row(
                            children: [
                              Expanded(
                                child: buildBtn(buttons[i]),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      // Add spacing between rows if not the last row
                      if (i + 2 < buttons.length || (hasSecond && i + 2 < buttons.length)) {
                         rows.add(const SizedBox(height: 3));
                      }
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: rows,
                    );
                  }
                ),
              )
            : const SizedBox.shrink(),

        body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                elevation: 0,
                backgroundColor: _isShrink ? AppColors.appColor : Colors.transparent,
                pinned: true,
                expandedHeight: 290,
                titleSpacing: 10,
                automaticallyImplyLeading: false,
                forceElevated: innerBoxIsScrolled,
                centerTitle: true,
                title: Text(
                  info?.title ?? '',
                  maxLines: 1,
                  style: AppTextStyle.title(
                    color: AppColors.appTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: _isShrink
                    ? GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.appTextColor,
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.appMutedColor,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.appIconColor,
                      ),
                    ),
                  ),
                ),
                actions: const [],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    children: [
                      CustomViewWidget(
                        type: media?.viewType ?? '',
                        bannerItems: dynamicMediaItems,
                        height: 290,
                        bannerLoading: false.obs,
                      ),
                      // Action Buttons & Menu Button positions
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 10,
                        right: 15,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Menu Button (3-dots)
                            if (menuButtons != null && menuButtons.isNotEmpty)
                               PopupMenuButton<String>(
                                padding: EdgeInsets.zero,
                                offset: const Offset(0, 45),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                itemBuilder: (BuildContext context) => menuButtons.map((menu) {
                                   return PopupMenuItem<String>(
                                     value: menu.label,
                                     child: Row(
                                      children: [
                                        _getIconForMenu(menu.icon),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          menu.label ?? '',
                                          style:AppTextStyle.body(color: AppColors.appBodyTextColor),
                                        ),
                                      ],
                                    ),
                                   );
                                }).toList(),
                                onSelected: (value) {
                                   final selectedMenu = menuButtons.firstWhere((element) => element.label == value);

                                   // Check if dialog fields are empty
                                   bool isDialogFieldsEmpty = (selectedMenu.title == null || selectedMenu.title!.isEmpty) &&
                                                              (selectedMenu.description == null || selectedMenu.description!.isEmpty) &&
                                                              (selectedMenu.pageImage == null || selectedMenu.pageImage!.isEmpty);

                                   if (isDialogFieldsEmpty) {
                                     // Navigate if we have navigation data
                                     if (selectedMenu.nextPageName != null && selectedMenu.nextPageName!.isNotEmpty) {
                                        CustomNavigator.navigate(selectedMenu.nextPageName);
                                     } else {
                                        // Values are empty but no navigation data?
                                        // Fallback or do nothing (or show toast)
                                        // User said: "jab next_page_name... null ya epmty hoge tabhi CustomAlertDialog user karna hai"
                                        // This implies if NO Navigation -> Force Dialog (even if empty? or maybe existing data?)
                                        // But we just checked if dialog fields IS empty.
                                        // Let's assume if NO navigation, we show dialog with whatever label we have.
                                        _showCustomDialog(context, selectedMenu);
                                     }
                                   } else {
                                      // Dialog fields exist -> Show Dialog
                                      _showCustomDialog(context, selectedMenu);
                                   }
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                     decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.appMutedColor,
                                    ),
                                    child: Icon(
                                      Icons.more_vert_rounded,
                                      color: AppColors.appIconColor,
                                    ),
                                  ),
                              ),

                            const SizedBox(height: 10),

                            // Action Buttons (Bells/etc)
                            if (result?.actionButton != null)
                              ...result!.actionButton!.map((btn) => Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    bool hasApi = btn.apiEndpoint != null && btn.apiEndpoint!.isNotEmpty;
                                    bool hasNextPage = btn.nextPageName != null && btn.nextPageName!.isNotEmpty;
                                    bool hasNextApi = btn.nextPageApiEndpoint != null && btn.nextPageApiEndpoint!.isNotEmpty;
                                    bool hasNextView = btn.nextPageViewType != null && btn.nextPageViewType!.isNotEmpty;

                                    bool hasConfirmData =
                                        (btn.title != null && btn.title!.isNotEmpty) &&
                                        (btn.description != null && btn.description!.isNotEmpty);


                                    // RULE 1: Favorite → direct api
                                    if (hasApi &&
                                        !hasNextPage &&
                                        !hasNextApi &&
                                        !hasNextView &&
                                        !hasConfirmData) {
                                      print("Rule 1 → Direct API");
                                      await getPostDetailsController.actionButtonAction(btn.apiEndpoint!);
                                      return;
                                    }

                                    // RULE 2: Edit → call next api → navigate
                                    if (!hasApi &&
                                        hasNextPage &&
                                        hasNextApi &&
                                        !hasConfirmData) {
                                      print("Rule 2 → Next API + Navigate");
                                      await Get.put(PostFormController()).getPostForm(
                                          endpoint: btn.nextPageApiEndpoint,
                                          isEditMode: true);
                                      CustomNavigator.navigate(btn.nextPageName);
                                      return;
                                    }

                                    // RULE 3: Confirm → show dialog
                                    if (!hasNextPage &&
                                        !hasNextApi &&
                                        !hasNextView &&
                                        hasConfirmData) {
                                      print("Rule 3 → Confirm dialog");
                                      _showCustomDialog(context, btn);
                                      return;
                                    }

                                    print("No matching rule");
                                  },


                                  child: Container(
                                     padding: const EdgeInsets.all(8.0),
                                     decoration: BoxDecoration(
                                       shape: BoxShape.circle,
                                       color: AppColors.appMutedColor,
                                     ),
                                     child: _getIconForMenu(btn.icon),
                                   ),
                                ),
                              )).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: RefreshIndicator(
            color: AppColors.appButtonColor,
            onRefresh: () async {
              await getPostDetailsController.getPostDetails(widget.ukey ?? '');
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                      (BuildContext context, int index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: AppColors.appPagecolor,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            info?.title ?? '',
                                            maxLines: 2,
                                            style: AppTextStyle.title(
                                                color: AppColors.appTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Builder(
                                          builder: (context) {
                                            String? countdownStr = info?.countdownDt;
                                            Duration remaining = Duration.zero;
                                            if (countdownStr != null && countdownStr.isNotEmpty) {
                                              try {
                                                final target = DateTime.parse(countdownStr);
                                                final now = DateTime.now();
                                                final diff = target.difference(now);
                                                if (!diff.isNegative) {
                                                  remaining = diff;
                                                }
                                              } catch (e) {
                                                debugPrint("Error parsing countdown date: $e");
                                              }
                                            }

                                            if (remaining.inSeconds > 0) {
                                              return SlideCountdownSeparated(
                                                duration: remaining,
                                                separatorType: SeparatorType.symbol,
                                                separatorStyle: AppTextStyle.body(color: Colors.transparent),
                                                decoration: BoxDecoration(
                                                  color: AppColors.appButtonColor,
                                                  borderRadius: BorderRadius.circular(3.0),
                                                ),
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        const Icon(
                                          IconlyBold.star,
                                          color: Colors.amber,
                                          size: 18.0,
                                        ),
                                        const SizedBox(width: 5.0),
                                        
                                        Text("${info?.ratingReview ?? 0}",  style: AppTextStyle.description(
                                            color: AppColors.appTitleColor)),
                                        const SizedBox(width: 8.0),
                                        if(info?.badge !=null)
                                        Container(
                                          height: 20.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            gradient: AppColors.appPagecolor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.appMutedColor,
                                                blurRadius: 3,
                                                spreadRadius: 1,
                                                offset: Offset(0, 4),
                                              ),
                                            ],

                                          ),
                                          child: Center(
                                            child:
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10,right: 10),
                                              child: Text(" ${info?.badge ?? ''}",style: AppTextStyle.body(),),
                                            ),
                                          ),
                                        ),
                                        // RichText(
                                        //   text: TextSpan(
                                        //     text: '${info?.dynamicValues['avg_rating'] ?? 0.0} ',
                                        //     style: AppTextStyle.description(
                                        //         color: AppColors.appTitleColor),
                                        //     children: [
                                        //       TextSpan(
                                        //         text: ,
                                        //         style: AppTextStyle.description(
                                        //             color: AppColors.appDescriptionColor),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        const Spacer(),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          '₹${info?.price ?? ''}',
                                          maxLines: 1,
                                          style: AppTextStyle.title(
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 10,
                                      leading: CircleAvatar(
                                        radius: 22.0,
                                        backgroundImage: NetworkImage(postOwner?.dp ?? profileImagePath),
                                      ),
                                      title: Text(
                                        postOwner?.name ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyle.title(
                                            color: AppColors.appTitleColor, fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: RichText(
                                        text: TextSpan(
                                          text: '${postOwner?.label ?? ''} ',
                                          style: AppTextStyle.body(
                                              color: AppColors.appBodyTextColor),
                                          children: [
                                            TextSpan(
                                              text: '(${postOwner?.viewLabel ?? ''})',
                                              style: AppTextStyle.body(
                                                  color: AppColors.appLinkColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: AppColors.appMutedColor,
                                    ),
                                    const SizedBox(height: 5.0),
                                    // HTML Content at the top
                                    if (htmlDetails?.html != null && htmlDetails!.html!.isNotEmpty) ...[
                                      Text(
                                        htmlDetails.label ?? '',
                                        maxLines: 1,
                                        style: AppTextStyle.title(
                                            color: AppColors.appTitleColor),
                                      ),
                                      const SizedBox(height: 5.0),
                                      CustomHtmlViewer(htmlContent: htmlDetails.html!),
                                      const SizedBox(height: 15.0),
                                    ],
                                    // Recent View Section
                                    // if (recentViewedList.isNotEmpty) ...[
                                    //   const SizedBox(height: 20.0),
                                    //   Row(
                                    //     children: [
                                    //       Text(
                                    //         'Recent Viewed',
                                    //         style: AppTextStyle.title(
                                    //             color: AppColors.appTitleColor),
                                    //       ),
                                    //       const Spacer(),
                                    //       GestureDetector(
                                    //         onTap: () => const RecentlyPost().launch(context),
                                    //         child: Text(
                                    //           'View All',
                                    //           style: AppTextStyle.description(
                                    //               color: AppColors.appLinkColor),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    //   const SizedBox(height: 10.0),
                                    //
                                    //   const SizedBox(height: 20.0),
                                    // ],
                                     SizedBox(height: 15.0),

                                    if (detailsTabs != null && detailsTabs.isNotEmpty)
                                    Container(
                                      height:270.h,
                                      decoration: BoxDecoration(
                                        gradient: AppColors.appPagecolor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.appMutedColor,
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: DefaultTabController(
                                        length: detailsTabs.length,
                                        child: Column(
                                          children: [
                                             TabBar(
                                              isScrollable: true,
                                              tabAlignment: TabAlignment.start,
                                              unselectedLabelColor: AppColors.appDescriptionColor,
                                              indicatorSize: TabBarIndicatorSize.tab,
                                              indicator: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(8.0),
                                                  topLeft: Radius.circular(8.0),
                                                ),
                                                color: AppColors.appColor,
                                              ),
                                              labelColor: AppColors.appWhite,
                                              tabs: detailsTabs.map((tab) {
                                                return Tab(text: tab.label ?? '');
                                              }).toList(),
                                            ),
                                             Divider(
                                              height: 0,
                                              thickness: 1.0,
                                              color: AppColors.appMutedColor,
                                            ),
                                              Expanded(
                                                child: Builder(
                                                  builder: (context) {
                                                    final tabController = DefaultTabController.of(context);
                                                    return AnimatedBuilder(
                                                      animation: tabController,
                                                      builder: (context, child) {
                                                        final int currentIndex = tabController.index;
                                                        final tab = detailsTabs[currentIndex];
                                                        return Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: SingleChildScrollView(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                              children: [
                                                                ...tab.values.entries
                                                                    .where((e) => !['price', 'label', 'icon'].contains(e.key))
                                                                    .map((e) {
                                                                  return Container(
                                                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                                                    child: Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          height: 20,
                                                                          width: 20,
                                                                          decoration: BoxDecoration(
                                                                            shape: BoxShape.circle,
                                                                            color: AppColors.appMutedColor,
                                                                            image: (tab.icon != null && tab.icon!.startsWith('http'))
                                                                                ? DecorationImage(
                                                                              image: NetworkImage(tab.icon!),
                                                                              fit: BoxFit.cover,
                                                                            )
                                                                                : null,
                                                                          ),
                                                                          child: (tab.icon == null || !tab.icon!.startsWith('http'))
                                                                              ? Icon(
                                                                            Icons.notifications_active_outlined,
                                                                            color: AppColors.appIconColor,
                                                                            size: 16,
                                                                          )
                                                                              : null,
                                                                        ),
                                                                         SizedBox(width: 5.w),
                                                                        Expanded(
                                                                          child: Text(
                                                                            e.value.toString(),
                                                                            style: AppTextStyle.description(
                                                                              color: AppColors.appTitleColor,
                                                                            ),
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );

                                                                }).toList(),
                                                                // const SizedBox(height: 10.0),
                                                                // Builder(
                                                                //   builder: (context) {
                                                                //      // Logic to determine if button is highlighted or primary
                                                                //      // Assuming false locally or usage of a controller value if needed.
                                                                //      // User code had 'isHighlighted' undefined. Using default style for now.
                                                                //      bool isHighlighted = false;
                                                                //      return ButtonGlobalWithoutIcon(
                                                                //         buttontext: 'Select Offer',
                                                                //         buttonDecoration: kButtonDecoration.copyWith(
                                                                //           color: isHighlighted
                                                                //               ? AppColors.appButtonTextColor
                                                                //               : AppColors.appButtonColor,
                                                                //           border: isHighlighted
                                                                //               ? null
                                                                //               : Border.all(color: AppColors.appColor),
                                                                //           borderRadius: BorderRadius.circular(30.0),
                                                                //         ),
                                                                //         onPressed: () {},
                                                                //         buttonTextColor: isHighlighted
                                                                //             ? AppColors.appButtonColor
                                                                //             : AppColors.appButtonTextColor,
                                                                //       );
                                                                //   }
                                                                // ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ) 
                                    else
                                       // Fallback or Empty
                                       const Text("No Pricing Plans Available"),
                                    

                                    const SizedBox(height: 15.0),
                                    // const SizedBox(height: 15.0),
                                    Builder(
                                      builder: (context) {
                                        final othersList = result?.others;
                                        
                                        if (othersList == null || othersList.isEmpty) {
                                          return const SizedBox.shrink();
                                        }

                                        return Column(
                                          children: othersList.map((section) {
                                            final viewType = section.viewType ?? '';
                                            final String? rawEndpoint = section.apiEndpoint;

                                            // 🔹 Pre-defined Post Lists (Lists, Grids)
                                            if (viewType == 'custom_vertical_listview_list' ||
                                                viewType == 'custom_horizontal_listview_list' ||
                                                viewType == 'custom_vertical_gridview_list' ||
                                                viewType == 'custom_horizontal_gridview_list') {

                                              // 🔹 Create unique controller for this section if it has an endpoint
                                              AppPostController? sectionController;
                                              if (section.apiEndpoint != null &&
                                                  section.apiEndpoint!.isNotEmpty) {
                                                final tag = section.apiEndpoint!;
                                                if (!Get.isRegistered<AppPostController>(tag: tag)) {
                                                  sectionController = Get.put(AppPostController(), tag: tag);
                                                } else {
                                                  sectionController = Get.find<AppPostController>(tag: tag);
                                                }
                                              }

                                              // Trigger fetch if needed
                                              if (sectionController != null && 
                                                  sectionController.getPostForHomeResponseModel.value == null && 
                                                  !sectionController.isLoading.value) {
                                                   print("🔄 Fetching data for endpoint: $rawEndpoint");
                                                   Future.microtask(() {
                                                     // Only fetch if still needed (double check inside microtask)
                                                     if (sectionController!.getPostForHomeResponseModel.value == null && !sectionController.isLoading.value) {
                                                       sectionController.getPostListForHomeScreen(endpoint: rawEndpoint).then((_) {
                                                         sectionController!.update();
                                                       });
                                                     }
                                                   });
                                              }

                                              return Obx(() {
                                                final controllerToWatch = sectionController ?? Get.find<AppPostController>(); // Fallback
                                                final isLoading = controllerToWatch.isLoading.value;
                                                final model = sectionController != null
                                                    ? controllerToWatch.getPostForHomeResponseModel.value
                                                    : controllerToWatch.getPostListResponseModel.value;

                                                if (!isLoading && (model?.result == null || (model?.result?.isEmpty ?? true))) {
                                                  return const SizedBox.shrink(); // Hide if empty
                                                }

                                                return CustomViewWidget(
                                                  type: viewType,
                                                  controller: controllerToWatch,
                                                  useHomeModel: sectionController != null,
                                                  onFavoriteToggle: (index, isFav) {},
                                                  bgColor: section.bgColor,
                                                  bgImg: section.bgImg,
                                                  label: section.label,
                                                  viewAllLabel: section.viewAllLabel,
                                                  viewAllNextPage: section.viewAllNextPage,
                                                  nextPageName: section.nextPageName,
                                                  nextPageViewType: section.nextPageViewType,
                                                );
                                              });
                                            }

                                            // 🔹 Banners
                                            if (viewType == 'custom_banner') {
                                                if (rawEndpoint != null && rawEndpoint.isNotEmpty) {
                                                   final tag = rawEndpoint;
                                                   final bannerController = Get.isRegistered<AppPostController>(tag: tag)
                                                       ? Get.find<AppPostController>(tag: tag)
                                                       : Get.put(AppPostController(), tag: tag);

                                                   if (bannerController.getPostForHomeResponseModel.value == null && !bannerController.isLoading.value) {
                                                      Future.microtask(() {
                                                        if (bannerController.getPostForHomeResponseModel.value == null && !bannerController.isLoading.value) {
                                                            bannerController.getPostListForHomeScreen(endpoint: rawEndpoint);
                                                        }
                                                      });
                                                   }

                                                   return Obx(() {
                                                      final model = bannerController.getPostForHomeResponseModel.value;
                                                      if (bannerController.isLoading.value) return const SizedBox.shrink();
                                                      if (model?.result == null || model!.result!.isEmpty) return const SizedBox.shrink();

                                                       // Convert all values to String to ensure Map<String, String> compatibility
                                                       // Map from Result (Post List Model) to Banner Item generic map
                                                       // Note: Result does not have 'filePath' or 'actionUrl'. We must extract from 'media', 'info' or 'details'.
                                                       final bannerItems = model.result!.map((b) {
                                                         final mediaItem = (b.media != null && b.media!.isNotEmpty) ? b.media!.first : null;
                                                         // Attempt to find action/redirect url in info or details
                                                         final actionUrl = b.info?['action_url'] ?? b.info?['redirect_url'] ?? b.details?['action_url'] ?? '';
                                                         
                                                         return {
                                                           'image': mediaItem?.url?.toString() ?? '',
                                                           'redirectUrl': actionUrl.toString(),
                                                           'type': mediaItem?.mediaType?.toString() ?? ''
                                                         };
                                                       }).toList();

                                                       return CustomViewWidget(
                                                          type: 'custom_banner',
                                                          bannerItems: bannerItems,
                                                          bannerLoading: bannerController.isLoading,
                                                       );
                                                   });
                                                }
                                            }

                                            // 🔹 Default / Other types
                                            return CustomViewWidget(
                                              type: viewType,
                                              title: section.title,
                                              bgColor: section.bgColor,
                                              bgImg: section.bgImg,
                                              label: section.label,
                                              viewAllLabel: section.viewAllLabel,
                                              viewAllNextPage: section.viewAllNextPage,
                                              nextPageName: section.nextPageName,
                                              nextPageViewType: section.nextPageViewType,
                                            );
                                          }).toList(),
                                        );
                                      }
                                    ),


                                    // Text(
                                    //   'Reviews',
                                    //   maxLines: 1,
                                    //   style: AppTextStyle.title(
                                    //       color: AppColors.appTitleColor),
                                    // ),
                                    // const SizedBox(height: 15.0),
                                    // const SizedBox(height: 20.0),
                                    // Container(
                                    //   height: 40.h,
                                    //   decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(30.0),
                                    //       color: AppColors.appButtonColor
                                    //   ),
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: [
                                    //       Text(
                                    //         'View all reviews',
                                    //         maxLines: 1,
                                    //         style: AppTextStyle.description(
                                    //             color: AppColors.appButtonTextColor),
                                    //       ),
                                    //       Icon(
                                    //         FeatherIcons.chevronDown,
                                    //         color: AppColors.appButtonTextColor,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          ),
        ),
      );
      }),
    );
  }

  Widget _getIconForMenu(String? iconName) {
      if (iconName == null) return Icon(Icons.circle, size: 10, color: AppColors.appIconColor);
      
      if (iconName.startsWith('http')) {
        return Image.network(
          iconName,
          width: 20,
          height: 20,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 20, color: AppColors.appIconColor),
        );
      }

      if (iconName.contains('chat')) return Icon(IconlyBold.chat, color: AppColors.appIconColor);
      if (iconName.contains('edit')) return Icon(IconlyBold.edit, color: AppColors.appIconColor);
      if (iconName.contains('share')) return Icon(IconlyBold.send, color: AppColors.appIconColor);
      if (iconName.contains('report')) return Icon(IconlyBold.danger, color: AppColors.appIconColor);
       return Icon(Icons.circle, size: 10, color: AppColors.appIconColor);
  }
}