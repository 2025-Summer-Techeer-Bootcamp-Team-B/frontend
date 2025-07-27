import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_preferences_provider.dart';
import '../providers/user_voice_type_provider.dart';
import '../models/common_models.dart';

class UserPreferencesExample extends StatefulWidget {
  const UserPreferencesExample({Key? key}) : super(key: key);

  @override
  State<UserPreferencesExample> createState() => _UserPreferencesExampleState();
}

class _UserPreferencesExampleState extends State<UserPreferencesExample> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 사용자 설정 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserPreferencesProvider>().loadUserPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사용자 설정 예시'),
      ),
      body: Consumer<UserPreferencesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('에러: ${provider.error}'),
                  ElevatedButton(
                    onPressed: () => provider.loadUserPreferences(),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          final preferences = provider.preferences;
          if (preferences == null) {
            return const Center(child: Text('설정을 불러올 수 없습니다.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 현재 설정 표시 - 새로운 API 응답 구조에 맞춰 수정
                _buildSection(
                  '현재 설정',
                  [
                    _buildInfoRow('TTS 음성', preferences.voiceType ?? '설정 안됨'),
                    _buildInfoRow('관심 카테고리', preferences.category?.join(', ') ?? '없음'),
                    _buildInfoRow('관심 키워드', preferences.keyword?.join(', ') ?? '없음'),
                    _buildInfoRow('관심 언론사', preferences.press?.join(', ') ?? '없음'),
                  ],
                ),
                const SizedBox(height: 24),

                // 설정 변경 버튼들 - API에서 지원하는 기능만 표시
                _buildSection(
                  '설정 변경',
                  [
                    _buildUpdateButton(
                      'TTS 음성 변경',
                      () => _showVoiceDialog(context, provider),
                    ),
                    _buildUpdateButton(
                      '관심 카테고리 변경',
                      () => _showCategoriesDialog(context, provider),
                    ),
                    _buildUpdateButton(
                      '관심 키워드 변경',
                      () => _showKeywordsDialog(context, provider),
                    ),
                    _buildUpdateButton(
                      '관심 언론사 변경',
                      () => _showMediaDialog(context, provider),
                    ),
                  ],
                ),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  // TTS 음성 설정 다이얼로그
  void _showVoiceDialog(BuildContext context, UserPreferencesProvider provider) {
    final voiceTypeProvider = context.read<UserVoiceTypeProvider>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('TTS 음성 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('남성'),
              subtitle: const Text('따뜻하고 안정적인 톤'),
              onTap: () async {
                Navigator.pop(context);
                await _updateVoiceType('male', voiceTypeProvider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.pink),
              title: const Text('여성'),
              subtitle: const Text('맑고 친근한 톤'),
              onTap: () async {
                Navigator.pop(context);
                await _updateVoiceType('female', voiceTypeProvider);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }

  // 음성 타입 업데이트 헬퍼 메서드
  Future<void> _updateVoiceType(String voiceType, UserVoiceTypeProvider provider) async {
    try {
      await provider.updateVoiceType(voiceType);
      
      // 성공 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${voiceType == 'male' ? '남성' : '여성'} 음성으로 변경되었습니다.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // 에러 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('음성 변경에 실패했습니다: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }



  // 관심 카테고리 설정 다이얼로그
  void _showCategoriesDialog(BuildContext context, UserPreferencesProvider provider) {
    final categories = ['정치', '경제', '사회', '국제', '문화', '스포츠', 'IT'];
    final selectedCategories = List<String>.from(provider.favoriteCategories ?? []);
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('관심 카테고리 선택'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: categories.map((category) {
                return CheckboxListTile(
                  title: Text(category),
                  value: selectedCategories.contains(category),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedCategories.add(category);
                      } else {
                        selectedCategories.remove(category);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.updateFavoriteCategories(selectedCategories);
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }

  // 관심 키워드 설정 다이얼로그
  void _showKeywordsDialog(BuildContext context, UserPreferencesProvider provider) {
    final controller = TextEditingController();
    final keywords = List<String>.from(provider.favoriteKeywords ?? []);
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('관심 키워드 관리'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: '키워드 입력',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final keyword = controller.text.trim();
                      if (keyword.isNotEmpty && !keywords.contains(keyword)) {
                        setState(() {
                          keywords.add(keyword);
                        });
                        controller.clear();
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...keywords.map((keyword) => ListTile(
                title: Text(keyword),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      keywords.remove(keyword);
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.updateFavoriteKeywords(keywords);
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }

  // 관심 언론사 설정 다이얼로그
  void _showMediaDialog(BuildContext context, UserPreferencesProvider provider) {
    final mediaList = ['SBS', '한국경제', '매일경제', '조선일보', '중앙일보', '동아일보'];
    final selectedMedia = List<String>.from(provider.favoriteMedia ?? []);
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('관심 언론사 선택'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: mediaList.map((media) {
                return CheckboxListTile(
                  title: Text(media),
                  value: selectedMedia.contains(media),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedMedia.add(media);
                      } else {
                        selectedMedia.remove(media);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.updateFavoriteMedia(selectedMedia);
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
} 