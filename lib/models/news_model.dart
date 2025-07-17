// lib/models/news_model.dart
class NewsModel {
  final String id;
  final String title;
  final String category;
  final String source;
  final String imageUrl;
  final String date;

  NewsModel({
    required this.id,
    required this.title,
    required this.category,
    required this.source,
    required this.imageUrl,
    required this.date,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      source: json['source'],
      imageUrl: json['imageUrl'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'source': source,
    'imageUrl': imageUrl,
    'date': date,
  };
}
