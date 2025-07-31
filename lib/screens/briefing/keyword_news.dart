import 'package:flutter/material.dart';
import '../../models/article_models.dart';
import '../briefing/briefing_screen.dart';

class KeywordNewsScreen extends StatefulWidget {
  final List<ArticleModel> articles;
  final String title;

  const KeywordNewsScreen({
    Key? key,
    required this.articles,
    required this.title,
  }) : super(key: key);

  @override
  State<KeywordNewsScreen> createState() => _KeywordNewsScreenState();
}

class _KeywordNewsScreenState extends State<KeywordNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
          ),
        ),
        centerTitle: true,
      ),
      body: widget.articles.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '키워드별 뉴스가 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.articles.length,
              itemBuilder: (context, index) {
                final article = widget.articles[index];
                return _buildNewsCard(article);
              },
            ),
    );
  }

  Widget _buildNewsCard(ArticleModel article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BriefingScreen(article: article),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 썸네일 이미지
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: article.thumbnailImageUrl != null && article.thumbnailImageUrl!.isNotEmpty
                        ? Image.network(
                            article.thumbnailImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.article,
                              size: 40,
                              color: Color(0xFF7B6F5B),
                            ),
                          )
                        : const Icon(
                            Icons.article,
                            size: 40,
                            color: Color(0xFF7B6F5B),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                // 기사 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 제목
                      Text(
                        article.title ?? '제목 없음',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'Pretendard',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // 출처와 날짜
                      Row(
                        children: [
                          Text(
                            article.author ?? '출처 없음',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0565FF),
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            article.publishedAt != null 
                                ? article.publishedAt!.toIso8601String().split('T').first 
                                : '날짜 없음',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 카테고리 태그
                      if (article.categoryName != null && article.categoryName!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0565FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            article.categoryName!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0565FF),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // 재생 버튼
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BriefingScreen(article: article, autoPlay: true),
                      ),
                    );
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0565FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 