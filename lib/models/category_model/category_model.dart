class Category {
  final String ukey;
  final String? parentUkey;
  final String name;
  final String title;
  final String categoryDetail;
  final String image;
  final bool hasSubcategories;

  Category({
    required this.ukey,
    this.parentUkey,
    required this.name,
    required this.title,
    required this.categoryDetail,
    required this.image,
    required this.hasSubcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      ukey: json['ukey'],
      parentUkey: json['parent_ukey'],
      name: json['name'],
      title: json['title'],
      categoryDetail: json['category_detail'],
      image: json['image'],
      hasSubcategories: json['has_subcategories'],
    );
  }
}