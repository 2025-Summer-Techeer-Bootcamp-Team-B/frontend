import 'package:flutter/material.dart';
import '../start_screen.dart';
import 'signup_email_screen.dart';

class SignupPwScreen extends StatefulWidget {
  const SignupPwScreen({super.key});

  @override
  State<SignupPwScreen> createState() => _SignupPwScreenState();
}

class _SignupPwScreenState extends State<SignupPwScreen> {
  String password = '';
  String confirmPassword = '';
  bool showKeyboard = false;
  bool inputFocused = false;
  bool passwordFocused = false;
  bool confirmPasswordFocused = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void handleKeyPress(String key) {
    setState(() {
      if (passwordFocused) {
        password += key;
        _passwordController.text = password;
        _passwordController.selection = TextSelection.fromPosition(
          TextPosition(offset: password.length),
        );
      } else if (confirmPasswordFocused) {
        confirmPassword += key;
        _confirmPasswordController.text = confirmPassword;
        _confirmPasswordController.selection = TextSelection.fromPosition(
          TextPosition(offset: confirmPassword.length),
        );
      }
    });
  }

  void handleBackspace() {
    setState(() {
      if (passwordFocused && password.isNotEmpty) {
        password = password.substring(0, password.length - 1);
        _passwordController.text = password;
        _passwordController.selection = TextSelection.fromPosition(
          TextPosition(offset: password.length),
        );
      } else if (confirmPasswordFocused && confirmPassword.isNotEmpty) {
        confirmPassword =
            confirmPassword.substring(0, confirmPassword.length - 1);
        _confirmPasswordController.text = confirmPassword;
        _confirmPasswordController.selection = TextSelection.fromPosition(
          TextPosition(offset: confirmPassword.length),
        );
      }
    });
  }

  void handleSpace() {
    setState(() {
      if (passwordFocused) {
        password += ' ';
        _passwordController.text = password;
        _passwordController.selection = TextSelection.fromPosition(
          TextPosition(offset: password.length),
        );
      } else if (confirmPasswordFocused) {
        confirmPassword += ' ';
        _confirmPasswordController.text = confirmPassword;
        _confirmPasswordController.selection = TextSelection.fromPosition(
          TextPosition(offset: confirmPassword.length),
        );
      }
    });
  }

  void handleReturn() {
    setState(() {
      showKeyboard = false;
      inputFocused = false;
      passwordFocused = false;
      confirmPasswordFocused = false;
    });
  }

  void handlePasswordFocus() {
    setState(() {
      passwordFocused = true;
      confirmPasswordFocused = false;
      inputFocused = true;
      showKeyboard = true;
    });
  }

  void handleConfirmPasswordFocus() {
    setState(() {
      confirmPasswordFocused = true;
      passwordFocused = false;
      inputFocused = true;
      showKeyboard = true;
    });
  }

  void handleBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignupEmailScreen()),
    );
  }

  void handleNext() {
    // 다음 단계로 진행
    print('다음: $password, $confirmPassword');
  }

  bool get isPasswordValid => password.length >= 8;
  bool get isConfirmPasswordValid =>
      confirmPassword == password && confirmPassword.isNotEmpty;
  bool get canProceed => isPasswordValid && isConfirmPasswordValid;

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
                            '비밀번호를 입력하세요',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF374151),
                              fontFamily: 'Pretendard',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // Password Input
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: GestureDetector(
                            onTap: handlePasswordFocus,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFAEAEAE),
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
                                obscureText: true,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Pretendard',
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(bottom: 8),
                                ),
                                cursorColor: passwordFocused
                                    ? const Color(0xFF2563EB)
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ),

                        // Confirm Password Input
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: GestureDetector(
                            onTap: handleConfirmPasswordFocus,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFAEAEAE),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: _confirmPasswordController,
                                onChanged: (value) {
                                  setState(() {
                                    confirmPassword = value;
                                  });
                                },
                                onTap: handleConfirmPasswordFocus,
                                obscureText: true,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFC7C7C7),
                                  fontFamily: 'Pretendard',
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(bottom: 8),
                                  hintText: '비밀번호 확인',
                                  hintStyle: TextStyle(
                                    color: Color(0xFFC7C7C7),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                                cursorColor: confirmPasswordFocused
                                    ? const Color(0xFF2563EB)
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ),

                        // Error Message
                        if (confirmPassword.isNotEmpty &&
                            !isConfirmPasswordValid)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '*비밀번호가 일치하지 않습니다.',
                                style: TextStyle(
                                  color: Color(0xFFFF3636),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                            ),
                          ),

                        // Next Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: canProceed ? handleNext : null,
                            child: Container(
                              width: 138,
                              height: 62,
                              decoration: BoxDecoration(
                                color: canProceed
                                    ? const Color(0xFF0565FF)
                                    : const Color(0xFF0565FF).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: canProceed
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
                                    fontSize: 18,
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
