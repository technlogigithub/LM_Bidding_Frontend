class ReviewModel {
  final String profileImage;
  final String name;
  final String level;
  final double initialRating;
  final String comment;
  final String? uploadedImagePath;

  ReviewModel({
    required this.profileImage,
    required this.name,
    required this.level,
    this.initialRating = 0.0,
    this.comment = '',
    this.uploadedImagePath,
  });
}