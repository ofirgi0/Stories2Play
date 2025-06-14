import 'page_model.dart';

class BookModel {
  final String id;
  final String title;
  final String description;
  final String author;
  final String coverImageUrl;
  final String backgroundMusic;
  final List<PageModel> pagesData;
  final String folderId; // ✅ Add this field

  BookModel({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.coverImageUrl,
    required this.backgroundMusic,
    required this.pagesData,
    required this.folderId, // ✅ add here
  });

  factory BookModel.fromJson(Map<String, dynamic> json, {required String folderId}) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      author: json['author'] ?? '',
      coverImageUrl: json['coverImageUrl'],
      backgroundMusic: json['backgroundMusic'] ?? '',
      pagesData: (json['pagesData'] as List? ?? [])
          .map((e) => PageModel.fromJson(e))
          .toList(),
      folderId: folderId, // ✅ set this from outside
    );
  }
}
