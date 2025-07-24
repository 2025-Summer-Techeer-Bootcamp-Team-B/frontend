import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  final List<String> categories = ['정치', '경제', '이슈', '사회', 'IT', '연예'];
  late TabController _tabController;

  // 데모용 더미 데이터
  final Map<String, List<Map<String, String>>> favoriteNews = {
    '정치': [
      {'title': '정치 기사 1', 'summary': '정치 기사 1 요약', 'date': '2024-07-10'},
      {'title': '정치 기사 2', 'summary': '정치 기사 2 요약', 'date': '2024-07-09'},
    ],
    '경제': [
      {'title': '경제 기사 1', 'summary': '경제 기사 1 요약', 'date': '2024-07-08'},
    ],
    '이슈': [
      {'title': '이슈 기사 1', 'summary': '이슈 기사 1 요약', 'date': '2024-07-07'},
    ],
    '사회': [],
    'IT': [
      {'title': 'IT 기사 1', 'summary': 'IT 기사 1 요약', 'date': '2024-07-06'},
    ],
    '연예': [],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: categories.map((cat) => Tab(text: cat)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories.map((cat) {
          final newsList = favoriteNews[cat]!;
          if (newsList.isEmpty) {
            return const Center(child: Text('이 카테고리에 저장된 뉴스가 없습니다.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: newsList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, idx) {
              final news = newsList[idx];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: Icon(Icons.star, color: Colors.amber[700]),
                  title: Text(news['title']!),
                  subtitle: Text(news['summary']!),
                  trailing: Text(news['date']!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  onTap: () {
                    // 상세 페이지 이동 등 구현 가능
                  },
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
