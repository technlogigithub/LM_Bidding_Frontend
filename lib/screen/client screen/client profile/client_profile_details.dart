import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:freelancer/screen/app_config/api_config.dart';
import 'package:freelancer/screen/model/profileget_model.dart';
import 'package:freelancer/screen/widgets/button_global.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/constant.dart';
import 'client_setup_profile.dart'; // Adjust import as needed

// Define the base URL for images
const String baseImageUrl = 'https://phplaravel-1517766-5835172.cloudwaysapps.com/';

class ClientProfileDetails extends StatefulWidget {
  const ClientProfileDetails({super.key});

  @override
  State<ClientProfileDetails> createState() => _ClientProfileDetailsState();
}

class _ClientProfileDetailsState extends State<ClientProfileDetails> {
  UserProfile? userProfile;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  // Fetch profile data using ApiService
  Future<void> fetchProfileData() async {
    setState(() => isLoading = true);
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          errorMessage = 'No internet connection. Please check your connection.';
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection. Please check your connection.')),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        setState(() {
          errorMessage = 'Authentication token not found. Please log in again.';
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token not found. Please log in again.')),
        );
        return;
      }

      final headers = {
        'Authorization': 'Bearer $token',
      };

      final response = await ApiService.getRequest('profile/details', headers: headers);

      if (response['response_code'] == 200 && response['success'] == true) {
        setState(() {
          userProfile = UserProfile.fromJson(response['result']);
          isLoading = false;
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage = response['message'] ?? 'Failed to fetch profile data';
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to fetch profile data')),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        backgroundColor: kDarkWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: kNeutralColor),
        title: Text(
          'My Profile',
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ButtonGlobalWithIcon(
          buttontext: 'Edit Profile',
          buttonDecoration: kButtonDecoration.copyWith(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () {
            if (userProfile != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SetupClientProfile(),
                ),
              );
            } else {
              const SetupClientProfile().launch(context);
            }
          },
          buttonTextColor: kWhite,
          buttonIcon: IconlyBold.edit,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
                : errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(errorMessage!, style: kTextStyle.copyWith(color: Colors.red)),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: fetchProfileData,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : userProfile == null
                        ? Center(child: Text('No profile data available', style: kTextStyle.copyWith(color: kNeutralColor)))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15.0),
                              Row(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: kNeutralColor, width: 2),
                                    ),
                                    child: ClipOval(
                                      child: userProfile!.dpImageUrl != null
                                          ? CachedNetworkImage(
                                              imageUrl: '$baseImageUrl${userProfile!.dpImageUrl!}',
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) => Image.asset(
                                                'images/profile3.png',
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Image.asset(
                                              'images/profile3.png',
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userProfile!.username,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: kTextStyle.copyWith(
                                          color: kNeutralColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        userProfile!.email,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: kTextStyle.copyWith(color: kLightNeutralColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (userProfile!.bannerImageUrl != null) ...[
                                const SizedBox(height: 20.0),
                                Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: kNeutralColor),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: CachedNetworkImage(
                                      imageUrl: '$baseImageUrl${userProfile!.bannerImageUrl!}',
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => Image.asset(
                                        'images/banner.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20.0),
                              Text(
                                'Basic Information',
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15.0),
                              _buildInfoRow('Name', userProfile!.name),
                              _buildInfoRow('Username', userProfile!.username),
                              _buildInfoRow('Email', userProfile!.email),
                              _buildInfoRow('Mobile', userProfile!.mobile),
                              const SizedBox(height: 20.0),
                              Text(
                                'Bank Accounts',
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15.0),
                              if (userProfile!.bankAccounts.isEmpty)
                                Text(
                                  'No bank accounts added',
                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                )
                              else
                                ...userProfile!.bankAccounts.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  BankAccount account = entry.value;
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bank Account ${index + 1}${account.isPrimary ? " (Primary)" : ""}',
                                        style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10.0),
                                      _buildInfoRow('Beneficiary Name', account.beneficiaryName ?? 'N/A'),
                                      _buildInfoRow('Account Number', account.accountNumber ?? 'N/A'),
                                      _buildInfoRow('IFSC Code', account.ifscCode ?? 'N/A'),
                                      _buildInfoRow('UPI Address', account.upiAddress ?? 'N/A'),
                                      if (account.documentUrl != null)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildInfoRow('Bank Document', 'Uploaded'),
                                            const SizedBox(height: 10.0),
                                            Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: kPrimaryColor),
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: '$baseImageUrl${account.documentUrl!}',
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      const SizedBox(height: 15.0),
                                    ],
                                  );
                                }),
                              const SizedBox(height: 20.0),
                              Text(
                                'Addresses',
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15.0),
                              if (userProfile!.addresses.isEmpty)
                                Text(
                                  'No addresses added',
                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                )
                              else
                                ...userProfile!.addresses.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  UserAddress address = entry.value;
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Address ${index + 1}${address.isDefault ? " (Default)" : ""}',
                                        style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10.0),
                                      _buildInfoRow('Address Type', address.addressType ?? 'N/A'),
                                      _buildInfoRow('Full Address', address.fullAddress ?? 'N/A'),
                                      if (address.latitude != null && address.longitude != null)
                                        _buildInfoRow('Coordinates', '${address.latitude}, ${address.longitude}'),
                                      const SizedBox(height: 15.0),
                                    ],
                                  );
                                }),
                              const SizedBox(height: 20.0),
                              Text(
                                'Documents',
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15.0),
                              if (userProfile!.documents.isEmpty)
                                Text(
                                  'No documents added',
                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                )
                              else
                                ...userProfile!.documents.map((doc) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatDocumentKey(doc.documentKey),
                                        style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10.0),
                                      _buildInfoRow('Value', doc.documentValue ?? 'N/A'),
                                      _buildInfoRow('Status', doc.isVerified ? 'Verified' : 'Not Verified'),
                                      if (doc.documentUrl != null)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildInfoRow('Document', 'Uploaded'),
                                            const SizedBox(height: 10.0),
                                            Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: kPrimaryColor),
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: '$baseImageUrl${doc.documentUrl!}',
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      const SizedBox(height: 15.0),
                                    ],
                                  );
                                }),
                            ],
                          ),
          ),
        ),
      ),
    );
  }

  // Helper to format document key for display
  String _formatDocumentKey(String key) {
    switch (key.toLowerCase()) {
      case 'aadhar_front':
        return 'Aadhar Card (Front)';
      case 'aadhar_back':
        return 'Aadhar Card (Back)';
      case 'pan':
        return 'PAN Card';
      case 'gstn':
        return 'GST Number';
      case 'reg_no':
        return 'Registration Number';
      default:
        return key.replaceAll('_', ' ').capitalizeFirstLetter();
    }
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
              style: kTextStyle.copyWith(color: kSubTitleColor),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ':',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
                const SizedBox(width: 10.0),
                Flexible(
                  child: Text(
                    value,
                    style: kTextStyle.copyWith(color: kSubTitleColor),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}