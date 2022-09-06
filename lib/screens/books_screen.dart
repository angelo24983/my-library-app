import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_library/widgets/main_drawer.dart';

class BooksScreen extends StatelessWidget {
  static const routeName = '/books';
  final _database = FirebaseDatabase.instance.ref();
  BooksScreen({Key? key}) : super(key: key);

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
              FutureBuilder(
                future: _database.child('test2').get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = Map<String, dynamic>.from(
                        (snapshot.data as DataSnapshot).value as Map);
                    final description = data['description'] as String;
                    return Text(description);
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 50),
              StreamBuilder(
                stream: _database
                    .child('books')
                    .orderByKey()
                    .limitToLast(10)
                    .onValue,
                builder: (context, snapshot) {
                  final tilesList = <ListTile>[];
                  if (snapshot.hasData) {
                    final myBooks = Map<String, dynamic>.from(
                        (snapshot.data! as DatabaseEvent).snapshot.value
                            as Map);
                    myBooks.forEach((key, value) {
                      final nextBook = Map<String, dynamic>.from(value);
                      final bookTile = ListTile(
                        leading: const Icon(Icons.book),
                        title: Text(
                          nextBook['title'],
                        ),
                        subtitle: Text(
                          nextBook['description'],
                        ),
                      );
                      tilesList.add(bookTile);
                    });
                  }
                  return Expanded(
                      child: ListView(
                    children: tilesList,
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
