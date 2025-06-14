import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryService {
  static const String url =
      'https://newstories2play.s3.eu-central-1.amazonaws.com/categories.json';

  static Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final categories = jsonData['categories'] as List;
      return categories.map((e) => CategoryModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
