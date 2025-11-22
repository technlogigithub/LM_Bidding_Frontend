import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../core/app_color.dart';
import '../../core/app_string.dart';
import '../../core/api_config.dart';
import '../../core/app_constant.dart';
import '../../core/app_constant.dart' as AppTextStyle;
import '../../models/static models/service_items_model.dart';
import '../../widget/button_global.dart';
import '../../widget/custom_horizontal_listview_list.dart';
import '../../widget/custom_html_viewer.dart';
import 'custom_banner_with_video.dart';
import '../view/Home_screen/recently_view.dart';
import '../view/client service details/bidding_sheet.dart';
import '../view/client service details/client_order.dart';

class CustomDetailScreen extends StatefulWidget {
  final String title;
  final double rating;
  final int reviewCount;
  final int favoriteCount;
  final String sellerName;
  final String sellerLevel;
  final String profileImagePath;
  final String description;
  final String status;
  final List<String> mediaUrls;
  final String htmlContent;
  final List<Map<String, dynamic>> pricingPlans;
  final List<Map<String, dynamic>> reviews;
  final List<ServiceItem> recentViewedList;

  const CustomDetailScreen({
    super.key,
    required this.title,
    required this.rating,
    required this.reviewCount,
    required this.favoriteCount,
    required this.sellerName,
    required this.sellerLevel,
    required this.profileImagePath,
    required this.description,
    required this.status,
    required this.mediaUrls,
    required this.htmlContent,
    required this.pricingPlans,
    required this.recentViewedList,
    required this.reviews,
  });

  @override
  State<CustomDetailScreen> createState() => _CustomDetailScreenState();
}

class _CustomDetailScreenState extends State<CustomDetailScreen> with TickerProviderStateMixin {
  PageController pageController = PageController(initialPage: 0);
  TabController? tabController;
  ScrollController? _scrollController;
  bool lastStatus = false;
  double height = 200;
  bool isFavorite = false;
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    tabController = TabController(length: widget.pricingPlans.length, vsync: this);

    // Fetch orders
    fetchOrders();
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

  Future<void> fetchOrders() async {
    try {
      final res = await ApiService.getRequest("ordersApi");
      setState(() {
        notifications = res["data"] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      toast("Error: $e");
    }
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    tabController?.dispose();
    super.dispose();
  }

  void toggleFavorite(int index, bool newValue) {
    setState(() {
      widget.recentViewedList[index].isFavorite;
    });
  }

  List<Map<String, dynamic>> _buildMediaItems() {
    // Separate videos first, then images as per requirement
    final videoItems = widget.mediaUrls
        .where((url) => url.endsWith('.mp4') || url.endsWith('.mov') || url.endsWith('.avi'))
        .map((url) => {'type': 'video', 'url': url})
        .toList();
    final imageItems = widget.mediaUrls
        .where((url) => !(url.endsWith('.mp4') || url.endsWith('.mov') || url.endsWith('.avi')))
        .map((url) => {'type': 'image', 'url': url, 'redirectUrl': null})
        .toList();
    return [...videoItems, ...imageItems];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Builder(
          builder: (context) {
            String buttonText = '';
            Color buttonColor = AppColors.neutralColor;
            VoidCallback? onPressed;

            switch (widget.status) {
              case 'before_pay':
                buttonText = 'Participate';
                buttonColor = AppColors.neutralColor;
                onPressed = () {
                  const ClientOrder().launch(context);
                };
                break;
              case 'waiting':
                buttonText = 'Waiting';
                buttonColor = AppColors.appColor;
                onPressed = null;
                break;
              case 'bidding':
                buttonText = 'Bid Now';
                buttonColor = AppColors.appColor;
                onPressed = () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => const BidBottomSheet(),
                  );
                };
                break;
              case 'closed':
                buttonText = 'Closed';
                buttonColor = AppColors.textgrey;
                onPressed = null;
                break;
            }

            return ButtonGlobalWithoutIcon(
              buttontext: buttonText,
              buttonDecoration: kButtonDecoration.copyWith(
                color: buttonColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
              onPressed: onPressed,
              buttonTextColor: AppColors.appWhite,
            );
          },
        ),
        backgroundColor: AppColors.appWhite,
        body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                elevation: 0,
                backgroundColor: _isShrink ? AppColors.appWhite : Colors.transparent,
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
                    color: AppColors.neutralColor,
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
                        color: AppColors.appWhite,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.neutralColor,
                      ),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: SafeArea(
                    child: CustomBannerWithVideo(
                      mediaItems: _buildMediaItems(),
                      height: 290,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: 0,
                    ),
                  ),
                ),
              ),
            ];
          },
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
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
                            color: AppColors.appWhite,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title,
                                      maxLines: 2,
                                      style: kTextStyle.copyWith(
                                          color: AppColors.neutralColor, fontWeight: FontWeight.bold),
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
                                        RichText(
                                          text: TextSpan(
                                            text: '${widget.rating} ',
                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
                                            children: [
                                              TextSpan(
                                                text: '(${widget.reviewCount} Reviews)',
                                                style: kTextStyle.copyWith(color: AppColors.textgrey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.favorite,
                                          color: AppColors.appColor,
                                          size: 18.0,
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          '${widget.favoriteCount}',
                                          maxLines: 1,
                                          style: kTextStyle.copyWith(color: AppColors.textgrey),
                                        ),
                                      ],
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 10,
                                      leading: CircleAvatar(
                                        radius: 22.0,
                                        backgroundImage: NetworkImage(widget.profileImagePath),
                                      ),
                                      title: Text(
                                        widget.sellerName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: kTextStyle.copyWith(
                                            color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: RichText(
                                        text: TextSpan(
                                          text: '${widget.sellerLevel} ',
                                          style: kTextStyle.copyWith(color: AppColors.neutralColor),
                                          children: [
                                            TextSpan(
                                              text: '(View Profile)',
                                              style: kTextStyle.copyWith(color: AppColors.appColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: AppColors.kBorderColorTextField,
                                    ),
                                    const SizedBox(height: 5.0),
                                    // HTML Content at the top
                                    if (widget.htmlContent.isNotEmpty) ...[
                                      Text(
                                        'Description',
                                        maxLines: 1,
                                        style: kTextStyle.copyWith(
                                            color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5.0),
                                      CustomHtmlViewer(htmlContent: widget.htmlContent),
                                      const SizedBox(height: 15.0),
                                    ],
                                    // Recent View Section
                                    if (widget.recentViewedList.isNotEmpty) ...[
                                      const SizedBox(height: 20.0),
                                      Row(
                                        children: [
                                          Text(
                                            'Recent Viewed',
                                            style: kTextStyle.copyWith(
                                                color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () => const RecentlyView().launch(context),
                                            child: Text(
                                              'View All',
                                              style: kTextStyle.copyWith(color: AppColors.textgrey),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      CustomHorizontalListViewList(
                                        items: widget.recentViewedList,
                                        onFavoriteToggle: toggleFavorite,
                                        isLoading: false.obs,
                                      ),
                                      const SizedBox(height: 20.0),
                                    ],
                                    const SizedBox(height: 15.0),
                                    Text(
                                      'Price',
                                      maxLines: 1,
                                      style: kTextStyle.copyWith(
                                          color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.appWhite,
                                        border: Border.all(color: AppColors.kBorderColorTextField),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Column(
                                        children: [
                                          TabBar(
                                            unselectedLabelColor: AppColors.subTitleColor,
                                            indicatorSize: TabBarIndicatorSize.tab,
                                            indicator: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(8.0),
                                                topLeft: Radius.circular(8.0),
                                              ),
                                              color: AppColors.appColor,
                                            ),
                                            controller: tabController,
                                            labelColor: AppColors.appWhite,
                                            tabs: widget.pricingPlans
                                                .map((plan) => Tab(text: plan['name']))
                                                .toList(),
                                          ),
                                          Divider(
                                            height: 0,
                                            thickness: 1.0,
                                            color: AppColors.kBorderColorTextField,
                                          ),
                                          SizedBox(
                                            height: 400,
                                            child: TabBarView(
                                              controller: tabController,
                                              children: widget.pricingPlans.map((plan) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${AppStrings.currencySign}${plan['price']}',
                                                        style: kTextStyle.copyWith(
                                                            color: AppColors.neutralColor,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Text(
                                                        plan['description'],
                                                        maxLines: 2,
                                                        style: kTextStyle.copyWith(
                                                            color: AppColors.neutralColor,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 15.0),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            IconlyLight.timeCircle,
                                                            color: AppColors.appColor,
                                                            size: 18.0,
                                                          ),
                                                          const SizedBox(width: 5.0),
                                                          Text(
                                                            'Delivery days',
                                                            maxLines: 1,
                                                            style: AppTextStyle.kTextStyle.copyWith(
                                                              color: AppColors.subTitleColor,
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Text(
                                                            '${plan['deliveryDays']} Days',
                                                            maxLines: 2,
                                                            style: kTextStyle.copyWith(
                                                                color: AppColors.neutralColor),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 10.0),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.loop,
                                                            color: AppColors.appColor,
                                                            size: 18.0,
                                                          ),
                                                          const SizedBox(width: 5.0),
                                                          Text(
                                                            'Revisions',
                                                            maxLines: 1,
                                                            style: AppTextStyle.kTextStyle.copyWith(
                                                              color: AppColors.subTitleColor,
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Text(
                                                            plan['revisions'],
                                                            maxLines: 2,
                                                            style: kTextStyle.copyWith(
                                                                color: AppColors.neutralColor),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 15.0),
                                                      Divider(
                                                        height: 0,
                                                        thickness: 1.0,
                                                        color: AppColors.kBorderColorTextField,
                                                      ),
                                                      const SizedBox(height: 15.0),
                                                      ...plan['features'].map<Widget>((feature) {
                                                        return Padding(
                                                          padding: const EdgeInsets.only(bottom: 5.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                feature['name'],
                                                                maxLines: 1,
                                                                style: kTextStyle.copyWith(
                                                                    color: feature['included']
                                                                        ? AppColors.neutralColor
                                                                        : AppColors.textgrey),
                                                              ),
                                                              const Spacer(),
                                                              Icon(
                                                                Icons.check_rounded,
                                                                color: feature['included']
                                                                    ? AppColors.appColor
                                                                    : AppColors.textgrey,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }).toList(),
                                                      const SizedBox(height: 10.0),
                                                      ButtonGlobalWithoutIcon(
                                                        buttontext: 'Select Offer',
                                                        buttonDecoration: kButtonDecoration.copyWith(
                                                          color: plan['isHighlighted']
                                                              ? AppColors.appColor
                                                              : AppColors.appWhite,
                                                          border: plan['isHighlighted']
                                                              ? null
                                                              : Border.all(color: AppColors.appColor),
                                                          borderRadius: BorderRadius.circular(30.0),
                                                        ),
                                                        onPressed: () {},
                                                        buttonTextColor: plan['isHighlighted']
                                                            ? AppColors.appWhite
                                                            : AppColors.appColor,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Text(
                                      'Reviews',
                                      maxLines: 1,
                                      style: kTextStyle.copyWith(
                                          color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 15.0),
                                    // ...widget.reviews.map((review) => Padding(
                                    //   padding: const EdgeInsets.only(bottom: 15.0),
                                    //   child: Review(
                                    //     rating: review['rating'],
                                    //     comment: review['comment'],
                                    //     reviewerName: review['reviewerName'],
                                    //     date: review['date'],
                                    //   ),
                                    // )),
                                    const SizedBox(height: 20.0),
                                    Container(
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30.0),
                                          border: Border.all(color: AppColors.subTitleColor)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'View all reviews',
                                            maxLines: 1,
                                            style: AppTextStyle.kTextStyle.copyWith(
                                              color: AppColors.subTitleColor,
                                            ),
                                          ),
                                          Icon(
                                            FeatherIcons.chevronDown,
                                            color: AppColors.subTitleColor,
                                          ),
                                        ],
                                      ),
                                    ),
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
  }
}