import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import '../core/app_color.dart';
import '../core/app_imagetype_helper.dart';
import '../core/app_images.dart';
import 'custom_auto_image_handle.dart';

class CustomBannerWithVideo extends StatefulWidget {
  final List<Map<String, dynamic>> mediaItems;
  final RxBool? isLoading;
  final double height;
  final double width;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;
  final String fallbackImage;
  final String? bgColor;
  final String? bgImg;

  const CustomBannerWithVideo({
    super.key,
    required this.mediaItems,
    this.isLoading,
    this.height = 300.0,
    this.width = double.infinity,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = 0.0,

    this.fallbackImage = 'assets/images/placeholder.png',
    this.bgColor,
    this.bgImg,
  });

  @override
  State<CustomBannerWithVideo> createState() => _CustomBannerWithVideoState();
}

class _CustomBannerWithVideoState extends State<CustomBannerWithVideo> {
  // ✅ Use CarouselController (or keep your type if it compiles)
  final CarouselController _controller = CarouselController();

  // ❌ REMOVE PageController (not used with CarouselSlider)
  // final PageController pageController = PageController(initialPage: 0);

  List<VideoPlayerController> videoControllers = [];

  // ✅ This must be a STATE field, not inside build()
  int _currentIndex = 0;

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
        if (mounted) setState(() {});
      });
      return controller;
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in videoControllers) {
      controller.dispose();
    }
    // pageController.dispose(); // ❌ removed
    super.dispose();
  }

  // ************ SHIMMER WIDGET ************
  Widget _buildShimmer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius.r),
      child: Image.asset(
        AppImage.placeholder,
        height: widget.height.h,
        width: widget.width.w,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildMediaItem(Map<String, dynamic> media, int index) {
    final isVideo = media['type'] == 'video';

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        isVideo
            ? _buildVideoPlayer(index)
            : _buildImageContainer(media['url'], media['redirectUrl']),
        // ❌ REMOVE indicator from here - it causes issues
      ],
    );
  }

  // ************ VIDEO WITH SHIMMER ************
  Widget _buildVideoPlayer(int index) {
    final videoIndex = widget.mediaItems
        .sublist(0, index + 1)
        .where((media) => media['type'] == 'video')
        .length -
        1;

    if (videoIndex < 0 || videoIndex >= videoControllers.length) {
      return _buildShimmer();
    }

    final controller = videoControllers[videoIndex];

    if (controller.value.hasError) {
       return Image.asset(AppImage.placeholder, fit: BoxFit.cover, height: widget.height.h, width: widget.width.w);
    }

    if (!controller.value.isInitialized) {
      return _buildShimmer();
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: VideoPlayer(controller),
        ),
        Center(
          child: IconButton(
            icon: Icon(
              controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 50,
            ),
            onPressed: () {
              setState(() {
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
              });
            },
          ),
        )
      ],
    );
  }

  // ************ IMAGE WITH SHIMMER ************
  Widget _buildImageContainer(String imageUrl, String? redirectUrl) {
    if (imageUrl.isEmpty || !ImageTypeHelper.isImage(imageUrl)) {
      return GestureDetector(
        onTap: () {
          if (redirectUrl != null && redirectUrl.isNotEmpty) {
             // handle redirect
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          child: Image.asset(AppImage.placeholder, fit: BoxFit.cover, height: widget.height.h, width: widget.width.w),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (redirectUrl != null && redirectUrl.isNotEmpty) {
          toast("Opening: $redirectUrl");
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          height: widget.height.h,
          width: widget.width.w,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return _buildShimmer(); // 🔥 Shimmer while image loads
          },
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(AppImage.placeholder, fit: BoxFit.cover);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show shimmer if loading or if mediaItems is empty
    if (widget.isLoading != null) {
      return Obx(() {
        if (widget.isLoading!.value || widget.mediaItems.isEmpty) {
          return _buildShimmer();
        }
        return _buildBannerContent();
      });
    }

    // If isLoading is not provided, show shimmer when mediaItems is empty
    if (widget.mediaItems.isEmpty) {
      return _buildShimmer();
    }

    return _buildBannerContent();
  }

  Widget _buildBannerContent() {
    final bool hasValidImage = ImageTypeHelper.isImage(widget.bgImg);

    Widget content = Container(
      height: widget.height.h,
      width: widget.width.w,
      padding: widget.padding,
      margin: widget.margin,
      child: Column(
        children: [
          /// --- SLIDER AREA ---
          Expanded(
            child: CarouselSlider.builder(
              // carouselController: _controller,
              options: CarouselOptions(
                height: widget.height.h,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: widget.mediaItems.length > 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index; // ✅ updates state
                  });
                },
              ),
              itemCount: widget.mediaItems.length,
              itemBuilder: (context, index, realIndex) {
                return _buildMediaItem(widget.mediaItems[index], index);
              },
            ),
          ),

          const SizedBox(height: 10),

          /// --- FIXED INDICATOR (always visible!) ---
          AnimatedSmoothIndicator(
            activeIndex: _currentIndex,
            count: widget.mediaItems.length,
            effect: JumpingDotEffect(
              dotHeight: 6,
              dotWidth: 6,
              jumpScale: 0.7,
              activeDotColor: AppColors.appColor,
              dotColor: AppColors.appMutedColor,
            ),
          ),
        ],
      ),
    );

    if (hasValidImage) {
      return Stack(
        children: [
          AutoNetworkImage(imageUrl: widget.bgImg),
          Positioned.fill(
             child: Align(
               alignment: Alignment.center,
               child: content,
             ),
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: (widget.bgColor != null && widget.bgColor!.isNotEmpty)
            ? parseLinearGradient(widget.bgColor)
            : AppColors.appPagecolor,
      ),
      child: content,
    );
  }
}
