import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup/signup_email_screen.dart';
import 'signup/signup_pw_screen.dart';
import 'login_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  bool showContent = false;

  late AnimationController _subtitleController;
  late AnimationController _newsAnimationController;
  late AnimationController _ewsFadeController;

  late Animation<double> _subtitleAnimation;
  late Animation<double> _newsAnimation;
  late Animation<double> _ewsFadeAnimation;

  @override
  void initState() {
    super.initState();

    // 서브타이틀 애니메이션
    _subtitleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _subtitleAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _subtitleController,
      curve: Curves.easeOut,
    ));

    // NEWS 애니메이션
    _newsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _newsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _newsAnimationController,
      curve: Curves.easeInOut,
    ));

    // EWS 페이드 아웃 애니메이션
    _ewsFadeController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _ewsFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _ewsFadeController,
      curve: Curves.easeInOut,
    ));

    // 컴포넌트 마운트 후 애니메이션 시작
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        showContent = true;
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        _subtitleController.forward();
      });
      // NEWS 애니메이션 시작
      Future.delayed(const Duration(milliseconds: 800), () {
        _newsAnimationController.forward();
        // EWS 페이드 아웃 시작
        Future.delayed(const Duration(milliseconds: 100), () {
          _ewsFadeController.forward();
        });
      });
    });
  }

  @override
  void dispose() {
    _subtitleController.dispose();
    _newsAnimationController.dispose();
    _ewsFadeController.dispose();
    super.dispose();
  }

  void handleSignup() {
    print('회원가입 버튼 클릭됨'); // 디버그 로그 추가
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupEmailScreen()),
    );
  }

  void handleLogin() {
    print('로그인 버튼 클릭됨'); // 디버그 로그 추가
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Stack(
            children: [
              // 로고 이미지
              Positioned(
                left: screenWidth * 0.16,
                top: screenHeight * 0.21,
                child: Opacity(
                  opacity: showContent ? 1.0 : 0.0,
                  child: Container(
                    width: screenWidth * 0.68,
                    height: screenHeight * 0.20,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/a_image/newsapp_logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              // NEWS 애니메이션 - "요즘 NEWS" → "요즘 N"
              AnimatedBuilder(
                animation: _newsAnimation,
                builder: (context, child) {
                  return Positioned(
                    left: 0,
                    right: 0,
                    top: screenHeight * 0.40,
                    child: Opacity(
                      opacity: showContent ? 1.0 : 0.0,
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          transform: Matrix4.translationValues(
                              _ewsFadeAnimation.value < 0.1
                                  ? (1.0 - _ewsFadeAnimation.value) * 50
                                  : 0,
                              0,
                              0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '요즘 ',
                                style: TextStyle(
                                  fontSize: 42,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'HakgyoansimAllimjang',
                                ),
                              ),
                              // N 부분 (색깔만 바뀜)
                              Text(
                                'N',
                                style: TextStyle(
                                  fontSize: 42,
                                  color: _ewsFadeAnimation.value > 0.5
                                      ? Colors.black
                                      : const Color(0xFF0566FF),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'HakgyoansimAllimjang',
                                ),
                              ),
                              // EWS 부분 (시작할 때는 보임)
                              if (_ewsFadeAnimation.value > 0.1)
                                const Text(
                                  'EWS',
                                  style: TextStyle(
                                    fontSize: 42,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'HakgyoansimAllimjang',
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // 부제목 "NEWS를 스마트하게"
              AnimatedBuilder(
                animation: _subtitleAnimation,
                builder: (context, child) {
                  return Positioned(
                    left: 0,
                    right: 0,
                    top: screenHeight * 0.48,
                    child: Opacity(
                      opacity: showContent ? 1.0 : 0.0,
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'NEWS',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF0566FF),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'HakgyoansimAllimjang',
                                ),
                              ),
                              TextSpan(
                                text: '를 스마트하게',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF666666),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'HakgyoansimAllimjang',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // 회원가입 버튼
              Positioned(
                left: screenWidth * 0.08,
                top: screenHeight * 0.61,
                child: SizedBox(
                  width: screenWidth * 0.84,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0566FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ),
                ),
              ),

              // 로그인 버튼
              Positioned(
                left: screenWidth * 0.08,
                top: screenHeight * 0.68,
                child: SizedBox(
                  width: screenWidth * 0.84,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0566FF),
                      elevation: 0,
                      side: BorderSide(
                        color: const Color(0xFF0566FF).withOpacity(0.3),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ),
                ),
              ),

              // 하단 약관 텍스트
              Positioned(
                left: screenWidth * 0.11,
                top: screenHeight * 0.85,
                child: const Text(
                  '계속하기로 서비스 이용약관 및 개인정보처리방침에 동의합니다',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF808080),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
