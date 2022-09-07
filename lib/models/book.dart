class Book {
  final String? id;
  final String category;
  final String title;
  final String author;
  final String imageUrl;
  final String description;

  const Book({
    required this.id,
    required this.category,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.description,
  });

  factory Book.fromTDB(Map<String, dynamic> data) {
    return Book(
      id: data['id'] ?? 'test',
      author: data['author'] ?? 'author',
      category: data['category'] ?? 'category',
      title: data['title'] ?? 'title',
      imageUrl: data['imageUrl'] ?? 'imageUrl',
      description: data['description'] ?? 'description',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'category': category,
        'title': title,
        'imageUrl': imageUrl,
        'description': description,
      };
}
