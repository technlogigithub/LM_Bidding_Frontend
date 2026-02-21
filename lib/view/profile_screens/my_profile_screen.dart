import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/widget/form_widgets/app_button.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/profile/profile_controller.dart';
import '../../controller/profile/edit_profile_controller.dart';
import '../../core/app_routes.dart';
import 'dynamic_profile_form_screen.dart';


class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  // Helper function to check if URL is an image file
  bool _isImageFile(String? url) {
    if (url == null || url.isEmpty) return false;
    final lowerUrl = url.toLowerCase();
    // Remove query parameters for checking
    final urlWithoutQuery = lowerUrl.split('?').first;
    return urlWithoutQuery.endsWith('.jpg') ||
        urlWithoutQuery.endsWith('.jpeg') ||
        urlWithoutQuery.endsWith('.png') ||
        urlWithoutQuery.endsWith('.gif') ||
        urlWithoutQuery.endsWith('.webp') ||
        urlWithoutQuery.endsWith('.bmp');
  }

  // Helper function to format field label
  String _formatFieldLabel(String key) {
    // If already has spaces and proper capitalization, return as is
    if (key.contains(' ') && key[0] == key[0].toUpperCase()) {
      return key;
    }
    // Convert snake_case or camelCase to Title Case
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isEmpty
        ? ''
        : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil with a reference design size (375x812 for mobile)
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true);

    final controller = Get.put(ProfileController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.profileDetailsResponeModel.value == null) {
        controller.fetchProfileDetails();
      }
    });
    final screenWidth = MediaQuery.of(context).size.width;
    // Define max width for web/large screens
    final maxContentWidth = screenWidth > 1200 ? 1200.0 : screenWidth;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            iconTheme:  IconThemeData(color: AppColors.appTextColor),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: AppColors.appbarColor,
              ),
            ),
            title: Text(
              'My Profile',
              style: AppTextStyle.title(
                color: AppColors.appTextColor,
                fontWeight: FontWeight.bold,

              ),
            ),
            centerTitle: true,
          ),
          bottomNavigationBar: kIsWeb ? null : Padding(
            padding: EdgeInsets.only(left: 15,right: 15,bottom: 10,top: 5),
            child: CustomButton(
              onTap: () {
                Get.put(SetupProfileController());
                Get.toNamed(AppRoutes.dynamicProfileForm);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const DynamicProfileFormScreen()),
                // );
              },
              text: 'Edit Profile',
            ),
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return _buildShimmerLoading(context, screenWidth);
            }

            final rawData = controller.profileDetailsResponeModel.value?.result?.rawData;
            if (rawData == null) {
              return const Center(
                child: Text('No profile data available'),
              );
            }

            // Get DP URL (check nested structure)
            String? dpUrl;
            if (rawData['DP'] != null && rawData['DP'] is Map) {
              dpUrl = rawData['DP']['DP']?.toString();
            }
            // Also check case-insensitive keys
            if ((dpUrl == null || dpUrl.isEmpty) && rawData.containsKey('dp')) {
              final dpData = rawData['dp'];
              if (dpData is Map) {
                dpUrl = dpData['dp']?.toString() ?? dpData['DP']?.toString();
              }
            }
            // Debug: Print DP URL
            print('🔍 DP URL: $dpUrl');
            print('🔍 Is Image: ${_isImageFile(dpUrl)}');

            // Get Banner URL (check nested structure with case-insensitive keys)
            String? bannerUrl;
            if (rawData['Banner'] != null && rawData['Banner'] is Map) {
              bannerUrl = rawData['Banner']['Banner']?.toString();
            }
            // Also check case-insensitive keys
            if ((bannerUrl == null || bannerUrl.isEmpty) && rawData.containsKey('banner')) {
              final bannerData = rawData['banner'];
              if (bannerData is Map) {
                bannerUrl = bannerData['Banner']?.toString() ?? bannerData['banner']?.toString();
              }
            }
            // Debug: Print Banner URL
            print('🔍 Banner URL: $bannerUrl');
            print('🔍 Is Image: ${_isImageFile(bannerUrl)}');

            // Get name and email from Basic Info for header
            String? name;
            String? email;
            if (rawData['Basic Info'] != null && rawData['Basic Info'] is Map) {
              final basicInfo = rawData['Basic Info'] as Map;
              name = basicInfo['Name']?.toString();
              email = basicInfo['Email']?.toString();
            }

            if (kIsWeb) {
               return _buildWebLayout(context, rawData, dpUrl, bannerUrl, name, email);
            }

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: AppColors.appPagecolor
                      // borderRadius: BorderRadius.only(
                      //   topLeft: Radius.circular(30.r),
                      //   topRight: Radius.circular(30.r),
                      // ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// PROFILE HEADER
                          Center(
                            child: Container(
                              height: 80.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.appBlack.withValues(alpha: 0.20), // stronger shadow
                                    blurRadius: 12,     // soft glow
                                    spreadRadius: 5,    // outer spread
                                    offset: Offset(0, 4), // down shadow
                                  ),
                                  BoxShadow(
                                    color: AppColors.appWhite.withValues(alpha: 0.8), // top highlight
                                    blurRadius: 6,
                                    spreadRadius: -2,
                                    offset: Offset(0, -2),
                                  ),
                                ],

                              ),
                              child: ClipOval(
                                child: (dpUrl != null && dpUrl.isNotEmpty && _isImageFile(dpUrl))
                                    ? CachedNetworkImage(
                                  imageUrl: dpUrl,
                                  fit: BoxFit.cover,
                                  width: 80.w,
                                  height: 80.h,
                                  placeholder: (context, url) => Shimmer.fromColors(
                                    baseColor: AppColors.appMutedColor,
                                    highlightColor: AppColors.appMutedTextColor,
                                    child: Container(
                                      width: 80.w,
                                      height: 80.h,
                                      decoration:  BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.appWhite,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) {
                                    print('❌ Image load error: $error');
                                    return Container(
                                        width: 80.w,
                                        height: 80.h,
                                        decoration:  BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.textgrey,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size: 50.sp,
                                          color: AppColors.appWhite,
                                        )
                                    );
                                  },
                                )
                                    : Container(
                                  width: 80.w,
                                  height: 80.h,
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:AppColors.appMutedColor,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 50.sp,
                                    color: AppColors.appIconColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // if (name != null)
                          //   Center(
                          //     child: Text(
                          //       name,
                          //       style: AppTextStyle.kTextStyle.copyWith(
                          //         color: AppColors.appTextColor,
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 18.sp,
                          //       ),
                          //     ),
                          //   ),
                          // if (email != null)
                          //   Center(
                          //     child: Text(
                          //       email,
                          //       style: AppTextStyle.kTextStyle.copyWith(
                          //         color: AppColors.subTitleColor,
                          //         fontSize: 14.sp,
                          //       ),
                          //     ),
                          //   ),

                          SizedBox(height: 20.h),

                          /// BANNER IMAGE
                          // if (bannerUrl != null && _isImageFile(bannerUrl))
                          Container(
                            height: 140.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.appMutedColor,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: Offset(0, 10),
                                  // blurRadius: 1,
                                  // spreadRadius: 1,
                                  // offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: (bannerUrl != null && _isImageFile(bannerUrl))
                                  ? CachedNetworkImage(
                                imageUrl: bannerUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: AppColors.appMutedColor,
                                  highlightColor: AppColors.appMutedTextColor,
                                  child: Container(
                                    width: double.infinity,
                                    height: 100.h,
                                    color: AppColors.appWhite,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Center(
                                  child: Icon(Icons.image, size: 40.sp),
                                ),
                              )

                              // ✅ WHEN bannerUrl IS NULL
                                  : Container(
                                decoration: BoxDecoration(
                                  gradient: AppColors.appPagecolor,
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 36.sp,
                                  color: AppColors.appIconColor,
                                ),
                              ),
                            ),
                          ),



                          SizedBox(height: 25.h),

                          /// DYNAMIC SECTIONS
                          ..._buildDynamicSections(rawData, context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  List<Widget> _buildDynamicSections(Map<String, dynamic> rawData, BuildContext context) {
    final sections = <Widget>[];

    // Iterate through all keys in rawData
    rawData.forEach((sectionKey, sectionValue) {
      // Skip hidden section
      if (sectionKey.toLowerCase() == 'hidden') {
        return;
      }

      // Skip DP and Banner (already handled in header) - case insensitive
      final lowerKey = sectionKey.toLowerCase();
      if (lowerKey == 'dp' || lowerKey == 'banner') {
        return;
      }

      // Handle array sections (Address, Documents, etc.)
      if (sectionValue is List) {
        sections.addAll(_buildArraySection(sectionKey, sectionValue, context));
      }
      // Handle object sections (Basic Info, etc.)
      else if (sectionValue is Map) {
        sections.addAll(_buildObjectSection(sectionKey, sectionValue, context));
      }
    });

    return sections;
  }

  List<Widget> _buildObjectSection(
      String sectionKey, Map<dynamic, dynamic> sectionData, BuildContext context) {

    final widgets = <Widget>[];

    // Section title OUTSIDE card
    widgets.add(
      Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(
          sectionKey,
          style: AppTextStyle.title(
            color: AppColors.appTitleColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    // CARD CONTAINER
    widgets.add(
      Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          // color: Colors.white,
          gradient: AppColors.appPagecolor,
          // border: Border.all(color: AppColors.appDescriptionColor,width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.appMutedColor,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 10),
              // blurRadius: 1,
              // spreadRadius: 1,
              // offset: Offset(0, 6),
            ),
          ],

          borderRadius: BorderRadius.circular(12.r),
          // boxShadow: [
          //   BoxShadow(
          //     color: AppColors.appDescriptionColor,
          //     blurRadius: 4,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sectionData.entries.map((entry) {
            final keyStr = entry.key.toString();
            final valueStr = entry.value.toString();

            if (_isImageFile(valueStr)) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatFieldLabel(keyStr),
                      style: AppTextStyle.description(
                        color: AppColors.appDescriptionColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildDocumentImage(valueStr, "", context),
                  ],
                ),
              );
            }

            return _buildInfoRow(_formatFieldLabel(keyStr), valueStr, context);
          }).toList(),
        ),
      ),
    );

    widgets.add(SizedBox(height: 22.h));
    return widgets;
  }


  List<Widget> _buildArraySection(String sectionKey, List<dynamic> sectionArray, BuildContext context) {
    final widgets = <Widget>[];

    if (sectionArray.isEmpty) return widgets;

    // Section Title
    widgets.add(
      Text(
        sectionKey,
        style: AppTextStyle.title(
          color: AppColors.appTitleColor,
          fontWeight: FontWeight.bold,

        ),
      ),
    );
    widgets.add(SizedBox(height: 15.h));

    // -----------------------------
    // CASE 1: ADDRESS SECTION - Each item in its own card
    // -----------------------------
    if (sectionKey.toLowerCase() == "address") {
      for (var item in sectionArray) {
        if (item is! Map) continue;

        widgets.add(
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              gradient: AppColors.appPagecolor,
              // border: Border.all(color: AppColors.appDescriptionColor,width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.appMutedColor,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 10),
                  // blurRadius: 1,
                  // spreadRadius: 1,
                  // offset: Offset(0, 6),
                ),
              ],

              borderRadius: BorderRadius.circular(12.r),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black12,
              //     blurRadius: 4,
              //     offset: const Offset(0, 2),
              //   ),
              // ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: item.entries.map((entry) {
                return _buildInfoRow(
                  _formatFieldLabel(entry.key.toString()),
                  entry.value.toString(),
                  context,
                );
              }).toList(),
            ),
          ),
        );

        widgets.add(SizedBox(height: 15.h));
      }

      widgets.add(SizedBox(height: 25.h));
      return widgets;
    }

    // -----------------------------
    // CASE 2: DOCUMENTS SECTION - Each document in its own card
    // -----------------------------
    if (sectionKey.toLowerCase() == "documents") {
      for (var item in sectionArray) {
        if (item is! Map) continue;

        final name = item["Name"]?.toString() ?? "";
        final number = item["Number"]?.toString() ?? "";
        final imageUrl = item["Image"]?.toString() ?? "";
        final hasImage = imageUrl.isNotEmpty;
        final hasNumber = number.isNotEmpty;

        // -----------------------------
        // CASE A: Name + Image - Each in its own card
        // -----------------------------
        if (name.isNotEmpty && hasImage) {
          widgets.add(
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                gradient: AppColors.appPagecolor,
                // border: Border.all(color: AppColors.appDescriptionColor,width: 1),

                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.appMutedColor,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 10),
                    // blurRadius: 1,
                    // spreadRadius: 1,
                    // offset: Offset(0, 6),
                  ),
                ],

                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black12,
                //     blurRadius: 4,
                //     offset: const Offset(0, 2),
                //   ),
                // ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRowDoc(name, context),
                  _buildDocumentImage(imageUrl, "", context),
                ],
              ),
            ),
          );
          widgets.add(SizedBox(height: 15.h));
          continue;
        }

        // -----------------------------
        // CASE B: Name + Number - Each in its own card
        // -----------------------------
        if (name.isNotEmpty && hasNumber && !hasImage) {
          widgets.add(
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                gradient: AppColors.appPagecolor,
                // border: Border.all(color: AppColors.appDescriptionColor,width: 1),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.appMutedColor,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 10),
                    // blurRadius: 1,
                    // spreadRadius: 1,
                    // offset: Offset(0, 6),
                  ),
                ],

                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black12,
                //     blurRadius: 4,
                //     offset: const Offset(0, 2),
                //   ),
                // ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Name", name, context),
                  _buildInfoRow("Number", number, context),
                ],
              ),
            ),
          );
          widgets.add(SizedBox(height: 15.h));
          continue;
        }

        // -----------------------------
        // CASE C: Only Image - Each in its own card
        // -----------------------------
        if (hasImage && name.isEmpty) {
          widgets.add(
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                gradient: AppColors.appPagecolor,
                // border: Border.all(color: AppColors.appDescriptionColor,width: 1),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.appMutedColor,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 10),
                    // blurRadius: 1,
                    // spreadRadius: 1,
                    // offset: Offset(0, 6),
                  ),
                ],

                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black12,
                //     blurRadius: 4,
                //     offset: const Offset(0, 2),
                //   ),
                // ],
              ),
              child: _buildDocumentImage(imageUrl, "", context),
            ),
          );
          widgets.add(SizedBox(height: 15.h));
          continue;
        }

        // -----------------------------
        // CASE D: Only Number - Each in its own card
        // -----------------------------
        if (hasNumber && name.isEmpty) {
          widgets.add(
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.appBlack.withValues(alpha: 0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildInfoRow("Number", number, context),
            ),
          );
          widgets.add(SizedBox(height: 15.h));
          continue;
        }
      }

      widgets.add(SizedBox(height: 25.h));
      return widgets;
    }

    // -----------------------------
    // CASE 3: GENERIC LIST SECTIONS (Future lists) - Each item in its own card
    // -----------------------------
    for (var item in sectionArray) {
      if (item is! Map) continue;

      widgets.add(
        Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: item.entries.map((entry) {
              final keyStr = entry.key.toString();
              final valueStr = entry.value.toString();

              // Check if value is an image URL
              if (_isImageFile(valueStr)) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatFieldLabel(keyStr),
                        style: AppTextStyle.description(
                          color: AppColors.appDescriptionColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildDocumentImage(valueStr, "", context),
                    ],
                  ),
                );
              }

              return _buildInfoRow(
                _formatFieldLabel(keyStr),
                valueStr,
                context,
              );
            }).toList(),
          ),
        ),
      );

      widgets.add(SizedBox(height: 15.h));
    }

    widgets.add(SizedBox(height: 25.h));
    return widgets;
  }



  Widget _buildInfoRow(String label, String value, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyle.description(
                color: AppColors.appDescriptionColor,

              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Text(
                  ":",
                  style: AppTextStyle.description(
                    color: AppColors.appDescriptionColor,
                  ),
                ),
                SizedBox(width: 10.w),
                Flexible(
                  child: Text(
                    value,
                    style: AppTextStyle.description(
                      color: AppColors.appBodyTextColor,

                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildInfoRowDoc(String label,BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label : ",
              style: AppTextStyle.description(
                color: AppColors.appDescriptionColor,

              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentImage(String url, String label, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 6,
          child: Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              // border: Border.all(color: AppColors.appColor),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withValues(alpha: 0.15),
              //     blurRadius: 18,
              //     spreadRadius: 2,
              //     offset: Offset(0, 6),
              //   ),
              //   BoxShadow(
              //     color: Colors.grey.withValues(alpha: 0.2),
              //     blurRadius: 4,
              //     spreadRadius: -1,
              //     offset: Offset(0, -2),
              //   ),
              // ],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.appMutedColor,
                  highlightColor: AppColors.appMutedTextColor,
                  child: Container(
                    width: double.infinity,
                    height: 200.h,
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error, size: 24.sp),
              ),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyle.description(
            color: AppColors.subTitleColor,

          ),
        ),
      ],
    );
  }

  Widget _buildShimmerLoading(BuildContext context, double screenWidth) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: screenWidth > 1200 ? 1200.0 : screenWidth),
        child: Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Shimmer
                  Center(
                    child: Shimmer.fromColors(
                      baseColor: AppColors.appMutedColor,
                      highlightColor: AppColors.appMutedTextColor,
                      child: Container(
                        height: 80.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.appWhite,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Banner Shimmer
                  Shimmer.fromColors(
                    baseColor: AppColors.appMutedColor,
                    highlightColor: AppColors.appMutedTextColor,
                    child: Container(
                      height: 100.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  // Section Shimmer
                  ...List.generate(3, (index) => Padding(
                    padding: EdgeInsets.only(bottom: 22.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Title Shimmer
                        Shimmer.fromColors(
                          baseColor: AppColors.appMutedColor,
                          highlightColor: AppColors.appMutedTextColor,
                          child: Container(
                            height: 20.h,
                            width: 150.w,
                            decoration: BoxDecoration(
                              color: AppColors.appWhite,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Card Shimmer
                        Container(
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.appBlack.withValues(alpha: 0.12),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: List.generate(3, (itemIndex) => Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Shimmer.fromColors(
                                      baseColor: AppColors.appMutedColor,
                                      highlightColor: AppColors.appMutedTextColor,
                                      child: Container(
                                        height: 14.h,
                                        width: 80.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.appWhite,
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Row(
                                      children: [
                                        Text(
                                          ":",
                                          style: AppTextStyle.description(
                                            color: AppColors.appDescriptionColor,

                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Shimmer.fromColors(
                                            baseColor: AppColors.appMutedColor,
                                            highlightColor: AppColors.appMutedTextColor,
                                            child: Container(
                                              height: 14.h,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: AppColors.appWhite,
                                                borderRadius: BorderRadius.circular(4.r),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildWebLayout(BuildContext context, Map<String, dynamic> rawData, String? dpUrl, String? bannerUrl, String? name, String? email) {
    // Extract Section Data
    var basicInfo = <String, dynamic>{};
    if (rawData['Basic Info'] is Map) {
      basicInfo = Map<String, dynamic>.from(rawData['Basic Info']);
    }
    // Filter out Name/Email from Grid if they are redundant with Header, but user asked for "Right side basic information", so keeping them is safe or filtering if desired. 
    // Usually Profile Header has Name, so removing Name from Basic Info grid is good UI.
    basicInfo.removeWhere((key, value) => key.toLowerCase() == 'name');

    var addressList = [];
    if (rawData['Address'] is List) {
      addressList = List.from(rawData['Address']);
    }

    var documentList = [];
    if (rawData['Documents'] is List) {
      documentList = List.from(rawData['Documents']);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        children: [
          // ------------------------------------------------
          // TOP CARD: Profile Header + Info + Address
          // ------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.appBlack.withValues(alpha:0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT SIDE: DP & Name (Fixed Width)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: Column(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.appWhite, width: 4),
                          boxShadow: [
                             BoxShadow(
                              color: AppColors.appBlack.withValues(alpha:0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: (dpUrl != null && dpUrl.isNotEmpty && _isImageFile(dpUrl))
                              ? CachedNetworkImage(
                                  imageUrl: dpUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(color: AppColors.kBorderColorTextField),
                                  errorWidget: (context, url, e) => Icon(Icons.person, size: 50, color: AppColors.textgrey),
                                )
                              : Container(color: AppColors.kBorderColorTextField, child: Icon(Icons.person, size: 60, color: AppColors.textgrey)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (name != null)
                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.title(
                             fontWeight: FontWeight.bold,
                          ).copyWith(fontSize: 24),
                        ),
                      if (email != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          email,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.appMutedTextColor, fontSize: 14),
                        ),
                      ],
                      // Trust Score / Rating Placeholder (from image)
                      const SizedBox(height: 15),

                      // Edit Profile Button
                      SizedBox(
                        width: 200,
                        child: CustomButton(
                          onTap: () {
                            Get.put(SetupProfileController());
                            Get.toNamed(AppRoutes.dynamicProfileForm);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => const DynamicProfileFormScreen()),
                            // );
                          },
                          text: 'Edit Profile',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 50),
                // VERTICAL DIVIDER
                Container(
                  width: 1,
                  height: 300, 
                  color: AppColors.kBorderColorTextField,
                ),
                const SizedBox(width: 50),

                // RIGHT SIDE: Basic Info & Address
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BASIC INFO
                      Text(
                        "Basic Information", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.appTitleColor)
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 60,
                        runSpacing: 25,
                        children: basicInfo.entries.map((e) {
                           return _buildWebFieldItem(e.key, e.value.toString());
                        }).toList(),
                      ),

                      // ADDRESS
                      if (addressList.isNotEmpty) ...[
                        const SizedBox(height: 40),
                        Divider(color: AppColors.kBorderColorTextField),
                        const SizedBox(height: 20),
                         Text(
                          "Address", 
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.appTitleColor)
                        ),
                        const SizedBox(height: 20),
                        Column(
                            children: addressList.map((addrItem) {
                                if (addrItem is Map) {
                                   return Padding(
                                     padding: const EdgeInsets.only(bottom: 15),
                                     child: Row(
                                       children: addrItem.entries.map((e) => Expanded(child: _buildWebFieldItem(e.key.toString(), e.value.toString()))).toList(),
                                     ),
                                   );
                                }
                                return SizedBox();
                            }).toList()
                        )
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ------------------------------------------------
          // BOTTOM SECTION: Documents List (Grid/Wrap)
          // ------------------------------------------------
          if (documentList.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.appBlack.withValues(alpha:0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    "Documents", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.appTitleColor)
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: documentList.map((doc) {
                      return _buildWebDocCard(context, doc);
                    }).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWebFieldItem(String label, String value) {
    return SizedBox(
      width: 200, // Fixed width for alignment
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatFieldLabel(label), // Reuse existing helper
            style: TextStyle(color: AppColors.textgrey, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyle.description(color: AppColors.appBodyTextColor)
          ),
        ],
      ),
    );
  }

  Widget _buildWebDocCard(BuildContext context, dynamic docData) {
     if (docData is! Map) return const SizedBox();

     String name = docData['Name']?.toString() ?? '';
     String number = docData['Number']?.toString() ?? '';
     String image = docData['Image']?.toString() ?? '';
     
     // Format name
     String displayName = _formatFieldLabel(name);

     return Container(
       width: 300, 
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         color: AppColors.appWhite,
         borderRadius: BorderRadius.circular(12),
         border: Border.all(color: AppColors.kBorderColorTextField),
         boxShadow: [
           BoxShadow(
             color: AppColors.appBlack.withValues(alpha:0.03),
             blurRadius: 10,
             offset: const Offset(0, 4),
           ),
         ],
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
             children: [
               Icon(Icons.description, color: AppColors.appColor, size: 20),
               const SizedBox(width: 8),
               Expanded(
                 child: Text(
                   displayName, 
                   style: AppTextStyle.title(fontWeight: FontWeight.bold).copyWith(fontSize: 16),
                   overflow: TextOverflow.ellipsis,
                 ),
               ),
             ],
           ),
           const SizedBox(height: 16),
           
           if (image.isNotEmpty && _isImageFile(image))
             GestureDetector(
               onTap: () {
                 showDialog(
                   context: context, 
                   builder: (context) => Dialog(
                     child: CachedNetworkImage(
                       imageUrl: image,
                       placeholder: (context, url) => const SizedBox(height: 50, width: 50, child: Center(child: CircularProgressIndicator())),
                       errorWidget: (context, url, error) => const Icon(Icons.error),
                     ),
                   )
                 );
               },
               child: Container(
                 height: 150,
                 width: double.infinity,
                 decoration: BoxDecoration(
                   color: AppColors.darkWhite,
                   borderRadius: BorderRadius.circular(8),
                   border: Border.all(color: AppColors.kBorderColorTextField)
                 ),
                 child: ClipRRect(
                   borderRadius: BorderRadius.circular(8),
                   child: CachedNetworkImage(
                     imageUrl: image,
                     fit: BoxFit.cover,
                     placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                     errorWidget: (context, url, error) =>  Center(child: Icon(Icons.broken_image, color: AppColors.textgrey)),
                   ),
                 ),
               ),
             )
           else if (number.isNotEmpty)
             Container(
               width: double.infinity,
               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
               decoration: BoxDecoration(
                 color: AppColors.appColor.withOpacity(0.05),
                 borderRadius: BorderRadius.circular(8),
               ),
               child: Center(
                 child: Text(
                   number,
                   style:AppTextStyle.body()
                 ),
               ),
             )
           else
              Padding(
               padding: EdgeInsets.symmetric(vertical: 20),
               child: Center(child: Text("No Preview", style: TextStyle(color: AppColors.textgrey))),
             ),
         ],
       ),
     );
  }
} 



