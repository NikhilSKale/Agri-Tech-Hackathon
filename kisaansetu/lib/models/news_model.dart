class NewsArticle {
  final String title;
  final String description;
  final String? imageUrl;
  final String url;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    this.imageUrl,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description Available',
      imageUrl: json['urlToImage'],
      url: json['url'],
    );
  }
}