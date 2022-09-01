import 'package:flutter/material.dart';
import '../widgets/book_item.dart';
import '../models/book.dart';

class CategoryBooksScreen extends StatefulWidget {
  static const routeName = '/category-books';

  final List<Book> availableBooks;

  const CategoryBooksScreen({
    super.key,
    required this.availableBooks,
  });

  @override
  State<CategoryBooksScreen> createState() => _CategoryBooksScreenState();
}

class _CategoryBooksScreenState extends State<CategoryBooksScreen> {
  late String categoryTitle;
  late List<Book> displayedBooks;
  var _loadedInitData = false;

  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      final routeArgs =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      categoryTitle = routeArgs['title'] as String;
      final categoryId = routeArgs['id'];
      displayedBooks = widget.availableBooks.where((book) {
        return book.category == categoryId;
      }).toList();
      _loadedInitData = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return BookItem(
            id: displayedBooks[index].id!,
            title: displayedBooks[index].title,
            author: displayedBooks[index].author,
            description: displayedBooks[index].description,
            imageUrl: displayedBooks[index].imageUrl,
          );
        },
        itemCount: displayedBooks.length,
      ),
    );
  }
}
