import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../../controller/participation/participation_detail_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../models/Participate/participate_details_model.dart';
import '../../widget/form_widgets/app_button.dart';
import '../../widget/custom_view_widget.dart';
import '../../widget/form_widgets/app_textfield.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/network.dart';
import '../../core/app_constant.dart';
import '../../widget/custom_navigator.dart';
import '../seller screen/seller messgae/chat_list.dart';
import '../../widget/custom_alert_dialog.dart';

class ParticipateDetailsScreen extends StatefulWidget {
  const ParticipateDetailsScreen({super.key});

  @override
  State<ParticipateDetailsScreen> createState() => _ParticipateDetailsScreenState();
}

class _ParticipateDetailsScreenState extends State<ParticipateDetailsScreen> {
  final controller = Get.put(ParticipationDetailController());
  String? apiEndpoint;

  @override
  void initState() {
    super.initState();
    // Get endpoint from arguments
    apiEndpoint = Get.arguments as String?;
    if (apiEndpoint != null && apiEndpoint!.isNotEmpty) {
      controller.getParticipationDetails(apiEndpoint!);
    } else {
      // If no endpoint, stop shimmer
      controller.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool iskweb = kIsWeb;
    final bool isdesktop = GetPlatform.isDesktop;

    if (iskweb || isdesktop) {
      return Obx(() {
        if (controller.isLoading.value) {
          return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(decoration: BoxDecoration(gradient: AppColors.appbarColor)),
              toolbarHeight: 80,
            ),
            body: _buildShimmerLoading(),
          );
        }
        return _buildWebLayout(context);
      });
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: AppColors.appTextColor),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.appbarColor),
          ),
          toolbarHeight: 80,
          centerTitle: true,
          title: Text(
            "Participation Details",
            style: AppTextStyle.title(
              color: AppColors.appTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          // title: Obx(() {
          //   final result = controller.detailResponse.value?.result;
          //   if (result == null) return const SizedBox.shrink();
          //
          //   // Priority: 1. Details Title, 2. Hidden ViewType
          //   String? title = result.details?.title?.toString();
          //   if (title == null || title.isEmpty) {
          //      title = result.hidden?.viewType?.toString().replaceAll('_', ' ').capitalizeFirst;
          //   }
          //
          //   return Text(
          //     title ?? "",
          //     style: AppTextStyle.title(
          //       color: AppColors.appTextColor,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   );
          // }),
          actions: [
            Obx(() {
               final result = controller.detailResponse.value?.result;
               final menuButtons = result?.menuButton ?? [];
               final actionButtons = result?.actionButton ?? [];

               List<Widget> appBarActions = [];

               // 1. Dynamic Action Buttons (e.g. Chat, Share icons)
               if (actionButtons.isNotEmpty) {
                 appBarActions.addAll(actionButtons.map((btn) {
                   return IconButton(
                     icon: _getIconForMenu(btn.icon?.toString()),
                     onPressed: () => _handleMenuAction(btn),
                   );
                 }));
               }

               // 2. Dynamic More Button (3-dots)
               if (menuButtons.isNotEmpty) {
                 appBarActions.add(
                   PopupMenuButton<MenuButton>(
                     padding: EdgeInsets.zero,
                     icon: Icon(Icons.more_vert_rounded, color: AppColors.appTextColor),
                     onSelected: (btn) => _handleMenuAction(btn),
                     itemBuilder: (context) => menuButtons.map((btn) {
                       return PopupMenuItem<MenuButton>(
                         value: btn,
                         child: Row(
                           children: [
                             _getIconForMenu(btn.icon?.toString()),
                             const SizedBox(width: 10),
                             Text(
                               btn.label?.toString() ?? '',
                               style: AppTextStyle.body(color: AppColors.appBodyTextColor),
                             ),
                           ],
                         ),
                       );
                     }).toList(),
                   ),
                 );
               }

               return Row(children: appBarActions);
            }),
          ],
        ),
        bottomNavigationBar: Obx(() {
          final result = controller.detailResponse.value?.result;
          if (result == null || result.submitButton == null || result.submitButton!.isEmpty) {
            return const SizedBox.shrink();
          }

          // Filter out payment buttons as requested (assuming payment buttons have 'pay' or 'payment' in label or api_endpoint)
          final buttons = result.submitButton!.where((btn) {
             final label = btn.label?.toString().toLowerCase() ?? '';
             final endpoint = btn.apiEndpoint?.toString().toLowerCase() ?? '';
             return !label.contains('pay') && !label.contains('payment') && 
                    !endpoint.contains('pay') && !endpoint.contains('payment');
          }).toList();

          if (buttons.isEmpty) return const SizedBox.shrink();

          return Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.050, vertical: screenHeight * 0.010),
            decoration: BoxDecoration(
              gradient: AppColors.appPagecolor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: buttons.map((btn) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: CustomButton(
                      onTap: () {
                        _handleSubmitButtonTap(btn);
                      },
                      text: btn.label?.toString() ?? '',
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          child: Obx(() {
            if (controller.isLoading.value) {
              return _buildShimmerLoading();
            }

            final result = controller.detailResponse.value?.result;
            if (result == null) {
              return const Center(child: Text("No data found"));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Address Section (First)
                  if (result.address != null) _buildAddressCard(result.address!),

                  // 2. Items List (Followed by address)
                  if (result.items != null && result.items!.isNotEmpty)
                    ...result.items!.map((item) => _buildItemsSection(item)).toList(),

                  // 3. Details Section (Key-Value)
                  if (result.details != null) _buildDetailsSection(result.details!),

                  // 4. Info Section (Key-Value)
                  if (result.info != null) _buildInfoSection(result.info!),

                  const SizedBox(height: 30),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    final result = controller.detailResponse.value?.result;
    if (result == null) return const SizedBox.shrink();

    // Filter submit buttons (same as mobile)
    final submitButtons = result.submitButton?.where((btn) {
      final label = btn.label?.toString().toLowerCase() ?? '';
      final endpoint = btn.apiEndpoint?.toString().toLowerCase() ?? '';
      return !label.contains('pay') && !label.contains('payment') &&
          !endpoint.contains('pay') && !endpoint.contains('payment');
    }).toList() ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appbarColor),
        ),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: AppColors.appTextColor),
        title: Text(
          "Participation Details",
          style: AppTextStyle.title(color: AppColors.appTextColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(() {
            final res = controller.detailResponse.value?.result;
            final menuButtons = res?.menuButton ?? [];
            final actionButtons = res?.actionButton ?? [];

            List<Widget> appBarActions = [];

            if (actionButtons.isNotEmpty) {
              appBarActions.addAll(actionButtons.map((btn) {
                return IconButton(
                  icon: _getIconForMenu(btn.icon?.toString()),
                  onPressed: () => _handleMenuAction(btn),
                );
              }));
            }

            if (menuButtons.isNotEmpty) {
              appBarActions.add(
                PopupMenuButton<MenuButton>(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.more_vert_rounded, color: AppColors.appTextColor),
                  onSelected: (btn) => _handleMenuAction(btn),
                  itemBuilder: (context) => menuButtons.map((btn) {
                    return PopupMenuItem<MenuButton>(
                      value: btn,
                      child: Row(
                        children: [
                          _getIconForMenu(btn.icon?.toString()),
                          const SizedBox(width: 10),
                          Text(
                            btn.label?.toString() ?? '',
                            style: AppTextStyle.body(color: AppColors.appBodyTextColor),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }

            return Row(children: appBarActions);
          }),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT COLUMN (Address & Items)
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (result.address != null) _buildAddressCard(result.address!),
                          if (result.items != null && result.items!.isNotEmpty)
                            ...result.items!.map((item) => _buildItemsSection(item)).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),

                    // RIGHT COLUMN (Summary & Buttons)
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(gradient: AppColors.appPagecolor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Summary",
                                    style: AppTextStyle.title(fontWeight: FontWeight.bold).copyWith(fontSize: 20)),
                                const SizedBox(height: 24),
                                if (result.details != null) _buildDetailsSection(result.details!),
                                if (result.info != null) _buildInfoSection(result.info!),
                                const Divider(),
                                const SizedBox(height: 24),
                                if (submitButtons.isNotEmpty)
                                  Column(
                                    children: _generateButtonRows(submitButtons),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _generateButtonRows(List<SubmitButton> buttons) {
    List<Widget> rows = [];
    for (int i = 0; i < buttons.length; i += 2) {
      if (i > 0) rows.add(const SizedBox(height: 10)); // Gap between rows

      if (i + 1 < buttons.length) {
        rows.add(Row(
          children: [
            Expanded(
                child: CustomButton(
                    text: buttons[i].label?.toString() ?? '', onTap: () => _handleSubmitButtonTap(buttons[i]))),
            const SizedBox(width: 10),
            Expanded(
                child: CustomButton(
                    text: buttons[i + 1].label?.toString() ?? '', onTap: () => _handleSubmitButtonTap(buttons[i + 1]))),
          ],
        ));
      } else {
        rows.add(Row(
          children: [
            Expanded(
                child: CustomButton(
                    text: buttons[i].label?.toString() ?? '', onTap: () => _handleSubmitButtonTap(buttons[i]))),
          ],
        ));
      }
    }
    return rows;
  }

  Widget _buildAddressCard(Address address) {
    if (address.description == null && address.title == null && address.label == null) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.appPagecolor,
        boxShadow: [BoxShadow(color: AppColors.appMutedColor, blurRadius: 5, spreadRadius: 1, offset: const Offset(0, 10))],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Label and Title
          Row(
            children: [
              Text(
                address.label?.toString() ?? '', 
                style: AppTextStyle.description(color: AppColors.appDescriptionColor)
              ),
              Text(
                " : ${address.title?.toString() ?? ''}",
                style: AppTextStyle.title(fontWeight: FontWeight.bold, color: AppColors.appTitleColor),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Row 2: Icon and Description
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.place_outlined, color: AppColors.appIconColor, size: 20),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  address.description?.toString() ?? '', 
                  style: AppTextStyle.description(color: AppColors.appDescriptionColor)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(Items item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: FutureBuilder(
        future: _fetchItemsIfNecessary(item),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildItemsShimmer();
          }
          final itemsList = snapshot.data as List<dynamic>? ?? [];
          if (itemsList.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.label?.isNotEmpty == true)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 12.0),
                  child: Text(item.label?.toString() ?? '', style: AppTextStyle.title()),
                ),
              CustomViewWidget(
                type: item.viewType ?? '',
                itemDataList: itemsList,
                isFromCartScreen: false,
                showWebVerticalList: true,
                nextPageName: item.nextPageName,
                nextPageViewType: item.nextPageViewType,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchItemsIfNecessary(Items item) async {
    if (item.apiEndpoint == null || item.apiEndpoint!.isEmpty) return [];
    return await controller.fetchSectionItems(item.apiEndpoint!);
  }

  Widget _buildDetailsSection(Details details) {
    // Collect all data pairs from Details response
    final Map<String, dynamic> detailsMap = details.rawData ?? {
      if (details.title != null) 'Title': details.title,
      if (details.description != null) 'Description': details.description,
    };

    if (detailsMap.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        ...detailsMap.entries.where((e) => e.value != null && e.value.toString().isNotEmpty).map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(entry.key.toString().replaceAll('_', ' ').capitalizeFirst!, style: AppTextStyle.description(color: AppColors.appDescriptionColor)),
                const Spacer(),
                Text(entry.value.toString(), style: AppTextStyle.body(fontWeight: FontWeight.bold, color: AppColors.appTitleColor)),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildInfoSection(Info info) {
    // Collect all data pairs from Info response
    final Map<String, dynamic> infoMap = info.rawData ?? {
      if (info.participationStatus != null) 'Participation Status': info.participationStatus,
      if (info.status != null) 'Status': info.status,
      if (info.startDateTime != null) 'Start Time': info.startDateTime,
      if (info.endDateTime != null) 'End Time': info.endDateTime,
      if (info.lastBidAmount != null) 'Last Bid Amount': "${AppStrings.currencySign}${info.lastBidAmount}",
      if (info.lastBidTime != null) 'Last Bid Time': info.lastBidTime,
    };

    if (infoMap.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        ...infoMap.entries.where((e) => e.value != null && e.value.toString().isNotEmpty).map((entry) {
          String value = entry.value.toString();
          // Add currency sign for amount fields
          if (entry.key.toString().toLowerCase().contains('amount')) {
            value = "${AppStrings.currencySign}$value";
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(entry.key.toString().replaceAll('_', ' ').capitalizeFirst!, style: AppTextStyle.description(color: AppColors.appDescriptionColor)),
                const Spacer(),
                Text(value, style: AppTextStyle.body(fontWeight: FontWeight.bold, color: AppColors.appTitleColor)),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  void _handleSubmitButtonTap(SubmitButton btn) {
    String? apiEndpoint = btn.apiEndpoint;
    String? nextPageName = btn.nextPageName;
    String? nextPageApiEndpoint = btn.nextPageApiEndpoint;
    String? nextPageViewType = btn.nextPageViewType;
    String? title = btn.title;
    String? description = btn.description;
    String? pageImage = btn.pageImage;
    
    // Check if there's a dynamic form design
    bool hasDesign = btn.design != null && btn.design!.inputs != null && btn.design!.inputs!.isNotEmpty;
    bool hasConfirmData = (title != null && title.isNotEmpty) || (description != null && description.isNotEmpty) || hasDesign;

    bool hasApi = apiEndpoint != null && apiEndpoint.isNotEmpty;
    bool hasNextPage = nextPageName != null && nextPageName.isNotEmpty;
    bool hasNextApi = nextPageApiEndpoint != null && nextPageApiEndpoint.isNotEmpty;
    bool hasNextView = nextPageViewType != null && nextPageViewType.isNotEmpty;

    // RULE 1: Direct API (No navigation, no confirmed data/form)
    if (hasApi && !hasNextPage && !hasNextApi && !hasNextView && !hasConfirmData) {
      controller.executeGeneralAction(apiEndpoint!, '', '');
      return;
    }

    // RULE 2: Navigate + API (or just Navigate)
    if ((hasApi && hasNextApi) || (hasNextPage && !hasConfirmData)) {
       controller.executeGeneralAction(
         apiEndpoint ?? '',
         nextPageName ?? '',
         nextPageViewType ?? '',
       );
       return;
    }

    // RULE 3: Confirm Data / Dynamic Form
    if (hasConfirmData) {
      if (kIsWeb || GetPlatform.isDesktop) {
        _showDynamicDialog(btn);
      } else {
        _showDynamicForm(btn);
      }
      return;
    }
    
    // Fallback: If anything else, try execute
    if (hasApi || hasNextPage) {
      controller.executeGeneralAction(
        apiEndpoint ?? '',
        nextPageName ?? '',
        nextPageViewType ?? '',
      );
    }
  }

  void _showDynamicForm(SubmitButton btn) {
    final formData = <String, dynamic>{}.obs;
    
    for (var input in btn.design!.inputs!) {
      if (input.name != null) {
        formData[input.name!] = input.value ?? '';
      }
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: BoxDecoration(
            gradient: AppColors.appPagecolor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50, height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: AppColors.appMutedColor, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Text(btn.title?.toString() ?? btn.label?.toString() ?? 'Action', style: AppTextStyle.title(fontWeight: FontWeight.bold, fontSize: 20.sp)),
              if (btn.description != null) ...[
                const SizedBox(height: 10),
                Text(btn.description!, style: AppTextStyle.description(color: AppColors.appDescriptionColor)),
              ],
              const SizedBox(height: 25),
              ...btn.design!.inputs!.map((input) {
                if (input.inputType == 'button') {
                  return Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Obx(() => CustomButton(
                      isLoading: controller.isLoadingForm.value,
                      onTap: () {
                        controller.submitSubmitButtonAction(
                          endpoint: input.apiEndpoint ?? btn.apiEndpoint ?? '',
                          formData: formData,
                        );
                      },
                      text: input.label ?? 'Submit',
                    )),
                  );
                }

                if (input.inputType == 'select') {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(input.label ?? '', style: AppTextStyle.body(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: (input.options ?? []).map((opt) {
                            return Obx(() => ChoiceChip(
                              showCheckmark: false,
                              label: Text(opt.label?.toString() ?? '', style: AppTextStyle.description(color: formData[input.name] == opt.value ? Colors.white : AppColors.appBodyTextColor)),
                              selected: formData[input.name] == opt.value,
                              selectedColor: AppColors.appButtonColor,
                              backgroundColor: AppColors.appMutedColor.withOpacity(0.2),
                              onSelected: (selected) {
                                if (selected) formData[input.name!] = opt.value;
                              },
                            ));
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: CustomTextfield(
                    label: input.label ?? '',
                    hintText: input.placeholder ?? '',
                    onChanged: (val) => formData[input.name!] = val,
                  ),
                );
              }).toList(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showDynamicDialog(SubmitButton btn) {
    final formData = <String, dynamic>{}.obs;

    for (var input in btn.design!.inputs!) {
      if (input.name != null) {
        formData[input.name!] = input.value ?? '';
      }
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: AppColors.appPagecolor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(btn.title?.toString() ?? btn.label?.toString() ?? 'Action',
                            style: AppTextStyle.title(fontWeight: FontWeight.bold, fontSize: 22)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  if (btn.description != null) ...[
                    const SizedBox(height: 10),
                    Text(btn.description!, style: AppTextStyle.description(color: AppColors.appDescriptionColor)),
                  ],
                  const SizedBox(height: 25),
                  ...btn.design!.inputs!.map((input) {
                    if (input.inputType == 'button') {
                      return Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Obx(() => CustomButton(
                              isLoading: controller.isLoadingForm.value,
                              onTap: () {
                                controller.submitSubmitButtonAction(
                                  endpoint: input.apiEndpoint ?? btn.apiEndpoint ?? '',
                                  formData: formData,
                                );
                              },
                              text: input.label ?? 'Submit',
                            )),
                      );
                    }

                    if (input.inputType == 'select') {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(input.label ?? '', style: AppTextStyle.body(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: (input.options ?? []).map((opt) {
                                return Obx(() => ChoiceChip(
                                      showCheckmark: false,
                                      label: Text(opt.label?.toString() ?? '',
                                          style: AppTextStyle.description(
                                              color: formData[input.name] == opt.value
                                                  ? Colors.white
                                                  : AppColors.appBodyTextColor)),
                                      selected: formData[input.name] == opt.value,
                                      selectedColor: AppColors.appButtonColor,
                                      backgroundColor: AppColors.appMutedColor.withOpacity(0.2),
                                      onSelected: (selected) {
                                        if (selected) formData[input.name!] = opt.value;
                                      },
                                    ));
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: CustomTextfield(
                        label: input.label ?? '',
                        hintText: input.placeholder ?? '',
                        onChanged: (val) => formData[input.name!] = val,
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(MenuButton btn) {
    if (btn.nextPageName?.toString().isNotEmpty == true && (btn.title == null)) {
      CustomNavigator.navigate(btn.nextPageName.toString());
    } else if (btn.title?.toString().isNotEmpty == true || btn.description?.toString().isNotEmpty == true) {
      _showCustomDialog(btn);
    } else if (btn.apiEndpoint?.toString().isNotEmpty == true) {
      controller.executeGeneralAction(
        btn.apiEndpoint!.toString(),
        btn.nextPageName?.toString() ?? '',
        btn.nextPageViewType?.toString() ?? '',
      );
    }
  }

  void _showCustomDialog(MenuButton menu) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: menu.title ?? menu.label ?? '',
        description: menu.description ?? '',
        backgroundImage: menu.pageImage,
        onConfirm: () async {
          Navigator.pop(context);
          if (menu.apiEndpoint?.isNotEmpty == true) {
            controller.executeGeneralAction(
              menu.apiEndpoint!,
              menu.nextPageName ?? '',
              menu.nextPageViewType ?? '',
            );
          } else if (menu.nextPageName?.isNotEmpty == true) {
            CustomNavigator.navigate(menu.nextPageName);
          }
        },
      ),
    );
  }

   Widget _getIconForMenu(dynamic icon) {
    String? iconName = icon?.toString();
    if (iconName == null || iconName.isEmpty) return Icon(Icons.circle, size: 10, color: AppColors.appIconColor);

    if (iconName.startsWith('http')) {
      return Image.network(
        iconName,
        width: 20,
        height: 20,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 20, color: AppColors.appIconColor),
      );
    }

    if (iconName.contains('chat')) return Icon(IconlyBold.chat, color: AppColors.appIconColor);
    if (iconName.contains('edit')) return Icon(IconlyBold.edit, color: AppColors.appIconColor);
    if (iconName.contains('share')) return Icon(IconlyBold.send, color: AppColors.appIconColor);
    if (iconName.contains('report')) return Icon(IconlyBold.danger, color: AppColors.appIconColor);
    if (iconName.contains('document')) return Icon(IconlyBold.document, color: AppColors.appIconColor);
    return Icon(Icons.circle, size: 10, color: AppColors.appIconColor);
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColors.appMutedColor.withOpacity(0.3),
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: List.generate(
            5,
            (index) => Container(
              height: 120,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemsShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.appMutedColor.withOpacity(0.3),
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(
          2,
          (index) => Container(
            height: 90.h,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}

