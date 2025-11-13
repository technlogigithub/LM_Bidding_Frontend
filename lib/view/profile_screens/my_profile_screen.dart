import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/widget/form_widgets/app_button.dart';
import '../../controller/profile/edit_profile_controller.dart';
import 'dynamic_profile_form_screen.dart';


class SetupClientProfileView extends GetView<SetupProfileController> {
  const SetupClientProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    const String baseImageUrl = "https://phplaravel-1517766-5835172.cloudwaysapps.com/";

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
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CustomButton(
            onTap: (){
          Get.put(SetupProfileController());
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DynamicProfileFormScreen()));
        }, text: 'Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
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
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.appTextColor, width: 2),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: "${baseImageUrl}uploads/profile/dp_image_sample.jpg",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        errorWidget: (context, url, error) => const Icon(Icons.person, size: 50),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: Text(
                    "John Doe",
                    style: AppTextStyle.kTextStyle.copyWith(
                      color: AppColors.appTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "john.doe@example.com",
                    style: AppTextStyle.kTextStyle.copyWith(
                      color: AppColors.subTitleColor,
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

                /// BANNER IMAGE
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AppColors.appTextColor.withOpacity(0.3)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: "${baseImageUrl}uploads/profile/banner_sample.jpg",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (context, url, error) => const Icon(Icons.image, size: 40),
                    ),
                  ),
                ),

                const SizedBox(height: 25.0),

                /// BASIC INFO
                Text(
                  "Basic Information",
                  style: AppTextStyle.kTextStyle.copyWith(
                    color: AppColors.appTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                _buildInfoRow("Name", "John Doe"),
                _buildInfoRow("Username", "johndoe"),
                _buildInfoRow("Email", "john.doe@example.com"),
                _buildInfoRow("Mobile", "+91 9876543210"),

                const SizedBox(height: 25.0),

                /// BANK ACCOUNTS
                Text(
                  "Bank Accounts",
                  style: AppTextStyle.kTextStyle.copyWith(
                    color: AppColors.appTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15.0),
                _buildInfoRow("Beneficiary Name", "John Doe"),
                _buildInfoRow("Account Number", "XXXX-XXXX-7890"),
                _buildInfoRow("IFSC Code", "HDFC0001234"),
                _buildInfoRow("UPI Address", "john@hdfcbank"),
                const SizedBox(height: 10.0),
                _buildInfoRow("Bank Document", "Uploaded"),
                const SizedBox(height: 8.0),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.appColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: "${baseImageUrl}uploads/bank_doc_sample.jpg",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),

                const SizedBox(height: 25.0),

                /// ADDRESSES
                Text(
                  "Addresses",
                  style: AppTextStyle.kTextStyle.copyWith(
                    color: AppColors.appTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15.0),
                _buildInfoRow("Address Type", "Home (Default)"),
                _buildInfoRow("Full Address", "123, Sunset Avenue, Mumbai, Maharashtra"),
                _buildInfoRow("Coordinates", "19.0760° N, 72.8777° E"),

                const SizedBox(height: 25.0),

                /// DOCUMENTS
                Text(
                  "Documents",
                  style: AppTextStyle.kTextStyle.copyWith(
                    color: AppColors.appTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15.0),
                _buildInfoRow("Aadhar Number", "XXXX XXXX 4321"),
                _buildInfoRow("Verification Status", "Verified"),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    _buildDocumentImage("${baseImageUrl}uploads/aadhar_front_sample.jpg", "Front"),
                    const SizedBox(width: 10.0),
                    _buildDocumentImage("${baseImageUrl}uploads/aadhar_back_sample.jpg", "Back"),
                  ],
                ),
                const SizedBox(height: 20.0),
                _buildInfoRow("PAN Number", "ABCDE1234F"),
                _buildInfoRow("Verification Status", "Verified"),
                const SizedBox(height: 8.0),
                _buildDocumentImage("${baseImageUrl}uploads/pan_sample.jpg", "PAN Card"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyle.kTextStyle.copyWith(color: AppColors.subTitleColor),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Text(":", style: AppTextStyle.kTextStyle.copyWith(color: AppColors.subTitleColor)),
                const SizedBox(width: 10.0),
                Flexible(
                  child: Text(
                    value,
                    style: AppTextStyle.kTextStyle.copyWith(color: AppColors.subTitleColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentImage(String url, String label) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.appColor),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: AppTextStyle.kTextStyle.copyWith(color: AppColors.subTitleColor),
        ),
      ],
    );
  }
}