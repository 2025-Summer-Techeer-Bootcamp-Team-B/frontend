import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import '../../../providers/user_voice_type_provider.dart';
import '../../../widgets/user_keyword_example.dart'; // 임시로 메인 화면으로 이동

class VoiceSelectScreen extends StatefulWidget {
  const VoiceSelectScreen({Key? key}) : super(key: key);

  @override
  State<VoiceSelectScreen> createState() => _VoiceSelectScreenState();
}

class _VoiceSelectScreenState extends State<VoiceSelectScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final just_audio.AudioPlayer _justAudioPlayer =
      just_audio.AudioPlayer(); // just_audio용 플레이어 추가
  String? _currentlyPlaying;
  bool _isPlaying = false;

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

    // 애니메이션 시작
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _audioPlayer.dispose();
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

                        const Spacer(),

                        // 완료 버튼
                        _buildCompleteButton(),

                        const SizedBox(height: 24),
                      ],
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

  // 상단 헤더
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          // 뒤로 버튼
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF0565FF),
                size: 20,
              ),
            ),
          ),

          // 가운데 공간 확보
          const Spacer(),
        ],
      ),
    );
  }

  // 안내 텍스트
  Widget _buildInstructionText() {
    return const Text(
      '음성을 선택해 주세요',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Pretendard',
        color: Colors.black,
      ),
    );
  }

  // 음성 선택 카드들
  Widget _buildVoiceCards() {
    return Column(
      children: [
        _buildVoiceCard(
          voiceType: 'male',
          color: const Color(0xFF0565FF),
          label: '남성',
          shadowColor: Colors.blue.withOpacity(0.1),
        ),
        const SizedBox(height: 20),
        _buildVoiceCard(
          voiceType: 'female',
          color: const Color(0xFF0565FF),
          label: '여성',
          shadowColor: Colors.pink.withOpacity(0.1),
        ),
      ],
    );
  }

  // 음성 카드
  Widget _buildVoiceCard({
    required String voiceType,
    required Color color,
    required String label,
    required Color shadowColor,
  }) {
    final isCurrentlyPlaying = _currentlyPlaying == voiceType;

    return GestureDetector(
      onTap: () => _selectVoice(voiceType),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.person,
                size: 30,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '따뜻하고 안정적인 톤',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            // 재생 버튼
            GestureDetector(
              onTap: () => _playVoiceSampleWithJustAudio(voiceType),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCurrentlyPlaying ? color : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  isCurrentlyPlaying ? Icons.stop : Icons.play_arrow,
                  color: isCurrentlyPlaying ? Colors.white : color,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 완료 버튼
  Widget _buildCompleteButton() {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // 기본값(남성)으로 설정하고 메인 화면으로 이동
          context.read<UserVoiceTypeProvider>().initializeWithDefault();
          _navigateToMain();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0565FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 4,
          shadowColor: const Color(0xFF0565FF).withOpacity(0.3),
        ),
        child: const Text(
          '완료',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  // just_audio를 사용한 음성 샘플 재생 (대안)
  Future<void> _playVoiceSampleWithJustAudio(String voiceType) async {
    try {
      if (_isPlaying && _currentlyPlaying == voiceType) {
        // 현재 재생 중인 음성 중지
        await _justAudioPlayer.stop();
        setState(() {
          _isPlaying = false;
          _currentlyPlaying = null;
        });
        return;
      }

      // 다른 음성 재생 중이면 중지
      if (_isPlaying) {
        await _justAudioPlayer.stop();
      }

      // 음성 파일 경로 (네트워크 URL 사용)
      String audioPath;
      if (voiceType == 'male') {
        audioPath =
            'https://storage.googleapis.com/news_briefing_bucket/audio/2025/07/28/61453fc4-dc0e-4317-895b-b8c4f78bd8f5.mp3';
      } else {
        audioPath =
            'https://storage.googleapis.com/news_briefing_bucket/audio/2025/07/28/61453fc4-dc0e-4317-895b-b8c4f78bd8f5.mp3';
      }

      setState(() {
        _isPlaying = true;
        _currentlyPlaying = voiceType;
      });

      print('just_audio로 음성 재생 시도: $audioPath');

      // just_audio로 재생 시도
      await _justAudioPlayer.setUrl(audioPath);
      await _justAudioPlayer.play();

      print('just_audio로 음성 재생 시작됨');

      // 재생 완료 후 상태 초기화
      _justAudioPlayer.playerStateStream.listen((state) {
        if (state.processingState == just_audio.ProcessingState.completed) {
          print('just_audio 음성 재생 완료');
          setState(() {
            _isPlaying = false;
            _currentlyPlaying = null;
          });
        }
      });
    } catch (e) {
      print('just_audio 음성 재생 오류: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('just_audio 음성 재생에 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _isPlaying = false;
        _currentlyPlaying = null;
      });
    }
  }

  // 음성 샘플 재생
  Future<void> _playVoiceSample(String voiceType) async {
    try {
      if (_isPlaying && _currentlyPlaying == voiceType) {
        // 현재 재생 중인 음성 중지
        await _audioPlayer.stop();
        setState(() {
          _isPlaying = false;
          _currentlyPlaying = null;
        });
        return;
      }

      // 다른 음성 재생 중이면 중지
      if (_isPlaying) {
        await _audioPlayer.stop();
      }

      // 음성 파일 경로 (네트워크 URL 사용)
      String audioPath;
      if (voiceType == 'male') {
        audioPath =
            'https://storage.googleapis.com/news_briefing_bucket/audio/2025/07/28/61453fc4-dc0e-4317-895b-b8c4f78bd8f5.mp3';
      } else {
        audioPath =
            'https://storage.googleapis.com/news_briefing_bucket/audio/2025/07/28/61453fc4-dc0e-4317-895b-b8c4f78bd8f5.mp3';
      }

      setState(() {
        _isPlaying = true;
        _currentlyPlaying = voiceType;
      });

      // 웹에서 음성 재생 문제 해결을 위해 try-catch 추가
      try {
        print('음성 재생 시도: $audioPath');

        // 웹 브라우저에서의 자동 재생 정책 우회 시도
        if (audioPath.startsWith('http')) {
          await _audioPlayer.play(UrlSource(audioPath));
        } else {
          await _audioPlayer.play(AssetSource(audioPath));
        }

        print('음성 재생 시작됨');

        // 재생 완료 후 상태 초기화
        _audioPlayer.onPlayerComplete.listen((_) {
          print('음성 재생 완료');
          setState(() {
            _isPlaying = false;
            _currentlyPlaying = null;
          });
        });
      } catch (playError) {
        print('음성 재생 시도 실패: $playError');
        // 재생 실패 시 상태 초기화
        setState(() {
          _isPlaying = false;
          _currentlyPlaying = null;
        });

        // 웹 브라우저 제한에 대한 상세한 안내
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('음성 재생 제한'),
              content: const Text(
                '웹 브라우저에서는 보안 정책으로 인해 자동 음성 재생이 제한됩니다.\n\n'
                '음성을 확인하려면:\n'
                '• 모바일 앱에서 테스트하거나\n'
                '• 브라우저 설정에서 자동 재생을 허용하세요.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('확인'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print('음성 재생 오류: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('음성 재생에 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _isPlaying = false;
        _currentlyPlaying = null;
      });
    }
  }

  // 음성 선택
  void _selectVoice(String voiceType) {
    // Provider에 음성 타입 설정
    context.read<UserVoiceTypeProvider>().setVoiceType(voiceType);

    // 선택 완료 애니메이션
    _showSelectionCompleteDialog(voiceType);
  }

  // 선택 완료 다이얼로그
  void _showSelectionCompleteDialog(String voiceType) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('선택 완료'),
          ],
        ),
        content: Text(
          '${voiceType == 'male' ? '남성' : '여성'} 음성으로 설정되었습니다.',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToMain();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  // 메인 화면으로 이동
  void _navigateToMain() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const UserKeywordExample(),
      ),
      (route) => false,
    );
  }
}
