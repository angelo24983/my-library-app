import 'package:flutter/material.dart';
import 'dummy_data.dart';
import 'models/book.dart';
import 'screens/category_books_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/book_detail_screen.dart';
import 'screens/tabs_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, String> _filters = {
    'author': '',
    'title': '',
  };

  List<Book> _availableBooks = dummyBooks;

  final List<Book> _favoritedBooks = [];

  void _setFilters(Map<String, String> filterData) {
    setState(() {
      _filters = filterData;
      _availableBooks = dummyBooks.where((book) {
        if ((_filters['author'] == null || _filters['author'] == '') &&
            book.author != _filters['author']) {
          return false;
        }
        if ((_filters['category'] == null || _filters['category'] == '') &&
            book.author != _filters['category']) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    final existingIndex =
        _favoritedBooks.indexWhere((meal) => meal.id == mealId);

    if (existingIndex >= 0) {
      setState(() {
        _favoritedBooks.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favoritedBooks.add(dummyBooks.firstWhere((meal) => meal.id == mealId));
      });
    }
  }

  bool _isBookFavorite(String mealId) {
    return _favoritedBooks.any((meal) => meal.id == mealId);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      primarySwatch: Colors.pink,
      canvasColor: const Color.fromRGBO(255, 254, 229, 1),
      fontFamily: 'Raleway',
      textTheme: ThemeData.light().textTheme.copyWith(
          bodySmall: const TextStyle(
            color: Color.fromRGBO(20, 51, 51, 1),
          ),
          bodyMedium: const TextStyle(
            color: Color.fromRGBO(20, 51, 51, 1),
          ),
          titleSmall: const TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold,
          )),
    );
    return MaterialApp(
      title: 'DeliMeals',
      theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
        secondary: Colors.amber,
      )),
      routes: {
        '/': (context) => TabsScreen(
              favoriteBooks: _favoritedBooks,
            ),
        CategoryBooksScreen.routeName: (context) =>
            CategoryBooksScreen(availableBooks: _availableBooks),
        BookDetailScreen.routeName: (context) => BookDetailScreen(
              toggleFavorite: _toggleFavorite,
              isBookFavorite: _isBookFavorite,
            ),
        FiltersScreen.routeName: (context) => FiltersScreen(
              saveFilters: _setFilters,
              currentFilters: _filters,
            ),
      },
    );
  }
}
