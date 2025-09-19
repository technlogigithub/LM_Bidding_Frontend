import 'package:flutter/material.dart';

class RestrictedPage extends StatelessWidget {
  const RestrictedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Restricted Page")),
      body: Center(child: Text("This is a restricted page")),
    );
  }
}
