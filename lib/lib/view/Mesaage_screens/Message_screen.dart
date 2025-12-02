import 'package:flutter/material.dart';

import '../../core/app_color.dart';
class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.appWhite,
        appBar: AppBar(
          title: Text("Message"),
          centerTitle: true,
        ),
      ),
    );
  }
}
