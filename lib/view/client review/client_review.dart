import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:libdding/core/app_color.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../core/app_constant.dart';
import '../../widget/button_global.dart';
import '../seller screen/orders/seller_orders.dart';
import '../seller screen/profile/seller_profile.dart';
import '../seller screen/seller home/seller_home_screen.dart';
import '../seller screen/seller messgae/chat_list.dart';
import '../seller screen/seller services/create_service.dart';

class ClientOrderReview extends StatefulWidget {
  const ClientOrderReview({super.key});

  @override
  State<ClientOrderReview> createState() => _ClientOrderReviewState();
}

class _ClientOrderReviewState extends State<ClientOrderReview> {
  //__________review_Submitted_PopUp________________________________________________
  void reviewSubmittedPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const ReviewSubmittedPopUp(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkWhite,
      appBar: AppBar(
        backgroundColor: AppColors.darkWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.neutralColor),
        title: Text(
          'Write a Review',
          style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: AppColors.appWhite),
        child: ButtonGlobalWithoutIcon(
            buttontext: 'Published Review',
            buttonDecoration: kButtonDecoration.copyWith(color: AppColors.appColor, borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {
              reviewSubmittedPopUp();
            },
            buttonTextColor: AppColors.appWhite),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          width: context.width(),
          height: context.height(),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
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
                Text(
                  'Review your experience',
                  style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'How would you rate your overall experience with this buyer?',
                  style: kTextStyle.copyWith(color: AppColors.subTitleColor),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('images/profilepic2.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'William Liam',
                        style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        'Seller Level - 1',
                        style: kTextStyle.copyWith(color: AppColors.subTitleColor),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Select Rating',
                  style: kTextStyle.copyWith(color: AppColors.neutralColor),
                ),
                const SizedBox(height: 5.0),
                RatingBarWidget(
                  itemCount: 5,
                  activeColor: AppColors.ratingBarColor,
                  inActiveColor: AppColors.kBorderColorTextField,
                  onRatingChanged: (rating) {
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  cursorColor: AppColors.neutralColor,
                  maxLines: 3,
                  decoration: kInputDecoration.copyWith(
                      labelText: 'Write a Comment',
                      labelStyle: kTextStyle.copyWith(color: AppColors.neutralColor),
                      hintText: 'Share your experience...',
                      hintStyle: kTextStyle.copyWith(color: AppColors.textgrey),
                      focusColor: AppColors.neutralColor,
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Upload Image (Optional)',
                  style: kTextStyle.copyWith(color: AppColors.neutralColor),
                ),
                const SizedBox(height: 10.0),
                Container(
                  width: 93,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: AppColors.appWhite,
                    border: Border.all(color: AppColors.kBorderColorTextField),
                  ),
                  child: Center(
                    child: Icon(
                      IconlyBold.camera,
                      color: AppColors.textgrey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReviewSubmittedPopUp extends StatefulWidget {
  const ReviewSubmittedPopUp({super.key});

  @override
  State<ReviewSubmittedPopUp> createState() => _ReviewSubmittedPopUpState();
}

class _ReviewSubmittedPopUpState extends State<ReviewSubmittedPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            Container(
              height: 124,
              width: 124,
              decoration: BoxDecoration(
                color: AppColors.appColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: AppColors.appColor,
                size: 50,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Successfully',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Thank you so much you\'ve just publish your review',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: AppColors.textgrey),
            ),
            const SizedBox(height: 20.0),
            ButtonGlobalWithoutIcon(
                buttontext: 'got it!',
                buttonDecoration: kButtonDecoration.copyWith(
                  color: AppColors.appColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  setState(() {
                    finish(context);
                    const SellerHome().launch(context);
                  });
                },
                buttonTextColor: AppColors.appWhite),
          ],
        ),
      ),
    );
  }
}


class SellerHome extends StatefulWidget {
  const SellerHome({super.key});

  @override
  State<SellerHome> createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  int _currentPage = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    SellerHomeScreen(),
    ChatListScreen(),
    CreateService(),
    SellerOrderList(),
    SellerProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhite,
      body: _widgetOptions.elementAt(_currentPage),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
            boxShadow: [BoxShadow(color: AppColors.darkWhite, blurRadius: 5.0, spreadRadius: 3.0, offset: Offset(0, -2))]),
        child: BottomNavigationBar(
          elevation: 0.0,
          selectedItemColor: AppColors.appColor,
          unselectedItemColor: AppColors.textgrey,
          backgroundColor: AppColors.appWhite,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(IconlyBold.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyBold.chat),
              label: "Message",
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyBold.paperPlus),
              label: "Service",
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyBold.document),
              label: "Orders",
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyBold.profile),
              label: "Profile",
            ),
          ],
          onTap: (int index) {
            setState(() => _currentPage = index);
          },
          currentIndex: _currentPage,
        ),
      ),
    );
  }
}