class NewsArticle {
  final String id;
  final String title;
  final String description;
  final String url;
  final String author;
  final String image;
  final String category;
  final String published;

  NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.author,
    required this.image,
    required this.category,
    required this.published,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      author: json['author'] ?? '',
      image: json['image'] ?? 'https://via.placeholder.com/150',
      category: json['category']?.first ?? '',
      published: json['published'] ?? '',
    );
  }
} 