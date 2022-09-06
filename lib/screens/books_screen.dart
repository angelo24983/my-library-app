import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_library/widgets/main_drawer.dart';

class BooksScreen extends StatefulWidget {
  static const routeName = '/books';
  const BooksScreen({Key? key}) : super(key: key);

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  String _textContent = 'Hello there';
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription testStream;

  @override
  void initState() {
    _activateListeners();
    super.initState();
  }

  @override
  void deactivate() {
    testStream.cancel();
    super.deactivate();
  }

  void _activateListeners() {
    testStream = _database.child('test2').onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final description = data['description'] as String;

      setState(() {
        _textContent = description;
      });
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Books!'),
      ),
      drawer: const MainDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            children: [
              Text(_textContent),
            ],
          ),
        ),
      ),
    );
  }
}
