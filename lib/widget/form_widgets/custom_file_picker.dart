  import 'dart:io';
  import 'dart:typed_data';
  import 'package:file_picker/file_picker.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/foundation.dart';
  import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:pdfx/pdfx.dart';
  import 'package:pro_image_editor/pro_image_editor.dart';
  import 'package:video_player/video_player.dart';
  import 'package:video_thumbnail/video_thumbnail.dart';
  import 'package:get/get.dart';
  import '../../core/app_color.dart';
  import '../../core/app_textstyle.dart';
  import '../../core/app_string.dart';
  import '../../controller/post/post_form_controller.dart';
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
    Uint8List? _networkThumbnail;
    Uint8List? _pdfThumb;
  
  
  
    @override
    void dispose() {
      _videoController?.dispose();
      super.dispose();
    }
  
    bool _isVideoFile(String path) {
      final ext = path.split('.').last.toLowerCase();
      // Remove query parameters for URL checking
      final cleanPath = path.split('?').first;
      final cleanExt = cleanPath.split('.').last.toLowerCase();
      return ['mp4', 'mov', 'mkv', 'avi', 'webm', '3gp', 'hevc', 'h265', 'h.265'].contains(ext) ||
             ['mp4', 'mov', 'mkv', 'avi', 'webm', '3gp', 'hevc', 'h265', 'h.265'].contains(cleanExt);
    }
    
    bool _isVideoUrl(String? url) {
      if (url == null || url.isEmpty) return false;
      return _isVideoFile(url);
    }
  
    bool _isDocumentUrl(String? url) {
      if (url == null || url.isEmpty) return false;
      return _isDocument(url);
    }
  
    Future<void> _loadVideoThumbnail(dynamic videoSource) async {
      try {
        Uint8List? thumbBytes;
  
        if (videoSource is File) {
          // 👉 LOCAL FILE → Use file path
          thumbBytes = await VideoThumbnail.thumbnailData(
            video: videoSource.path,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 350,
            quality: 75,
          );
        } else if (videoSource is String && videoSource.startsWith("http")) {
          // 👉 NETWORK URL → Generate thumbnail
          thumbBytes = await VideoThumbnail.thumbnailData(
            video: videoSource,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 350,
            quality: 75,
          );
        }
  
        if (thumbBytes != null) {
          setState(() {
            _networkThumbnail = thumbBytes;
          });
        }
      } catch (e) {
        debugPrint("Thumbnail error: $e");
      }
    }
  
  
    Future<void> _pick(BuildContext context) async {
      try {
        final controller = Get.find<PostFormController>();
        controller.setUserInteracting(true);
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) controller.setUserInteracting(false);
        });
      } catch (_) {}
      
      final category = widget.category ?? (widget.isImageFile ? 'image' : 'any');
  
      if (category == 'image') {
        if (kIsWeb) {
          await _showWebImagePicker();
        } else {
          await _showMobileImagePicker();
        }
        return;
      }
  
      if (category == 'video') {
        if (kIsWeb) {
          await _showWebVideoPicker();
        } else {
          await _showMobileVideoPicker();
        }
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
          setState(() {
            _localFile = file;
            _pdfThumb = null;
          });
          try {
            final controller = Get.find<PostFormController>();
            controller.setUserInteracting(true);
            Future.delayed(const Duration(seconds: 3), () => controller.setUserInteracting(false));
          } catch (_) {}
          if (_isPdf(file.path)) await _loadPdfThumbnail(file);
        }
      }
    }

    Future<void> _showWebImagePicker() async {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Select Image Source', style: AppTextStyle.title(color: AppColors.appTitleColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library_outlined, color: AppColors.appIconColor),
                title: Text('Gallery', style: AppTextStyle.description(color: AppColors.appTitleColor)),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) await _handleImagePicked(File(picked.path));
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera_outlined, color: AppColors.appIconColor),
                title: Text('Camera', style: AppTextStyle.description(color: AppColors.appTitleColor)),
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
    }

    Future<void> _showMobileImagePicker() async {
      await showModalBottomSheet(
        context: context,
        builder: (_) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library_outlined, color: AppColors.appIconColor),
                title: Text('Gallery', style: AppTextStyle.description(color: AppColors.appTitleColor)),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) await _handleImagePicked(File(picked.path));
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera_outlined, color: AppColors.appIconColor),
                title: Text('Camera', style: AppTextStyle.description(color: AppColors.appTitleColor)),
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
    }

    Future<void> _showWebVideoPicker() async {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Select Video Source', style: AppTextStyle.title(color: AppColors.appTitleColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.video_library_outlined, color: AppColors.appIconColor),
                title: Text('Video Gallery', style: AppTextStyle.description(color: AppColors.appTitleColor)),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? picked = await _picker.pickVideo(source: ImageSource.gallery);
                  if (picked != null) {
                    final file = File(picked.path);
                    widget.onPicked(file);
                    setState(() {
                      _localFile = file;
                      _networkThumbnail = null;
                    });
                    await _loadVideoThumbnail(file);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam_outlined, color: AppColors.appIconColor),
                title: Text('Record Video', style: AppTextStyle.description(color: AppColors.appTitleColor)),
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
    }

    Future<void> _showMobileVideoPicker() async {
      await showModalBottomSheet(
        context: context,
        builder: (_) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.video_library_outlined, color: AppColors.appIconColor),
                title: Text('Video Gallery', style: AppTextStyle.description(color: AppColors.appTitleColor)),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? picked = await _picker.pickVideo(source: ImageSource.gallery);
                  if (picked != null) {
                    final file = File(picked.path);
                    widget.onPicked(file);
                    setState(() {
                      _localFile = file;
                      _networkThumbnail = null;
                    });
                    await _loadVideoThumbnail(file);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam_outlined, color: AppColors.appIconColor),
                title: Text('Record Video', style: AppTextStyle.description(color: AppColors.appTitleColor)),
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
                content: Text('File type not allowed. Allowed: ${widget.allowedExtensions!.join(", ")}', style: AppTextStyle.description(color: AppColors.appDescriptionColor)),
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
        setState(() {
          _localFile = file;
          _pdfThumb = null; // Reset PDF thumb when new file is picked
        });
        // Load PDF thumbnail if it's a PDF
        if (_isPdf(file.path)) {
          await _loadPdfThumbnail(file);
        }
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
      final isVideoUrl = _isVideoUrl(widget.imageUrl);
      final isDocumentUrl = _isDocumentUrl(widget.imageUrl);
      final hasMediaPreview = _hasMediaPreview(
        effectiveFile,
        widget.imageUrl,
        isVideoUrl,
        isDocumentUrl,
      );
  
      // Load video thumbnail if imageUrl is a video URL
      if (isVideoUrl && _networkThumbnail == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadVideoThumbnail(widget.imageUrl!));
      }
  
      // Load video thumbnail for local video files
      if (effectiveFile != null && _isVideoFile(effectiveFile.path) && _networkThumbnail == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadVideoThumbnail(effectiveFile));
      }
  
      // Load PDF thumbnail for local PDF files
      if (effectiveFile != null && _isPdf(effectiveFile.path) && _pdfThumb == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadPdfThumbnail(effectiveFile));
      }
  
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label.isNotEmpty)
            Text(
              widget.label,
              style: AppTextStyle.description(
                color: AppColors.appBodyTextColor,
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
                            color: _isDragging ? AppColors.appColor :Colors.transparent,
                            width: _isDragging ? 3 : 2,
                          ),
                        ),
                        child: ClipOval(
                          child: effectiveFile != null || (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                              ? Stack(
                            fit: StackFit.expand,
                            children: [
                              effectiveFile != null
                                  ? _isVideoFile(effectiveFile.path)
                                  ? (_networkThumbnail != null
                                  ? Image.memory(_networkThumbnail!, fit: BoxFit.cover)
                                  : Center(child: CircularProgressIndicator()))
                                  : buildFilePreview(effectiveFile)
  
  
                                  : (isVideoUrl && _networkThumbnail != null
                                      ? Image.memory(_networkThumbnail!, fit: BoxFit.cover)
                                      : (isVideoUrl && _networkThumbnail == null
                                          ? Center(child: CircularProgressIndicator())
                                          : (isDocumentUrl
                                              ? _buildDocumentFromUrlPreview(widget.imageUrl!)
                                              : (widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                                                  ? CachedNetworkImage(
                                                      imageUrl: widget.imageUrl!,
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context, url, error) => _buildNoImagePlaceholder(),
                                                    )
                                                  : _buildNoImagePlaceholder())))),
                              // ALWAYS show edit icon (image + video + API + local)
                              Positioned(
                                top: 15,
                                right: 13,
                                child: GestureDetector(
                                  onTap: () async {
                                    // If it's a video (local or API), open video picker
                                    if (_isVideoFile(effectiveFile?.path ?? '') || isVideoUrl) {
                                      _pick(context);   // open video bottom sheet
                                      return;
                                    }
  
                                    // If image comes from API → open picker (don't edit)
                                    if (widget.imageUrl != null && widget.imageUrl!.startsWith("http")) {
                                      _pick(context);
                                      return;
                                    }
  
                                    // If file path is http → also pick
                                    if (effectiveFile != null && effectiveFile.path.startsWith("http")) {
                                      _pick(context);
                                      return;
                                    }
  
                                    // ELSE → image editor
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
                        Text('Drag & Drop or Click', style: AppTextStyle.body( color: AppColors.appDescriptionColor)),
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
                  height: 180.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    border: Border.all(
                      color: _isDragging
                          ? AppColors.appDescriptionColor
                          : (hasMediaPreview ? Colors.transparent : AppColors.appDescriptionColor),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // === PREVIEW (Image or Video) ===
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: effectiveFile != null
                            ? (_isVideoFile(effectiveFile.path)
                            ? (_networkThumbnail != null
                                ? GestureDetector(
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
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.memory(_networkThumbnail!, fit: BoxFit.cover, width: double.infinity),
                                        // Play icon overlay
                                        Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: AppColors.appMutedColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child:  Icon(
                                              Icons.play_arrow,
                                              color: AppColors.appIconColor,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const Center(child: CircularProgressIndicator()))
                            : (_isDocument(effectiveFile.path)
                                ? _buildFullSizeDocumentPreview(effectiveFile)
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
                                  )))
                            : (isVideoUrl && _networkThumbnail != null
                                ? GestureDetector(
                                    onTap: () {
                                      // 👉 Open video viewer for URL
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => VideoViewScreen(
                                            videoFile: File(''),
                                            videoUrl: widget.imageUrl,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.memory(
                                          _networkThumbnail!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                        // Play icon overlay
                                        Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: AppColors.appMutedColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child:  Icon(
                                              Icons.play_arrow,
                                              color: AppColors.appIconColor,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : (isVideoUrl && _networkThumbnail == null
                                    ? Center(child: CircularProgressIndicator())
                                    : (isDocumentUrl
                                        ? _buildDocumentFromUrlPreview(widget.imageUrl!)
                                        : (widget.imageUrl != null
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
                                                  errorWidget: (context, url, error) => _buildNoImagePlaceholder(),
                                                ),
                                              )
                                            : _buildNoImagePlaceholder())))),
                      ),
  
                      // === EDIT BUTTON ===
                      if ((effectiveFile != null) || 
                          (widget.imageUrl != null && widget.imageUrl!.isNotEmpty && effectiveFile == null))
                        Positioned(
                          top: 10,
                          left: 10,
                          child: GestureDetector(
                            onTap: () async {
                              // If it's a video (local or API), open video picker
                              if (_isVideoFile(effectiveFile?.path ?? '') || isVideoUrl) {
                                _pick(context);   // open video bottom sheet
                                return;
                              }
  
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
                              setState(() {
                                _localFile = null;
                                _networkThumbnail = null;
                              });
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
                      if (effectiveFile == null && widget.imageUrl == null && !isVideoUrl)
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isDragging ? Icons.cloud_upload : null,
                                size: 50,
                                color: _isDragging
                                    ? AppColors.appColor
                                    : AppColors.appIconColor,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isDragging ? 'Drop Here' : '',
                                style: AppTextStyle.body(
                                  color:
                                  AppColors.appDescriptionColor,

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
          else if (widget.isImageFile || widget.category == 'video') ...[
              _buildDragTarget(
                child: GestureDetector(
                  onTap: () => _pick(context),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _isDragging
                            ? AppColors.appDescriptionColor
                            : (hasMediaPreview ? Colors.transparent : AppColors.appDescriptionColor),
                        width: _isDragging ? 3 : 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: _isDragging 
                          ? AppColors.appColor.withValues(alpha: 0.05)
                          : (widget.category == 'video' && effectiveFile == null && widget.imageUrl == null && !isVideoUrl
                              ? Colors.transparent
                              : Colors.transparent),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: effectiveFile != null
                          ? Stack(
                        fit: StackFit.expand,
                        children: [
                          _isVideoFile(effectiveFile.path)
                              ? (_networkThumbnail != null
                                  ? Image.memory(_networkThumbnail!, fit: BoxFit.cover)
                                  : const Center(child: CircularProgressIndicator()))
                              : buildFilePreview(effectiveFile),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    // If it's a video (local or API), open video picker
                                    if (_isVideoFile(effectiveFile.path) || isVideoUrl) {
                                      _pick(context);   // open video bottom sheet
                                      return;
                                    }
  
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
  
                                    // If it's a document, don't edit
                                    if (_isDocument(effectiveFile.path)) {
                                      _pick(context);
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
                          : (isVideoUrl && _networkThumbnail != null
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.memory(_networkThumbnail!, fit: BoxFit.cover),
                                    Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.appMutedColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child:  Icon(Icons.play_arrow, color: AppColors.appIconColor, size: 30),
                                      ),
                                    ),
                                  ],
                                )
                              : (isVideoUrl && _networkThumbnail == null
                                  ? Center(child: CircularProgressIndicator())
                                  : (isDocumentUrl
                                      ? _buildDocumentFromUrlPreview(widget.imageUrl!)
                                      : (widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                                          ? Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: widget.imageUrl!,
                                                  fit: BoxFit.cover,
                                                  errorWidget: (context, url, error) => _buildNoImagePlaceholder(),
                                                ),
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
                                            widget.category == 'video' 
                                              ? Container(
                                                  color: Colors.transparent,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          _isDragging ? Icons.cloud_upload : Icons.videocam_outlined,
                                                          size: 50,
                                                          color: _isDragging 
                                                              ? AppColors.appColor 
                                                              : AppColors.appIconColor,
                                                        ),
                                                        const SizedBox(height: 12),
                                                        Text(
                                                          _isDragging ? 'Drop Video Here' : 'Tap to Select Files',
                                                          style: AppTextStyle.description(
                                                            color: _isDragging 
                                                                ? AppColors.appColor 
                                                                : AppColors.appDescriptionColor,

                                                          ),
                                                        ),
                                                        if (kIsWeb && !_isDragging)
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 4),
                                                            child: Text(
                                                              'or Drag & Drop',
                                                              style: AppTextStyle.body(
                                                                color: AppColors.appDescriptionColor,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : _buildNoImagePlaceholder(),
                                            if (kIsWeb && widget.category != 'video')
                                              Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(_isDragging ? Icons.cloud_upload : Icons.image_outlined, size: 40, color: _isDragging ? AppColors.appColor : AppColors.appIconColor),
                                                    const SizedBox(height: 8),
                                                    Text(_isDragging ? 'Drop Image Here' : 'Drag & Drop or Click', style: AppTextStyle.body(color: AppColors.appDescriptionColor)),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ))))),
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
                        border: Border.all(
                          color: _isDragging
                              ? AppColors.appColor
                              : (hasMediaPreview ? Colors.transparent : AppColors.appDescriptionColor),
                          width: _isDragging ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color:Colors.transparent,
                      ),
  
                      // 🔥 IF DOCUMENT → SHOW PREVIEW
                      child: (effectiveFile != null && _isDocument(effectiveFile.path))
                          ? _buildDocumentPreview(effectiveFile)
  
                      // 🔥 OTHERWISE SHOW DEFAULT ROW
                          : Row(
                        children: [
                          Icon(
                            _isDragging ? Icons.cloud_upload : Icons.attach_file,
                            color: _isDragging
                                ? AppColors.appColor
                                : AppColors.appIconColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _isDragging && kIsWeb
                                  ? 'Drop File Here'
                                  : (effectiveFile != null
                                  ? effectiveFile.path.split('/').last
                                  : AppStrings.noFileSelected),
                              style: AppTextStyle.description(
                                color: _isDragging
                                    ? AppColors.appColor
                                    : AppColors.appDescriptionColor
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (kIsWeb && effectiveFile == null && !_isDragging)
                            Text(
                              'or Click',
                              style: AppTextStyle.body(
                                color: AppColors.appDescriptionColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
  
        ],
      );
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
  
    bool _hasMediaPreview(File? file, String? url, bool isVideoUrl, bool isDocumentUrl) {
      if (isVideoUrl) return true;
      if (file != null) {
        if (_isVideoFile(file.path)) return true;
        if (!_isDocument(file.path)) return true;
      }
      if (url != null && url.isNotEmpty && !isDocumentUrl) return true;
      return false;
    }

    IconData _fileIcon(String path) {
      if (_isPdf(path)) return Icons.picture_as_pdf;
      if (_isWord(path)) return Icons.description;
      if (_isExcel(path)) return Icons.grid_on;
      if (_isPpt(path)) return Icons.slideshow;
      if (_isText(path)) return Icons.text_snippet;
      if (_isEpub(path)) return Icons.book;
      return Icons.insert_drive_file;
    }
  
  
    Future<Uint8List?> _generatePdfThumbnail(String path) async {
      try {
        final pdf = await PdfDocument.openFile(path);
        final page = await pdf.getPage(1);
  
        final render = await page.render(
          width: page.width,
          height: page.height,
          format: PdfPageImageFormat.png,
        );
  
        await page.close();
        return render?.bytes;
      } catch (e) {
        debugPrint("PDF thumbnail error: $e");
        return null;
      }
    }
  
    Future<void> _loadPdfThumbnail(File file) async {
      if (!_isPdf(file.path) || _pdfThumb != null) return;
      try {
        final thumb = await _generatePdfThumbnail(file.path);
        if (thumb != null && mounted) {
          setState(() {
            _pdfThumb = thumb;
          });
        }
      } catch (e) {
        debugPrint("Error loading PDF thumbnail: $e");
      }
    }
  
  
    Widget _buildDocumentPreview(File file) {
      final fileName = file.path.split('/').last;
      final fileSize = (file.lengthSync() / (1024 * 1024)).toStringAsFixed(2);
  
      return Row(
        children: [
          // Thumbnail / Icon
          Container(
            width: 60,
            height: 75,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _isPdf(file.path)
                ? (_pdfThumb == null
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(_pdfThumb!, fit: BoxFit.cover),
            ))
                : Icon(_fileIcon(file.path), size: 32, color: Colors.blue),
          ),
  
          const SizedBox(width: 12),
  
          // File name & size
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:  AppTextStyle.body(),
                ),
                const SizedBox(height: 4),
                Text(
                  "$fileSize MB",
                  style: AppTextStyle.body(),
                ),
                Text(
                  file.path.split(".").last.toUpperCase(),
                  style:AppTextStyle.body(),
                ),
              ],
            ),
          ),
        ],
      );
    }
  
  
  
    Widget buildFilePreview(File file) {
      if (_isVideoFile(file.path)) {
        // 🔥 If it's a video, never try to decode the video as image
        return _networkThumbnail != null
            ? Image.memory(_networkThumbnail!, fit: BoxFit.cover)
            : const Center(child: CircularProgressIndicator());
      }
  
      if (_isDocument(file.path)) {
        // 📄 Document file - show preview
        return _buildFullSizeDocumentPreview(file);
      }
  
      // 🖼 Normal Image file
      return Image.file(file, fit: BoxFit.cover);
    }
  
    Widget _buildFullSizeDocumentPreview(File file) {
      final fileName = file.path.split('/').last;
      final fileSize = (file.lengthSync() / (1024 * 1024)).toStringAsFixed(2);
      final extension = file.path.split('.').last.toUpperCase();
  
      return Container(
        color: Colors.grey.shade100,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // PDF thumbnail or icon
            _isPdf(file.path)
                ? (_pdfThumb != null
                    ? Image.memory(_pdfThumb!, fit: BoxFit.contain)
                    : const Center(child: CircularProgressIndicator()))
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_fileIcon(file.path), size: 64, color: Colors.blue),
                        const SizedBox(height: 8),
                        Text(
                          extension,
                          style: AppTextStyle.body(),
                        ),
                      ],
                    ),
                  ),
            // File info overlay at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:  AppTextStyle.description(
                        color: AppColors.appMutedTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$fileSize MB • $extension",
                      style: AppTextStyle.description(
                        color: AppColors.appMutedTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  
    Widget _buildDocumentFromUrlPreview(String url) {
      final fileName = url.split('/').last.split('?').first;
      final extension = fileName.contains('.') ? fileName.split('.').last.toUpperCase() : 'FILE';
  
      return Container(
        color: Colors.grey.shade100,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_fileIcon(url), size: 64, color: Colors.blue),
                  const SizedBox(height: 8),
                  Text(
                    extension,
                    style: AppTextStyle.body(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // File info overlay at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.description(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      extension,
                      style: AppTextStyle.body(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  
    Widget _buildNoImagePlaceholder() {
      return SizedBox.expand(
        child: Container(
          color: AppColors.appTextColor.withValues(alpha: 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_outlined, size: 40, color: AppColors.appIconColor),
              const SizedBox(height: 8),
              Text(AppStrings.noImage, style: AppTextStyle.body( color: AppColors.appDescriptionColor)),
            ],
          ),
        ),
      );
    }
  }