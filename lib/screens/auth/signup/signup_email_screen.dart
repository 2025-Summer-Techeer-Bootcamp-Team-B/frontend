import 'package:flutter/material.dart';
import '../start_screen.dart';
import 'signup_pw_screen.dart';
import '../../../services/auth_service.dart';

class SignupEmailScreen extends StatefulWidget {
  const SignupEmailScreen({super.key});

  @override
  State<SignupEmailScreen> createState() => _SignupEmailScreenState();
}

class _SignupEmailScreenState extends State<SignupEmailScreen> {
  String email = '';
  bool showKeyboard = false;
  bool inputFocused = false;
  bool isCheckingEmail = false;
  bool emailExists = false;
  bool emailFormatError = false;
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  // 이메일 형식 검증 함수
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  void handleKeyPress(String key) {
    setState(() {
      email += key;
      _emailController.text = email;
      _emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: email.length),
      );
    });
  }

  void handleBackspace() {
    if (email.isNotEmpty) {
      setState(() {
        email = email.substring(0, email.length - 1);
        _emailController.text = email;
        _emailController.selection = TextSelection.fromPosition(
          TextPosition(offset: email.length),
        );
      });
    }
  }

  void handleSpace() {
    setState(() {
      email += ' ';
      _emailController.text = email;
      _emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: email.length),
      );
    });
  }

  void handleReturn() {
    setState(() {
      showKeyboard = false;
      inputFocused = false;
    });
  }

  void handleInputFocus() {
    setState(() {
      inputFocused = true;
      showKeyboard = true;
    });
  }

  void handleBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StartScreen()),
    );
  }

  Future<void> checkEmailExists() async {
    if (email.trim().isEmpty) {
      setState(() {
        emailExists = false;
      });
      return;
    }

    setState(() {
      isCheckingEmail = true;
    });

    try {
      final exists = await _authService.checkEmailDuplicate(email.trim());
      setState(() {
        emailExists = exists;
        isCheckingEmail = false;
      });
    } catch (e) {
      print('이메일 중복 검사 실패: $e');
      setState(() {
        isCheckingEmail = false;
      });
    }
  }

  void handleNext() {
    if (emailFormatError || emailExists == true) {
      // 이메일 형식이 잘못되거나 이미 존재하면 다음 화면으로 이동하지 않음
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPwScreen(email: email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: 393,
        height: 852,
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: handleBack,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            size: 48,
                            color: Color(0xFF2563EB),
                            weight: 100,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 64),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 64),

                        // Instruction Text
                        const Padding(
                          padding: EdgeInsets.only(bottom: 64),
                          child: Text(
                            '이메일 주소를 입력하세요',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF374151),
                              fontFamily: 'Pretendard',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // Email Input with Duplicate Check Button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: handleInputFocus,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xFFD1D5DB),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _emailController,
                                      onChanged: (value) {
                                        setState(() {
                                          email = value;
                                          emailExists = false; // 입력이 변경되면 중복 상태 초기화
                                          emailFormatError = false; // 입력이 변경되면 형식 오류 상태 초기화
                                        });
                                      },
                                      onEditingComplete: () {
                                        // 입력 완료 시 형식 검사만 수행
                                        if (email.trim().isNotEmpty) {
                                          if (!isValidEmail(email.trim())) {
                                            setState(() {
                                              emailFormatError = true;
                                            });
                                            return;
                                          }
                                          // 중복 검사는 버튼으로 수동 실행
                                          setState(() {
                                            emailFormatError = false;
                                            emailExists = false; // 이전 중복 검사 결과 초기화
                                          });
                                        }
                                      },
                                      onTap: handleInputFocus,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontFamily: 'Pretendard',
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(bottom: 8),
                                      ),
                                      cursorColor: inputFocused
                                          ? const Color(0xFF2563EB)
                                          : Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // 중복 확인 버튼
                              if (email.trim().isNotEmpty && !emailFormatError && !emailExists && !isCheckingEmail)
                                GestureDetector(
                                  onTap: checkEmailExists,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      '중복확인',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Pretendard',
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // 이메일 중복 검사 결과 표시
                        if (isCheckingEmail)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0565FF)),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '이메일 중복 확인 중...',
                                  style: TextStyle(
                                    color: Color(0xFF0565FF),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (emailExists)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              '이미 존재하는 이메일입니다.',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ),

                        if (emailFormatError)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              '올바른 이메일 형식이 아닙니다.',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ),



                        // Next Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: (email.trim().isNotEmpty && !emailFormatError && (emailExists == false || emailExists == null)) ? handleNext : null,
                            child: Container(
                              width: 120,
                              height: 48,
                              decoration: BoxDecoration(
                                color: (email.trim().isNotEmpty && !emailFormatError && (emailExists == false || emailExists == null))
                                    ? const Color(0xFF0565FF)
                                    : const Color(0xFF0565FF).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: (email.trim().isNotEmpty && !emailFormatError && (emailExists == false || emailExists == null))
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF0565FF)
                                              .withOpacity(0.25),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: const Center(
                                child: Text(
                                  '다음',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Virtual Keyboard
            if (showKeyboard)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: VirtualKeyboard(
                  onKeyPress: handleKeyPress,
                  onBackspace: handleBackspace,
                  onSpace: handleSpace,
                  onReturn: handleReturn,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // 화살표 몸통
    canvas.drawLine(
      Offset(28, size.height / 2),
      Offset(size.width - 28, size.height / 2),
      paint,
    );

    // 화살표 머리 (둥글게)
    final path = Path();
    path.moveTo(size.width - 28, size.height / 2 - 6);
    path.quadraticBezierTo(
      size.width - 20,
      size.height / 2,
      size.width - 28,
      size.height / 2 + 6,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class VirtualKeyboard extends StatelessWidget {
  final Function(String) onKeyPress;
  final VoidCallback onBackspace;
  final VoidCallback onSpace;
  final VoidCallback onReturn;

  const VirtualKeyboard({
    super.key,
    required this.onKeyPress,
    required this.onBackspace,
    required this.onSpace,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF3F4F6),
      child: Column(
        children: [
          // First row
          Row(
            children: [
              _buildKey('q'),
              _buildKey('w'),
              _buildKey('e'),
              _buildKey('r'),
              _buildKey('t'),
              _buildKey('y'),
              _buildKey('u'),
              _buildKey('i'),
              _buildKey('o'),
              _buildKey('p'),
            ],
          ),
          // Second row
          Row(
            children: [
              const SizedBox(width: 20),
              _buildKey('a'),
              _buildKey('s'),
              _buildKey('d'),
              _buildKey('f'),
              _buildKey('g'),
              _buildKey('h'),
              _buildKey('j'),
              _buildKey('k'),
              _buildKey('l'),
            ],
          ),
          // Third row
          Row(
            children: [
              _buildSpecialKey('123', onTap: () {}),
              _buildKey('z'),
              _buildKey('x'),
              _buildKey('c'),
              _buildKey('v'),
              _buildKey('b'),
              _buildKey('n'),
              _buildKey('m'),
              _buildSpecialKey('⌫', onTap: onBackspace),
            ],
          ),
          // Fourth row
          Row(
            children: [
              _buildSpecialKey('123', onTap: () {}),
              _buildKey('@'),
              _buildKey('.'),
              _buildSpecialKey('space', onTap: onSpace, isSpace: true),
              _buildSpecialKey('return', onTap: onReturn),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String key) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onKeyPress(key),
        child: Container(
          height: 50,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Center(
            child: Text(
              key,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey(String text,
      {required VoidCallback onTap, bool isSpace = false}) {
    return Expanded(
      flex: isSpace ? 3 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: const Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
