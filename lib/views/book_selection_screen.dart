import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/category_model.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';
import 'package:stories2play/views/story_screen.dart';


class BookSelectionScreen extends StatefulWidget {
  final CategoryModel category;

  const BookSelectionScreen({super.key, required this.category});

  @override
  State<BookSelectionScreen> createState() => _BookSelectionScreenState();
}

class _BookSelectionScreenState extends State<BookSelectionScreen> {
  List<BookModel?> books = [];
  bool isLoading = true;

  final List<Color> fallbackColors = [
    Colors.teal,
    Colors.deepPurple,
    Colors.orangeAccent,
    Colors.brown,
    Colors.green,
  ];

  @override
  void initState() {
    super.initState();
    print('📦 Selected categoryId: ${widget.category.categoryId}');
    print('📚 Books list: ${widget.category.books}');
    _loadBookData();
  }

  Future<void> _loadBookData() async {
    List<BookModel?> loaded = [];

    for (String bookId in widget.category.books) {
      final book = await BookService.fetchBookMetadata(bookId, 'he');
      print('bookId11111111: $bookId');

      loaded.add(
        book ??
            BookModel(
              id: bookId,
              title: bookId,
              description: '',
              author: '',
              coverImageUrl: '',
              backgroundMusic: '',
              pagesData: [],
              folderId: bookId,
            )
        ,
      );
    }

    setState(() {
      books = loaded;
      isLoading = false;
    });
  }

  List<Widget> _buildBookItems() {
    List<Widget> items = [];

    for (BookModel? book in books) {
      print('bookId: ${book?.id}, cover: "${book?.coverImageUrl}"');
      items.add(
        GestureDetector(
          onTap: () {
            if (book.pagesData.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoryScreen(book: book),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Book data missing or still loading.')),
              );
            }
          },

          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: book!.coverImageUrl.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(book.coverImageUrl),
                fit: BoxFit.cover,
              )
                  : null,
              color: book.coverImageUrl.isEmpty ? Colors.grey : null,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    while (items.length < 5) {
      items.add(
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 250,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: fallbackColors[items.length % fallbackColors.length],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Coming Soon",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : CarouselSlider(
        options: CarouselOptions(
          height: 250,
          enlargeCenterPage: true,
          autoPlay: false,
        ),
        items: _buildBookItems(),
      ),
    );
  }
}
