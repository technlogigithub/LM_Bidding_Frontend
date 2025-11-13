import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:video_player/video_player.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../core/app_string.dart';
import '../../view/image_view_screen/image_view_screen.dart';
import '../../view/video_view_screen/video_view_screen.dart';
import 'web_file_drop_zone_stub.dart'
if (dart.library.html) 'web_file_drop_zone_web.dart' as web_drop;

class CustomFilePicker extends StatefulWidget {
  final String label;
  final String? fieldName;
  final ValueChanged<File?> onPicked;
  final File? value;
  final String? imageUrl;
  final bool isImageFile;
  final List<String>? allowedExtensions;
  final String? category;

  const CustomFilePicker({
    super.key,
    required this.label,
    this.fieldName,
    required this.onPicked,
    this.value,
    this.imageUrl,
    this.isImageFile = false,
    this.allowedExtensions,
    this.category,
  });

  @override
  State<CustomFilePicker> createState() => _CustomFilePickerState();
}

class _CustomFilePickerState extends State<CustomFilePicker> {
  File? _localFile;
  final ImagePicker _picker = ImagePicker();
  bool _isDragging = false;
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  bool _isVideoFile(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'mkv', 'avi', 'webm', '3gp', 'hevc', 'h265', 'h.265'].contains(ext);
  }

  Future<void> _loadVideoThumbnail(File videoFile) async {
    _videoController?.dispose();
    try {
      final controller = VideoPlayerController.file(videoFile);
      await controller.initialize();
      if (mounted) {
        setState(() {
          _videoController = controller;
        });
      }
    } catch (e) {
      debugPrint('Error loading video: $e');
    }
  }

  Future<void> _pick(BuildContext context) async {
    final category = widget.category ?? (widget.isImageFile ? 'image' : 'any');

    if (category == 'image') {
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
                  final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) await _handleImagePicked(File(picked.path));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
                  if (picked != null) await _handleImagePicked(File(picked.path));
                },
              ),
            ],
          ),
        ),
      );
      return;
    }

    if (category == 'video') {
      await showModalBottomSheet(
        context: context,
        builder: (_) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.video_library_outlined),
                title: const Text('Video Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? picked = await _picker.pickVideo(source: ImageSource.gallery);
                  if (picked != null) {
                    final file = File(picked.path);
                    widget.onPicked(file);
                    setState(() => _localFile = file);
                    await _loadVideoThumbnail(file);
                  }
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
                    widget.onPicked(file);
                    setState(() => _localFile = file);
                    await _loadVideoThumbnail(file);
                  }
                },
              ),
            ],
          ),
        ),
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: widget.allowedExtensions != null && widget.allowedExtensions!.isNotEmpty
          ? FileType.custom
          : FileType.any,
      allowedExtensions: widget.allowedExtensions,
    );
    if (result != null && result.files.isNotEmpty) {
      final path = result.files.single.path;
      if (path != null) {
        final file = File(path);
        widget.onPicked(file);
        setState(() => _localFile = file);
      }
    }
  }

  Future<void> _handleImagePicked(File file) async {
    final editedFile = await _openImageEditor(file);
    if (editedFile != null) {
      widget.onPicked(editedFile);
      setState(() => _localFile = editedFile);
    }
  }

  // FIXED: Return type + callbacks + i18n
  Future<File?> _openImageEditor(File file) async {
    final bytes = await file.readAsBytes();

    final result = await Navigator.of(context).push<Uint8List?>(
      MaterialPageRoute(
        builder: (_) => ProImageEditor.memory(
          bytes,
          callbacks: ProImageEditorCallbacks(
            onImageEditingComplete: (Uint8List bytes) async {
              Navigator.pop(context, bytes);
            },
          ),
          configs: ProImageEditorConfigs(
            designMode: ImageEditorDesignMode.cupertino,
            theme: Theme.of(context).copyWith(
              primaryColor: AppColors.appColor,
            ),
          ),
        ),
      ),
    );

    if (result != null) {
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(result);
      return tempFile;
    }
    return null;
  }

  Future<void> _handleDroppedFiles(List<File> files) async {
    if (files.isEmpty) return;
    File file = files.first;

    if (kIsWeb && file.path.startsWith('web://')) {
      final bytes = _getWebFileBytes(file.path);
      if (bytes != null) {
        final platformFile = PlatformFile(
          name: file.path.replaceFirst('web://', ''),
          size: bytes.length,
          bytes: bytes,
          path: null,
        );
        file = File(platformFile.name);
        _storeWebFileBytesForWeb(file.path, bytes);
      }
    }

    if (widget.allowedExtensions != null && widget.allowedExtensions!.isNotEmpty) {
      final fileName = file.path.split('/').last;
      final extension = fileName.contains('.') ? fileName.split('.').last.toLowerCase() : '';
      if (extension.isNotEmpty && !widget.allowedExtensions!.any((ext) => ext.toLowerCase() == extension)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File type not allowed. Allowed: ${widget.allowedExtensions!.join(", ")}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }

    final category = widget.category ?? (widget.isImageFile ? 'image' : 'any');
    if (category == 'image' || widget.isImageFile) {
      await _handleImagePicked(file);
    } else if (category == 'video' || _isVideoFile(file.path)) {
      widget.onPicked(file);
      setState(() => _localFile = file);
      await _loadVideoThumbnail(file);
    } else {
      widget.onPicked(file);
      setState(() => _localFile = file);
    }
  }

  Uint8List? _getWebFileBytes(String path) {
    if (kIsWeb) return web_drop.getWebFileBytes(path);
    return null;
  }

  void _storeWebFileBytesForWeb(String path, Uint8List bytes) {
    if (kIsWeb) web_drop.storeWebFileBytes(path, bytes);
  }

  Widget _buildDragTarget({required Widget child}) {
    if (!kIsWeb) return child;
    return web_drop.WebFileDropZone(
      isDragging: _isDragging,
      onDragStateChanged: (dragging) => setState(() => _isDragging = dragging),
      onFilesDropped: (files) {
        setState(() => _isDragging = false);
        _handleDroppedFiles(files);
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lowerLabel = widget.label.toLowerCase();
    final lowerField = (widget.fieldName ?? '').toLowerCase();
    final isDisplayPicture = lowerField == 'display_picture' ||
        lowerLabel.contains('display') || lowerLabel.contains('profile') || lowerLabel.contains('avatar');
    final isBannerImage = lowerField == 'banner_image' || lowerLabel.contains('banner');
    final effectiveFile = _localFile ?? widget.value;

    if (effectiveFile != null && _isVideoFile(effectiveFile.path) && _videoController == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadVideoThumbnail(effectiveFile));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Text(
            widget.label,
            style: AppTextStyle.kTextStyle.copyWith(
              color: AppColors.appTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        const SizedBox(height: 12),

        // === DISPLAY PICTURE ===
        if (isDisplayPicture) ...[
          Center(
            child: _buildDragTarget(
              child: GestureDetector(
                onTap: () => _pick(context),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isDragging ? AppColors.appColor : AppColors.appColor.withValues(alpha: 0.3),
                          width: _isDragging ? 3 : 2,
                        ),
                      ),
                      child: ClipOval(
                        child: effectiveFile != null || (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                            ? Stack(
                          fit: StackFit.expand,
                          children: [
                            effectiveFile != null
                                ? Image.file(effectiveFile, fit: BoxFit.cover)
                                : (widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: widget.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => _buildNoImagePlaceholder(),
                                      )
                                    : _buildNoImagePlaceholder()),
                            Positioned(
                              top: 15,
                              right: 13,
                              child: GestureDetector(
                                onTap: () async {
                                  // If image comes from URL (HTTP), then select new photo instead of editing
                                  if (widget.imageUrl != null && widget.imageUrl!.startsWith("http")) {
                                    _pick(context);   // opens gallery/camera
                                    return;
                                  }
                                  
                                  // Check if file path itself starts with HTTP
                                  if (effectiveFile != null && effectiveFile.path.startsWith("http")) {
                                    _pick(context);   // opens gallery/camera
                                    return;
                                  }

                                  // ELSE: If file already local → edit photo
                                  if (effectiveFile != null) {
                                    final edited = await _openImageEditor(effectiveFile);
                                    if (edited != null) {
                                      widget.onPicked(edited);
                                      setState(() => _localFile = edited);
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: AppColors.appColor, shape: BoxShape.circle),
                                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        )
                            : _buildNoImagePlaceholder(),
                      ),
                    ),
                    if (kIsWeb && !_isDragging) ...[
                      const SizedBox(height: 8),
                      Text('Drag & Drop or Click', style: AppTextStyle.kTextStyle.copyWith(fontSize: 12, color: AppColors.appTextColor.withValues(alpha: 0.6))),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ]

        // === BANNER IMAGE ===
        else if (isBannerImage) ...[
          _buildDragTarget(
            child: GestureDetector(
              onTap: () => _pick(context),
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: AppColors.appPagecolor,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // === PREVIEW (Image or Video) ===
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: effectiveFile != null
                          ? (_isVideoFile(effectiveFile.path) &&
                          _videoController?.value.isInitialized == true
                          ? Stack(
                        fit: StackFit.expand,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // 👉 Open video viewer
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      VideoViewScreen(videoFile: effectiveFile),
                                ),
                              );
                            },
                            child: VideoPlayer(_videoController!),
                          ),
                          // Play icon overlay
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                // 👉 Open video viewer
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        VideoViewScreen(videoFile: effectiveFile),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                          : GestureDetector(
                        onTap: () {
                          // 👉 Open image viewer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ImageViewScreen(
                                imageFile: effectiveFile,
                              ),
                            ),
                          );
                        },
                        child: Image.file(
                          effectiveFile,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ))
                          : widget.imageUrl != null
                          ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ImageViewScreen(
                                imageFile: File(''),
                                imageUrl: widget.imageUrl,
                              ),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: widget.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                          : _buildNoImagePlaceholder(),
                    ),

                    // === EDIT BUTTON ===
                    if ((effectiveFile != null && !_isVideoFile(effectiveFile.path)) || 
                        (widget.imageUrl != null && widget.imageUrl!.isNotEmpty && effectiveFile == null))
                      Positioned(
                        top: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: () async {
                            // If image comes from URL (HTTP), then select new photo instead of editing
                            if (widget.imageUrl != null && widget.imageUrl!.startsWith("http")) {
                              _pick(context);   // opens gallery/camera
                              return;
                            }
                            
                            // Check if file path itself starts with HTTP
                            if (effectiveFile != null && effectiveFile.path.startsWith("http")) {
                              _pick(context);   // opens gallery/camera
                              return;
                            }

                            // ELSE: If file already local → edit photo
                            if (effectiveFile != null) {
                              final editedFile = await _openImageEditor(effectiveFile);
                              if (editedFile != null) {
                                widget.onPicked(editedFile);
                                setState(() => _localFile = editedFile);
                              }
                            }
                          },

                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.appColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 18),
                          ),
                        ),
                      ),

                    // === REMOVE BUTTON ===
                    if (effectiveFile != null || (widget.imageUrl != null && widget.imageUrl!.isNotEmpty))
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _localFile = null);
                            widget.onPicked(null);
                            _videoController?.dispose();
                            _videoController = null;
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                          ),
                        ),
                      ),

                    // === HINT TEXT (when empty) ===
                    if (effectiveFile == null && widget.imageUrl == null)
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isDragging ? Icons.cloud_upload : null,
                              size: 50,
                              color: _isDragging
                                  ? AppColors.appColor
                                  : AppColors.appTextColor.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isDragging ? 'Drop Here' : '',
                              style: AppTextStyle.kTextStyle.copyWith(
                                color:
                                AppColors.appTextColor.withValues(alpha: 0.7),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ]
        else if (widget.isImageFile) ...[
            _buildDragTarget(
              child: GestureDetector(
                onTap: () => _pick(context),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: _isDragging ? AppColors.appColor : AppColors.appColor.withValues(alpha: 0.3), width: _isDragging ? 3 : 2),
                    borderRadius: BorderRadius.circular(8),
                    color: _isDragging ? AppColors.appColor.withValues(alpha: 0.05) : Colors.transparent,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: effectiveFile != null
                        ? Stack(
                      fit: StackFit.expand,
                      children: [
                        _isVideoFile(effectiveFile.path) && _videoController?.value.isInitialized == true
                            ? VideoPlayer(_videoController!)
                            : Image.file(effectiveFile, fit: BoxFit.cover),
                        if (!_isVideoFile(effectiveFile.path))
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    // If image comes from URL (HTTP), then select new photo instead of editing
                                    if (widget.imageUrl != null && widget.imageUrl!.startsWith("http")) {
                                      _pick(context);   // opens gallery/camera
                                      return;
                                    }
                                    
                                    // Check if file path itself starts with HTTP
                                    if (effectiveFile.path.startsWith("http")) {
                                      _pick(context);   // opens gallery/camera
                                      return;
                                    }

                                    // ELSE: If file already local → edit photo
                                    final edited = await _openImageEditor(effectiveFile);
                                    if (edited != null) {
                                      widget.onPicked(edited);
                                      setState(() => _localFile = edited);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(color: AppColors.appColor, shape: BoxShape.circle),
                                    child: const Icon(Icons.edit, color: Colors.white, size: 18),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() => _localFile = null);
                                    widget.onPicked(null);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.8), shape: BoxShape.circle),
                                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    )
                        : widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                        ? Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(imageUrl: widget.imageUrl!, fit: BoxFit.cover),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  // If image comes from URL (HTTP), then select new photo instead of editing
                                  if (widget.imageUrl != null && widget.imageUrl!.startsWith("http")) {
                                    _pick(context);   // opens gallery/camera
                                    return;
                                  }
                                  
                                  // Check if file path itself starts with HTTP
                                  if (effectiveFile != null && effectiveFile.path.startsWith("http")) {
                                    _pick(context);   // opens gallery/camera
                                    return;
                                  }

                                  // ELSE: If file already local → edit photo
                                  if (effectiveFile != null) {
                                    final edited = await _openImageEditor(effectiveFile);
                                    if (edited != null) {
                                      widget.onPicked(edited);
                                      setState(() => _localFile = edited);
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: AppColors.appColor, shape: BoxShape.circle),
                                  child: const Icon(Icons.edit, color: Colors.white, size: 18),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => widget.onPicked(null),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.8), shape: BoxShape.circle),
                                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                        : Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildNoImagePlaceholder(),
                        if (kIsWeb)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(_isDragging ? Icons.cloud_upload : Icons.image_outlined, size: 40, color: _isDragging ? AppColors.appColor : AppColors.appTextColor.withValues(alpha: 0.4)),
                                const SizedBox(height: 8),
                                Text(_isDragging ? 'Drop Image Here' : 'Drag & Drop or Click', style: AppTextStyle.kTextStyle.copyWith(fontSize: 12)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]

          // === DEFAULT FILE PICKER ===
          else ...[
              _buildDragTarget(
                child: GestureDetector(
                  onTap: () => _pick(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: _isDragging ? AppColors.appColor : AppColors.appTextColor.withValues(alpha: 0.3), width: _isDragging ? 3 : 1),
                      borderRadius: BorderRadius.circular(8),
                      color: _isDragging ? AppColors.appColor.withValues(alpha: 0.05) : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Icon(_isDragging ? Icons.cloud_upload : Icons.attach_file, color: _isDragging ? AppColors.appColor : AppColors.appTextColor.withValues(alpha: 0.6)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _isDragging && kIsWeb
                                ? 'Drop File Here'
                                : (effectiveFile != null ? effectiveFile.path.split('/').last : AppStrings.noFileSelected),
                            style: AppTextStyle.kTextStyle.copyWith(color: _isDragging ? AppColors.appColor : AppColors.appTextColor.withValues(alpha: 0.7)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (kIsWeb && effectiveFile == null && !_isDragging)
                          Text('or Click', style: AppTextStyle.kTextStyle.copyWith(fontSize: 12, color: AppColors.appTextColor.withValues(alpha: 0.5))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
      ],
    );
  }

  Widget _buildNoImagePlaceholder() {
    return SizedBox.expand(
      child: Container(
        color: AppColors.appTextColor.withValues(alpha: 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 40, color: AppColors.appTextColor.withValues(alpha: 0.4)),
            const SizedBox(height: 8),
            Text(AppStrings.noImage, style: AppTextStyle.kTextStyle.copyWith(fontSize: 12, color: AppColors.appTextColor.withValues(alpha: 0.6))),
          ],
        ),
      ),
    );
  }
}