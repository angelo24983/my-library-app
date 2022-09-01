import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/books_provider.dart';

class EditBookScreen extends StatefulWidget {
  static const routeName = '/edit-book';

  const EditBookScreen({super.key});
  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _form = GlobalKey<FormState>();
  var _editedBook = const Book(
    id: null,
    title: '',
    description: '',
    author: '',
    category: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'author': '',
    'category': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String;

      _editedBook = Provider.of<BooksProvider>(context, listen: false)
          .findById(productId);
      _initValues = {
        'title': _editedBook.title,
        'description': _editedBook.description,
        'author': _editedBook.author,
        'category': _editedBook.category,
        'imageUrl': '',
      };
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedBook.id != null) {
      await Provider.of<BooksProvider>(context, listen: false)
          .updateBook(_editedBook.id!, _editedBook);
    } else {
      try {
        await Provider.of<BooksProvider>(context, listen: false)
            .addBook(_editedBook);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('An error occurred!'),
                  content: const Text('Something went wrong.'),
                  actions: [
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedBook = Book(
                          title: value ?? '',
                          description: _editedBook.description,
                          imageUrl: _editedBook.imageUrl,
                          id: _editedBook.id,
                          author: _editedBook.author,
                          category: _editedBook.category,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['author'],
                      decoration: const InputDecoration(labelText: 'Author'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an author.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedBook = Book(
                          title: _editedBook.title,
                          description: _editedBook.description,
                          imageUrl: _editedBook.imageUrl,
                          id: _editedBook.id,
                          author: value ?? '',
                          category: _editedBook.category,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        if (value.length < 10) {
                          return 'Description should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedBook = Book(
                          title: _editedBook.title,
                          description: value ?? '',
                          imageUrl: _editedBook.imageUrl,
                          id: _editedBook.id,
                          author: _editedBook.description,
                          category: _editedBook.category,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
