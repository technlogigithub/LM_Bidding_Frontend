import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../core/app_color.dart';
import '../../core/app_string.dart';
import '../../core/api_config.dart';
import '../../core/app_constant.dart';
import '../../models/static models/service_items_model.dart';
import '../../widget/button_global.dart';
import '../../widget/custom_horizontal_listview_list.dart';
import '../../widget/custom_html_viewer.dart';
import '../view/post_details_service/bidding_sheet.dart';
import '../view/post_details_service/post_order.dart';
import 'custom_view_widget.dart';
import 'custom_banner_with_video.dart';
import '../view/Home_screen/recently_post_screen.dart';
import '../../controller/post/get_post_details_controller.dart';
import '../../models/Post/Get_Post_details_Model.dart';
import '../../controller/post/app_post_controller.dart';



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
  double height = 200;
  bool isFavorite = false;
  List<dynamic> notifications = [];
  bool isLoading = true;

  // Static Data
  final String profileImagePath = 'https://i.pravatar.cc/150?img=3';
  final String status = 'bidding';


  final List<ServiceItem> recentViewedList = [
    ServiceItem(
      imagePath: "https://picsum.photos/300/200?4",
      title: "Logo Design",
      rating: 4.5,
      reviewCount: 120,
      price: 299,
      profileImagePath: "https://i.pravatar.cc/150?img=11",
      sellerName: "Rahul Graphics",
      sellerLevel: "Top Rated",
      isFavorite: false,
    ),
    ServiceItem(
      imagePath: "https://picsum.photos/300/200?5",
      title: "Website UI",
      rating: 4.8,
      reviewCount: 210,
      price: 999,
      profileImagePath: "https://i.pravatar.cc/150?img=12",
      sellerName: "Aman Studio",
      sellerLevel: "Level 2 Seller",
      isFavorite: true,
    ),
  ];


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

  void toggleFavorite(int index, bool newValue) {
    recentViewedList[index].isFavorite.value = newValue;
  }




  @override
  Widget build(BuildContext context) {
    return Container(
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
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              gradient: AppColors.appPagecolor
          ),
          child: Builder(
            builder: (context) {
              String buttonText = '';
              VoidCallback? onPressed;
              bool useGradient = false;

              switch (status) {
                case 'before_pay':
                  buttonText = 'Participate';
                  useGradient = false;
                  onPressed = () {
                    const PostOrderScreen().launch(context);
                  };
                  break;

                case 'waiting':
                  buttonText = 'Waiting';
                  useGradient = true;
                  onPressed = null;
                  break;

                case 'bidding':
                  buttonText = 'Bid Now';
                  useGradient = true;
                  onPressed = () {
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
                        child: const BidBottomSheet(),
                      ),
                    );
                  };
                  break;

                case 'closed':
                  buttonText = 'Closed';
                  useGradient = false;
                  onPressed = null;
                  break;
              }

              return ButtonGlobalWithoutIcon(
                buttontext: buttonText,
                buttonDecoration: kButtonDecoration.copyWith(
                  borderRadius: BorderRadius.circular(30.0),
                  color: AppColors.appButtonColor,
                ),
                onPressed: onPressed,
                buttonTextColor: AppColors.appButtonTextColor,
              );
            },
          ),
        ),

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
                leading: _isShrink
                    ? GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.appIconColor,
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
                  background: SafeArea(
                    child: Stack(
                      children: [
                        CustomViewWidget(
                          type: media?.viewType ?? 'custom_banner_with_video',
                          bannerItems: dynamicMediaItems,
                          height: 290,
                          bannerLoading: false.obs,
                        ),
                        // Action Buttons & Menu Button positions
                        Positioned(
                          top: 10,
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
                                     toast("Selected: $value"); 
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
                                    onTap: () => toast(btn.label),
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
              ),
            ];
          },
          body: CustomScrollView(
            // physics: const BouncingScrollPhysics(),
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

                                    Text(
                                      info?.title ?? '',
                                      maxLines: 2,
                                      style: AppTextStyle.title(
                                          color: AppColors.appTitleColor, fontWeight: FontWeight.bold),
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
                                              text: '(${postOwner?.viewLabel ?? 'View Profile'})',
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
                                        htmlDetails.label ?? 'Description',
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
                                    const SizedBox(height: 15.0),
                                    Text(
                                      'Price',
                                      maxLines: 1,
                                      style: AppTextStyle.title(
                                          color: AppColors.appTitleColor),
                                    ),
                                    const SizedBox(height: 10.0),
                                    if (detailsTabs != null && detailsTabs.isNotEmpty)
                                    Container(
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
                                      child: Column(
                                        children: [
                                          // NOTE: TabBar needs a TabController with correct length. 
                                          // Since data is dynamic, we need to ensure the existing tabController is updated or create a new one.
                                          // For simplicity in this step, I'll rebuild the DefaultTabController or just handle it 
                                          // This part requires careful handling if TabController was initialized in initState.
                                          // A better approach for dynamic tabs is DefaultTabController.
                                          DefaultTabController(
                                            length: detailsTabs.length,
                                            child: Column(
                                              children: [
                                                 TabBar(
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
                                                    return Tab(text: tab.label ?? 'Plan');
                                                  }).toList(),
                                                ),
                                                 Divider(
                                                  height: 0,
                                                  thickness: 1.0,
                                                  color: AppColors.appMutedColor,
                                                ),
                                                  Builder(
                                                    builder: (context) {
                                                      final tabController = DefaultTabController.of(context);
                                                      return AnimatedBuilder(
                                                        animation: tabController,
                                                        builder: (context, child) {
                                                          final int currentIndex = tabController.index;
                                                          final tab = detailsTabs[currentIndex];
                                                          return Padding(
                                                            padding: const EdgeInsets.all(10.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                              children: [
                                                                ...tab.values.entries
                                                                    .where((e) => !['price', 'label', 'icon'].contains(e.key))
                                                                    .map((e) {
                                                                      return ListTile(
                                                                        contentPadding: EdgeInsets.zero,
                                                                        leading: Container(
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
                                                                              ? Icon(Icons.notifications_active_outlined, color: AppColors.appIconColor, size: 20)
                                                                              : null,
                                                                        ),
                                                                        title: Text(
                                                                          e.value.toString(),
                                                                          style: AppTextStyle.description(color: AppColors.appTitleColor),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                const SizedBox(height: 10.0),
                                                                Builder(
                                                                  builder: (context) {
                                                                     // Logic to determine if button is highlighted or primary
                                                                     // Assuming false locally or usage of a controller value if needed.
                                                                     // User code had 'isHighlighted' undefined. Using default style for now.
                                                                     bool isHighlighted = false;
                                                                     return ButtonGlobalWithoutIcon(
                                                                        buttontext: 'Select Offer',
                                                                        buttonDecoration: kButtonDecoration.copyWith(
                                                                          color: isHighlighted
                                                                              ? AppColors.appButtonTextColor
                                                                              : AppColors.appButtonColor,
                                                                          border: isHighlighted
                                                                              ? null
                                                                              : Border.all(color: AppColors.appColor),
                                                                          borderRadius: BorderRadius.circular(30.0),
                                                                        ),
                                                                        onPressed: () {},
                                                                        buttonTextColor: isHighlighted
                                                                            ? AppColors.appButtonColor
                                                                            : AppColors.appButtonTextColor,
                                                                      );
                                                                  }
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ) 
                                    else
                                       // Fallback or Empty
                                       const Text("No Pricing Plans Available"),
                                    

                                    const SizedBox(height: 15.0),
                                    const SizedBox(height: 15.0),
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
                                                   sectionController.getPostListForHomeScreen(endpoint: rawEndpoint).then((_) {
                                                      sectionController!.update();
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
                                                      bannerController.getPostListForHomeScreen(endpoint: rawEndpoint);
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
                                                           'type': mediaItem?.mediaType?.toString() ?? 'image' 
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