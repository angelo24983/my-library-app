import 'package:firebase_database/firebase_database.dart';
import 'package:my_library/models/book.dart';

class BookStreamPublisher {
  final _database = FirebaseDatabase.instance.ref();

  Stream<List<Book>> getBookStream() {
    final bookStream = _database.child('books').onValue;
    final streamToPublish = bookStream.map((event) {
      final bookMap = Map<String, dynamic>.from(event.snapshot.value as Map);
      final bookList = bookMap.entries.map((element) {
        return Book.fromTDB(Map<String, dynamic>.from(element.value));
      }).toList();
      return bookList;
    });
    return streamToPublish;
  }
}
