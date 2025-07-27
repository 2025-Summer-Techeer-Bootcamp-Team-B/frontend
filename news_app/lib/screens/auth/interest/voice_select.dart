import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // 헤더
                    _buildHeader(),
                    
                    const SizedBox(height: 60),
                    
                    // 음성 선택 카드들
                    Expanded(
                      child: Column(
                        children: [
                          _buildVoiceCard(
                            title: '남성 음성',
                            subtitle: '따뜻하고 안정적인 톤',
                            icon: Icons.person,
                            voiceType: 'male',
                            color: const Color(0xFF4A90E2),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          _buildVoiceCard(
                            title: '여성 음성',
                            subtitle: '맑고 친근한 톤',
                            icon: Icons.person_outline,
                            voiceType: 'female',
                            color: const Color(0xFFE91E63),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // 스킵 버튼
                    _buildSkipButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // 앱 로고 또는 아이콘
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.record_voice_over,
            size: 40,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // 제목
        const Text(
          '음성을 선택해주세요',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // 부제목
        Text(
          '뉴스를 읽어주는 음성을 선택하세요\n선택한 음성으로 뉴스를 들을 수 있습니다',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVoiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String voiceType,
    required Color color,
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
              color: color.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            // 아이콘
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 30,
                color: color,
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isCurrentlyPlaying ? color : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  isCurrentlyPlaying ? Icons.stop : Icons.play_arrow,
                  color: isCurrentlyPlaying ? Colors.white : color,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.skip_next,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => _skipSelection(),
                child: Text(
                  '나중에 설정하기',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.white.withOpacity(0.6),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '기본값: 남성 음성으로 설정됩니다',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

      // 음성 파일 경로 (assets/a_voice/ 폴더의 파일들 사용)
      String audioPath;
      if (voiceType == 'male') {
        audioPath = 'assets/a_voice/1번 남자.mp3';
      } else {
        audioPath = 'assets/a_voice/2번 남자.mp3'; // 여성 음성 파일이 있으면 변경
      }

      setState(() {
        _isPlaying = true;
        _currentlyPlaying = voiceType;
      });

      await _audioPlayer.play(AssetSource(audioPath));
      
      // 재생 완료 후 상태 초기화
      _audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          _isPlaying = false;
          _currentlyPlaying = null;
        });
      });

    } catch (e) {
      print('음성 재생 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('음성 재생에 실패했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
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

  // 스킵
  void _skipSelection() {
    // 기본값(남성)으로 설정
    context.read<UserVoiceTypeProvider>().initializeWithDefault();
    
    // 스킵 완료 다이얼로그 표시
    _showSkipCompleteDialog();
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

  // 스킵 완료 다이얼로그
  void _showSkipCompleteDialog() {
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
              Icons.settings,
              color: Colors.blue,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('기본 설정 완료'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '기본값으로 설정되었습니다.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '남성 음성으로 설정됨',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '나중에 설정에서 언제든지 변경할 수 있습니다.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const UserKeywordExample(),
      ),
    );
  }
} 