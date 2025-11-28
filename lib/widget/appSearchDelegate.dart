import 'package:flutter/material.dart';
import 'package:libdding/core/app_textstyle.dart';

import '../core/app_color.dart';


class CustomSearchDelegate extends SearchDelegate {
  List<String> searchItems = [
    'UI UX Designer',
    'Logo designer',
    'App developer',
    'Designer',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: IconButton(
          onPressed: () {
            query = '';
          },
          icon:  Icon(Icons.clear, color: AppColors.appIconColor),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      color: AppColors.appTextColor,
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back, color: AppColors.appIconColor),
    );
  }


  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = searchItems
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      decoration: BoxDecoration(
        gradient:AppColors.appPagecolor
      ),
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(
              matchQuery[i],
              style: AppTextStyle.description(
                color: AppColors.appDescriptionColor,
              ),
            ),
          );
        },
      ),
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = searchItems
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.appPagecolor
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: matchQuery.length,
        itemBuilder: (_, i) {
          return Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Text(
                  matchQuery[i],
                  style: AppTextStyle.description(
                      color: AppColors.appDescriptionColor),
                ),
              ),
              const Spacer(),
              Icon(Icons.clear, color: AppColors.appIconColor),
            ],
          );
        },
      ),
    );
  }

}
