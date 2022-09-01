import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_library/screens/edit_book_screen.dart';
import 'dummy_data.dart';
import 'models/book.dart';
import 'screens/category_books_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/book_detail_screen.dart';
import 'screens/tabs_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

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

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

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
        '/': (context) => FutureBuilder(
            future: _fbApp,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong!');
              } else if (snapshot.hasData) {
                return TabsScreen(
                  favoriteBooks: _favoritedBooks,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
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
        EditBookScreen.routeName: (context) => const EditBookScreen(),
      },
    );
  }
}
