import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_textstyle.dart';

class BidBottomSheet extends StatefulWidget {
  const BidBottomSheet({super.key});

  @override
  State<BidBottomSheet> createState() => _BidBottomSheetState();
}

class _BidBottomSheetState extends State<BidBottomSheet> {
  final TextEditingController bidController = TextEditingController();
  int quantity = 1; // default qty
  Duration remaining = const Duration(minutes: 10); // 10 min countdown
  Timer? timer;

  // Example data
  int currentBid = 12000;
  int minIncrement = 500;

  @override
  void initState() {
    super.initState();
    bidController.text = (currentBid + minIncrement).toString();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remaining.inSeconds > 0) {
        setState(() {
          remaining = Duration(seconds: remaining.inSeconds - 1);
        });
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    bidController.dispose();
    super.dispose();
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  void increaseBid() {
    int currentValue = int.tryParse(bidController.text) ?? currentBid;
    currentValue += minIncrement;
    bidController.text = currentValue.toString();
    setState(() {});
  }

  void decreaseBid() {
    int currentValue = int.tryParse(bidController.text) ?? currentBid;
    if (currentValue - minIncrement >= currentBid) {
      currentValue -= minIncrement;
      bidController.text = currentValue.toString();
      setState(() {});
    }
  }

  Widget buildCounterButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 26, color: AppColors.appIconColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration:  BoxDecoration(
      gradient: AppColors.appPagecolor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Grab handle
          Container(
            height: 5.h,
            width: 50.w,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.appMutedColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Title & countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Place Your Bid",
               style: AppTextStyle.title(),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.appPagecolor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.appMutedColor,
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, 5),
                      // blurRadius: 1,
                      // spreadRadius: 1,
                      // offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  "⏱ ${formatTime(remaining)}",
                  style:  AppTextStyle.description(
                      color: AppColors.appDescriptionColor,
                      fontWeight: FontWeight.bold,),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Enter your bid amount for this project. Make sure it is above the current highest bid.",
            style: AppTextStyle.description(
              color: AppColors.appDescriptionColor,
            ),
          ),
          const SizedBox(height: 20),

          // Info card
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.appMutedColor,
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // ✅ LEFT COLUMN
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Highest Bid",
                        style: AppTextStyle.description(
                          color: AppColors.appDescriptionColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "₹ $currentBid",
                        style: AppTextStyle.body(
                          color: AppColors.appDescriptionColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12), // spacing between columns

                // ✅ RIGHT COLUMN
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Min Increment",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.description(
                          color: AppColors.appDescriptionColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "₹ $minIncrement",
                        style: AppTextStyle.body(
                          color: AppColors.appDescriptionColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

          // Bid amount input with +/- buttons
          Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                  gradient: AppColors.appPagecolor,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCounterButton(Icons.remove, decreaseBid),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Center(
                            child: TextField(
                              controller: bidController,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.title(
                                  fontWeight: FontWeight.bold,),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        buildCounterButton(Icons.add, increaseBid),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: AppColors.appPagecolor,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCounterButton(Icons.remove, () {
                          if (quantity > 1) setState(() => quantity--);
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "$quantity",
                            style: AppTextStyle.title(
                              fontWeight: FontWeight.bold,),
                          ),
                        ),
                        buildCounterButton(Icons.add, () {
                          setState(() => quantity++);
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 25),

          // Submit button
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: () {
              final bidAmount = bidController.text.trim();
              if (bidAmount.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter a bid amount")),
                );
                return;
              }

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "Your bid of ₹$bidAmount x $quantity has been placed!"),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.appButtonColor,
                borderRadius: BorderRadius.circular(14),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black26,
                //     blurRadius: 6,
                //     offset: Offset(0, 3),
                //   ),
                // ],
              ),
              alignment: Alignment.center,
              child: Text(
                "Submit Bid",
                style: AppTextStyle.title(
                  fontWeight: FontWeight.bold,
                  color: AppColors.appButtonTextColor,
                ),
              ),
            ),
          ),
        )

        ],
        ),
      ),
    );
  }
}
