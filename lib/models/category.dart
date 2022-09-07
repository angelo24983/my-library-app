import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final Color color;

  const Category({
    required this.id,
    required this.title,
    required this.color,
  });

  factory Category.fromTDB(Map<String, dynamic> data) {
    return Category(
      id: data['id'] ?? 'test',
      title: data['title'] ?? 'title',
      color: Color(int.parse(data['color'])),
    );
  }
}
