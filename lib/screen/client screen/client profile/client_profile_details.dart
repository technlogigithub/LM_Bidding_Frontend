// import 'package:flutter/material.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
// import 'package:freelancer/screen/client%20screen/client%20profile/client_setup_profile.dart';
// import 'package:freelancer/screen/widgets/button_global.dart';
// import 'package:nb_utils/nb_utils.dart';

// import '../../widgets/constant.dart';
// import 'client_edit_profile_details.dart';

// class ClientProfileDetails extends StatefulWidget {
//   const ClientProfileDetails({super.key});

//   @override
//   State<ClientProfileDetails> createState() => _ClientProfileDetailsState();
// }

// class _ClientProfileDetailsState extends State<ClientProfileDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kDarkWhite,
//       appBar: AppBar(
//         backgroundColor: kDarkWhite,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: kNeutralColor),
//         title: Text(
//           'My Profile',
//           style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       bottomNavigationBar: ButtonGlobalWithIcon(
//         buttontext: 'Edit Profile',
//         buttonDecoration: kButtonDecoration.copyWith(
//           color: kPrimaryColor,
//           borderRadius: BorderRadius.circular(30.0),
//         ),
//         onPressed: () {
     
//              //const ClientEditProfile().launch(context);
//             const SetupClientProfile().launch(context);
          
//         },
//         buttonTextColor: kWhite,
//         buttonIcon: IconlyBold.edit,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 30.0),
//         child: Container(
//           padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
//           width: context.width(),
//           decoration: const BoxDecoration(
//             color: kWhite,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30.0),
//               topRight: Radius.circular(30.0),
//             ),
//           ),
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 15.0),
//                 Row(
//                   children: [
//                     Container(
//                       height: 80,
//                       width: 80,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                           image: AssetImage('images/profile3.png'),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10.0),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'User Name',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
//                         ),
//                         Text(
//                           'email@gmail.com',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: kTextStyle.copyWith(color: kLightNeutralColor),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20.0),
//                 Text(
//                   'Basic Information',
//                   style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 15.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         'First Name',
//                         style: kTextStyle.copyWith(color: kSubTitleColor),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 4,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             ':',
//                             style: kTextStyle.copyWith(color: kSubTitleColor),
//                           ),
//                           const SizedBox(width: 10.0),
//                           Flexible(
//                             child: Text(
//                               'Shahidul',
//                               style: kTextStyle.copyWith(color: kSubTitleColor),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         'Last Name',
//                         style: kTextStyle.copyWith(color: kSubTitleColor),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 4,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             ':',
//                             style: kTextStyle.copyWith(color: kSubTitleColor),
//                           ),
//                           const SizedBox(width: 10.0),
//                           Flexible(
//                             child: Text(
//                               'Islam',
//                               style: kTextStyle.copyWith(color: kSubTitleColor),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         'User Name',
//                         style: kTextStyle.copyWith(color: kSubTitleColor),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 4,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             ':',
//                             style: kTextStyle.copyWith(color: kSubTitleColor),
//                           ),
//                           const SizedBox(width: 10.0),
//                           Flexible(
//                             child: Text(
//                               'shaidulislam',
//                               style: kTextStyle.copyWith(color: kSubTitleColor),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         'Email',
//                         style: kTextStyle.copyWith(color: kSubTitleColor),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 4,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             ':',
//                             style: kTextStyle.copyWith(color: kSubTitleColor),
//                           ),
//                           const SizedBox(width: 10.0),
//                           Flexible(
//                             child: Text(
//                               'shaidulislam@gmail.com',
//                               style: kTextStyle.copyWith(color: kSubTitleColor),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         'Phone Number',
//                         style: kTextStyle.copyWith(color: kSubTitleColor),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 4,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             ':',
//                             style: kTextStyle.copyWith(color: kSubTitleColor),
//                           ),
//                           const SizedBox(width: 10.0),
//                           Flexible(
//                             child: Text(
//                               '(+1) 3635 654454 548',
//                               style: kTextStyle.copyWith(color: kSubTitleColor),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         'Country',
//                         style: kTextStyle.copyWith(color: kSubTitleColor),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 4,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             ':',
//                             style: kTextStyle.copyWith(color: kSubTitleColor),
//                           ),
//                           const SizedBox(width: 10.0),
//                           Flexible(
//                             child: Text(
//                               'United States',
//                               style: kTextStyle.copyWith(color: kSubTitleColor),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         'Address',
//                         style: kTextStyle.copyWith(color: kSubTitleColor),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 4,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             ':',
//                             style: kTextStyle.copyWith(color: kSubTitleColor),
//                           ),
//                           const SizedBox(width: 10.0),
//                           Flexible(
//                             child: Text(
//                               '5205 North Kierland Blvd. Suite 100',
//                               style: kTextStyle.copyWith(color: kSubTitleColor),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         'City',
//                         style: kTextStyle.copyWith(color: kSubTitleColor),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 4,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             ':',
//                             style: kTextStyle.copyWith(color: kSubTitleColor),
//                           ),
//                           const SizedBox(width: 10.0),
//                           Flexible(
//                             child: Text(
//                               'Scottsdale',
//                               style: kTextStyle.copyWith(color: kSubTitleColor),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         'State',
//                         style: kTextStyle.copyWith(color: kSubTitleColor),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 4,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             ':',
//                             style: kTextStyle.copyWith(color: kSubTitleColor),
//                           ),
//                           const SizedBox(width: 10.0),
//                           Flexible(
//                             child: Text(
//                               'AZ',
//                               style: kTextStyle.copyWith(color: kSubTitleColor),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         'ZIP/Post Code',
//                         style: kTextStyle.copyWith(color: kSubTitleColor),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 4,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             ':',
//                             style: kTextStyle.copyWith(color: kSubTitleColor),
//                           ),
//                           const SizedBox(width: 10.0),
//                           Flexible(
//                             child: Text(
//                               '12365',
//                               style: kTextStyle.copyWith(color: kSubTitleColor),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         'Language',
//                         style: kTextStyle.copyWith(color: kSubTitleColor),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 4,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             ':',
//                             style: kTextStyle.copyWith(color: kSubTitleColor),
//                           ),
//                           const SizedBox(width: 10.0),
//                           Flexible(
//                             child: Text(
//                               'English',
//                               style: kTextStyle.copyWith(color: kSubTitleColor),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         'Gender',
//                         style: kTextStyle.copyWith(color: kSubTitleColor),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 4,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             ':',
//                             style: kTextStyle.copyWith(color: kSubTitleColor),
//                           ),
//                           const SizedBox(width: 10.0),
//                           Flexible(
//                             child: Text(
//                               'Male',
//                               style: kTextStyle.copyWith(color: kSubTitleColor),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:freelancer/screen/widgets/button_global.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../widgets/constant.dart';
import 'client_setup_profile.dart'; // Adjust import as needed

// Model classes to represent the data
class UserProfile {
  final String name;
  final String email;
  final String mobile;
  final String dpImage;
  final String? bannerImage;
  final List<String> industries;
  final List<BankAccount> bankAccounts;
  final List<UserAddress> addresses;

  UserProfile({
    required this.name,
    required this.email,
    required this.mobile,
    required this.dpImage,
    this.bannerImage,
    required this.industries,
    required this.bankAccounts,
    required this.addresses,
  });
}

class BankAccount {
  final String? beneficiaryName;
  final String? accountNumber;
  final String? ifscCode;
  final String? upiAddress;
  final bool isPrimary;

  BankAccount({
    this.beneficiaryName,
    this.accountNumber,
    this.ifscCode,
    this.upiAddress,
    required this.isPrimary,
  });
}

class UserAddress {
  final String? addressType;
  final String? addressLine1;
  final String? addressLine2;
  final String? landmark;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  UserAddress({
    this.addressType,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
    required this.isDefault,
  });
}

class ClientProfileDetails extends StatefulWidget {
  const ClientProfileDetails({super.key});

  @override
  State<ClientProfileDetails> createState() => _ClientProfileDetailsState();
}

class _ClientProfileDetailsState extends State<ClientProfileDetails> {
  // Sample data (replace with actual data from API or passed arguments)
  final UserProfile userProfile = UserProfile(
    name: 'Shahidul Islam',
    email: 'shaidulislam@gmail.com',
    mobile: '(+1) 3635 654454 548',
    dpImage: 'images/profile3.png',
    bannerImage: 'images/banner.png',
    industries: ['Technology', 'Finance'],
    bankAccounts: [
      BankAccount(
        beneficiaryName: 'Shahidul Islam',
        accountNumber: '1234567890',
        ifscCode: 'ABCD0123456',
        upiAddress: 'shahidul@upi',
        isPrimary: true,
      ),
      BankAccount(
        beneficiaryName: 'Shahidul Islam',
        accountNumber: '0987654321',
        ifscCode: 'WXYZ9876543',
        upiAddress: 'shahidul2@upi',
        isPrimary: false,
      ),
    ],
    addresses: [
      UserAddress(
        addressType: 'Primary',
        addressLine1: '5205 North Kierland Blvd. Suite 100',
        addressLine2: 'Apartment 5B',
        landmark: 'Near Central Park',
        city: 'Scottsdale',
        state: 'AZ',
        country: 'United States',
        postalCode: '12365',
        latitude: 33.5091,
        longitude: -111.9276,
        isDefault: true,
      ),
      UserAddress(
        addressType: 'Secondary',
        addressLine1: '1234 Elm Street',
        addressLine2: 'Building C',
        landmark: 'Opposite City Mall',
        city: 'Phoenix',
        state: 'AZ',
        country: 'United States',
        postalCode: '85001',
        latitude: 33.4484,
        longitude: -112.0740,
        isDefault: false,
      ),
    ],
  );

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
          style: kTextStyle.copyWith(
              color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: ButtonGlobalWithIcon(
        buttontext: 'Edit Profile',
        buttonDecoration: kButtonDecoration.copyWith(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: () {
          const SetupClientProfile().launch(context);
        },
        buttonTextColor: kWhite,
        buttonIcon: IconlyBold.edit,
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
            child: Column(
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
                        image: DecorationImage(
                          image: AssetImage(userProfile.dpImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProfile.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: kTextStyle.copyWith(
                            color: kNeutralColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          userProfile.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: kTextStyle.copyWith(color: kLightNeutralColor),
                        ),
                      ],
                    ),
                  ],
                ),
                // if (userProfile.bannerImage != null) ...[
                //   const SizedBox(height: 20.0),
                //   Container(
                //     height: 100,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       image: DecorationImage(
                //         image: AssetImage(userProfile.bannerImage!),
                //         fit: BoxFit.cover,
                //       ),
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //   ),
                // ],
                const SizedBox(height: 20.0),
                Text(
                  'Basic Information',
                  style: kTextStyle.copyWith(
                      color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15.0),
                _buildInfoRow('Name', userProfile.name),
                _buildInfoRow('Email', userProfile.email),
                _buildInfoRow('Mobile', userProfile.mobile),
                const SizedBox(height: 20.0),
                Text(
                  'Industries',
                  style: kTextStyle.copyWith(
                      color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15.0),
                _buildInfoRow('Industries', userProfile.industries.join(', ')),
                const SizedBox(height: 20.0),
                Text(
                  'Bank Accounts',
                  style: kTextStyle.copyWith(
                      color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15.0),
                ...userProfile.bankAccounts.asMap().entries.map((entry) {
                  int index = entry.key;
                  BankAccount account = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank Account ${index + 1}${account.isPrimary ? " (Primary)" : ""}',
                        style: kTextStyle.copyWith(
                            color: kNeutralColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),
                      _buildInfoRow('Beneficiary Name',
                          account.beneficiaryName ?? 'N/A'),
                      _buildInfoRow('Account Number',
                          account.accountNumber ?? 'N/A'),
                      _buildInfoRow('IFSC Code', account.ifscCode ?? 'N/A'),
                      _buildInfoRow('UPI Address', account.upiAddress ?? 'N/A'),
                      const SizedBox(height: 15.0),
                    ],
                  );
                }),
                const SizedBox(height: 20.0),
                Text(
                  'Addresses',
                  style: kTextStyle.copyWith(
                      color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15.0),
                ...userProfile.addresses.asMap().entries.map((entry) {
                  int index = entry.key;
                  UserAddress address = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address ${index + 1}${address.isDefault ? " (Default)" : ""}',
                        style: kTextStyle.copyWith(
                            color: kNeutralColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),
                      _buildInfoRow('Address Type', address.addressType ?? 'N/A'),
                      _buildInfoRow(
                          'Address Line 1', address.addressLine1 ?? 'N/A'),
                      _buildInfoRow(
                          'Address Line 2', address.addressLine2 ?? 'N/A'),
                      _buildInfoRow('Landmark', address.landmark ?? 'N/A'),
                      _buildInfoRow('City', address.city ?? 'N/A'),
                      _buildInfoRow('State', address.state ?? 'N/A'),
                      _buildInfoRow('Country', address.country ?? 'N/A'),
                      _buildInfoRow('Postal Code', address.postalCode ?? 'N/A'),
                      _buildInfoRow('Latitude',
                          address.latitude?.toString() ?? 'N/A'),
                      _buildInfoRow('Longitude',
                          address.longitude?.toString() ?? 'N/A'),
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