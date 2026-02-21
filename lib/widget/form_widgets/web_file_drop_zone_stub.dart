// Stub file for non-web platforms
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

// Stub functions for non-web platforms
Uint8List? getWebFileBytes(String path) {
  return null;
}

void storeWebFileBytes(String path, Uint8List bytes) {
  // No-op on non-web platforms
}

void clearWebFileBytes(String path) {
  // No-op on non-web platforms
}

class WebFileDropZone extends StatelessWidget {
  final Widget child;
  final bool isDragging;
  final Function(bool) onDragStateChanged;
  final Function(List<File>) onFilesDropped;
  final VoidCallback? onTap;

  const WebFileDropZone({
    super.key,
    required this.child,
    required this.isDragging,
    required this.onDragStateChanged,
    required this.onFilesDropped,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

