import 'package:flutter/material.dart';
import 'package:libdding/core/app_color.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../core/app_constant.dart';


class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  List<String> languageList = [
    'English',
    'Bengali',
    'Hindi',
    'Francais',
    'Italiano',
  ];

  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkWhite,
      appBar: AppBar(
        backgroundColor: AppColors.darkWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.neutralColor),
        title: Text(
          'Language',
          style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
          ),
          width: context.width(),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 30.0),
              ListView.builder(
                itemCount: languageList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (_, i) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        selectedLanguage = languageList[i];
                      });
                    },
                    visualDensity: const VisualDensity(vertical: -3),
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(bottom: 15),
                    title: Text(
                      languageList[i],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: kTextStyle.copyWith(color: AppColors.neutralColor),
                    ),
                    trailing: Icon(
                      selectedLanguage == languageList[i] ? Icons.check : null,
                      color: AppColors.appColor,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
