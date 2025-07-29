import 'package:flutter/material.dart';
import 'start_screen.dart';
import '../../services/auth_service.dart';
import '../../models/auth_models.dart';
import 'signup/signup_email_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  bool showKeyboard = false;
  bool inputFocused = false;
  bool emailFocused = false;
  bool passwordFocused = false;
  bool isPasswordVisible = false;
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void handleKeyPress(String key) {
    setState(() {
      if (emailFocused) {
        email += key;
        _emailController.text = email;
        _emailController.selection = TextSelection.fromPosition(
          TextPosition(offset: email.length),
        );
      } else if (passwordFocused) {
        password += key;
        _passwordController.text = password;
        _passwordController.selection = TextSelection.fromPosition(
          TextPosition(offset: password.length),
        );
      }
    });
  }

  void handleBackspace() {
    setState(() {
      if (emailFocused && email.isNotEmpty) {
        email = email.substring(0, email.length - 1);
        _emailController.text = email;
        _emailController.selection = TextSelection.fromPosition(
          TextPosition(offset: email.length),
        );
      } else if (passwordFocused && password.isNotEmpty) {
        password = password.substring(0, password.length - 1);
        _passwordController.text = password;
        _passwordController.selection = TextSelection.fromPosition(
          TextPosition(offset: password.length),
        );
      }
    });
  }

  void handleSpace() {
    setState(() {
      if (emailFocused) {
        email += ' ';
        _emailController.text = email;
        _emailController.selection = TextSelection.fromPosition(
          TextPosition(offset: email.length),
        );
      } else if (passwordFocused) {
        password += ' ';
        _passwordController.text = password;
        _passwordController.selection = TextSelection.fromPosition(
          TextPosition(offset: password.length),
        );
      }
    });
  }

  void handleReturn() {
    setState(() {
      showKeyboard = false;
      inputFocused = false;
      emailFocused = false;
      passwordFocused = false;
    });
  }

  void handleEmailFocus() {
    setState(() {
      emailFocused = true;
      passwordFocused = false;
      inputFocused = true;
      showKeyboard = true;
    });
  }

  void handlePasswordFocus() {
    setState(() {
      passwordFocused = true;
      emailFocused = false;
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

  Future<void> handleLogin() async {
    if (!canLogin || isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      // API 호출
      final authResponse = await _authService.login(email.trim(), password);

      print('로그인 성공: ${authResponse.email}');
      print('토큰: ${authResponse.accessToken}');

      // 로그인 성공 시 다음 화면으로 이동
      // TODO: 실제 화면으로 변경
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StartScreen()),
      );
    } catch (e) {
      // 에러 처리
      print('로그인 실패: $e');

      // 에러 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인에 실패했습니다: ${e.toString()}'),
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

  void handleSignup() {
    // 회원가입 페이지로 이동
    print('회원가입 페이지로 이동');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupEmailScreen()),
    );
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  bool get canLogin => email.trim().isNotEmpty && password.trim().isNotEmpty;

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
                            '로그인',
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

                        // Welcome Text
                        const Padding(
                          padding: EdgeInsets.only(bottom: 64),
                          child: Text(
                            '뉴스 브리핑 앱에\n오신 것을 환영합니다',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF374151),
                              fontFamily: 'Pretendard',
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // Email Input
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: GestureDetector(
                            onTap: handleEmailFocus,
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
                                  });
                                },
                                onTap: handleEmailFocus,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Pretendard',
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(bottom: 8),
                                  hintText: '이메일 주소',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                                cursorColor: emailFocused
                                    ? const Color(0xFF2563EB)
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ),

                        // Password Input
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            onTap: handlePasswordFocus,
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
                                controller: _passwordController,
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                onTap: handlePasswordFocus,
                                obscureText: !isPasswordVisible,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Pretendard',
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(bottom: 8),
                                  hintText: '비밀번호',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                                cursorColor: passwordFocused
                                    ? const Color(0xFF2563EB)
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ),

                        // Password Visibility Toggle
                        Padding(
                          padding: const EdgeInsets.only(bottom: 48),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: togglePasswordVisibility,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Text(
                                    isPasswordVisible ? '숨기기' : '보기',
                                    style: const TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Pretendard',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Login Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap:
                                (canLogin && !isLoading) ? handleLogin : null,
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                color: (canLogin && !isLoading)
                                    ? const Color(0xFF0565FF)
                                    : const Color(0xFF0565FF).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: (canLogin && !isLoading)
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
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        '로그인',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Pretendard',
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Signup Link
                        GestureDetector(
                          onTap: handleSignup,
                          child: const Text(
                            '계정이 없으신가요? 회원가입',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Pretendard',
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
    _passwordController.dispose();
    super.dispose();
  }
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
