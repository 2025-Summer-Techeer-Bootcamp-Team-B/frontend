import 'package:flutter/material.dart';
import '../../services/token_storage.dart';
import '../../services/auth_service.dart';

class VoiceSettingScreen extends StatefulWidget {
  const VoiceSettingScreen({super.key});

  @override
  State<VoiceSettingScreen> createState() => _VoiceSettingScreenState();
}

class _VoiceSettingScreenState extends State<VoiceSettingScreen> {
  String selectedVoice = 'male'; // 기본값: 남성
  bool isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadCurrentVoiceSetting();
  }

  Future<void> _loadCurrentVoiceSetting() async {
    try {
      // 현재 사용자의 목소리 설정을 가져오는 API 호출
      final voiceType = await _authService.getUserVoiceType();
      if (voiceType != null) {
        setState(() {
          selectedVoice = voiceType;
        });
      }
    } catch (e) {
      print('목소리 설정 로드 실패: $e');
    }
  }

  Future<void> _updateVoiceSetting(String voiceType) async {
    setState(() {
      isLoading = true;
    });

    try {
      await _authService.updateVoiceType(voiceType);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('목소리 설정이 변경되었습니다.'),
            backgroundColor: const Color(0xFF0565FF),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('목소리 설정 변경에 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 뒤로가기 버튼
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: Color(0xFF0565FF),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    '목소리 설정',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 설명 텍스트
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '뉴스를 읽어줄 목소리를 선택해주세요',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Pretendard',
                  color: Color(0xFF2C2C2C),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),

            // 목소리 선택 옵션들
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // 남성 목소리
                  GestureDetector(
                    onTap: () => _updateVoiceSetting('male'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: selectedVoice == 'male' ? const Color(0xFF0565FF) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x0A000000),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: selectedVoice == 'male' 
                                  ? Colors.white.withOpacity(0.2) 
                                  : const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 32,
                              color: Color(0xFF0565FF),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '남성 목소리',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Pretendard',
                                    color: selectedVoice == 'male' ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '따뜻하고 신뢰감 있는 목소리',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Pretendard',
                                    color: selectedVoice == 'male' 
                                        ? Colors.white.withOpacity(0.8) 
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selectedVoice == 'male')
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 여성 목소리
                  GestureDetector(
                    onTap: () => _updateVoiceSetting('female'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: selectedVoice == 'female' ? const Color(0xFF0565FF) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x0A000000),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: selectedVoice == 'female' 
                                  ? Colors.white.withOpacity(0.2) 
                                  : const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 32,
                              color: Color(0xFFE91E63),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '여성 목소리',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Pretendard',
                                    color: selectedVoice == 'female' ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '맑고 친근한 목소리',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Pretendard',
                                    color: selectedVoice == 'female' 
                                        ? Colors.white.withOpacity(0.8) 
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selectedVoice == 'female')
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 로딩 인디케이터
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0565FF)),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 