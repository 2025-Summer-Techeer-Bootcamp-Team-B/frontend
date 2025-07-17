// lib/providers/news_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news_model.dart';
import '../services/news_services.dart';

final newsProvider = FutureProvider<List<NewsModel>>((ref) async {
  return NewsService().fetchNewsList();
});
