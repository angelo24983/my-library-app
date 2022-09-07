import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_library/models/book.dart';

class BookModel with ChangeNotifier {
  List<Book> _books = [];
  late StreamSubscription _booksStream;
  final _db = FirebaseDatabase.instance.ref();

  BookModel() {
    _listenToBooks();
  }

  static const booksPath = 'books';

  List<Book> get books => _books;

  void _listenToBooks() {
    _booksStream = _db.child(booksPath).onValue.listen((event) {
      final allBooks = Map<String, dynamic>.from(event.snapshot.value as Map);
      _books = allBooks.values
          .map((bookAsJSON) =>
              Book.fromTDB(Map<String, dynamic>.from(bookAsJSON)))
          .toList();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _booksStream.cancel();
    super.dispose();
  }

  Book findById(String bookId) {
    return _books.firstWhere((book) => book.id == bookId);
  }

  Future<void> addBook(Book book) async {
    try {
      DatabaseReference booksRef =
          FirebaseDatabase.instance.ref().child(booksPath);

      var pushedBookRef = booksRef.push();

      await pushedBookRef.set(book.toJson());

      final newBook = Book(
        title: book.title,
        description: book.description,
        author: book.author,
        category: book.category,
        imageUrl: book.imageUrl,
        id: pushedBookRef.key ?? '',
      );
      _books.add(newBook);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateBook(String id, Book newBook) async {
    final bookIndex = _books.indexWhere((book) => book.id == id);
    if (bookIndex >= 0) {
      DatabaseReference bookRef =
          FirebaseDatabase.instance.ref().child('$booksPath/$id');

      await bookRef.update(newBook.toJson());
      _books[bookIndex] = newBook;
      notifyListeners();
    }
  }

  Future<void> deleteBook(String id) async {
    final existingBookIndex = _books.indexWhere((book) => book.id == id);
    var existingBook = _books[existingBookIndex];
    _books.removeAt(existingBookIndex);
    notifyListeners();
    try {
      DatabaseReference bookRef =
          FirebaseDatabase.instance.ref().child('$books/$id');
      await bookRef.remove();
      existingBook = null as Book;
    } catch (error) {
      _books.insert(existingBookIndex, existingBook);
      notifyListeners();
      throw const HttpException('Could not delete product');
    }
  }
}
