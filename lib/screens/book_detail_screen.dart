import 'package:flutter/material.dart';
import 'package:my_library/models/book_model.dart';
import 'package:provider/provider.dart';

class BookDetailScreen extends StatelessWidget {
  static const routeName = '/book-detail';

  final Function toggleFavorite;
  final Function isBookFavorite;

  const BookDetailScreen({
    super.key,
    required this.toggleFavorite,
    required this.isBookFavorite,
  });

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 150,
      width: 300,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookId = ModalRoute.of(context)?.settings.arguments as String;
    final selectedBook = Provider.of<BookModel>(context)
        .books
        .firstWhere((book) => book.id == bookId);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedBook.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(
              selectedBook.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          buildSectionTitle(context, 'Author'),
          buildContainer(
            Text(selectedBook.author),
          ),
          buildSectionTitle(context, 'Category'),
          buildContainer(
            Text(selectedBook.category),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(isBookFavorite(bookId) ? Icons.star : Icons.star_border),
        onPressed: () => toggleFavorite(bookId),
      ),
    );
  }
}
