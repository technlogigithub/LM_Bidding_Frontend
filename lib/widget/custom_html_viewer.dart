import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class CustomHtmlViewer extends StatelessWidget {
  final String htmlContent;

  const CustomHtmlViewer({
    super.key,
    required this.htmlContent,
  });

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlContent,
    );
  }
}