class CategoryModel {
  final String categoryId;
  final String name;
  final String coverImgUrl;
  final Map<String, String> description;
  final List<String> books;


  CategoryModel({
    required this.categoryId,
    required this.name,
    required this.coverImgUrl,
    required this.description,
    required this.books,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'],
      name: json['name'],
      coverImgUrl: json['coverImgUrl'],
      description: Map<String, String>.from(json['description'] ?? {}),
      books: List<String>.from(json['books']),
    );
  }
}
