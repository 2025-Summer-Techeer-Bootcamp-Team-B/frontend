import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import '../../../providers/user_voice_type_provider.dart';
import '../display_setting/setting_screen.dart';

class VoiceEditPage extends StatefulWidget {
  const VoiceEditPage({super.key});

  @override
  State<VoiceEditPage> createState() => _VoiceEditPageState();
}

class _VoiceEditPageState extends State<VoiceEditPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final just_audio.AudioPlayer _justAudioPlayer = just_audio.AudioPlayer();
  String? _currentlyPlaying;
  bool _isPlaying = false;
  String? selectedVoiceType;
  String? currentVoiceType;

  @override
  void initState() {
    super.initState();

    // 애니메이션 초기화
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // 현재 음성 타입 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final voiceProvider = Provider.of<UserVoiceTypeProvider>(context, listen: false);
      setState(() {
        // male -> male_voice, female -> female_voice로 변환
        String providerVoiceType = voiceProvider.currentVoiceType ?? 'male';
        currentVoiceType = providerVoiceType == 'male' ? 'male_voice' : 'female_voice';
        selectedVoiceType = currentVoiceType;
      });
    });

    // 애니메이션 시작
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _justAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // 상단 헤더
                _buildHeader(),

                // 메인 콘텐츠
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),

                          // 안내 텍스트
                          _buildInstructionText(),

                          const SizedBox(height: 40),

                          // 음성 선택 카드들
                          _buildVoiceCards(),

                          const SizedBox(height: 40),

                          // 완료 버튼
                          _buildCompleteButton(),

                          const SizedBox(height: 40),
                        ],
                      ),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 24,
                  color: Color(0xFF0565FF),
                ),
                SizedBox(width: 2),
                Text(
                  '뒤로',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0565FF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionText() {
    return Column(
      children: [
        const Text(
          '음성 선택',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            fontFamily: 'Pretendard',
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '원하는 음성을 선택해주세요',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Pretendard',
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceCards() {
    return Column(
      children: [
                    // 남성 음성 카드
            _buildVoiceCard(
              voiceType: 'male_voice',
              title: '남성 음성',
              subtitle: '깊고 안정적인 톤',
              imagePath: 'assets/a_image/male_symbol.png',
              isSelected: selectedVoiceType == 'male_voice',
            ),
            
            const SizedBox(height: 16),
            
            // 여성 음성 카드
            _buildVoiceCard(
              voiceType: 'female_voice',
              title: '여성 음성',
              subtitle: '밝고 친근한 톤',
              imagePath: 'assets/a_image/female_symbol.png',
              isSelected: selectedVoiceType == 'female_voice',
            ),
      ],
    );
  }

  Widget _buildVoiceCard({
    required String voiceType,
    required String title,
    required String subtitle,
    required String imagePath,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedVoiceType = voiceType;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0565FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF0565FF) : const Color(0xFFE0E0E0),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 프로필 이미지
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : const Color(0xFFF5F5F5),
              ),
              child: ClipOval(
                                  child: Image.asset(
                    imagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        voiceType == 'male_voice' ? Icons.man : Icons.woman,
                        size: 30,
                        color: isSelected ? const Color(0xFF0565FF) : Colors.grey,
                      );
                    },
                  ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // 텍스트 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Pretendard',
                      color: isSelected ? Colors.white.withOpacity(0.8) : const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16),
            
            // 재생 버튼
            GestureDetector(
              onTap: () => _playVoiceSample(voiceType),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  _isPlaying && _currentlyPlaying == voiceType ? Icons.stop : Icons.play_arrow,
                  color: isSelected ? const Color(0xFF0565FF) : Colors.grey,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteButton() {
    bool isButtonEnabled = selectedVoiceType != null;
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isButtonEnabled ? _saveVoiceType : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isButtonEnabled ? const Color(0xFF0565FF) : Colors.grey[300],
          foregroundColor: isButtonEnabled ? Colors.white : Colors.grey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          '완료',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
          ),
        ),
      ),
    );
  }

  Future<void> _playVoiceSample(String voiceType) async {
    try {
      // 현재 재생 중인 음성이 같은 것이면 정지
      if (_isPlaying && _currentlyPlaying == voiceType) {
        await _justAudioPlayer.stop();
        setState(() {
          _isPlaying = false;
          _currentlyPlaying = null;
        });
        return;
      }

      // 다른 음성이 재생 중이면 정지
      if (_isPlaying) {
        await _justAudioPlayer.stop();
      }

      String audioUrl;
      if (voiceType == 'male_voice') {
        audioUrl = 'assets/a_voice/male_voice.mp3';
      } else {
        audioUrl = 'assets/a_voice/female_voice.mp3';
      }

      setState(() {
        _isPlaying = true;
        _currentlyPlaying = voiceType;
      });

      await _justAudioPlayer.setAsset(audioUrl);
      await _justAudioPlayer.play();

      // 재생 완료 리스너
      _justAudioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == just_audio.ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
            _currentlyPlaying = null;
          });
        }
      });
    } catch (e) {
      print('음성 재생 오류: $e');
      setState(() {
        _isPlaying = false;
        _currentlyPlaying = null;
      });
    }
  }

  void _saveVoiceType() {
    if (selectedVoiceType != null) {
      final voiceProvider = Provider.of<UserVoiceTypeProvider>(context, listen: false);
      // male_voice -> male, female_voice -> female로 변환
      String voiceType = selectedVoiceType == 'male_voice' ? 'male' : 'female';
      voiceProvider.setVoiceType(voiceType);

      // 설정 화면으로 바로 돌아가기
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SettingScreen(),
        ),
      );
    }
  }
}