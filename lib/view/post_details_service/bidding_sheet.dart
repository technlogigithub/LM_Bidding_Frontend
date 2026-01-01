import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../models/App_moduls/AppResponseModel.dart';
import '../../models/Post/Get_Post_details_Model.dart';
import '../../widget/form_widgets/dynamic_form_builder.dart';

class BidBottomSheet extends StatefulWidget {
  final String? title;
  final String? description;
  final String? pageImage;
  final dynamic design;

  const BidBottomSheet({super.key, this.title, this.description, this.pageImage, this.design});

  @override
  State<BidBottomSheet> createState() => _BidBottomSheetState();
}

class _BidBottomSheetState extends State<BidBottomSheet> {
  // ... existing state variables ...
  final TextEditingController bidController = TextEditingController();
  int quantity = 1; // default qty
  Duration remaining = const Duration(minutes: 10); // 10 min countdown
  Timer? timer;
  
  Map<String, dynamic> formValues = {};

  // Example data
  int currentBid = 12000;
  int minIncrement = 500;
  // ... existing initState, dispose and methods ...

  @override
  void initState() {
    super.initState();
    bidController.text = (currentBid + minIncrement).toString();
    
    // Initialize form values from design if available
    if (widget.design != null) {
       List<RegisterInput>? inputsList;
       
       if (widget.design is SubmitButtonDesign) {
          inputsList = (widget.design as SubmitButtonDesign).inputs;
       } else if (widget.design is Map && widget.design['inputs'] != null) {
          // Fallback for Map (if passed as raw JSON)
          // Handle Map construction
          // ... (simplified for brevity as we prioritize new model)
       }

       if (inputsList != null) {
         for (var item in inputsList) {
             String key = item.name ?? '';
             if (key.isNotEmpty) {
               formValues[key] = item.value ?? '1';
             }
         }
       }
       
       // Legacy handling for raw maps if necessary (omitted for cleaner refactor, assuming model usage)
    }

    // Handle Countdown
    String? countdownStr;
    if (widget.design is SubmitButtonDesign) {
       countdownStr = (widget.design as SubmitButtonDesign).countdown;
    } else if (widget.design is Map) {
       countdownStr = widget.design['countdown'];
    }

    if (countdownStr != null && countdownStr.isNotEmpty) {
       try {
         final target = DateTime.parse(countdownStr);
         final now = DateTime.now();
         final diff = target.difference(now);
         if (diff.isNegative) {
            remaining = Duration.zero;
         } else {
            remaining = diff;
         }
       } catch (e) {
         debugPrint("Error parsing countdown date: $e");
         remaining = Duration.zero;
       }
    } else {
       // Default or fallback (optional)
       remaining = Duration.zero; 
    }
    
    // No need for manual timer if we are using SlideCountdownSeparated with a duration
    // But if we want to update the UI or do something else when finished, we might need listeners. 
    // For now, I will remove the manual timer since it was updating 'remaining' state which might conflict or be redundant if 'SlideCountdownSeparated' is used.
    // However, the original code had a manual timer. I will remove it to rely on the widget or if the user wants custom logic. 
    // The user request specific "backend side se jo date and time aa rha hai or current date ,time hai uske base par countdown show karna hai UI me".
    // So setting 'remaining' is the key.
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
    print("Page Image  >>${widget.pageImage}");
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: (widget.pageImage == null || widget.pageImage!.isEmpty)
            ? AppColors.appPagecolor
            : null,
        image: (widget.pageImage != null && widget.pageImage!.isNotEmpty)
            ? DecorationImage(
                image: NetworkImage(widget.pageImage!),
                fit: BoxFit.cover,
              )
            : null,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: const [
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Grab handle
          Center(
            child: Container(
              height: 5.h,
              width: 50.w,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.appMutedColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Title & countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title ?? "",
               style: AppTextStyle.title(),
              ),


              if (remaining.inSeconds > 0)
                SlideCountdownSeparated(
                  duration: remaining,
                  separatorType: SeparatorType.symbol,
                  separatorStyle: AppTextStyle.body(color: Colors.transparent),
                  decoration: BoxDecoration(
                    color: AppColors.appButtonColor,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),

              // Container(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              //   decoration: BoxDecoration(
              //     gradient: AppColors.appPagecolor,
              //     borderRadius: BorderRadius.circular(12),
              //     boxShadow: [
              //       BoxShadow(
              //         color: AppColors.appMutedColor,
              //         blurRadius: 5,
              //         spreadRadius: 1,
              //         offset: Offset(0, 5),
              //         // blurRadius: 1,
              //         // spreadRadius: 1,
              //         // offset: Offset(0, 6),
              //       ),
              //     ],
              //   ),
              //   child: Text(
              //     "⏱ ${formatTime(remaining)}",
              //     style:  AppTextStyle.description(
              //         color: AppColors.appDescriptionColor,
              //         fontWeight: FontWeight.bold,),
              //   ),
              // ),
            ],
          ),
           SizedBox(height: 15.h),
          Text(
            widget.description ?? "",
            style: AppTextStyle.description(
              color: AppColors.appDescriptionColor,
            ),
          ),
            SizedBox(height: 20.h),
          // const SizedBox(height: 20),

            // Dynamic Inputs rendering
            if (widget.design != null)
              Builder(
                builder: (context) {
                  List<RegisterInput> inputs = [];
                  
                  if (widget.design is SubmitButtonDesign) {
                     inputs = (widget.design as SubmitButtonDesign).inputs ?? [];
                  } else if (widget.design is Map && widget.design['inputs'] != null) {
                      // Fallback for raw map
                      var rawInputs = widget.design['inputs'];
                      if (rawInputs is Map) {
                        rawInputs.forEach((key, value) {
                          if (value is Map) {
                            Map<String, dynamic> json = Map<String, dynamic>.from(value);
                            json['name'] = key.toString(); 
                            inputs.add(RegisterInput.fromJson(json));
                          }
                        });
                      } else if (rawInputs is List) {
                        for (var item in rawInputs) {
                          if (item is Map) {
                            inputs.add(RegisterInput.fromJson(Map<String, dynamic>.from(item)));
                          }
                        }
                      }
                  }

                  if (inputs.isEmpty) return const SizedBox.shrink();

                  return DynamicFormBuilder(
                    inputs: inputs,
                    formData: formValues,
                    onFieldChanged: (key, value) {
                      setState(() {
                        formValues[key] = value;
                      });
                    },
                    errors: {}, // Handle errors if needed
                  );
                },
              ),

            // Fallback to static fields if no design provided
            // Column(
            //   children: [
            //     CounterInput(
            //       label: "Bid Price",
            //       value: bidController.text,
            //       showCurrency: true,
            //       onIncrease: increaseBid,
            //       onDecrease: decreaseBid,
            //     ),
            //     const SizedBox(height: 12),
            //     CounterInput(
            //       label: "Quantity",
            //       value: quantity.toString(),
            //       onIncrease: () => setState(() => quantity++),
            //       onDecrease: () {
            //         if (quantity > 1) setState(() => quantity--);
            //       },
            //     ),
            //   ],
            // ),



            const SizedBox(height: 15),

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
