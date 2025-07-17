import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../models/news_model.dart';

class NowPlayingInfo extends StatelessWidget {
  final NewsModel news;

  const NowPlayingInfo({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🖼️ 이미지
        Image.network(news.imageUrl, height: 200, fit: BoxFit.cover),

        const SizedBox(height: 16),

        // 🏷️ 카테고리
        Text(news.category, style: const TextStyle(color: Colors.blue)),

        const SizedBox(height: 8),

        // 📰 제목
        Text(news.title, style: Theme.of(context).textTheme.titleLarge),

        const SizedBox(height: 8),

        // ⭐👁️ 즐겨찾기 + 조회수 아이콘 Row 추가!
        Row(
          children: const [
            Icon(CupertinoIcons.star, size: 20),
            SizedBox(width: 12),
            Icon(CupertinoIcons.eye, size: 20),
          ],
        ),

        const SizedBox(height: 8),

        // 📰 출처
        Text(news.source, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
