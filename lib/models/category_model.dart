import 'dart:convert';

class CategoryModel {
  final String categoryId;
  final String name;
  final String coverImgUrl;
  final String description;
  final List<String> books;

  CategoryModel({
    required this.categoryId,
    required this.name,
    required this.coverImgUrl,
    required this.description,
    required this.books,
  });

  // Convert JSON to CategoryModel
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'],
      name: json['name'],
      coverImgUrl: json['coverImgUrl'],
      description: json['description'],
      books: List<String>.from(json['books']),
    );
  }

  // Convert CategoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'coverImgUrl': coverImgUrl,
      'description': description,
      'books': books,
    };
  }
}
