import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stories2play/models/book_model.dart';
import 'package:stories2play/models/page_model.dart';
import 'package:flutter/services.dart';

class StoryScreen extends StatefulWidget {
  final BookModel book;

  const StoryScreen({super.key, required this.book});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  int currentPageIndex = 0;
  final List<int> pageHistory = [];

  PageModel get currentPage => widget.book.pagesData[currentPageIndex];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _precacheAllImages();
  }

  Future<void> _precacheAllImages() async {
    for (final page in widget.book.pagesData) {
      precacheImage(CachedNetworkImageProvider(page.pageImageUrl), context);
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _goToPage(int newPageIndex) {
    if (newPageIndex < 0) {
      Navigator.pop(context);
    } else if (newPageIndex == 0) {
      setState(() {
        currentPageIndex = 0;
        pageHistory.clear();
      });
    } else {
      setState(() {
        pageHistory.add(currentPageIndex);
        currentPageIndex = newPageIndex;
      });
    }
  }

  void _goToPreviousPage() {
    if (pageHistory.isNotEmpty) {
      setState(() {
        currentPageIndex = pageHistory.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = currentPage;

    return WillPopScope(
      onWillPop: () async {
        if (pageHistory.isNotEmpty) {
          _goToPreviousPage();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: page.pageImageUrl,
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholder: (context, url) => const SizedBox.shrink(),
                errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (page.gotoAction.isEmpty) {
                  if (page.nextPage != -1) {
                    _goToPage(page.nextPage);
                  }
                }
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Align(
                        alignment: _getTextAlignment(page.textLocation),
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 24,
                            right: 24,
                            top: 24,
                            bottom: (page.textLocation == 'bottom' &&
                                page.gotoAction.isNotEmpty)
                                ? page.gotoAction.length > 2
                                ? 160
                                : 90
                                : 24,
                          ),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              page.pageText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      if (page.gotoAction.isNotEmpty)
                        Positioned(
                          bottom: 32,
                          left: 16,
                          right: 16,
                          child: Center(
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              alignment: WrapAlignment.center,
                              children: page.gotoAction.map((choice) {
                                return ElevatedButton(
                                  onPressed: () {
                                    _goToPage(choice.page);
                                  },
                                  child: Text(choice.text),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 12,
              child: IconButton(
                onPressed: _goToPreviousPage,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Alignment _getTextAlignment(String location) {
    switch (location) {
      case 'top':
        return Alignment.topCenter;
      case 'bottom':
        return Alignment.bottomCenter;
      case 'left':
        return Alignment.centerLeft;
      case 'right':
        return Alignment.centerRight;
      default:
        return Alignment.bottomCenter;
    }
  }
}
