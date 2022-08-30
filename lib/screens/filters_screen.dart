import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';

  final Function saveFilters;
  final Map<String, String> currentFilters;

  const FiltersScreen({
    super.key,
    required this.saveFilters,
    required this.currentFilters,
  });

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  late TextEditingController _authorController;
  late TextEditingController _titleController;

  @override
  void initState() {
    _authorController =
        TextEditingController(text: widget.currentFilters['author']);
    _titleController =
        TextEditingController(text: widget.currentFilters['title']);
    super.initState();
  }

  @override
  void dispose() {
    _authorController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Widget _buildFilterField(
    TextEditingController controller,
    String label,
    Function(String) updateValue,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      onSubmitted: updateValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters!'),
        actions: [
          IconButton(
            onPressed: () {
              final selectedFilters = {
                'author': _authorController.text,
                'title': _titleController.text,
              };

              widget.saveFilters(selectedFilters);
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Adjust your book selection.',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Expanded(
                child: ListView(
              children: [
                _buildFilterField(
                  _authorController,
                  'Author',
                  (newValue) {
                    setState(() {
                      _authorController.text = newValue;
                    });
                  },
                ),
                _buildFilterField(
                  _titleController,
                  'Title',
                  (newValue) {
                    setState(() {
                      _titleController.text = newValue;
                    });
                  },
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
