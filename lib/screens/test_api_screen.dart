import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TestApiScreen extends StatefulWidget {
  const TestApiScreen({super.key});

  @override
  State<TestApiScreen> createState() => _TestApiScreenState();
}

class _TestApiScreenState extends State<TestApiScreen> {
  String _testResult = '테스트를 시작하려면 버튼을 누르세요.';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API 연결 테스트'),
        backgroundColor: const Color(0xFF0565FF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '백엔드 서버 연결 테스트',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pretendard',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '서버 주소: http://34.47.70.30',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Pretendard',
              ),
            ),
            const SizedBox(height: 24),
            
            // 테스트 버튼들
            ElevatedButton(
              onPressed: _isLoading ? null : _testPressApi,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0565FF),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('언론사 API 테스트', style: TextStyle(fontFamily: 'Pretendard')),
            ),
            const SizedBox(height: 12),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _testCategoryApi,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0565FF),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('카테고리 API 테스트', style: TextStyle(fontFamily: 'Pretendard')),
            ),
            const SizedBox(height: 12),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _testKeywordApi,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0565FF),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('키워드 API 테스트', style: TextStyle(fontFamily: 'Pretendard')),
            ),
            const SizedBox(height: 24),
            
            // 결과 표시
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '테스트 결과:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _testResult,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // 앱 화면으로 이동 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/media-select');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('언론사 선택 화면으로 이동', style: TextStyle(fontFamily: 'Pretendard')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testPressApi() async {
    setState(() {
      _isLoading = true;
      _testResult = '언론사 API 테스트 중...';
    });

    try {
      final apiService = ApiService();
      await apiService.getUserPress();
      setState(() {
        _testResult = '✅ 언론사 API 연결 성공!\n\n서버가 정상적으로 응답하고 있습니다.\n(인증이 필요한 API이므로 Authorization 오류는 정상입니다.)';
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ 언론사 API 연결 실패:\n\n$e\n\n이는 예상된 결과입니다. 인증이 필요한 API이기 때문입니다.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testCategoryApi() async {
    setState(() {
      _isLoading = true;
      _testResult = '카테고리 API 테스트 중...';
    });

    try {
      final apiService = ApiService();
      await apiService.getUserCategories();
      setState(() {
        _testResult = '✅ 카테고리 API 연결 성공!\n\n서버가 정상적으로 응답하고 있습니다.\n(인증이 필요한 API이므로 Authorization 오류는 정상입니다.)';
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ 카테고리 API 연결 실패:\n\n$e\n\n이는 예상된 결과입니다. 인증이 필요한 API이기 때문입니다.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testKeywordApi() async {
    setState(() {
      _isLoading = true;
      _testResult = '키워드 API 테스트 중...';
    });

    try {
      final apiService = ApiService();
      await apiService.getUserKeywords();
      setState(() {
        _testResult = '✅ 키워드 API 연결 성공!\n\n서버가 정상적으로 응답하고 있습니다.\n(인증이 필요한 API이므로 Authorization 오류는 정상입니다.)';
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ 키워드 API 연결 실패:\n\n$e\n\n이는 예상된 결과입니다. 인증이 필요한 API이기 때문입니다.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
} 