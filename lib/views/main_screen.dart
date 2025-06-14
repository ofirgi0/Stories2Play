import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';
import 'book_selection_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<CategoryModel> categories = [];
  bool isLoading = true;
  int _currentIndex = 0;

  final List<Color> fallbackColors = [
    Colors.blueGrey,
    Colors.deepOrange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final fetched = await CategoryService.fetchCategories();
      setState(() {
        categories = fetched;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching categories: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Widget> _buildCategoryItems() {
    List<Widget> items = [];

    for (CategoryModel category in categories) {
      items.add(
        GestureDetector(
          onTap: () {
            if (category.books.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookSelectionScreen(category: category),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon!')),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: category.coverImgUrl.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(category.coverImgUrl),
                fit: BoxFit.cover,
              )
                  : null,
              color:
              category.coverImgUrl.isEmpty ? Colors.grey.shade700 : null,
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
                  category.name,
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

    // Add "Coming Soon" placeholders
    while (items.length < 5) {
      items.add(
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
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


  List<Widget> _buildCarouselItems() {
    List<Widget> items = [];

    for (var category in categories) {
      items.add(GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookSelectionScreen(category: category),
            ),
          );
        }
        ,
        child: Stack(
          children: [
            Image.network(category.coverImgUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey, height: 250)),
            Container(
              alignment: Alignment.bottomCenter,
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54])),
              child: Text(
                category.name,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ));
    }

    // Fill with placeholders
    while (items.length < 5) {
      items.add(Container(
        width: double.infinity,
        height: 250,
        color: fallbackColors[items.length % fallbackColors.length],
        alignment: Alignment.center,
        child: const Text(
          'Coming Soon',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'בחרו סדרת סיפורים',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CarouselSlider(
              options: CarouselOptions(
                height: 250,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                viewportFraction: 0.8,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: _buildCategoryItems(),
            ),
            const SizedBox(height: 24),
            if (categories.isNotEmpty &&
                _currentIndex < categories.length &&
                categories[_currentIndex].description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  categories[_currentIndex].description[lang] ??
                      categories[_currentIndex].description['en'] ??
                      '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

}
