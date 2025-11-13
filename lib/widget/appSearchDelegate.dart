import 'package:flutter/material.dart';

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
          icon:  Icon(Icons.clear, color: AppColors.appTextColor),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      color: AppColors.appTextColor,
      onPressed: () {
        close(context, null);
      },
      icon:  Icon(
        Icons.arrow_back,
        color: AppColors.appTextColor,
      ),
    );

    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var car in searchItems) {
      if (car.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(car);
      }
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: matchQuery.length,
      itemBuilder: (_, i) {
        var result = matchQuery[i];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var car in searchItems) {
      if (car.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(car);
      }
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: matchQuery.length,
      itemBuilder: (_, i) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const ClientLogIn()),
                  //
                  // );
                },
                child: Text(
                  matchQuery[i].toString(),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon:  Icon(Icons.clear, color: AppColors.appTextColor),
              )
            ],
          ),
        );
      },
    );
  }
}
