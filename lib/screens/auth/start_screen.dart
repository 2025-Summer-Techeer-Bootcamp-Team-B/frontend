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
  bool isLoading = false;

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
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupEmailScreen()),
      );
    });
  }

  void handleLogin() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 메인 컨테이너
          Container(
            width: 393,
            height: 852,
            color: Colors.white,
            child: Opacity(
              opacity: isLoading ? 0.5 : 1.0,
              child: Stack(
                children: [
                  // 로고 이미지 (애니메이션 없음)
                  Positioned(
                    left: 62,
                    top: 175,
                    child: Opacity(
                      opacity: showContent ? 1.0 : 0.0,
                      child: Container(
                        width: 269,
                        height: 169,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assets/a_image/newsapp_logo.png'),
                            fit: BoxFit.cover,
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
                        top: 340,
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

                  // EWS 페이드 아웃 애니메이션 (별도로 분리)
                  AnimatedBuilder(
                    animation: _ewsFadeAnimation,
                    builder: (context, child) {
                      return const SizedBox.shrink(); // EWS는 "요즘 NEWS" 안에서만 표시
                    },
                  ),

                  // 부제목 "NEWS를 스마트하게" - 애니메이션 (세 번째)
                  AnimatedBuilder(
                    animation: _subtitleAnimation,
                    builder: (context, child) {
                      return Positioned(
                        left: 0,
                        right: 0,
                        top: 410,
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
                    left: 32,
                    top: 520,
                    child: GestureDetector(
                      onTap: isLoading ? null : handleSignup,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 329,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0566FF),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Center(
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 로그인 버튼
                  Positioned(
                    left: 32,
                    top: 580,
                    child: GestureDetector(
                      onTap: isLoading ? null : handleLogin,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 329,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF0566FF).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '로그인',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF0566FF),
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 하단 약관 텍스트
                  const Positioned(
                    left: 42,
                    top: 720,
                    child: Text(
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

          // 로딩 오버레이
          if (isLoading)
            Container(
              width: 393,
              height: 852,
              color: Colors.white.withOpacity(0.3),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color: Color(0xFF0566FF),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
            ),

          // 테두리
          Container(
            width: 393,
            height: 852,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF767676),
                width: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
