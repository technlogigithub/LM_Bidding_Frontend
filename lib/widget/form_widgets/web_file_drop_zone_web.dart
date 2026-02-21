// Web-specific implementation using dart:html
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

// Static storage for web file bytes (accessed from custom_file_picker)
final Map<String, Uint8List> _webFileBytesStorage = {};

// Export the function so it can be accessed from custom_file_picker
void storeWebFileBytes(String path, Uint8List bytes) {
  _webFileBytesStorage[path] = bytes;
}

Uint8List? getWebFileBytes(String path) {
  return _webFileBytesStorage[path];
}

void clearWebFileBytes(String path) {
  _webFileBytesStorage.remove(path);
}

class WebFileDropZone extends StatefulWidget {
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
  State<WebFileDropZone> createState() => _WebFileDropZoneState();
}

class _WebFileDropZoneState extends State<WebFileDropZone> {
  static int _viewCounter = 0;
  late final String _viewId = 'file_drop_zone_${_viewCounter++}';
  html.DivElement? _dropZoneElement;

  @override
  void initState() {
    super.initState();
    _setupDropZone();
  }

  void _setupDropZone() {
    _dropZoneElement = html.DivElement()
      ..style.position = 'absolute'
      ..style.top = '0'
      ..style.left = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.pointerEvents = 'auto';

    // Forward clicks if onTap is provided
    _dropZoneElement!.onClick.listen((e) {
      if (widget.onTap != null) {
        widget.onTap!();
      }
    });

    // Prevent default drag behaviors
    _dropZoneElement!.onDragOver.listen((e) {
      e.preventDefault();
      e.stopPropagation();
      widget.onDragStateChanged(true);
    });

    _dropZoneElement!.onDragEnter.listen((e) {
      e.preventDefault();
      e.stopPropagation();
      widget.onDragStateChanged(true);
    });

    _dropZoneElement!.onDragLeave.listen((e) {
      e.preventDefault();
      e.stopPropagation();
      // Only trigger drag leave if we're actually leaving the drop zone
      final rect = _dropZoneElement!.getBoundingClientRect();
      final x = e.client.x;
      final y = e.client.y;
      if (x < rect.left || x > rect.right || y < rect.top || y > rect.bottom) {
        widget.onDragStateChanged(false);
      }
    });

    _dropZoneElement!.onDrop.listen((e) {
      e.preventDefault();
      e.stopPropagation();
      widget.onDragStateChanged(false);

      final files = <html.File>[];
      if (e.dataTransfer != null && e.dataTransfer!.files != null) {
        files.addAll(e.dataTransfer!.files!);
      }

      if (files.isNotEmpty) {
        // For web, convert html.File to a format that can be used
        // We'll read the file and create a PlatformFile, then convert to File
        final htmlFile = files.first;
        final reader = html.FileReader();
        
        reader.onLoadEnd.listen((e) {
          final result = reader.result;
          if (result != null) {
            // Convert to Uint8List
            Uint8List? bytes;
            if (result is List<int>) {
              bytes = Uint8List.fromList(result);
            } else if (result is ByteBuffer) {
              bytes = result.asUint8List();
            }
            
            if (bytes != null) {
              // Create a PlatformFile from the dropped file
              // For web, we need to create a File object that can be used
              // Since dart:io File doesn't work on web, we'll use a workaround
              // by creating a File with a special path that indicates it's from web
              // Store the bytes in a static map that can be accessed by the file picker
              final webFilePath = 'web://${htmlFile.name}';
              
              // Store bytes in the static map (will be accessed in custom_file_picker)
              storeWebFileBytes(webFilePath, bytes);
              
              final webFile = File(webFilePath);
              widget.onFilesDropped([webFile]);
            }
          }
        });
        
        reader.readAsArrayBuffer(htmlFile);
      }
    });

    // Register platform view
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) => _dropZoneElement!,
    );
  }

  @override
  void dispose() {
    _dropZoneElement = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: HtmlElementView(viewType: _viewId),
        ),
      ],
    );
  }
}

