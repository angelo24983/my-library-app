import 'package:flutter/material.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/models/book_stream_publisher.dart';
import 'package:my_library/widgets/main_drawer.dart';

class BooksScreen extends StatelessWidget {
  static const routeName = '/books';
  const BooksScreen({Key? key}) : super(key: key);

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
              StreamBuilder(
                stream: BookStreamPublisher().getBookStream(),
                builder: (context, snapshot) {
                  final tilesList = <ListTile>[];
                  if (snapshot.hasData) {
                    final myBooks = snapshot.data as List<Book>;
                    tilesList.addAll(myBooks.map((nextBook) {
                      return ListTile(
                        leading: const Icon(Icons.book),
                        title: Text(nextBook.title),
                        subtitle: Text(nextBook.description),
                      );
                    }));
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
