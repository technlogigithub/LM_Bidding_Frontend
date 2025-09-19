import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:freelancer/screen/app_config/api_config.dart';
import 'package:freelancer/screen/client%20screen/client%20help%20support/client_help_support.dart';
import 'package:freelancer/screen/client%20screen/client%20home/client_home.dart';
import 'package:freelancer/screen/client%20screen/client%20profile/client_profile_details.dart';
import 'package:freelancer/screen/client%20screen/client_authentication/client_log_in.dart';
import 'package:freelancer/screen/client%20screen/client_authentication/client_login_mobile.dart';
import 'package:freelancer/screen/seller%20screen/add%20payment%20method/seller_add_payment_method.dart';
import 'package:freelancer/screen/seller%20screen/buyer%20request/seller_buyer_request.dart';
import 'package:freelancer/screen/seller%20screen/withdraw_money/seller_withdraw_history.dart';
import 'package:freelancer/screen/seller%20screen/withdraw_money/seller_withdraw_money.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../widgets/constant.dart';
import '../client dashboard/client_dashboard.dart';
import '../client favourite/client_favourite_list.dart';
import '../client invite/client_invite.dart';
import '../client report/client_report.dart';
import '../client_setting/client_setting.dart';
import '../deposit/add_deposit.dart';
import '../deposit/deposit_history.dart';
import '../transaction/transaction.dart';

class ClientProfile extends StatefulWidget {
  const ClientProfile({super.key});

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  @override
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final res = await ApiService.getRequest("ordersApi");
      setState(() {
        notifications = res["data"] ??
            []; // <-- API response structure ke hisaab se adjust karna
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      toast("Error: $e");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        backgroundColor: kDarkWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: kNeutralColor),
        titleSpacing: 0,
        title: ListTile(
          visualDensity: const VisualDensity(vertical: -4),
          contentPadding: EdgeInsets.zero,
          leading: Container(
            height: 45,
            width: 45,
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kDarkWhite,
              image: DecorationImage(
                  image: AssetImage('images/profile1.png'), fit: BoxFit.cover),
            ),
          ),
          title: Text(
            'User Name',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: kTextStyle.copyWith(color: kNeutralColor),
          ),
          subtitle: RichText(
            text: TextSpan(
              text: 'Balance: ',
              style: kTextStyle.copyWith(color: kLightNeutralColor),
              children: [
                TextSpan(
                  text: '$currencySign 500.00',
                  style: kTextStyle.copyWith(color: kNeutralColor),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
              children: [
                const SizedBox(height: 20.0),
                ListTile(
                  onTap: () => const ClientProfileDetails().launch(context),
                  visualDensity: const VisualDensity(vertical: -3),
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.only(bottom: 20),
                  leading: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE2EED8),
                    ),
                    child: const Icon(
                      IconlyBold.profile,
                      color: kPrimaryColor,
                    ),
                  ),
                  title: Text(
                    'My Profile',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    color: kLightNeutralColor,
                  ),
                ),
                ListTile(
                  onTap: () => const ClientDashBoard().launch(context),
                  visualDensity: const VisualDensity(vertical: -3),
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.only(bottom: 20),
                  leading: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE3EDFF),
                    ),
                    child: const Icon(
                      IconlyBold.chart,
                      color: Color(0xFF144BD6),
                    ),
                  ),
                  title: Text(
                    'Dashboard',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    color: kLightNeutralColor,
                  ),
                ),
                ListTile(
                  onTap: () => const SellerBuyerReq().launch(context),
                  visualDensity: const VisualDensity(vertical: -3),
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.only(bottom: 20),
                  leading: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFD0F1FF),
                    ),
                    child: const Icon(
                      IconlyBold.paper,
                      color: Color(0xFF06AEF3),
                    ),
                  ),
                  title: Text(
                    'Buyer Request',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    color: kLightNeutralColor,
                  ),
                ),
                ListTile(
                  onTap: () => const SellerAddPaymentMethod().launch(context),
                  visualDensity: const VisualDensity(vertical: -3),
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.only(bottom: 12),
                  leading: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFE5E3),
                    ),
                    child: const Icon(
                      IconlyBold.ticketStar,
                      color: Color(0xFFFF3B30),
                    ),
                  ),
                  title: Text(
                    'Add Payment method',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    color: kLightNeutralColor,
                  ),
                ),
                Theme(
                  data: ThemeData(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.zero,
                    tilePadding: const EdgeInsets.only(bottom: 10),
                    collapsedIconColor: kLightNeutralColor,
                    iconColor: kLightNeutralColor,
                    title: Text(
                      'Deposit',
                      style: kTextStyle.copyWith(color: kNeutralColor),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFEFE0),
                      ),
                      child: const Icon(
                        IconlyBold.wallet,
                        color: Color(0xFFFF7A00),
                      ),
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronDown,
                      color: kLightNeutralColor,
                    ),
                    children: [
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -3),
                        horizontalTitleGap: 10,
                        contentPadding: const EdgeInsets.only(left: 60),
                        title: Text(
                          'Add Deposit',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: kTextStyle.copyWith(color: kNeutralColor),
                        ),
                        trailing: const Icon(
                          FeatherIcons.chevronRight,
                          color: kLightNeutralColor,
                        ),
                        onTap: () => const AddDeposit().launch(context),
                      ),
                      ListTile(
                        onTap: () => const DepositHistory().launch(context),
                        visualDensity: const VisualDensity(vertical: -3),
                        horizontalTitleGap: 10,
                        contentPadding: const EdgeInsets.only(left: 60),
                        title: Text(
                          'Deposit History',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: kTextStyle.copyWith(color: kNeutralColor),
                        ),
                        trailing: const Icon(
                          FeatherIcons.chevronRight,
                          color: kLightNeutralColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Theme(
                  data: ThemeData(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.zero,
                    tilePadding: const EdgeInsets.only(bottom: 10),
                    collapsedIconColor: kLightNeutralColor,
                    iconColor: kLightNeutralColor,
                    title: Text(
                      'Withdraw',
                      style: kTextStyle.copyWith(color: kNeutralColor),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE2EED8),
                      ),
                      child: Icon(
                        IconlyBold.wallet,
                        color: kPrimaryColor,
                      ),
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronDown,
                      color: kLightNeutralColor,
                    ),
                    children: [
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -3),
                        horizontalTitleGap: 10,
                        contentPadding: const EdgeInsets.only(left: 60),
                        title: Text(
                          'Withdraw Amount',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: kTextStyle.copyWith(color: kNeutralColor),
                        ),
                        trailing: const Icon(
                          FeatherIcons.chevronRight,
                          color: kLightNeutralColor,
                        ),
                        onTap: () =>
                            const SellerWithdrawMoney().launch(context),
                      ),
                      ListTile(
                        onTap: () =>
                            const SellerWithDrawHistory().launch(context),
                        visualDensity: const VisualDensity(vertical: -3),
                        horizontalTitleGap: 10,
                        contentPadding: const EdgeInsets.only(left: 60),
                        title: Text(
                          'Withdrawal History',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: kTextStyle.copyWith(color: kNeutralColor),
                        ),
                        trailing: const Icon(
                          FeatherIcons.chevronRight,
                          color: kLightNeutralColor,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () => const ClientTransaction().launch(context),
                  visualDensity: const VisualDensity(vertical: -3),
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.only(bottom: 12),
                  leading: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE8E1FF),
                    ),
                    child: const Icon(
                      IconlyBold.ticketStar,
                      color: Color(0xFF7E5BFF),
                    ),
                  ),
                  title: Text(
                    'Transaction',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    color: kLightNeutralColor,
                  ),
                ),
                ListTile(
                  onTap: () => const ClientFavList().launch(context),
                  visualDensity: const VisualDensity(vertical: -3),
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.only(bottom: 15),
                  leading: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFE5E3),
                    ),
                    child: const Icon(
                      IconlyBold.heart,
                      color: Color(0xFFFF3B30),
                    ),
                  ),
                  title: Text(
                    'Favorite',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    color: kLightNeutralColor,
                  ),
                ),
                ListTile(
                  onTap: () => const ClientReport().launch(context),
                  visualDensity: const VisualDensity(vertical: -3),
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.only(bottom: 15),
                  leading: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFD0F1FF),
                    ),
                    child: const Icon(
                      IconlyBold.document,
                      color: Color(0xFF06AEF3),
                    ),
                  ),
                  title: Text(
                    'Seller Report',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    color: kLightNeutralColor,
                  ),
                ),
                ListTile(
                  onTap: () => const ClientSetting().launch(context),
                  visualDensity: const VisualDensity(vertical: -3),
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.only(bottom: 15),
                  leading: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFDDED),
                    ),
                    child: const Icon(
                      IconlyBold.setting,
                      color: Color(0xFFFF298C),
                    ),
                  ),
                  title: Text(
                    'Setting',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    color: kLightNeutralColor,
                  ),
                ),
                ListTile(
                  onTap: () => const ClientInvite().launch(context),
                  visualDensity: const VisualDensity(vertical: -3),
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.only(bottom: 15),
                  leading: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE2EED8),
                    ),
                    child: const Icon(
                      IconlyBold.addUser,
                      color: kPrimaryColor,
                    ),
                  ),
                  title: Text(
                    'Invite Friends',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    color: kLightNeutralColor,
                  ),
                ),
                ListTile(
                  onTap: () => const ClientHelpSupport().launch(context),
                  visualDensity: const VisualDensity(vertical: -3),
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.only(bottom: 15),
                  leading: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE3EDFF),
                    ),
                    child: const Icon(
                      IconlyBold.danger,
                      color: Color(0xFF144BD6),
                    ),
                  ),
                  title: Text(
                    'Help & Support',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    color: kLightNeutralColor,
                  ),
                ),
                ListTile(
                  visualDensity: const VisualDensity(vertical: -3),
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.only(bottom: 15),
                  leading: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFEFE0),
                    ),
                    child: const Icon(
                      IconlyBold.logout,
                      color: Color(0xFFFF7A00),
                    ),
                  ),
                  title: Text(
                    'Log Out',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    color: kLightNeutralColor,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: const Text("Confirm Logout"),
                          content:
                              const Text("Are you sure you want to log out?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // dialog close
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                              ),
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('isLoggedIn', false);

                                // replace current page with login page and pass the current page as redirect
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ClientHome(
                                     // ya jis page pe user wapas aana chahte ho
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Yes, Logout",
                                style: TextStyle(color: kDarkWhite),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
