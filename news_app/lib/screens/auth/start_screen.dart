import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup/signup_email_screen.dart';
import 'signup/signup_pw_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  bool showContent = false;
  bool isLoading = false;

  late AnimationController _logoController;
  late AnimationController _titleController;
  late AnimationController _subtitleController;

  late Animation<double> _logoAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _subtitleAnimation;

  @override
  void initState() {
    super.initState();

    // 로고 애니메이션
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _logoAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    ));

    // 타이틀 애니메이션
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _titleAnimation = Tween<double>(
      begin: 60.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOut,
    ));

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

    // 컴포넌트 마운트 후 애니메이션 시작
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        showContent = true;
      });
      _logoController.forward();
      Future.delayed(const Duration(milliseconds: 400), () {
        _titleController.forward();
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        _subtitleController.forward();
      });
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
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
        MaterialPageRoute(builder: (context) => const SignupPwScreen()),
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
                  // 로고 이미지 - 애니메이션 (첫 번째)
                  AnimatedBuilder(
                    animation: _logoAnimation,
                    builder: (context, child) {
                      return Positioned(
                        left: 62,
                        top: 175 + _logoAnimation.value,
                        child: Opacity(
                          opacity: showContent ? 1.0 : 0.0,
                          child: Container(
                            width: 269,
                            height: 169,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/a_image/newsapp_logo.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // 메인 타이틀 "요즘어때?" - 애니메이션 (두 번째)
                  AnimatedBuilder(
                    animation: _titleAnimation,
                    builder: (context, child) {
                      return Positioned(
                        left: 114,
                        top: 362 + _titleAnimation.value,
                        child: Opacity(
                          opacity: showContent ? 1.0 : 0.0,
                          child: const Text(
                            '요즘어때?',
                            style: TextStyle(
                              fontSize: 42,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'HakgyoansimAllimjang',
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // 부제목 "뉴스를 더 스마트하게" - 애니메이션 (세 번째)
                  AnimatedBuilder(
                    animation: _subtitleAnimation,
                    builder: (context, child) {
                      return Positioned(
                        left: 123,
                        top: 433 + _subtitleAnimation.value,
                        child: Opacity(
                          opacity: showContent ? 1.0 : 0.0,
                          child: const Text(
                            '뉴스를 더 스마트하게',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w700,
                              fontFamily: 'HakgyoansimAllimjang',
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
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0566FF),
                          borderRadius: BorderRadius.circular(25),
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
                    top: 592,
                    child: GestureDetector(
                      onTap: isLoading ? null : handleLogin,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 329,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
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
