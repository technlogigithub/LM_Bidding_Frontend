import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/widget/form_widgets/app_button.dart';
import '../../controller/profile/profile_controller.dart';
import '../../controller/profile/edit_profile_controller.dart';
import 'dynamic_profile_form_screen.dart';


class SetupClientProfileView extends StatelessWidget {
  const SetupClientProfileView({super.key});

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
    final screenWidth = MediaQuery.of(context).size.width;
    // Define max width for web/large screens
    final maxContentWidth = screenWidth > 1200 ? 1200.0 : screenWidth;

    return Scaffold(
      backgroundColor: AppColors.appWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'My Profile',
          style: AppTextStyle.kTextStyle.copyWith(
            color: AppColors.appTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 15,right: 15,bottom: 10,top: 5),
        child: CustomButton(
          onTap: () {
            Get.put(SetupProfileController());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DynamicProfileFormScreen()),
            );
          },
          text: 'Edit Profile',
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
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

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
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
                      /// PROFILE HEADER
                      Center(
                        child: Container(
                          height: 80.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.20), // stronger shadow
                                blurRadius: 12,     // soft glow
                                spreadRadius: 5,    // outer spread
                                offset: Offset(0, 4), // down shadow
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.8), // top highlight
                                blurRadius: 6,
                                spreadRadius: -2,
                                offset: Offset(0, -2),
                              ),
                            ],
                            border: Border.all(color: AppColors.appTextColor, width: 2.w),
                          ),
                          child: ClipOval(
                            child: (dpUrl != null && dpUrl.isNotEmpty && _isImageFile(dpUrl))
                                ? CachedNetworkImage(
                                    imageUrl: dpUrl,
                                    fit: BoxFit.cover,
                                    width: 80.w,
                                    height: 80.h,
                                    placeholder: (context, url) => Container(
                                      width: 80.w,
                                      height: 80.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(strokeWidth: 2.w),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) {
                                      print('❌ Image load error: $error');
                                      return Container(
                                        width: 80.w,
                                        height: 80.h,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size: 50.sp,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 80.w,
                                    height: 80.h,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 50.sp,
                                      color: Colors.white,
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
                      if (bannerUrl != null && _isImageFile(bannerUrl))
                        Card(
                          elevation: 6,
                          child: Container(
                            height: 100.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                  offset: Offset(0, 6),
                                ),
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  spreadRadius: -1,
                                  offset: Offset(0, -2),
                                ),
                              ],
                              border: Border.all(
                                color: AppColors.appTextColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: CachedNetworkImage(
                                imageUrl: bannerUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(strokeWidth: 2.w),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.image,
                                  size: 40.sp,
                                ),
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
          style: AppTextStyle.kTextStyle.copyWith(
            color: AppColors.appTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
      ),
    );

    // CARD CONTAINER
    widgets.add(
      Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colors.white,
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
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.subTitleColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
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
        style: AppTextStyle.kTextStyle.copyWith(
          color: AppColors.appTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
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
              color: Colors.white,
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
                color: Colors.white,
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
                color: Colors.white,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                    color: Colors.black12,
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
            color: Colors.white,
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
                        style: AppTextStyle.kTextStyle.copyWith(
                          color: AppColors.subTitleColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
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
              style: AppTextStyle.kTextStyle.copyWith(
                color: AppColors.subTitleColor,
                fontSize: 14.sp,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Text(
                  ":",
                  style: AppTextStyle.kTextStyle.copyWith(
                    color: AppColors.subTitleColor,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Flexible(
                  child: Text(
                    value,
                    style: AppTextStyle.kTextStyle.copyWith(
                      color: AppColors.subTitleColor,
                      fontSize: 14.sp,
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
              style: AppTextStyle.kTextStyle.copyWith(
                color: AppColors.subTitleColor,
                fontSize: 16.sp,
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
              border: Border.all(color: AppColors.appColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 18,
                  spreadRadius: 2,
                  offset: Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 4,
                  spreadRadius: -1,
                  offset: Offset(0, -2),
                ),
              ],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(strokeWidth: 2.w),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error, size: 24.sp),
              ),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyle.kTextStyle.copyWith(
            color: AppColors.subTitleColor,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}



