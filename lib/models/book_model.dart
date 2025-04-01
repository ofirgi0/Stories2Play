import 'dart:convert';
import 'page_model.dart';

class BookModel {
  final String id;
  final double price;
  final String author;
  final String title;
  final String coverImageUrl;
  final String backgroundMusic;
  final String description;
  final List<PageModel> pagesData;

  BookModel({
    required this.id,
    required this.price,
    required this.author,
    required this.title,
    required this.coverImageUrl,
    required this.backgroundMusic,
    required this.description,
    required this.pagesData,
  });

  // Convert JSON to BookModel
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      price: (json['price'] as num).toDouble(),
      author: json['author'],
      title: json['title'],
      coverImageUrl: json['coverImageUrl'],
      backgroundMusic: json['backgroundMusic'] ?? "",
      description: json['description'],
      pagesData: (json['pagesData'] as List)
          .map((page) => PageModel.fromJson(page))
          .toList(),
    );
  }

  // Convert BookModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'author': author,
      'title': title,
      'coverImageUrl': coverImageUrl,
      'backgroundMusic': backgroundMusic,
      'description': description,
      'pagesData': pagesData.map((page) => page.toJson()).toList(),
    };
  }
}
