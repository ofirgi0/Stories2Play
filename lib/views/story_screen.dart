import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';

import '../viewmodels/book_provider.dart';
import '../viewmodels/page_provider.dart';
import '../models/page_model.dart';

class StoryScreen extends StatefulWidget {
  final String bookId;

  const StoryScreen({Key? key, required this.bookId}) : super(key: key);

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final book = bookProvider.books[widget.bookId];

    if (book != null) {
      Provider.of<PageProvider>(context, listen: false).loadPages(book.pagesData);
      _playNarration();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playNarration() async {
    final page = Provider.of<PageProvider>(context, listen: false).currentPage;
    if (page?.voiceNarration != null && page!.voiceNarration!.isNotEmpty) {
      try {
        await _audioPlayer.setUrl(page.voiceNarration!);
        _audioPlayer.play();
      } catch (e) {
        print("Failed to play narration: $e");
      }
    }
  }

  void _goToNextPage(int nextPageIndex) {
    final pageProvider = Provider.of<PageProvider>(context, listen: false);
    pageProvider.goToPage(nextPageIndex);
    _playNarration();
  }

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);
    final currentPage = pageProvider.currentPage;

    if (currentPage == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Story")),
        body: const Center(child: Text("No pages available")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Story")),
      body: GestureDetector(
        onTap: () {
          if (currentPage.choices.isEmpty) {
            _goToNextPage(pageProvider.currentPageIndex + 1);
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Image.network(currentPage.pageImageUrl, fit: BoxFit.cover, width: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(currentPage.pageText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
            ),
            if (currentPage.choices.isNotEmpty)
              Column(
                children: currentPage.choices.map((choice) {
                  return ElevatedButton(
                    onPressed: () => _goToNextPage(choice.page),
                    child: Text(choice.text),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
