import 'package:flutter/material.dart';
import '../models/page_model.dart';

class PageProvider with ChangeNotifier {
  int _currentPageIndex = 0;
  List<PageModel> _pages = [];

  int get currentPageIndex => _currentPageIndex;
  PageModel? get currentPage => _pages.isNotEmpty ? _pages[_currentPageIndex] : null;

  void loadPages(List<PageModel> pages) {
    _pages = pages;
    _currentPageIndex = 0;
    notifyListeners();
  }

  void goToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < _pages.length) {
      _currentPageIndex = pageIndex;
      notifyListeners();
    }
  }

  void resetPages() {
    _currentPageIndex = 0;
    notifyListeners();
  }
}
