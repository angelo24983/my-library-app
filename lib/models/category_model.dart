import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_library/models/category.dart';

class CategoryModel with ChangeNotifier {
  List<Category> _categories = [];
  late StreamSubscription _categoriesStream;
  final _db = FirebaseDatabase.instance.ref();

  CategoryModel() {
    _listenToCategories();
  }

  static const categoriesPath = 'categories';

  List<Category> get categories => _categories;

  void _listenToCategories() {
    _categoriesStream = _db.child(categoriesPath).onValue.listen((event) {
      final allCategories =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      _categories = allCategories.values
          .map((categoryAsJSON) =>
              Category.fromTDB(Map<String, dynamic>.from(categoryAsJSON)))
          .toList();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _categoriesStream.cancel();
    super.dispose();
  }
}
