import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../core/app_color.dart';
import '../../../core/app_constant.dart';
import 'chat_inbox.dart';
import 'model/chat_model.dart';
import 'provider/data_provider.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  RxList<ChatModel> list_data = maanGetChatList().obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.appPagecolor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.appTextColor),
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.appbarColor,
            ),
          ),
          title: Text(
            'Message',
            style: AppTextStyle.title(
              color: AppColors.appTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              gradient: AppColors.appPagecolor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),

            child: Obx(() => ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: list_data.length,
              itemBuilder: (context, index) {
                final data = list_data[index];

                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10),
                  decoration: BoxDecoration(
                    gradient: AppColors.appPagecolor,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.appMutedColor,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        data.image.validate(),
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      data.title.validate(),
                      style: AppTextStyle.title(),
                    ),
                    subtitle: Text(
                      data.subTitle.validate(),
                      style: AppTextStyle.description(),
                    ),
                    trailing: Text(
                      "11.05 AM",
                      style: AppTextStyle.description(),
                    ),
                    onTap: () {
                      ChatInbox(
                        img: data.image.validate(),
                        name: data.title.validate(),
                      ).launch(context);
                    },
                  ),
                );
              },
            )),
          ),
        ),
      ),
    );
  }
}
