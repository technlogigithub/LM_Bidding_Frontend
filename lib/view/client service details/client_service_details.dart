import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../controller/home/home_controller.dart';
import '../../core/api_config.dart';
import '../../core/app_constant.dart';
import '../../core/app_constant.dart' as AppTextStyle;
import '../../models/static models/service_items_model.dart';
import '../../widget/button_global.dart';
import '../../widget/custom_horizontal_listview_list.dart';
import '../../widget/review.dart';
import '../Home_screen/recently_view.dart';
import 'bidding_sheet.dart';
import 'client_order.dart';

class ClientServiceDetails extends StatefulWidget {
  const ClientServiceDetails({super.key});

  @override
  State<ClientServiceDetails> createState() => _ClientServiceDetailsState();
}

class _ClientServiceDetailsState extends State<ClientServiceDetails> with TickerProviderStateMixin {
  PageController pageController = PageController(initialPage: 0);
  TabController? tabController;
  ScrollController? _scrollController;
  bool lastStatus = false;
  double height = 200;
  bool isFavorite = false;
  var recentViewedList = <ServiceItem>[].obs;

  void toggleFavorite(int index, bool newValue) {
      services[index].isFavorite = newValue;
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController != null && _scrollController!.hasClients && _scrollController!.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    recentViewedList.assignAll([
      ServiceItem(
        imagePath: 'assets/images/shot5.png',
        title: 'modern unique business logo design',
        rating: 5.0,
        reviewCount: 520,
        price: 30,
        profileImagePath: 'assets/images/profilepic2.png',
        sellerName: 'William Liam',
        sellerLevel: 'Seller Level - 1',
        isFavorite: true,
      ),
      ServiceItem(
        imagePath: 'assets/images/shot5.png',
        title: 'Website Design and Development',
        rating: 4.8,
        reviewCount: 320,
        price: 45,
        profileImagePath: 'assets/images/profilepic2.png',
        sellerName: 'Sarah Smith',
        sellerLevel: 'Seller Level - 2',
        isFavorite: true,
      ),
    ]);
    _scrollController = ScrollController()..addListener(_scrollListener);
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }
  String status = "bidding";

  // final CarouselController _controller = CarouselController();
  final CarouselSliderController _controller = CarouselSliderController();
 List<dynamic> notifications = [];
  bool isLoading = true;


  Future<void> fetchOrders() async {
    try {
      final res = await  ApiService.getRequest("ordersApi");
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      bottomNavigationBar: Builder(
  builder: (context) {
    String buttonText = '';
    Color buttonColor = AppColors.neutralColor;
    VoidCallback? onPressed;

    switch (status) {
      case 'before_pay': // Before pay and Before start Bid
        buttonText = 'Participate';
        buttonColor = AppColors.neutralColor;
        onPressed = () {
          const ClientOrder().launch(context);
        };
        break;

      case 'waiting': // After pay but before start Bid
        buttonText = 'Waiting';
        buttonColor = khaki; // your defined rating color
        onPressed = null; // Disabled
        break;

      case 'bidding': // After start bid till End Bid
        buttonText = 'Bid Now';
        buttonColor = AppColors.appColor;
        onPressed = () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const BidBottomSheet(),
          );
        };
        break;

      case 'closed': // After End Bid
        buttonText = 'Closed';
        buttonColor = AppColors.textgrey;
        onPressed = null; // Disabled
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
                    child: CarouselSlider.builder(
                      carouselController: _controller,
                      options: CarouselOptions(
                        height: 300,
                        aspectRatio: 18 / 18,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: false,
                        onPageChanged: (i, j) {
                          pageController.nextPage(duration: const Duration(microseconds: 1), curve: Curves.bounceIn);
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index, int realIndex) {
                        return Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                image: DecorationImage(image: AssetImage('assets/images/bg2.png'), fit: BoxFit.fitWidth),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SmoothPageIndicator(
                                  controller: pageController,
                                  count: 10,
                                  effect: JumpingDotEffect(
                                    dotHeight: 6.0,
                                    dotWidth: 6.0,
                                    jumpScale: .7,
                                    verticalOffset: 15,
                                    activeDotColor: AppColors.neutralColor,
                                    dotColor: AppColors.neutralColor.withValues(alpha: 0.4),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30.0),
                                        topLeft: Radius.circular(30.0),
                                      ),
                                      color: AppColors.appWhite),
                                )
                              ],
                            ),
                          ],
                        );
                      },
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
                            borderRadius: BorderRadius.only(
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


                                    /// HTML Tag Starting From Here Show we don't need to design from our side we just here need to handle html tags


                                    Text(
                                      'Mobile UI UX design or app UI UX design',
                                      maxLines: 2,
                                      style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
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
                                            text: '5.0 ',
                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
                                            children: [
                                              TextSpan(
                                                text: '(520 Reviews)',
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
                                          '807',
                                          maxLines: 1,
                                          style: kTextStyle.copyWith(color: AppColors.textgrey),
                                        )
                                      ],
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 10,
                                      leading: const CircleAvatar(
                                        radius: 22.0,
                                        backgroundImage: AssetImage('assets/images/profilepic2.png'),
                                      ),
                                      title: Text(
                                        'William Liam',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: RichText(
                                        text: TextSpan(
                                          text: 'Seller Level - 1 ',
                                          style: kTextStyle.copyWith(color: AppColors.neutralColor),
                                          children: [
                                            TextSpan(
                                              text: '(View Profile)',
                                              style: kTextStyle.copyWith(color: AppColors.appColor),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: AppColors.kBorderColorTextField,
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      'Details',
                                      maxLines: 1,
                                      style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5.0),
                                    ReadMoreText(
                                      'Lorem ipsum dolor sit amet consectetur. Tortor sapien aliquam amet elit. Quis varius amet grav ida molestie rhoncus. Lorem ipsum dolor sit amet consectetur. Tortor sapien aliquam amet elit. Quis varius amet grav ida molestie rhoncus.',
                                      style: kTextStyle.copyWith(color: AppColors.textgrey),
                                      trimLines: 3,
                                      colorClickableText: AppColors.appColor,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '..Read more',
                                      trimExpandedText: '..Read less',
                                    ),
                                    const SizedBox(height: 15.0),
                                    Text(
                                      'Price',
                                      maxLines: 1,
                                      style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
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
                                            indicator:  BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(8.0),
                                                topLeft: Radius.circular(8.0),
                                              ),
                                              color: AppColors.appColor,
                                            ),
                                            controller: tabController,
                                            labelColor: AppColors.appWhite,
                                            tabs: const [
                                              Tab(
                                                text: 'Basic',
                                              ),
                                              Tab(
                                                text: 'Standard',
                                              ),
                                              Tab(
                                                text: 'Premium',
                                              ),
                                            ],
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
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${AppStrings.currencySign}${30}',
                                                        style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Text(
                                                        'I can design the website with 6 pages.',
                                                        maxLines: 2,
                                                        style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
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
                                                            '5 Days ',
                                                            maxLines: 2,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
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
                                                            'Unlimited',
                                                            maxLines: 2,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
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
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '3 Page/Screen',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.appColor,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '2 Custom assets',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.textgrey),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.textgrey,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Responsive design',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.appColor,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Prototype',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.textgrey),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.textgrey,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Source file',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.appColor,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 10.0),
                                                      ButtonGlobalWithoutIcon(
                                                        buttontext: 'Select Offer',
                                                        buttonDecoration: kButtonDecoration.copyWith(
                                                          color: AppColors.appColor,
                                                          borderRadius: BorderRadius.circular(30.0),
                                                        ),
                                                        onPressed: () {},
                                                        buttonTextColor: AppColors.appWhite,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${AppStrings.currencySign}${60}',
                                                        style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Text(
                                                        'I can design the website with 6 pages.',
                                                        maxLines: 2,
                                                        style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
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
                                                            '5 Days ',
                                                            maxLines: 2,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
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
                                                            'Unlimited',
                                                            maxLines: 2,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
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
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '3 Page/Screen',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.appColor,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '2 Custom assets',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.textgrey),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.appColor,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Responsive design',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.appColor,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Prototype',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.textgrey),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.appColor,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Source file',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.appColor,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 10.0),
                                                      ButtonGlobalWithoutIcon(
                                                        buttontext: 'Select Offer',
                                                        buttonDecoration: kButtonDecoration.copyWith(
                                                          color: AppColors.appWhite,
                                                          border: Border.all(color: AppColors.appColor),
                                                          borderRadius: BorderRadius.circular(30.0),
                                                        ),
                                                        onPressed: () {},
                                                        buttonTextColor: AppColors.appColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${AppStrings.currencySign}${99}',
                                                        style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Text(
                                                        'I can design the website with 100 pages.',
                                                        maxLines: 2,
                                                        style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
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
                                                            '15 Days ',
                                                            maxLines: 2,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
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
                                                            'Unlimited',
                                                            maxLines: 2,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
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
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '3 Page/Screen',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.appColor,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '2 Custom assets',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.textgrey),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.appColor,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Responsive design',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.appColor,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Prototype',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.textgrey),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.appColor,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Source file',
                                                            maxLines: 1,
                                                            style: kTextStyle.copyWith(color: AppColors.neutralColor),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.check_rounded,
                                                            color: AppColors.appColor,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 10.0),
                                                      ButtonGlobalWithoutIcon(
                                                        buttontext: 'Select Offer',
                                                        buttonDecoration: kButtonDecoration.copyWith(
                                                          color: AppColors.appWhite,
                                                          border: Border.all(color: AppColors.appColor),
                                                          borderRadius: BorderRadius.circular(30.0),
                                                        ),
                                                        onPressed: () {},
                                                        buttonTextColor: AppColors.appColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    /// End HTML Body Tags Here



                                    const SizedBox(height: 15.0),
                                    Text(
                                      'Reviews',
                                      maxLines: 1,
                                      style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 15.0),
                                    const Review(),
                                    const SizedBox(height: 15.0),
                                    const ReviewDetails(),
                                    const SizedBox(height: 15.0),
                                    const ReviewDetails2(),
                                    const SizedBox(height: 20.0),
                                    Container(
                                      height: 40.0,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), border: Border.all(color: AppColors.subTitleColor)),
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
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      'Recent Viewed',
                                      style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
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
                              ),
                              CustomHorizontalListViewList(items: recentViewedList, onFavoriteToggle: toggleFavorite, isLoading: false.obs),
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
