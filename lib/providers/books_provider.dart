import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_library/models/book.dart';

class BooksProvider with ChangeNotifier {
  List<Book> _items = [];

  List<Book> get items {
    return [..._items];
  }

  Book findById(String bookId) {
    return _items.firstWhere((book) => book.id == bookId);
  }

  Future<void> fetchAndSetBooks() async {
    try {
      DatabaseReference booksRef =
          FirebaseDatabase.instance.ref().child('books');
      final List<Book> loadedBooks = [];
      var dataSnapshot = await booksRef.get();

      for (var element in dataSnapshot.children) {
        loadedBooks.add(
          Book.fromTDB(
              Map<String, dynamic>.from(element.value as Map<String, dynamic>)),
        );
      }

      _items = loadedBooks;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addBook(Book book) async {
    try {
      DatabaseReference booksRef =
          FirebaseDatabase.instance.ref().child('books');

      var pushedBookRef = booksRef.push();

      await pushedBookRef.set({
        'author': book.author,
        'title': book.title,
        'description': book.description,
      });

      final newBook = Book(
        title: book.title,
        description: book.description,
        author: book.author,
        category: book.category,
        imageUrl: book.imageUrl,
        id: pushedBookRef.key ?? '',
      );
      _items.add(newBook);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateBook(String id, Book newBook) async {
    final bookIndex = _items.indexWhere((book) => book.id == id);
    if (bookIndex >= 0) {
      DatabaseReference bookRef =
          FirebaseDatabase.instance.ref().child('books/$id');

      await bookRef.update({
        'author': newBook.author,
        'title': newBook.title,
        'description': newBook.description,
      });
      _items[bookIndex] = newBook;
      notifyListeners();
    }
  }

  Future<void> deleteBook(String id) async {
    final existingBookIndex = _items.indexWhere((book) => book.id == id);
    var existingBook = _items[existingBookIndex];
    _items.removeAt(existingBookIndex);
    notifyListeners();
    try {
      DatabaseReference bookRef =
          FirebaseDatabase.instance.ref().child('books/$id');
      await bookRef.remove();
      existingBook = null as Book;
    } catch (error) {
      _items.insert(existingBookIndex, existingBook);
      notifyListeners();
      throw const HttpException('Could not delete product');
    }
  }
}
