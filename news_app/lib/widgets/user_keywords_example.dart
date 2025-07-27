import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_keywords_provider.dart';

class UserKeywordsExample extends StatefulWidget {
  const UserKeywordsExample({Key? key}) : super(key: key);

  @override
  State<UserKeywordsExample> createState() => _UserKeywordsExampleState();
}

class _UserKeywordsExampleState extends State<UserKeywordsExample> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 사용자 키워드 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserKeywordsProvider>().loadUserKeywords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사용자 관심 키워드'),
        actions: [
          IconButton(
            onPressed: () => context.read<UserKeywordsProvider>().loadUserKeywords(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Consumer<UserKeywordsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '에러가 발생했습니다',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => provider.loadUserKeywords(),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          final keywords = provider.keywords;
          
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더
                Row(
                  children: [
                    const Icon(Icons.tag, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '관심 키워드',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Spacer(),
                    Text(
                      '${keywords.length}개',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 키워드 목록
                if (keywords.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.tag_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '관심 키워드가 없습니다',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '키워드를 추가하여 관심 있는 뉴스를 받아보세요',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: keywords.length,
                      itemBuilder: (context, index) {
                        final keyword = keywords[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue[100],
                              child: Text(
                                keyword.isNotEmpty ? keyword[0].toUpperCase() : '#',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              keyword,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text('관심 키워드 #${index + 1}'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // 키워드 클릭 시 처리 (예: 해당 키워드 뉴스 보기)
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$keyword 관련 뉴스를 검색합니다'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                // 하단 정보
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '관심 키워드를 설정하면 관련 뉴스를 우선적으로 받아볼 수 있습니다.',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 