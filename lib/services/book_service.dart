import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class BookService {
  static Future<BookModel?> fetchBookMetadata(String folderId, String language) async {
    final url =
        'https://newstories2play.s3.eu-central-1.amazonaws.com/books/$folderId/book_data_$language.txt';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final data = json.decode(decoded);
        return BookModel.fromJson(data, folderId: folderId); // ✅ pass folderId
      }
    } catch (e) {
      print('Error fetching book $folderId: $e');
    }

    return null;
  }
}
