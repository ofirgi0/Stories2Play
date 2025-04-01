import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/book_provider.dart';
import 'story_screen.dart';

class BookListScreen extends StatefulWidget {
  final String categoryId;

  const BookListScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookProvider>(context, listen: false).fetchBook(widget.categoryId, 'he');
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final book = bookProvider.books[widget.categoryId];

    return Scaffold(
      appBar: AppBar(title: const Text('Select a Book')),
      body: bookProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookProvider.errorMessage.isNotEmpty
          ? Center(child: Text(bookProvider.errorMessage))
          : book == null
          ? const Center(child: Text('No books available'))
          : GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StoryScreen(bookId: book.id)),
          );
        },
        child: Card(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.network(book.coverImageUrl, height: 150, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(book.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
