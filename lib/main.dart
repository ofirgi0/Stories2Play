import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/category_provider.dart';
import 'viewmodels/book_provider.dart';
import 'viewmodels/page_provider.dart';
import 'views/main_screen.dart';

void main() {
  runApp(const Stories2PlayApp());
}

class Stories2PlayApp extends StatelessWidget {
  const Stories2PlayApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => BookProvider()),
        ChangeNotifierProvider(create: (context) => PageProvider()),
      ],
      child: MaterialApp(
        title: 'Stories2Play',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      ),
    );
  }
}
