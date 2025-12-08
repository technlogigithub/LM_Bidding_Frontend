import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../core/api_config.dart';
import '../../core/app_constant.dart';
import '../../core/app_textstyle.dart';
import '../../widget/button_global.dart';
import 'client_add_card.dart';

class ClientOrder extends StatefulWidget {
  const ClientOrder({super.key});

  @override
  State<ClientOrder> createState() => _ClientOrderState();
}

class _ClientOrderState extends State<ClientOrder> {
  List<String> paymentMethod = [
    'Credit or Debit Card',
    'Paypal',
    'bkash',
  ];

  String selectedPaymentMethod = 'Credit or Debit Card';
  bool isFavorite = false;
  List<String> imageList = [
    'images/creditcard.png',
    'images/paypal2.png',
    'images/bkash2.png',
  ];
 List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }
  Future<void> fetchOrders() async {
    try {
      final res = await  ApiService.getRequest("ordersApi");
      setState(() {
        notifications = res["data"] ?? []; // <-- API response structure ke hisaab se adjust karna
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      toast("Error: $e");
    }
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhite,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.appWhite,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.neutralColor),
        title: Text(
          'Order',
          style: AppTextStyle.kTextStyle.copyWith(
            color: AppColors.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: AppColors.appWhite),
        child: ButtonGlobalWithoutIcon(
          buttontext: 'Continue',
          buttonDecoration: kButtonDecoration.copyWith(
            color: AppColors.appColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () {
            setState(() {
              const AddNewCard().launch(context);
            });
          },
          buttonTextColor: AppColors.appWhite,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          width: context.width(),
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
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColors.kBorderColorTextField),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.appWhite,
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                                topLeft: Radius.circular(8.0),
                              ),
                              image: DecorationImage(
                                  image: AssetImage(
                                    'images/shot1.png',
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   isFavorite = !isFavorite;
                              // });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10.0,
                                      spreadRadius: 1.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isFavorite
                                    ? const Center(
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 16.0,
                                        ),
                                      )
                                    : Center(
                                        child: Icon(
                                          Icons.favorite_border,
                                          color: AppColors.neutralColor,
                                          size: 16.0,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: SizedBox(
                                width: 190,
                                child: Text(
                                  'Mobile UI UX design or app UI UX design.',
                                  style: AppTextStyle.kTextStyle.copyWith(
                                    color: AppColors.appTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  IconlyBold.star,
                                  color: Colors.amber,
                                  size: 18.0,
                                ),
                                const SizedBox(width: 2.0),
                                Text(
                                  '5.0',
                                  style: AppTextStyle.kTextStyle.copyWith(
                                    color: AppColors.appTextColor,
                                  ),
                                ),
                                const SizedBox(width: 2.0),
                                Text(
                                  '(520)',
                                  style: AppTextStyle.kTextStyle.copyWith(
                                    color: AppColors.textgrey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            RichText(
                              text: TextSpan(
                                text: 'Price: ',
                                style: AppTextStyle.kTextStyle.copyWith(
                                  color: AppColors.textgrey,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${AppStrings.currencySign}${30}',
                                    style: AppTextStyle.kTextStyle.copyWith(
                                      color: AppColors.appColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(
                  'Order Details',
                  style: AppTextStyle.kTextStyle.copyWith(
                    color: AppColors.textgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text(
                      'Delivery days',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.subTitleColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '2 days',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.subTitleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text(
                      'Revisions',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.subTitleColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Unlimited',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.subTitleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text(
                      '3 Page/Screen',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.subTitleColor,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_rounded,
                      color: AppColors.appColor,
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text(
                      'Responsive design',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.subTitleColor,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_rounded,
                      color: AppColors.appColor,
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text(
                      'Source file',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.subTitleColor,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_rounded,
                      color: AppColors.appColor,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Payment Method',
                  style: AppTextStyle.kTextStyle.copyWith(
                    color: AppColors.subTitleColor,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 20.0),
                ListView.builder(
                  itemCount: paymentMethod.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: AppColors.appWhite,
                          border: Border.all(color: AppColors.kBorderColorTextField),
                        ),
                        child: ListTile(
                          visualDensity: const VisualDensity(vertical: -2),
                          onTap: () {
                            setState(
                              () {
                                selectedPaymentMethod = paymentMethod[i];
                              },
                            );
                          },
                          contentPadding: const EdgeInsets.only(right: 8.0),
                          leading: Container(
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(image: AssetImage(imageList[i]), fit: BoxFit.cover),
                            ),
                          ),
                          title: Text(
                            paymentMethod[i],
                            style: AppTextStyle.kTextStyle.copyWith(
                              color: AppColors.appTextColor,
                            ),
                          ),
                          trailing: Icon(
                            selectedPaymentMethod == paymentMethod[i] ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                            color: selectedPaymentMethod == paymentMethod[i] ? AppColors.appColor : AppColors.subTitleColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Order Summary',
                  style: AppTextStyle.kTextStyle.copyWith(
                    color: AppColors.appTextColor,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Text(
                      'Subtotal',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.subTitleColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${AppStrings.currencySign}${30}',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.subTitleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      'Service Fee',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.subTitleColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${AppStrings.currencySign}${5.50}',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.subTitleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      'Total',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.appTextColor,
                          fontWeight: FontWeight.bold, fontSize: 18.0
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${AppStrings.currencySign}${35.50}',
                      style: AppTextStyle.kTextStyle.copyWith(
                          color: AppColors.appTextColor,
                          fontWeight: FontWeight.bold, fontSize: 18.0
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      'Delivery Date',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.subTitleColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Thursday, 14 July 2023',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.subTitleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
