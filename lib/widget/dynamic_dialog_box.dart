import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../controller/post/get_post_details_controller.dart';
import '../core/utils.dart';
import '../models/App_moduls/AppResponseModel.dart';
import '../models/Post/Get_Post_details_Model.dart';
import '../service/socket_service_interface.dart';
import 'form_widgets/dynamic_form_builder.dart';

class DynamicDialogBox extends StatefulWidget {
  final String? title;
  final String? description;
  final String? pageImage;
  final dynamic design;
  final String? apiEndpoint;
  final Future<bool> Function(String endpoint, Map<String, dynamic> formData)? onSubmit;

  const DynamicDialogBox({super.key, this.title, this.description, this.pageImage, this.design, this.apiEndpoint, this.onSubmit});

  @override
  State<DynamicDialogBox> createState() => _DynamicDialogBoxState();
}

class _DynamicDialogBoxState extends State<DynamicDialogBox> {
  final TextEditingController bidController = TextEditingController();
  int quantity = 1; // default qty
  Duration remaining = const Duration(minutes: 10); // 10 min countdown
  Timer? timer;
  
  Map<String, dynamic> formValues = {};

  // Example data
  int currentBid = 12000;
  int minIncrement = 500;

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
          // Fallback for Map
       }

       if (inputsList != null) {
         for (var item in inputsList) {
             String key = item.name ?? '';
             if (key.isNotEmpty) {
               formValues[key] = item.value ?? '1';
             }
         }
       }
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
       remaining = Duration.zero; 
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    bidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.transparent, // Background handled by Container
      elevation: 0,
      insetPadding: const EdgeInsets.all(20),
      child: Center(
       child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500), // Max width for web dialog
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            gradient: (widget.pageImage == null || widget.pageImage!.isEmpty)
                ? null // Dialog usually has white bg, but can use gradient if needed. Sticking to white for cleaner look on web unless specified.
                : null,
            image: (widget.pageImage != null && widget.pageImage!.isNotEmpty)
                ? DecorationImage(
                    image: NetworkImage(widget.pageImage!),
                    fit: BoxFit.cover,
                  )
                : null,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title ?? "",
                        style: AppTextStyle.title().copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      color: AppColors.appIconColor,
                    ),
                  ],
                ),
                
                if (remaining.inSeconds > 0) ...[
                  const SizedBox(height: 10),
                  SlideCountdownSeparated(
                    duration: remaining,
                    separatorType: SeparatorType.symbol,
                    separatorStyle: AppTextStyle.body(color: Colors.transparent),
                    decoration: BoxDecoration(
                      color: AppColors.appButtonColor,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                ],

                const SizedBox(height: 15),
                Text(
                  widget.description ?? "",
                  style: AppTextStyle.description(
                    color: AppColors.appDescriptionColor,
                  ),
                ),
                const SizedBox(height: 25),

                // Dynamic Inputs
                if (widget.design != null)
                  Builder(
                    builder: (context) {
                      List<RegisterInput> inputs = [];
                      
                      if (widget.design is SubmitButtonDesign) {
                         inputs = (widget.design as SubmitButtonDesign).inputs ?? [];
                      } else if (widget.design is Map && widget.design['inputs'] != null) {
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

                      final filteredInputs = inputs.where((input) {
                        final type = (input.inputType ?? '').toLowerCase();
                        return type != 'button';
                      }).toList();

                      return DynamicFormBuilder(
                        inputs: filteredInputs,
                        formData: formValues,
                        onFieldChanged: (key, value) {
                          setState(() {
                            formValues[key] = value;
                          });
                        },
                        errors: {}, 
                      );
                    },
                  ),

                const SizedBox(height: 25),

                // Submit Button
                Builder(
                  builder: (context) {
                    List<RegisterInput> inputs = [];
                    if (widget.design is SubmitButtonDesign) {
                       inputs = (widget.design as SubmitButtonDesign).inputs ?? [];
                    } else if (widget.design is Map && widget.design['inputs'] != null) {
                        var rawInputs = widget.design['inputs'];
                        if (rawInputs is List) {
                          for (var item in rawInputs) {
                            if (item is Map) {
                              inputs.add(RegisterInput.fromJson(Map<String, dynamic>.from(item)));
                            }
                          }
                        }
                    }

                    final buttonInput = inputs.firstWhereOrNull((input) => (input.inputType ?? '').toLowerCase() == 'button');
                    final buttonLabel = buttonInput?.label ?? "Submit";
                    
                    String? targetEndpoint = widget.apiEndpoint;

                    if (buttonInput != null && buttonInput.name != null) {
                      if (widget.design is SubmitButtonDesign) {
                        final endpoints = (widget.design as SubmitButtonDesign).inputApiEndpoints;
                        if (endpoints.containsKey(buttonInput.name)) {
                          targetEndpoint = endpoints[buttonInput.name];
                        }
                      } else if (widget.design is Map && widget.design['inputs'] is List) {
                         final rawInputs = widget.design['inputs'] as List;
                         for (var ri in rawInputs) {
                            if (ri is Map && (ri['input_type'] ?? '').toString().toLowerCase() == 'button' && ri['api_endpoint'] != null) {
                               targetEndpoint = ri['api_endpoint'].toString();
                               break;
                            }
                         }
                      }
                    }

                    return SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () async {
                          final Map<String, dynamic> finalBody = {};
                          
                          formValues.forEach((key, value) {
                            final input = inputs.firstWhereOrNull((i) => i.name == key);
                            if (input != null) {
                              final type = (input.inputType ?? '').toLowerCase();
                              if (type != 'button' && type != 'custom_horizontal_bullets') {
                                finalBody[key] = value;
                              }
                            } else {
                              if (key != 'button' && key != 'custom_horizontal_bullets') {
                                finalBody[key] = value;
                              }
                            }
                          });

                          if (targetEndpoint != null && targetEndpoint!.isNotEmpty) {
                            bool success = false;
                            if (widget.onSubmit != null) {
                               success = await widget.onSubmit!(targetEndpoint!, finalBody);
                            } else {
                               if (Get.isRegistered<GetPostDetailsController>()) {
                                 final controller = Get.find<GetPostDetailsController>();
                                 success = await controller.submitDynamicForm(
                                    endpoint: targetEndpoint!,
                                    formData: finalBody,
                                 );
                               } else {
                                 Utils.showSnackbar(isSuccess: false, title: "Error", message: "Controller not found");
                               }
                            }

                            if (success) {
                              Navigator.pop(context, true);
                            }
                          } else {
                            Navigator.pop(context, true);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.appButtonColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            buttonLabel,
                            style: AppTextStyle.title(
                              fontWeight: FontWeight.bold,
                              color: AppColors.appButtonTextColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
