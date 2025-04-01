import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/book_model.dart';

class BookProvider with ChangeNotifier {
  Map<String, BookModel> _books = {};
  bool _isLoading = false;
  String _errorMessage = '';

  Map<String, BookModel> get books => _books;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchBook(String bookId, String language) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final url = 'https://newstories2play.s3.eu-central-1.amazonaws.com/books/$bookId/book_data_$language.txt';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _books[bookId] = BookModel.fromJson(data);
      } else {
        _errorMessage = 'Failed to load book';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    }

    _isLoading = false;
    notifyListeners();
  }
}
