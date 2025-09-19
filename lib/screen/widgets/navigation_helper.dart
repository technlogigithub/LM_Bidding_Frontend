import 'package:flutter/material.dart';
import 'package:freelancer/screen/client%20screen/client_authentication/client_log_in.dart';
import 'package:nb_utils/nb_utils.dart';

class NavigationHelper {
  static void navigateToPage(BuildContext context, Widget page) async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // User already logged in → directly go to the page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    } else {
      // User not logged in → go to login page and pass the selected page as redirectPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ClientLogIn(redirectPage: page),
        ),
      );
    }
  }
}
