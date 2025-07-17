import '../models/news_model.dart';

class NewsService {
  Future<List<NewsModel>> fetchNewsList() async {
    await Future.delayed(Duration(seconds: 1)); // 로딩 테스트용

    return [
      NewsModel(
        id: '1',
        title: '테스트 뉴스입니다',
        category: '정치',
        date: '2025-07-17',
        source: '가짜뉴스통신사',
        imageUrl: 'https://via.placeholder.com/300x200',
      ),
      NewsModel(
        id: '2',
        title: '또다른 테스트 뉴스',
        category: '경제',
        date: '2025-07-17',
        source: '테스트통신',
        imageUrl: 'https://via.placeholder.com/300x200',
      ),
    ];
  }
}
