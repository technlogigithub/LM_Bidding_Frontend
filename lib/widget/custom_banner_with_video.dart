import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import '../core/app_color.dart';

class CustomBannerWithVideo extends StatefulWidget {
  final List<Map<String, dynamic>> mediaItems;
  final double height;
  final double width;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;
  final String fallbackImage;

  const CustomBannerWithVideo({
    super.key,
    required this.mediaItems,
    this.height = 300.0,
    this.width = double.infinity,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = 0.0,
    this.fallbackImage = 'assets/images/placeholder.png', // Replace with your default placeholder
  });

  @override
  State<CustomBannerWithVideo> createState() => _CustomBannerWithVideoState();
}

class _CustomBannerWithVideoState extends State<CustomBannerWithVideo> {
  final CarouselSliderController _controller = CarouselSliderController();
  final PageController pageController = PageController(initialPage: 0);
  List<VideoPlayerController> videoControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeVideoControllers();
  }

  void _initializeVideoControllers() {
    videoControllers = widget.mediaItems
        .asMap()
        .entries
        .where((entry) => entry.value['type'] == 'video')
        .map((entry) {
      final controller = VideoPlayerController.network(entry.value['url']);
      controller.initialize().then((_) {
        setState(() {});
      });
      return controller;
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in videoControllers) {
      controller.dispose();
    }
    pageController.dispose();
    super.dispose();
  }

  Widget _buildMediaItem(Map<String, dynamic> media, int index) {
    final isVideo = media['type'] == 'video';
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        isVideo
            ? _buildVideoPlayer(index)
            : _buildImageContainer(media['url'], media['redirectUrl']),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            SmoothPageIndicator(
              controller: pageController,
              count: widget.mediaItems.length,
              effect: JumpingDotEffect(
                dotHeight: 6.0,
                dotWidth: 6.0,
                jumpScale: 0.7,
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
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
                color: AppColors.appWhite,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoPlayer(int index) {
    final videoIndex = widget.mediaItems
        .sublist(0, index + 1)
        .where((media) => media['type'] == 'video')
        .length - 1;

    if (videoIndex < 0 ||
        videoIndex >= videoControllers.length ||
        !videoControllers[videoIndex].value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        VideoPlayer(videoControllers[videoIndex]),
        Center(
          child: IconButton(
            icon: Icon(
              videoControllers[videoIndex].value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
              size: 50,
            ),
            onPressed: () {
              setState(() {
                if (videoControllers[videoIndex].value.isPlaying) {
                  videoControllers[videoIndex].pause();
                } else {
                  videoControllers[videoIndex].play();
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageContainer(String imageUrl, String? redirectUrl) {
    return GestureDetector(
      onTap: () {
        if (redirectUrl != null && redirectUrl.isNotEmpty) {
          toast("Opening: $redirectUrl");
          // Add navigation logic here if needed
        }
      },
      child: Container(
        height: widget.height.h,
        width: widget.width.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) => Image.asset(
              widget.fallbackImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaItems.isEmpty) {
      return Container(
        height: widget.height.h,
        width: widget.width.w,
        color: AppColors.darkWhite,
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            color: AppColors.textgrey,
            size: 50,
          ),
        ),
      );
    }

    return Container(
      height: widget.height.h,
      width: widget.width.w,
      padding: widget.padding,
      margin: widget.margin,
      child: CarouselSlider.builder(
        carouselController: _controller,
        options: CarouselOptions(
          height: widget.height.h,
          aspectRatio: 18 / 18,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: widget.mediaItems.length > 1,
          reverse: false,
          autoPlay: false,
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: false,
          onPageChanged: (index, reason) {
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          scrollDirection: Axis.horizontal,
        ),
        itemCount: widget.mediaItems.length,
        itemBuilder: (context, index, realIndex) {
          return _buildMediaItem(widget.mediaItems[index], index);
        },
      ),
    );
  }
}