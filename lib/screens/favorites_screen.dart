import 'package:flutter/material.dart';
import '../widgets/book_item.dart';
import '../models/book.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Book> favoriteBooks;

  const FavoritesScreen({
    super.key,
    required this.favoriteBooks,
  });

  @override
  Widget build(BuildContext context) {
    if (favoriteBooks.isEmpty) {
      return const Center(
        child: Text('You have no favorites yet - Start adding some!'),
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          return BookItem(
            id: favoriteBooks[index].id,
            title: favoriteBooks[index].title,
            author: favoriteBooks[index].author,
            description: favoriteBooks[index].description,
            imageUrl: favoriteBooks[index].imageUrl,
          );
        },
        itemCount: favoriteBooks.length,
      );
    }
  }
}
