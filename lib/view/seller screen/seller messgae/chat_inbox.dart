import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../core/app_constant.dart';
import '../../../service/socket_service.dart';
import '../seller popUp/seller_popup.dart';
import 'model/chat_model.dart';
import 'provider/data_provider.dart';


class ChatInbox extends StatefulWidget {
  final String? img;
  final String? name;

  const ChatInbox({super.key, this.img, this.name});

  @override
  State<ChatInbox> createState() => _ChatInboxState();
}

class _ChatInboxState extends State<ChatInbox>
    with SingleTickerProviderStateMixin { // ✅ FIXED: Added mixin

  // final SocketService _socketService = SocketService();

  final SocketService _socketService = SocketService();

  //__________Popup Functions________________________________________________
  void showBlockPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: const BlockingReasonPopUp(),
        );
      },
    );
  }

  Future<void> showAddFilePopUp() async {
    final result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: const ImportDocumentPopUp(),
        );
      },
    );

    if (result != null && result is String) {
      final lower = result.toLowerCase();
      final isImage = lower.endsWith('.jpg') ||
          lower.endsWith('.jpeg') ||
          lower.endsWith('.png') ||
          lower.endsWith('.gif') ||
          lower.endsWith('.bmp') ||
          lower.endsWith('.webp');

      setState(() {
        selectedPath = result;
        isImageSelected = isImage;
        messageController.text = ''; // clear text field for visual preview
      });
    }
  }





  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  final FocusNode msgFocusNode = FocusNode();

  List<InboxData> data = maanInboxChatDataList();
  bool showTime = false;
  bool isTyping = false;
  bool isSenderTyping = false;
  late AnimationController _dotController;
  String? selectedPath; // holds selected image/file path
  bool isImageSelected = false; // true if it's an image


  @override
  void initState() {
    super.initState();

    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    // ✅ 1. Connect first
      _socketService.connect('user_456');  // use your id

      // ✅ 2. Listen for incoming messages
      _socketService.onMessageReceived((messageData) {
        setState(() {
          data.insert(
            0,
            InboxData(
              id: 1, // receiver side
              message: messageData['message'],
            ),
          );
        });
      });

    // ✅ 3. Scroll listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 10) {
        if (!showTime) setState(() => showTime = true);
      } else {
        if (showTime) setState(() => showTime = false);
      }
    });
  }

  @override
  void dispose() {
    _dotController.dispose();
    scrollController.dispose();
    messageController.dispose();
    msgFocusNode.dispose();
    _socketService.disconnect(); // ✅ Disconnect cleanly
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.appWhite,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leadingWidth: 24,
        iconTheme: const IconThemeData(color: kNeutralColor),
        backgroundColor: Colors.transparent,   // important
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appbarColor,   // <-- your gradient applied here
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(radius: 20, backgroundImage: NetworkImage(widget.img.validate())),
            15.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name.validate(), style: AppTextStyle.title(color: AppColors.appTextColor)),
                Text('Online', style: AppTextStyle.description(color: AppColors.appTextColor)),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
              child: PopupMenuButton(
                color: AppColors.appColor,
                itemBuilder: (BuildContext bc) => [
                  PopupMenuItem(
                    child: Text('Block', style: AppTextStyle.body(color: AppColors.appTextColor))
                        .onTap(() => showBlockPopUp()),
                  ),
                  PopupMenuItem(
                    child: Text('Report', style:  AppTextStyle.body(color: AppColors.appTextColor)),
                  ),
                ],
                child: Icon(FeatherIcons.moreVertical, color: AppColors.appTextColor),
              ),
            ),
          ),
        ],
      ),


      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,  // 🎨 FULL PAGE GRADIENT HERE
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                8.height,
                AnimatedOpacity(
                  opacity: showTime ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text('10 June 25 9:41 AM', style: AppTextStyle.description(color: AppColors.appTitleColor)),
                ),
                8.height,

                /// Message list
                ListView.builder(
                  padding: const EdgeInsets.all(10),
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final isSender = item.id == 0;

                    return isSender
                        ? _buildSenderBubble(item)
                        : _buildReceiverBubble(item);
                  },
                ),
              ],
            ),
          ),
        ),
      ),


      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildSenderBubble(InboxData item) {
    final message = item.message.validate();

    // detect image or document
    final lower = message.toLowerCase();
    final isImage = lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.bmp') ||
        lower.endsWith('.webp');
    final isDoc = lower.endsWith('.pdf') ||
        lower.endsWith('.doc') ||
        lower.endsWith('.docx') ||
        lower.endsWith('.txt') ||
        lower.endsWith('.xlsx');

    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: AppColors.appColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: isImage
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(message),
                  width: 180,
                  fit: BoxFit.cover,
                ),
              )
                  : isDoc
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Icon(Icons.insert_drive_file,
                      color: AppColors.appTextColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message.split('/').last,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.body(color: AppColors.appTextColor),
                    ),
                  ),
                ],
              )
                  : Text(
                message,
                style: AppTextStyle.description(color: AppColors.appTextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiverBubble(InboxData item) {
    final message = item.message.validate();

    final lower = message.toLowerCase();
    final isImage = lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.bmp') ||
        lower.endsWith('.webp');
    final isDoc = lower.endsWith('.pdf') ||
        lower.endsWith('.doc') ||
        lower.endsWith('.docx') ||
        lower.endsWith('.txt') ||
        lower.endsWith('.xlsx');

    return Padding(
      padding: const EdgeInsets.only(right: 50, left: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: AppColors.appMutedColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: isImage
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(message),
                  width: 180,
                  fit: BoxFit.cover,
                ),
              )
                  : isDoc
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.insert_drive_file,
                      color: Colors.black87),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message.split('/').last,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.description(color: AppColors.appMutedTextColor),
                    ),
                  ),
                ],
              )
                  : Text(
                message,
                style: AppTextStyle.description(color: AppColors.appMutedTextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBottomBar(BuildContext context) {

    return Container(
      padding: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
      gradient: AppColors.appPagecolor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ Preview area
          if (selectedPath != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Row(
                children: [
                  // Show image or doc preview
                  isImageSelected
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(selectedPath!),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Row(
                    children: [
                       Icon(Icons.insert_drive_file, color: AppColors.appIconColor),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 180,
                        child: Text(
                          selectedPath!.split('/').last,
                          overflow: TextOverflow.ellipsis,
                          style:  AppTextStyle.body(color: AppColors.appBodyTextColor),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Close (remove preview)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.redAccent),
                    onPressed: () {
                      setState(() {
                        selectedPath = null;
                        isImageSelected = false;
                      });
                    },
                  )
                ],
              ),
            ),

          // ✅ Message input
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: showAddFilePopUp,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.appColor,
                    ),
                    child: Icon(FeatherIcons.link, color: AppColors.appTextColor),
                  ),
                ),
                8.width,
                Expanded(
                  child: Container(
                    padding:  EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: AppColors.appMutedColor,
                    ),
                    child: AppTextField(
                      controller: messageController,
                      textFieldType: TextFieldType.OTHER,
                      focus: msgFocusNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Message...',
                        hintStyle: AppTextStyle.description(color: AppColors.appMutedTextColor),
                        suffixIcon: Icon(Icons.send_outlined,
                            size: 24, color: AppColors.appColor)
                            .paddingAll(4.0)
                            .onTap(() {
                          // ✅ If image or doc selected, send that
                          if (selectedPath != null) {
                            addMessageWithAttachment(selectedPath!);
                            setState(() {
                              selectedPath = null;
                              isImageSelected = false;
                            });
                          } else if (messageController.text.isNotEmpty) {
                            addMessage();
                            messageController.clear();
                          }
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void addMessage() {
    hideKeyboard(context);
    final message = messageController.text.trim();
    if (message.isEmpty) return;

    final messageData = {
      'senderId': 'user_456',  // user id
      'receiverId': 'user_123', // receiver id
      'message': message,
      'type': 'text',  // doc, image , text
      'time': DateTime.now().toIso8601String(),
    };

    _socketService.sendMessage(messageData);

    setState(() {
      data.insert(0, InboxData(id: 0, message: message));
      messageController.clear();
    });

    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void addMessageWithAttachment(String path) {
    hideKeyboard(context);
    setState(() {
      data.insert(0, InboxData(id: 0, message: path));
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }




}
