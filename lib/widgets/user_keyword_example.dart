import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_keyword_provider.dart';
import '../models/common_models.dart';

class UserKeywordExample extends StatefulWidget {
  const UserKeywordExample({Key? key}) : super(key: key);

  @override
  State<UserKeywordExample> createState() => _UserKeywordExampleState();
}

class _UserKeywordExampleState extends State<UserKeywordExample> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 사용자 키워드 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserKeywordProvider>().loadUserKeywords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사용자 관심 키워드'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<UserKeywordProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('키워드를 불러오는 중...'),
                ],
              ),
            );
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
                    '에러: ${provider.error}',
                    style: const TextStyle(fontSize: 16),
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
          if (keywords == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.keyboard_arrow_up,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '키워드를 불러올 수 없습니다.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 현재 키워드 표시
                _buildSection(
                  '현재 관심 키워드',
                  [
                    if (keywords.keyword?.isNotEmpty == true)
                      ...keywords.keyword!.map((keyword) => 
                        _buildKeywordChip(keyword)
                      ).toList()
                    else
                      const Text(
                        '설정된 키워드가 없습니다.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // 키워드 관리 버튼
                _buildSection(
                  '키워드 관리',
                  [
                    _buildUpdateButton(
                      '키워드 새로고침',
                      () => provider.loadUserKeywords(),
                      icon: Icons.refresh,
                    ),
                    const SizedBox(height: 8),
                    _buildUpdateButton(
                      '키워드 추가 (테스트)',
                      () => _showAddKeywordDialog(context, provider),
                      icon: Icons.add,
                    ),
                  ],
                ),

                // API 정보
                const SizedBox(height: 32),
                _buildApiInfo(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildKeywordChip(String keyword) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Chip(
        label: Text(keyword),
        backgroundColor: Colors.blue[100],
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: () {
          // TODO: 키워드 삭제 기능 구현
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$keyword 삭제 기능은 아직 구현되지 않았습니다.')),
          );
        },
      ),
    );
  }

  Widget _buildUpdateButton(String label, VoidCallback onPressed, {IconData? icon}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildApiInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'API 정보',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow('엔드포인트', 'GET /api/v1/user/keyword'),
          _buildInfoRow('설명', '사용자의 관심 키워드를 조회합니다.'),
          _buildInfoRow('파라미터', '없음'),
          _buildInfoRow('응답 형식', 'application/json'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // 키워드 추가 다이얼로그
  void _showAddKeywordDialog(BuildContext context, UserKeywordProvider provider) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('키워드 추가'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '추가할 키워드를 입력하세요',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              final keyword = controller.text.trim();
              if (keyword.isNotEmpty) {
                // TODO: 실제 키워드 추가 API 구현 시 사용
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$keyword 추가 기능은 아직 구현되지 않았습니다.')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }
} 