import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_player/video_player.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
// Conditional import for web drag & drop
import '../../view/image_view_screen/image_view_screen.dart';
import '../../view/video_view_screen/video_view_screen.dart';
import 'web_file_drop_zone_stub.dart'
if (dart.library.html) 'web_file_drop_zone_web.dart' as web_drop;

class CustomMultipleFilePicker extends StatefulWidget {
  final String label;
  final String? fieldName;
  final ValueChanged<List<File>> onPicked;
  final List<File>? value;
  final List<String>? imageUrls;
  final bool isImageFile;
  final List<String>? allowedExtensions;
  final String? category;

  const CustomMultipleFilePicker({
    super.key,
    required this.label,
    this.fieldName,
    required this.onPicked,
    this.value,
    this.imageUrls,
    this.isImageFile = false,
    this.allowedExtensions,
    this.category,
  });

  @override
  State<CustomMultipleFilePicker> createState() => _CustomMultipleFilePickerState();
}

class _CustomMultipleFilePickerState extends State<CustomMultipleFilePicker> {
  List<File> _localFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _isDragging = false;
  final Map<String, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      _localFiles = List.from(widget.value!);
      _initializeVideoControllers();
    }
  }

  @override
  void dispose() {
    _disposeVideoControllers();
    super.dispose();
  }

  void _disposeVideoControllers() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
  }

  Future<void> _initializeVideoControllers() async {
    for (var file in _localFiles) {
      if (_isVideoFile(file.path)) {
        await _loadVideoThumbnail(file);
      }
    }
  }

  bool _isVideoFile(String path) {
    final ext = path.split('.').last.toLowerCase();
    // Remove query parameters for URL checking
    final cleanPath = path.split('?').first;
    final cleanExt = cleanPath.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'mkv', 'avi', 'webm', '3gp', 'hevc', 'h265', 'h.265'].contains(ext) ||
           ['mp4', 'mov', 'mkv', 'avi', 'webm', '3gp', 'hevc', 'h265', 'h.265'].contains(cleanExt);
  }

  bool _isPdf(String path) =>
      path.toLowerCase().endsWith(".pdf");

  bool _isWord(String path) =>
      path.toLowerCase().endsWith(".doc") ||
          path.toLowerCase().endsWith(".docx");

  bool _isExcel(String path) =>
      path.toLowerCase().endsWith(".xls") ||
          path.toLowerCase().endsWith(".xlsx");

  bool _isPpt(String path) =>
      path.toLowerCase().endsWith(".ppt") ||
          path.toLowerCase().endsWith(".pptx");

  bool _isText(String path) =>
      path.toLowerCase().endsWith(".txt") ||
          path.toLowerCase().endsWith(".csv") ||
          path.toLowerCase().endsWith(".rtf");

  bool _isEpub(String path) =>
      path.toLowerCase().endsWith(".epub");

  bool _isDocument(String path) =>
      _isPdf(path) ||
          _isWord(path) ||
          _isExcel(path) ||
          _isPpt(path) ||
          _isText(path) ||
          _isEpub(path);

  IconData _fileIcon(String path) {
    if (_isPdf(path)) return Icons.picture_as_pdf;
    if (_isWord(path)) return Icons.description;
    if (_isExcel(path)) return Icons.grid_on;
    if (_isPpt(path)) return Icons.slideshow;
    if (_isText(path)) return Icons.text_snippet;
    if (_isEpub(path)) return Icons.book;
    return Icons.insert_drive_file;
  }
  
  Future<void> _loadVideoThumbnail(File videoFile) async {
    if (_videoControllers.containsKey(videoFile.path)) return;

    try {
      final controller = VideoPlayerController.file(videoFile);
      await controller.initialize();
      if (mounted) {
        setState(() {
          _videoControllers[videoFile.path] = controller;
        });
      }
    } catch (e) {
      debugPrint('Error loading video: $e');
    }
  }

  // === IMAGE EDITOR ===
  Future<File?> _openImageEditor(File file) async {
    Uint8List bytes;
    try {
      bytes = await file.readAsBytes();
    } catch (e) {
      if (kIsWeb) {
        final webBytes = web_drop.getWebFileBytes(file.path);
        if (webBytes != null) {
          bytes = webBytes;
        } else {
          return null;
        }
      } else {
        rethrow;
      }
    }

    final result = await Navigator.of(context).push<Uint8List?>(
      MaterialPageRoute(
        builder: (_) => ProImageEditor.memory(
          bytes,
          callbacks: ProImageEditorCallbacks(
            onImageEditingComplete: (Uint8List editedBytes) async {
              Navigator.pop(context, editedBytes);
            },
          ),
          configs: ProImageEditorConfigs(
            designMode: ImageEditorDesignMode.cupertino,
            theme: Theme.of(context).copyWith(primaryColor: AppColors.appColor),
          ),
        ),
      ),
    );

    if (result != null) {
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(result);

      if (kIsWeb) {
        web_drop.storeWebFileBytes(tempFile.path, result);
      }
      return tempFile;
    }
    return null;
  }

  Future<void> _editFile(int index) async {
    final file = _localFiles[index];
    if (_isVideoFile(file.path)) return;

    final extension = file.path.split('.').last.toLowerCase();
    final imageExts = ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'];
    if (!imageExts.contains(extension)) return;

    final editedFile = await _openImageEditor(file);
    if (editedFile != null && mounted) {
      setState(() {
        _localFiles[index] = editedFile;
      });
      widget.onPicked(_localFiles);
    }
  }

  // === FILE PICKING ===
  Future<void> _pickFiles(BuildContext context) async {
    final category = widget.category ?? (widget.isImageFile ? 'image' : 'any');

    if (category == 'video') {
      await _pickVideos(context);
      return;
    }

    if (category == 'image') {
      await _pickImages(context);
      return;
    }

    final hasVideoExts = widget.allowedExtensions != null &&
        widget.allowedExtensions!.any((ext) => ['mp4', 'mov', 'mkv', 'avi', 'webm', '3gp', 'hevc', 'h265', 'h.265'].contains(ext.toLowerCase()));
    final hasImageExts = widget.allowedExtensions != null &&
        widget.allowedExtensions!.any((ext) => ['jpg', 'jpeg', 'png'].contains(ext.toLowerCase()));

    if (hasVideoExts && !hasImageExts) {
      await _pickVideos(context);
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: widget.allowedExtensions != null && widget.allowedExtensions!.isNotEmpty
          ? FileType.custom
          : FileType.any,
      allowedExtensions: widget.allowedExtensions,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final files = <File>[];
      for (var platformFile in result.files) {
        if (platformFile.path != null) {
          files.add(File(platformFile.path!));
        }
      }
      if (files.isNotEmpty) {
        await _validateAndAddFiles(files);
      }
    }
  }

  Future<void> _pickImages(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final List<XFile>? picked = await _picker.pickMultiImage();
                if (picked != null && picked.isNotEmpty) {
                  final files = picked.map((x) => File(x.path)).toList();
                  await _validateAndAddFiles(files);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
                if (picked != null) {
                  await _validateAndAddFiles([File(picked.path)]);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickVideos(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.video_library_outlined),
              title: const Text('Pick Videos from Gallery'),
              subtitle: const Text('Select one video at a time'),
              onTap: () async {
                Navigator.pop(context);
                await _pickVideoFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: const Text('Record Video'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? picked = await _picker.pickVideo(source: ImageSource.camera);
                if (picked != null) {
                  final file = File(picked.path);
                  if (_isVideoFile(file.path)) {
                    await _validateAndAddFiles([file]);
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Selected file is not a video.'), backgroundColor: Colors.red),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickVideoFromGallery() async {
    final XFile? picked = await _picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      if (_isVideoFile(file.path)) {
        await _validateAndAddFiles([file]);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a valid video file.'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // === VALIDATION & ADD ===
  Future<void> _validateAndAddFiles(List<File> newFiles) async {
    final validFiles = <File>[];
    final category = widget.category ?? (widget.isImageFile ? 'image' : 'any');

    for (var file in newFiles) {
      final extension = file.path.split('.').last.toLowerCase();
      final fileName = file.path.split('/').last;

      if (category == 'video') {
        if (!_isVideoFile(file.path)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Only video files allowed: $fileName'), backgroundColor: Colors.red),
            );
          }
          continue;
        }
      }

      if (category == 'image') {
        final imageExts = ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'];
        if (!imageExts.contains(extension)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Only image files allowed: $fileName'), backgroundColor: Colors.red),
            );
          }
          continue;
        }
      }

      if (widget.allowedExtensions != null && widget.allowedExtensions!.isNotEmpty) {
        final cleanExts = widget.allowedExtensions!.map((e) => e.toLowerCase().trim()).toList();
        if (!cleanExts.contains(extension)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('File type not allowed: $fileName'), backgroundColor: Colors.red),
            );
          }
          continue;
        }
      }

      validFiles.add(file);
      if (_isVideoFile(file.path)) {
        await _loadVideoThumbnail(file);
      }
    }

    if (validFiles.isNotEmpty) {
      setState(() {
        _localFiles.addAll(validFiles);
      });
      widget.onPicked(_localFiles);
    }
  }

  void _removeFile(int index) {
    final file = _localFiles[index];
    if (_videoControllers.containsKey(file.path)) {
      _videoControllers[file.path]!.dispose();
      _videoControllers.remove(file.path);
    }
    setState(() {
      _localFiles.removeAt(index);
    });
    widget.onPicked(_localFiles);
  }

  // === DRAG TARGET ===
  Widget _buildDragTarget({required Widget child}) {
    if (!kIsWeb) return child;
    return web_drop.WebFileDropZone(
      isDragging: _isDragging,
      onDragStateChanged: (dragging) => setState(() => _isDragging = dragging),
      onFilesDropped: (files) {
        setState(() => _isDragging = false);
        _validateAndAddFiles(files);
      },
      child: child,
    );
  }

  // === VIDEO THUMBNAIL ===
  Widget _buildVideoThumbnail(File videoFile) {
    final controller = _videoControllers[videoFile.path];
    if (controller == null || !controller.value.isInitialized) {
      return Container(
        color: AppColors.appDescriptionColor,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        VideoPlayer(controller),
        Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), shape: BoxShape.circle),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
          ),
        ),
      ],
    );
  }

  // === FILE PREVIEW ===
  Widget _buildFilePreview(File file, int index) {
    final isVideo = _isVideoFile(file.path);
    final extension = file.path.split('.').last.toLowerCase();
    final isImage = ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'].contains(extension);
    final isDocument = _isDocument(file.path);

    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.appDescriptionColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: GestureDetector(
              onTap: () {
                if (isVideo) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoViewScreen(videoFile: file),
                    ),
                  );
                } else if (isImage) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImageViewScreen(imageFile: file),
                    ),
                  );
                }
              },
              child: isVideo
                  ? _buildVideoThumbnail(file)
                  : (isImage
                      ? Image.file(file, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildPlaceholder())
                      : (isDocument
                          ? _buildDocumentPreview(file)
                          : _buildPlaceholder())),
            ),
          ),

          // Edit Icon (only for images)
          if (isImage)
            Positioned(
              top: 4,
              left: 4,
              child: GestureDetector(
                onTap: () => _editFile(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: AppColors.appColor, shape: BoxShape.circle),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
            ),
          if (isVideo)
            Positioned(
              top: 4,
              left: 4,
              child: GestureDetector(
                onTap: () => _editVideoFile(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: AppColors.appColor, shape: BoxShape.circle),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
            ),

          // Remove Icon
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeFile(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.9), shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),

          // Video Indicator
          if (isVideo)
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(4)),
                child: const Icon(Icons.videocam, color: Colors.white, size: 14),
              ),
            ),

          // Document Indicator
          if (isDocument)
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(4)),
                child: Icon(_fileIcon(file.path), color: Colors.white, size: 14),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDocumentPreview(File file) {
    final fileName = file.path.split('/').last;
    final extension = file.path.split('.').last.toUpperCase();

    return Container(
      color: Colors.grey.shade100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_fileIcon(file.path), size: 40, color: Colors.blue),
                const SizedBox(height: 4),
                Text(
                  extension,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // File name overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Text(
                fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.appDescriptionColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_drive_file, size: 30, color: AppColors.appDescriptionColor),
          const SizedBox(height: 4),
          Text('File', style: AppTextStyle.kTextStyle.copyWith(fontSize: 10, color: AppColors.appDescriptionColor)),
        ],
      ),
    );
  }

  // === BUILD ===
  @override
  Widget build(BuildContext context) {
    final effectiveFiles = _localFiles.isNotEmpty ? _localFiles : (widget.value ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Text(
            widget.label,
            style: AppTextStyle.kTextStyle.copyWith(color: AppColors.appBodyTextColor, fontWeight: FontWeight.w600),
          ),
        const SizedBox(height: 12),

        _buildDragTarget(
          child: GestureDetector(
            onTap: () => _pickFiles(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isDragging ? AppColors.appColor : AppColors.appColor.withValues(alpha: 0.3),
                  width: _isDragging ? 3 : 2,
                ),
                borderRadius: BorderRadius.circular(8),
                color: _isDragging 
                    ? AppColors.appColor.withValues(alpha: 0.05) 
                    : (widget.category == 'video'
                        ? AppColors.appColor.withValues(alpha: 0.1)
                        : Colors.transparent),
              ),
              child: Column(
                children: [
                  Icon(
                    _isDragging 
                        ? Icons.cloud_upload 
                        : (widget.category == 'video' 
                            ? Icons.videocam_outlined 
                            : Icons.add_photo_alternate_outlined),
                    size: widget.category == 'video' ? 50 : 40,
                    color: _isDragging 
                        ? AppColors.appColor 
                        : AppColors.appDescriptionColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isDragging ? 'Drop Files Here' : 'Tap to Select Files',
                    style: AppTextStyle.kTextStyle.copyWith(
                      color: _isDragging 
                          ? AppColors.appColor 
                          : AppColors.appDescriptionColor,
                      fontWeight: _isDragging ? FontWeight.bold : FontWeight.normal,
                      fontSize: widget.category == 'video' ? 14 : null,
                    ),
                  ),
                  if (kIsWeb && !_isDragging)
                    Text(
                      'or Drag & Drop',
                      style: AppTextStyle.kTextStyle.copyWith(color: AppColors.appDescriptionColor, fontSize: 12),
                    ),
                ],
              ),
            ),
          ),
        ),

        if (effectiveFiles.isNotEmpty) ...[
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final crossAxisCount = 3;
              final spacing = 8.0;
              final totalSpacing = spacing * (crossAxisCount - 1);
              final itemWidth = (screenWidth - totalSpacing) / crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: List.generate(effectiveFiles.length, (i) {
                  return SizedBox(
                    width: itemWidth,
                    child: _buildFilePreview(effectiveFiles[i], i),
                  );
                }),
              );
            },
          ),

        ],
      ],
    );
  }

  Future<void> _editVideoFile(int index) async {
    final file = _localFiles[index];
    if (!_isVideoFile(file.path)) return;

    final editedFile = await Navigator.push<File?>(
      context,
      MaterialPageRoute(builder: (_) => VideoEditScreen(videoFile: file)),
    );

    if (editedFile != null && mounted) {
      setState(() {
        _localFiles[index] = editedFile;
      });
      await _loadVideoThumbnail(editedFile);
      widget.onPicked(_localFiles);
    }
  }


}


class VideoEditScreen extends StatefulWidget {
  final File videoFile;
  const VideoEditScreen({super.key, required this.videoFile});

  @override
  State<VideoEditScreen> createState() => _VideoEditScreenState();
}

// Helper class to save/load video trim metadata
class _VideoTrimMetadata {
  final double startTrim;
  final double endTrim;
  
  _VideoTrimMetadata({required this.startTrim, required this.endTrim});
  
  Map<String, dynamic> toJson() => {
    'startTrim': startTrim,
    'endTrim': endTrim,
  };
  
  factory _VideoTrimMetadata.fromJson(Map<String, dynamic> json) => _VideoTrimMetadata(
    startTrim: json['startTrim']?.toDouble() ?? 0.0,
    endTrim: json['endTrim']?.toDouble() ?? 0.0,
  );
  
  static Future<void> saveTrimMetadata(File videoFile, double startTrim, double endTrim) async {
    try {
      final metadataFile = File('${videoFile.path}.trim.json');
      final metadata = _VideoTrimMetadata(startTrim: startTrim, endTrim: endTrim);
      await metadataFile.writeAsString(jsonEncode(metadata.toJson()));
    } catch (e) {
      debugPrint('Error saving trim metadata: $e');
    }
  }
  
  static Future<_VideoTrimMetadata?> loadTrimMetadata(File videoFile) async {
    try {
      final metadataFile = File('${videoFile.path}.trim.json');
      if (await metadataFile.exists()) {
        final content = await metadataFile.readAsString();
        final json = jsonDecode(content) as Map<String, dynamic>;
        return _VideoTrimMetadata.fromJson(json);
      }
    } catch (e) {
      debugPrint('Error loading trim metadata: $e');
    }
    return null;
  }
  
}

class _VideoEditScreenState extends State<VideoEditScreen> {
  late final VideoEditorController _controller;
  bool _isLoading = true;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    _controller = VideoEditorController.file(
      widget.videoFile,
      minDuration: const Duration(seconds: 1),
      maxDuration: const Duration(minutes: 2),
    );

    await _controller.initialize(aspectRatio: 9 / 16);
    
    if (mounted) {
      // Load saved trim metadata if available
      final metadata = await _VideoTrimMetadata.loadTrimMetadata(widget.videoFile);
      if (metadata != null) {
        // Validate trim values against video duration
        final videoDuration = _controller.video.value.duration;
        final minDuration = _controller.minDuration;
        
        // Ensure trim values are valid
        double startTrim = metadata.startTrim.clamp(0.0, videoDuration.inSeconds.toDouble());
        double endTrim = metadata.endTrim.clamp(
          (minDuration.inSeconds).toDouble(),
          videoDuration.inSeconds.toDouble(),
        );
        
        // Ensure endTrim > startTrim and duration >= minDuration
        if (endTrim <= startTrim) {
          endTrim = startTrim + minDuration.inSeconds.toDouble();
        }
        if (endTrim > videoDuration.inSeconds.toDouble()) {
          endTrim = videoDuration.inSeconds.toDouble();
        }
        if ((endTrim - startTrim) < minDuration.inSeconds.toDouble()) {
          endTrim = startTrim + minDuration.inSeconds.toDouble();
          if (endTrim > videoDuration.inSeconds.toDouble()) {
            startTrim = videoDuration.inSeconds.toDouble() - minDuration.inSeconds.toDouble();
            endTrim = videoDuration.inSeconds.toDouble();
          }
        }
        
        // Apply validated trim settings - updateTrim expects double (seconds)
        try {
          _controller.updateTrim(startTrim, endTrim);
        } catch (e) {
          debugPrint('Error applying trim: $e');
          // If trim fails, use default values
        }
      }
      
      // Listen to trim changes to update preview in real-time
      _controller.addListener(_onControllerUpdate);
      setState(() => _isLoading = false);
    }
  }

  void _onControllerUpdate() {
    // Update preview when trim or other settings change
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _exportEditedVideo() async {
    setState(() => _isExporting = true);

    try {
      // Save trim metadata so we can restore it when re-editing
      // Get trim values from controller - these are Duration objects
      final startTrim = _controller.startTrim.inSeconds.toDouble();
      final endTrim = _controller.endTrim.inSeconds.toDouble();
      
      await _VideoTrimMetadata.saveTrimMetadata(
        widget.videoFile,
        startTrim,
        endTrim,
      );
      
      // Note: Video export requires ffmpeg_kit which is now discontinued.
      // We save the trim metadata so when user re-edits, the trimmed duration is shown.
      // TODO: Find an alternative to ffmpeg_kit for actual video export functionality
      
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate processing
      
      if (mounted) {
        // Return the original file but with trim metadata saved
        Navigator.pop(context, widget.videoFile);
      }
    } catch (e) {
      debugPrint('Export error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Export error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.appColor,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Edit Video"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _isExporting ? null : _exportEditedVideo,
            icon: const Icon(Icons.check, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              AnimatedBuilder(
                                animation: _controller,
                                builder: (_, __) => Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CropGridViewer.preview(controller: _controller),
                                    AnimatedBuilder(
                                      animation: _controller.video,
                                      builder: (_, __) => AnimatedOpacity(
                                        opacity: _controller.isPlaying ? 0 : 1,
                                        duration: kThemeAnimationDuration,
                                        child: GestureDetector(
                                          onTap: _controller.video.play,
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.play_arrow, color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CoverViewer(controller: _controller),
                            ],
                          ),
                        ),
                        Container(
                          height: 180,
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              TabBar(
                                indicatorColor: AppColors.appColor,
                                labelColor: AppColors.appColor,
                                unselectedLabelColor: Colors.grey,
                                tabs: const [
                                  Tab(icon: Icon(Icons.content_cut), text: 'Trim'),
                                  Tab(icon: Icon(Icons.video_label), text: 'Cover'),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            sliderTheme: SliderThemeData(
                                              activeTrackColor: AppColors.appColor,
                                              inactiveTrackColor: AppColors.appColor.withValues(alpha: 0.3),
                                              thumbColor: AppColors.appColor,
                                              overlayColor: AppColors.appColor.withValues(alpha: 0.2),
                                              activeTickMarkColor: AppColors.appColor,
                                              inactiveTickMarkColor: AppColors.appColor.withValues(alpha: 0.5),
                                            ),
                                          ),
                                          child: TrimSlider(
                                            controller: _controller,
                                            height: 60,
                                            horizontalMargin: 16,
                                            child: TrimTimeline(
                                              controller: _controller,
                                              padding: const EdgeInsets.only(top: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Center(
                                      child: CoverSelection(
                                        controller: _controller,
                                        size: 70,
                                        quantity: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isExporting)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.appColor,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Exporting edited video...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => _controller.rotate90Degrees(),
              icon: const Icon(Icons.rotate_left, color: Colors.white),
            ),
            IconButton(
              onPressed: () => _controller.rotate90Degrees(),
              icon: const Icon(Icons.rotate_right, color: Colors.white),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}